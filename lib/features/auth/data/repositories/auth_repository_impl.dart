import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/core/security/token_store.dart';
import 'package:can_i_eat_it/features/auth/data/dtos/auth_login_response_dto.dart';
import 'package:can_i_eat_it/features/auth/data/dtos/auth_me_response_dto.dart';
import 'package:can_i_eat_it/features/auth/data/dtos/consent_request_dto.dart';
import 'package:can_i_eat_it/features/auth/data/dtos/onboarding_status_dto.dart';
import 'package:can_i_eat_it/features/auth/data/services/kakao_auth_service.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/sign_in_outcome.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/terms_agreement.dart';
import 'package:can_i_eat_it/features/auth/domain/repositories/auth_repository.dart';

/// [AuthRepository] 실 구현 (ADR-0007 §3-1 (6-A)).
///
/// 카카오 OIDC idToken → `POST /auth/{provider}/login` → JWT 토큰 저장.
/// 성공 시 `GET /onboarding/status` 를 이어 호출해 [Authenticated.onboarded] 를 채운다.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required Dio dio,
    required TokenStore tokenStore,
    required KakaoAuthService kakaoAuthService,
  })  : _dio = dio,
        _tokenStore = tokenStore,
        _kakaoAuthService = kakaoAuthService;

  final Dio _dio;
  final TokenStore _tokenStore;
  final KakaoAuthService _kakaoAuthService;

  /// 현재 로컬 세션 (토큰 기반 in-memory 캐시).
  AuthSession? _session;

  /// 콜드스타트 시 오프라인으로 인해 토큰은 보존됐지만 세션 재수화에 실패했음을 나타내는 플래그.
  bool _lastRestoreWasOffline = false;

  // ---------------------------------------------------------------------------
  // AuthRepository 구현
  // ---------------------------------------------------------------------------

  @override
  Future<AuthSession?> currentSession() async {
    if (_session != null) return _session;
    // 콜드스타트 재수화: 토큰이 있으면 GET /auth/me 로 세션을 복원한다.
    final token = await _tokenStore.readAccessToken();
    if (token == null) return null;
    try {
      return await getMe();
    } on NetworkFailure {
      // 연결 오류 — 토큰 보존, 오프라인 플래그 set.
      _lastRestoreWasOffline = true;
      return null;
    } on SessionExpiredFailure {
      await _tokenStore.clear();
      return null;
    } on AuthFailure {
      await _tokenStore.clear();
      return null;
    }
  }

  @override
  bool consumeOfflineRestoreFlag() {
    final flag = _lastRestoreWasOffline;
    _lastRestoreWasOffline = false;
    return flag;
  }

  @override
  Future<SignInOutcome> signInWithKakao() async {
    return _signIn(AuthProvider.kakao);
  }

  @override
  Future<SignInOutcome> signInWithApple() async {
    // 베타는 카카오 단독 (ADR-0003 §7). Apple Mock 경로는 유지.
    // TODO: Apple OIDC 실연동 시 apple provider 로 교체.
    return _signIn(AuthProvider.apple);
  }

  @override
  Future<void> recordTermsAgreement(TermsAgreement agreement) async {
    if (_session == null) {
      throw StateError(
        'recordTermsAgreement: 활성 세션이 없습니다. signIn 후 호출해야 합니다.',
      );
    }
    final dto = ConsentRequestDto.fromEntity(agreement);
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.consent,
        data: dto.toJson(),
      );
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
    _session = _session!.copyWith(hasAgreedTerms: true);
  }

  @override
  Future<AuthSession> recoverAccount(
    AuthProvider provider, {
    required String idToken,
  }) async {
    // 403 복구 경로: 로그인 시 획득한 idToken 을 재사용해 카카오 SDK 재인증 없이 복구.
    final response = await _dio.post<dynamic>(
      ApiEndpoints.authRecover(provider.name),
      data: {'idToken': idToken},
    );

    final dto = unwrap<AuthLoginResponseDto>(
      response,
      (json) => AuthLoginResponseDto.fromJson(json as Map<String, dynamic>),
    );

    await _tokenStore.writeTokens(
      access: dto.accessToken,
      refresh: dto.refreshToken,
    );

    _session = dto.toEntity(provider);
    return _session!;
  }

  @override
  Future<void> refresh() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    if (refreshToken == null) throw const SessionExpiredFailure();

    final response = await _dio.post<dynamic>(
      ApiEndpoints.authRefresh,
      data: {'refreshToken': refreshToken},
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const SessionExpiredFailure('토큰 갱신 응답 형식이 올바르지 않아요.');
    }
    final newAccess = body['result']?['accessToken'] as String?;
    final newRefresh = body['result']?['refreshToken'] as String?;
    if (newAccess == null || newRefresh == null) {
      throw const SessionExpiredFailure('토큰 갱신 응답에 토큰이 없어요.');
    }
    await _tokenStore.writeTokens(access: newAccess, refresh: newRefresh);
  }

  @override
  Future<AuthSession> getMe() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.authMe);
      final dto = unwrap<AuthMeResponseDto>(
        response,
        (json) => AuthMeResponseDto.fromJson(json as Map<String, dynamic>),
      );
      final provider = _session?.provider ?? AuthProvider.kakao;
      _session = dto.toEntity(provider);
      return _session!;
    } on DioException catch (e) {
      // 인터셉터가 SessionExpiredFailure 를 e.error 에 실어 전파한다.
      if (e.error is Failure) throw e.error as Failure;
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    final refreshToken = await _tokenStore.readRefreshToken();
    try {
      await _dio.delete<dynamic>(
        ApiEndpoints.authLogout,
        data: refreshToken != null ? {'refreshToken': refreshToken} : null,
      );
    } catch (_) {
      // 서버 로그아웃 실패해도 로컬은 반드시 클리어
    } finally {
      await _tokenStore.clear();
      _session = null;
    }
  }

  @override
  Future<void> withdraw() async {
    try {
      await _dio.delete<dynamic>(ApiEndpoints.authWithdraw);
    } catch (_) {
      // 서버 탈퇴 실패해도 로컬은 반드시 클리어
    } finally {
      await _tokenStore.clear();
      _session = null;
    }
  }

  @override
  Future<void> signOut() async {
    await _tokenStore.clear();
    _session = null;
  }

  // ---------------------------------------------------------------------------
  // 내부 헬퍼
  // ---------------------------------------------------------------------------

  /// 소셜 로그인 공통 흐름.
  ///
  /// 1. 카카오 SDK 로 idToken 획득 (Apple은 TODO)
  /// 2. `POST /auth/{provider}/login` 호출
  /// 3. 성공(200) → 토큰 저장 + `GET /onboarding/status` → [Authenticated]
  /// 4. [TermsRequiredFailure] catch → [NeedsTerms]
  /// 5. [RecoverableAccountFailure] catch → [Recoverable]
  Future<SignInOutcome> _signIn(AuthProvider provider) async {
    // idToken 을 try 블록 밖에 선언 — RecoverableAccountFailure catch 에서 운반하기 위함.
    String? idToken;
    try {
      // 1. idToken 획득
      if (provider == AuthProvider.kakao) {
        final kakaoResult = await _kakaoAuthService.signIn();
        idToken = kakaoResult.idToken;
      } else {
        // Apple OIDC — 티켓 4 이후 실연동. 현재는 에러 (테스트에서 override).
        throw UnimplementedError('Apple 로그인은 아직 구현되지 않았습니다.');
      }

      // 2. 서버 로그인
      final loginResponse = await _dio.post<dynamic>(
        ApiEndpoints.authLogin(provider.name),
        data: {'idToken': idToken},
      );

      final loginDto = unwrap<AuthLoginResponseDto>(
        loginResponse,
        (json) => AuthLoginResponseDto.fromJson(json as Map<String, dynamic>),
      );

      // 3. 토큰 저장
      await _tokenStore.writeTokens(
        access: loginDto.accessToken,
        refresh: loginDto.refreshToken,
      );
      _session = loginDto.toEntity(provider);

      // 4. GET /onboarding/status — 방금 받은 accessToken 이 AuthInterceptor 에 주입됨
      final statusResponse = await _dio.get<dynamic>(ApiEndpoints.onboardingStatus);
      final statusDto = unwrap<OnboardingStatusDto>(
        statusResponse,
        (json) => OnboardingStatusDto.fromJson(json as Map<String, dynamic>),
      );

      return Authenticated(session: _session!, onboarded: statusDto.onboarded);
    } on TermsRequiredFailure catch (f) {
      return NeedsTerms(requirements: f.requirements);
    } on RecoverableAccountFailure catch (f) {
      // idToken 은 카카오 획득 직후 대입됐으므로 null 이 아님.
      return Recoverable(reason: f.reason, provider: provider, idToken: idToken!);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
