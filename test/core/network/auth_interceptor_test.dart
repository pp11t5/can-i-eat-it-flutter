import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/network/auth_interceptor.dart';
import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/core/security/token_store.dart';

// ---------------------------------------------------------------------------
// 공통 헬퍼
// ---------------------------------------------------------------------------

const _baseUrl = 'https://test.example.com';

// URL + 메서드만 매칭 (헤더·바디 무시)
const _urlMatcher = UrlRequestMatcher(matchMethod: true);

Map<String, dynamic> _successEnvelope(Object? result) => {
      'isSuccess': true,
      'code': 'SUCCESS',
      'message': 'ok',
      'traceId': 'trace-1',
      'result': result,
    };

Map<String, dynamic> _failureEnvelope(String code, String message) => {
      'isSuccess': false,
      'code': code,
      'message': message,
      'traceId': 'trace-1',
      'result': null,
    };

Map<String, dynamic> _refreshSuccess({
  String access = 'new-access',
  String refresh = 'new-refresh',
}) =>
    _successEnvelope({'accessToken': access, 'refreshToken': refresh});

/// validateStatus: 401만 throw, 400/403은 정상 Response (CRITICAL 2 설정 반영)
Dio _mainDioWithValidateStatus({List<Interceptor> interceptors = const []}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      validateStatus: (status) =>
          status != null && status != 401 && status < 500,
    ),
  );
  for (final i in interceptors) {
    dio.interceptors.add(i);
  }
  return dio;
}

/// 카운팅 래퍼: refreshDio 의 /auth/refresh POST 호출 횟수를 어댑터 레벨에서 센다.
///
/// DioAdapter 가 내부적으로 mock 을 소비하는 방식에 의존하지 않고,
/// HttpClientAdapter 를 래핑해 실제 fetch 호출 수를 카운트한다.
class _CountingAdapter implements HttpClientAdapter {
  _CountingAdapter(this._inner);

  final HttpClientAdapter _inner;
  int callCount = 0;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future? cancelFuture,
  ) {
    if (options.path == ApiEndpoints.authRefresh ||
        options.uri.path == ApiEndpoints.authRefresh) {
      callCount++;
    }
    return _inner.fetch(options, requestStream, cancelFuture);
  }

  @override
  void close({bool force = false}) => _inner.close(force: force);
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  // ── (a) 401 → refresh → retry 성공 ────────────────────────────────────────
  group('(a) 401 → refresh → retry 성공', () {
    test('401 수신 시 refresh 후 원본 요청을 재시도해 성공한다', () async {
      final store = InMemoryTokenStore();
      await store.writeTokens(access: 'old-access', refresh: 'my-refresh');

      // refreshDio: refresh + retry 모두 처리 (interceptor._retry 가 refreshDio.fetch 호출)
      final refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
      final refreshAdapter = DioAdapter(dio: refreshDio, matcher: _urlMatcher);

      refreshAdapter
        ..onPost(
          ApiEndpoints.authRefresh,
          (server) => server.reply(200, _refreshSuccess()),
        )
        ..onGet(
          '/protected',
          (server) => server.reply(200, _successEnvelope({'data': 'ok'})),
        );

      final interceptor =
          AuthInterceptor(tokenStore: store, refreshDio: refreshDio);

      final mainDio = _mainDioWithValidateStatus(interceptors: [interceptor]);
      final mainAdapter = DioAdapter(dio: mainDio, matcher: _urlMatcher);

      mainAdapter.onGet(
        '/protected',
        (server) =>
            server.reply(401, _failureEnvelope('AUTH401', 'unauthorized')),
      );

      final response = await mainDio.get<dynamic>('/protected');
      expect(response.statusCode, 200);
      expect(await store.readAccessToken(), 'new-access');
      expect(await store.readRefreshToken(), 'new-refresh');
    });
  });

  // ── (b) 동시 N=3개 401 → refresh 정확히 1회 ─────────────────────────────
  //
  // 거짓 양성 제거: 기존 테스트는 DioAdapter mock 핸들러 카운터가 실제 호출 횟수를
  // 숨겼다. 여기서는:
  // 1) _CountingAdapter 로 어댑터 레벨에서 /auth/refresh 호출 횟수를 센다.
  // 2) refresh mock 을 1회만 등록하고 2번째 호출 시 명시적으로 실패하게 한다.
  // 3) 수정 전(토큰 비교 가드 없음)이면 이 테스트가 실패하고,
  //    수정 후(토큰 비교 가드 있음)이면 통과한다.
  group('(b) 동시 N=3개 401 → refresh 정확히 1회 + N개 모두 새 토큰으로 retry 성공', () {
    test('_CountingAdapter 레벨에서 refresh 정확히 1회만 호출됨을 검증', () async {
      final store = InMemoryTokenStore();
      await store.writeTokens(access: 'old-access', refresh: 'my-refresh');

      // refreshDio 에 _CountingAdapter 래퍼 장착
      final refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
      final refreshDioAdapter =
          DioAdapter(dio: refreshDio, matcher: _urlMatcher);

      // refresh 1회 등록 (DioAdapter 는 등록된 순서대로 1회씩 소비)
      refreshDioAdapter.onPost(
        ApiEndpoints.authRefresh,
        (server) => server.reply(200, _refreshSuccess()),
      );
      // retry 3회 등록
      for (var i = 0; i < 3; i++) {
        refreshDioAdapter.onGet(
          '/protected',
          (server) => server.reply(200, _successEnvelope({'ok': true})),
        );
      }

      // 어댑터 레벨 카운터 래핑
      final countingAdapter = _CountingAdapter(refreshDio.httpClientAdapter);
      refreshDio.httpClientAdapter = countingAdapter;

      final interceptor =
          AuthInterceptor(tokenStore: store, refreshDio: refreshDio);

      final mainDio = _mainDioWithValidateStatus(interceptors: [interceptor]);
      final mainAdapter = DioAdapter(dio: mainDio, matcher: _urlMatcher);

      // 3개 요청 모두 401
      for (var i = 0; i < 3; i++) {
        mainAdapter.onGet(
          '/protected',
          (server) =>
              server.reply(401, _failureEnvelope('AUTH401', 'unauthorized')),
        );
      }

      // 동시 3개 발사
      final results = await Future.wait(
        List.generate(3, (_) => mainDio.get<dynamic>('/protected')),
      );

      expect(results.length, 3);
      for (final r in results) {
        expect(r.statusCode, 200,
            reason: '모든 retry 가 200 을 반환해야 한다');
      }

      // 핵심 검증: 어댑터 레벨에서 refresh 가 정확히 1회
      expect(countingAdapter.callCount, 1,
          reason: 'refresh 는 어댑터 레벨에서 정확히 1회만 호출돼야 한다 '
              '(현재: ${countingAdapter.callCount}회)');
    });

    test('refresh token rotation: 토큰 비교 가드로 두 번째 401은 refresh 없이 새 토큰으로 retry 됨',
        () async {
      // 시나리오: "요청 시점에는 old-access 헤더, onError 진입 시 store = new-access".
      // 구현: store 를 new-access 로 설정하되 overrideInterceptor 로
      // 요청 헤더를 강제로 'Bearer old-access' 로 오버라이드한다.
      // 이렇게 하면 onRequest chain → old-access 헤더, onError → store new-access
      // 상황이 결정론적으로 재현된다.
      //
      // 주의: DioAdapter 의 onPost/onGet 콜백은 등록 시점에 즉시 실행된다
      // (server.reply 로 mockResponse 필드를 설정하기 위해). 따라서
      // 콜백 내부에서 카운터를 증가시키면 등록 시점에 카운트가 올라간다.
      // → _CountingAdapter 로 어댑터 레벨에서 /auth/refresh 호출 횟수를 센다.
      final store = InMemoryTokenStore();
      await store.writeTokens(access: 'new-access', refresh: 'new-refresh');

      final refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
      final refreshDioAdapter =
          DioAdapter(dio: refreshDio, matcher: _urlMatcher);

      // refresh 가 호출되면 401 실패 (가드로 막혀 실제로는 호출되지 않아야 함)
      refreshDioAdapter.onPost(
        ApiEndpoints.authRefresh,
        (server) =>
            server.reply(401, _failureEnvelope('AUTH401', 'should-not-be-called')),
      );
      // retry 1회 (new-access 로 성공)
      refreshDioAdapter.onGet(
        '/protected',
        (server) => server.reply(200, _successEnvelope({'ok': true})),
      );

      // _CountingAdapter 로 어댑터 레벨에서 /auth/refresh 호출 횟수를 센다.
      // DioAdapter 가 refreshDio.httpClientAdapter 를 이미 교체했으므로
      // 그 위에 래핑한다.
      final countingAdapter = _CountingAdapter(refreshDio.httpClientAdapter);
      refreshDio.httpClientAdapter = countingAdapter;

      final interceptor =
          AuthInterceptor(tokenStore: store, refreshDio: refreshDio);

      // AuthInterceptor 다음에 헤더를 'old-access' 로 덮어쓰는 인터셉터 추가.
      // 실제로는 앞선 onError 가 refresh 를 완료하기 전에 onRequest 가 실행됐고
      // 그때 old-access 가 박혀있었던 상황을 모델링한다.
      final overrideInterceptor = InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer old-access';
          handler.next(options);
        },
      );

      final mainDio = _mainDioWithValidateStatus(
        interceptors: [interceptor, overrideInterceptor],
      );
      final mainAdapter = DioAdapter(dio: mainDio, matcher: _urlMatcher);

      mainAdapter.onGet(
        '/protected',
        (server) =>
            server.reply(401, _failureEnvelope('AUTH401', 'unauthorized')),
      );

      final response = await mainDio.get<dynamic>('/protected');

      expect(response.statusCode, 200);
      // 핵심 검증: 어댑터 레벨에서 /auth/refresh 가 0회 — 가드가 refresh 를 막았다.
      expect(countingAdapter.callCount, 0,
          reason: '토큰 비교 가드로 refresh 가 호출되지 않아야 한다 '
              '(store=new-access, 헤더=old-access → 가드 통과 → 바로 retry)');
    });
  });

  // ── (c) refresh 실패 → SessionExpiredFailure + clear + onSessionExpired ──
  group('(c) refresh 실패 → SessionExpiredFailure + clear + onSessionExpired', () {
    test('refresh 실패 시 TokenStore clear + onSessionExpired 호출된다', () async {
      final store = InMemoryTokenStore();
      await store.writeTokens(access: 'old-access', refresh: 'bad-refresh');

      bool sessionExpiredCalled = false;

      final refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
      final refreshAdapter = DioAdapter(dio: refreshDio, matcher: _urlMatcher);

      // refresh 실패
      refreshAdapter.onPost(
        ApiEndpoints.authRefresh,
        (server) =>
            server.reply(401, _failureEnvelope('AUTH401', 'refresh failed')),
      );

      final interceptor = AuthInterceptor(
        tokenStore: store,
        refreshDio: refreshDio,
        onSessionExpired: () => sessionExpiredCalled = true,
      );

      final mainDio = _mainDioWithValidateStatus(interceptors: [interceptor]);
      final mainAdapter = DioAdapter(dio: mainDio, matcher: _urlMatcher);

      mainAdapter.onGet(
        '/protected',
        (server) =>
            server.reply(401, _failureEnvelope('AUTH401', 'unauthorized')),
      );

      Object? caughtError;
      try {
        await mainDio.get<dynamic>('/protected');
      } catch (e) {
        caughtError = e;
      }

      expect(caughtError, isNotNull);
      final failure =
          caughtError is DioException ? caughtError.error : caughtError;
      expect(failure, isA<SessionExpiredFailure>());
      expect(await store.readAccessToken(), isNull);
      expect(await store.readRefreshToken(), isNull);
      expect(sessionExpiredCalled, isTrue);
    });
  });

  // ── (d) FailureMapper code 별 매핑 ───────────────────────────────────────
  group('(d) 봉투 code 별 Failure 매핑 (FailureMapper)', () {
    test('AUTH400_1 → TermsRequiredFailure(email)', () {
      final f = FailureMapper.fromCode('AUTH400_1');
      expect(f, isA<TermsRequiredFailure>());
      expect(
          (f as TermsRequiredFailure).requirements, {TermsRequirement.email});
    });

    test('AUTH400_3 → TermsRequiredFailure(nickname)', () {
      final f = FailureMapper.fromCode('AUTH400_3');
      expect(f, isA<TermsRequiredFailure>());
      expect(
          (f as TermsRequiredFailure).requirements, {TermsRequirement.nickname});
    });

    test('AUTH403_2 → RecoverableAccountFailure(inactive)', () {
      final f = FailureMapper.fromCode('AUTH403_2');
      expect(f, isA<RecoverableAccountFailure>());
      expect((f as RecoverableAccountFailure).reason, RecoverReason.inactive);
    });

    test('AUTH403_5 → RecoverableAccountFailure(deletionInProgress)', () {
      final f = FailureMapper.fromCode('AUTH403_5');
      expect(f, isA<RecoverableAccountFailure>());
      expect((f as RecoverableAccountFailure).reason,
          RecoverReason.deletionInProgress);
    });

    test('AUTH401 → InvalidTokenFailure', () {
      expect(FailureMapper.fromCode('AUTH401'), isA<InvalidTokenFailure>());
    });

    test('미매핑 code → NetworkFailure 폴백', () {
      expect(FailureMapper.fromCode('UNKNOWN_999'), isA<NetworkFailure>());
    });
  });

  // ── (e) 실 HTTP 4xx 매핑 — validateStatus 적용 경로 ─────────────────────
  //
  // 거짓 양성 제거: 기존 unwrap 테스트는 reply(200, 실패봉투) 로 throw 경로를
  // 우회했다. 여기서는 실제 HTTP 400/403 status 로 reply 해 "datasource 가
  // validateStatus 를 통해 Response 를 받고 unwrap() 이 Failure 를 생성함"을
  // 검증한다.
  group('(e) 실 HTTP 4xx → validateStatus → unwrap → Failure 자동 경로', () {
    test('HTTP 400 + AUTH400_1 봉투 → TermsRequiredFailure (validateStatus 경로)', () async {
      // validateStatus: 400 을 정상 Response 로 받는 dio
      final dio = _mainDioWithValidateStatus();
      final adapter = DioAdapter(dio: dio, matcher: _urlMatcher);

      adapter.onGet(
        '/login',
        (server) => server.reply(
          400,
          _failureEnvelope('AUTH400_1', '약관 동의 필요'),
        ),
      );

      // dio 가 400 을 throw 하지 않고 Response 로 반환
      final response = await dio.get<dynamic>('/login');
      expect(response.statusCode, 400);

      // unwrap 이 TermsRequiredFailure 를 throw
      expect(
        () => unwrap<String>(response, (j) => j as String),
        throwsA(isA<TermsRequiredFailure>()),
      );
    });

    test('HTTP 403 + AUTH403_5 봉투 → RecoverableAccountFailure (validateStatus 경로)',
        () async {
      final dio = _mainDioWithValidateStatus();
      final adapter = DioAdapter(dio: dio, matcher: _urlMatcher);

      adapter.onGet(
        '/login',
        (server) => server.reply(
          403,
          _failureEnvelope('AUTH403_5', '탈퇴 처리 중'),
        ),
      );

      final response = await dio.get<dynamic>('/login');
      expect(response.statusCode, 403);

      expect(
        () => unwrap<String>(response, (j) => j as String),
        throwsA(isA<RecoverableAccountFailure>()),
      );
    });

    test('HTTP 403 + AUTH403_2 봉투 → RecoverableAccountFailure(inactive)', () async {
      final dio = _mainDioWithValidateStatus();
      final adapter = DioAdapter(dio: dio, matcher: _urlMatcher);

      adapter.onGet(
        '/login',
        (server) => server.reply(
          403,
          _failureEnvelope('AUTH403_2', '비활성 계정'),
        ),
      );

      final response = await dio.get<dynamic>('/login');
      expect(
        () => unwrap<String>(response, (j) => j as String),
        throwsA(predicate<RecoverableAccountFailure>(
            (f) => f.reason == RecoverReason.inactive)),
      );
    });

    test('HTTP 401 은 validateStatus 에서 throw → AuthInterceptor.onError 가 처리함',
        () async {
      final store = InMemoryTokenStore();
      await store.writeTokens(access: 'token', refresh: 'rtoken');

      final refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
      final refreshAdapter = DioAdapter(dio: refreshDio, matcher: _urlMatcher);

      // refresh 성공
      refreshAdapter
        ..onPost(
          ApiEndpoints.authRefresh,
          (server) => server.reply(200, _refreshSuccess()),
        )
        ..onGet(
          '/secured',
          (server) => server.reply(200, _successEnvelope('data')),
        );

      final interceptor =
          AuthInterceptor(tokenStore: store, refreshDio: refreshDio);
      final mainDio = _mainDioWithValidateStatus(interceptors: [interceptor]);
      final mainAdapter = DioAdapter(dio: mainDio, matcher: _urlMatcher);

      // 401 은 throw 되어 AuthInterceptor.onError 진입
      mainAdapter.onGet(
        '/secured',
        (server) =>
            server.reply(401, _failureEnvelope('AUTH401', 'unauthorized')),
      );

      // refresh 후 retry 가 성공해야 한다
      final response = await mainDio.get<dynamic>('/secured');
      expect(response.statusCode, 200);
    });

    test('HTTP 400 + AUTH400_3 봉투 → TermsRequiredFailure(nickname) (validateStatus 경로)',
        () async {
      final dio = _mainDioWithValidateStatus();
      final adapter = DioAdapter(dio: dio, matcher: _urlMatcher);

      adapter.onGet(
        '/ep',
        (server) => server.reply(
          400,
          _failureEnvelope('AUTH400_3', '닉네임 필요'),
        ),
      );

      final response = await dio.get<dynamic>('/ep');
      expect(response.statusCode, 400);
      expect(
        () => unwrap<String>(response, (j) => j as String),
        throwsA(predicate<TermsRequiredFailure>(
            (f) => f.requirements.contains(TermsRequirement.nickname))),
      );
    });
  });

  // ── (f) unwrap 헬퍼 통합 (기존 reply(200) 방식 유지, 역할은 봉투 파싱 검증) ──
  group('(f) unwrap 헬퍼 봉투 파싱', () {
    test('isSuccess:true 봉투 → result 역직렬화 성공', () async {
      final dio = Dio(BaseOptions(baseUrl: _baseUrl));
      final adapter = DioAdapter(dio: dio, matcher: _urlMatcher);

      adapter.onGet(
        '/ep',
        (server) => server.reply(200, _successEnvelope('hello')),
      );

      final response = await dio.get<dynamic>('/ep');
      expect(unwrap<String>(response, (j) => j as String), 'hello');
    });

    test('isSuccess:false 봉투 (200 status) → FailureMapper 경유 throw', () async {
      final dio = Dio(BaseOptions(baseUrl: _baseUrl));
      final adapter = DioAdapter(dio: dio, matcher: _urlMatcher);

      adapter.onGet(
        '/ep',
        (server) => server.reply(200, _failureEnvelope('AUTH400_1', 'test')),
      );

      final response = await dio.get<dynamic>('/ep');
      expect(
        () => unwrap<String>(response, (j) => j as String),
        throwsA(isA<TermsRequiredFailure>()),
      );
    });
  });
}
