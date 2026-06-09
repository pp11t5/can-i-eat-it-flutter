import 'dart:async';

import 'package:dio/dio.dart';

import '../error/failure.dart';
import '../security/token_store.dart';
import 'api_endpoints.dart';

/// JWT Bearer 토큰 주입 + 401 단일 refresh 큐잉 인터셉터 (ADR-0007 §3-1 (1)(4)).
///
/// ## 요청 단계
/// - [TokenStore] 에서 액세스 토큰을 읽어 `Authorization: Bearer <token>` 헤더 주입.
/// - 토큰이 없으면 헤더 미주입(비인증 요청 허용).
///
/// ## 응답 401 단계 (큐잉 규약, ADR-0007 §3-1 (4))
/// 1. 이 요청에 사용된 토큰이 현재 store 토큰과 다르면 다른 onError 가 이미
///    refresh 를 완료한 것이므로 현재 토큰으로 바로 retry (refresh skip).
/// 2. refresh 미진행 중 → `POST /auth/refresh` 1회 시작, [_refreshCompleter] 세팅.
/// 3. refresh 진행 중 도착한 401 → 새 refresh 시작 안 하고 Completer await(큐잉).
/// 4. refresh 성공 → 새 토큰 저장, 큐잉 요청 전부 새 토큰으로 **재시도 1회**.
/// 5. refresh 실패 → [TokenStore.clear()] + 큐잉 요청 전부 [SessionExpiredFailure] +
///    [onSessionExpired] 콜백 호출(세션만료 시그널).
///
/// ## QueuedInterceptor + 토큰 비교 가드 조합
/// [QueuedInterceptor] 는 onError 를 직렬화(순차 실행)한다. 따라서 첫 번째 onError
/// 가 refresh 를 완료하고 [_refreshCompleter] 를 null 로 리셋한 뒤 두 번째 onError
/// 가 시작되면 Completer 가드가 작동하지 않는다.
/// **토큰 비교 가드**는 이 직렬화 동작을 보완한다: 요청에 박힌 토큰이 store 현재 토큰과
/// 다르면 이미 refresh 가 끝난 것이므로 현재 토큰으로 바로 retry 한다.
///
/// ## seam
/// [onSessionExpired] 는 기본 no-op. AuthController 배선은 티켓 3 소관.
///
/// ## refresh 재귀 방지
/// refresh 요청 경로가 [ApiEndpoints.authRefresh] 와 정확히 일치하면 인터셉터를 건너뛴다.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.tokenStore,
    required this.refreshDio,
    this.onSessionExpired,
  });

  final TokenStore tokenStore;

  /// refresh 전용 bare Dio (인터셉터 없음, 재귀 방지).
  final Dio refreshDio;

  /// 세션 만료 시그널 콜백 (기본 no-op).
  ///
  /// 티켓 3 에서 AuthController 가 이 seam 을 통해 세션을 null 로 전이시킨다.
  final void Function()? onSessionExpired;

  // ---------------------------------------------------------------------------
  // 내부 상수
  // ---------------------------------------------------------------------------

  static const _extraRetried = '_auth_retried';

  // refresh 동시성 제어 (Completer 는 QueuedInterceptor 직렬화 내에서 사용)
  Completer<String>? _refreshCompleter;

  // ---------------------------------------------------------------------------
  // 요청 — 토큰 주입
  // ---------------------------------------------------------------------------

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStore.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  // ---------------------------------------------------------------------------
  // 응답 오류 — 401 단일 refresh + 토큰 비교 가드
  // ---------------------------------------------------------------------------

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    // 401 이 아니거나 refresh 요청 자체가 실패한 경우 → 그냥 전파
    if (statusCode != 401 || _isRefreshRequest(err.requestOptions)) {
      handler.next(err);
      return;
    }

    // 이미 retry 한 요청은 무한 루프 방지
    if (err.requestOptions.extra[_extraRetried] == true) {
      handler.next(err);
      return;
    }

    // ── 토큰 비교 가드 (CRITICAL 1) ──────────────────────────────────────────
    // QueuedInterceptor 는 onError 를 직렬화한다. 첫 번째 onError 가 refresh 를
    // 완료하고 _refreshCompleter 를 null 로 리셋한 뒤 두 번째 onError 가 진입하므로
    // Completer 가드(_refreshCompleter != null) 가 두 번째에는 걸리지 않는다.
    // 이 가드는 "이 요청이 사용한 토큰 ≠ store 현재 토큰" 이면 이미 다른 onError 가
    // refresh 를 마친 것으로 판단해 새 refresh 없이 현재 토큰으로 바로 retry 한다.
    final currentToken = await tokenStore.readAccessToken();
    final usedToken = err.requestOptions.headers['Authorization'];
    if (currentToken != null && usedToken != 'Bearer $currentToken') {
      // 이미 refresh 완료 — 현재 토큰으로 바로 retry
      try {
        final retryResponse = await _retry(err.requestOptions, currentToken);
        handler.resolve(retryResponse);
      } on DioException catch (retryErr) {
        handler.next(retryErr);
      } catch (_) {
        handler.next(err);
      }
      return;
    }

    // ── 정상 refresh 경로 ────────────────────────────────────────────────────
    try {
      final newAccessToken = await _performRefresh();
      final retryResponse = await _retry(err.requestOptions, newAccessToken);
      handler.resolve(retryResponse);
    } on SessionExpiredFailure catch (f) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: f,
          type: DioExceptionType.badResponse,
        ),
      );
    } on DioException catch (retryErr) {
      // HIGH 2: retry 의 실패 원인을 그대로 전파 (원본 err 로 덮지 않는다)
      handler.next(retryErr);
    } catch (_) {
      handler.next(err);
    }
  }

  // ---------------------------------------------------------------------------
  // 내부 helpers
  // ---------------------------------------------------------------------------

  /// refresh 요청인지 정확 매칭 (MEDIUM: contains → == 으로 교체).
  bool _isRefreshRequest(RequestOptions options) {
    return options.path == ApiEndpoints.authRefresh;
  }

  /// refresh 단일 실행 / 큐잉.
  ///
  /// [QueuedInterceptor] 가 onError 를 직렬화하므로 이 메서드가 동시에 호출되는
  /// 상황은 없다. [_refreshCompleter] 는 단일 onError 내에서 재진입(재귀) 방지용.
  Future<String> _performRefresh() async {
    // 재진입 방지 (단일 onError 내에서 중첩 호출 불가 가드)
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String>();

    try {
      final refreshToken = await tokenStore.readRefreshToken();
      if (refreshToken == null) {
        throw const SessionExpiredFailure();
      }

      final response = await refreshDio.post<dynamic>(
        ApiEndpoints.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      // 봉투에서 새 토큰 추출
      final body = response.data;
      if (body is! Map<String, dynamic>) {
        throw const SessionExpiredFailure('토큰 갱신 응답 형식이 올바르지 않아요.');
      }

      final newAccess = body['result']?['accessToken'] as String?;
      final newRefresh = body['result']?['refreshToken'] as String?;

      if (newAccess == null || newRefresh == null) {
        throw const SessionExpiredFailure('토큰 갱신 응답에 토큰이 없어요.');
      }

      await tokenStore.writeTokens(access: newAccess, refresh: newRefresh);
      _refreshCompleter!.complete(newAccess);
      return newAccess;
    } catch (e) {
      // refresh 실패 → clear + 세션만료
      await tokenStore.clear();
      const failure = SessionExpiredFailure();
      // completeError 후 이 future 를 아무도 await 하지 않으면
      // unhandled future error 가 되므로 ignore() 로 억제한다.
      _refreshCompleter!.future.ignore();
      _refreshCompleter!.completeError(failure);
      onSessionExpired?.call();
      throw failure;
    } finally {
      _refreshCompleter = null;
    }
  }

  /// [options] 를 [newAccessToken] 으로 재시도한다 (1회).
  Future<Response<dynamic>> _retry(
    RequestOptions options,
    String newAccessToken,
  ) async {
    final retryOptions = options.copyWith(
      headers: {
        ...options.headers,
        'Authorization': 'Bearer $newAccessToken',
      },
      extra: {
        ...options.extra,
        _extraRetried: true,
      },
    );

    return refreshDio.fetch<dynamic>(retryOptions);
  }
}
