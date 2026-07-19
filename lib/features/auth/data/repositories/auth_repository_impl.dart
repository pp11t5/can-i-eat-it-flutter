import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/config/terms_catalog.dart';
import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/core/security/token_store.dart';
import 'package:can_i_eat_it/features/auth/data/dtos/auth_login_response_dto.dart';
import 'package:can_i_eat_it/features/auth/data/dtos/auth_me_response_dto.dart';
import 'package:can_i_eat_it/features/auth/data/dtos/consent_request_dto.dart';
import 'package:can_i_eat_it/features/auth/data/dtos/onboarding_status_dto.dart';
import 'package:can_i_eat_it/features/auth/data/dtos/term_response_dto.dart';
import 'package:can_i_eat_it/features/auth/data/services/apple_auth_service.dart';
import 'package:can_i_eat_it/features/auth/data/services/kakao_auth_service.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/sign_in_outcome.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/terms_agreement.dart';
import 'package:can_i_eat_it/features/auth/domain/repositories/auth_repository.dart';

/// [AuthRepository] 실 구현 (ADR-0007 §3-1 (6-A)).
///
/// 카카오/애플 OIDC idToken → `POST /auth/{provider}/login` → JWT 토큰 저장.
/// 성공 시 `GET /onboarding/status` 를 이어 호출해 [Authenticated.onboarded] 를 채운다.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required Dio dio,
    required TokenStore tokenStore,
    required KakaoAuthService kakaoAuthService,
    required AppleAuthService appleAuthService,
  })  : _dio = dio,
        _tokenStore = tokenStore,
        _kakaoAuthService = kakaoAuthService,
        _appleAuthService = appleAuthService;

  final Dio _dio;
  final TokenStore _tokenStore;
  final KakaoAuthService _kakaoAuthService;
  final AppleAuthService _appleAuthService;

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
    } on Failure {
      // 미예상 실패(UnexpectedFailure 등 — 예: 5xx·봉투 이상).
      // 일시적 서버 오류로 간주: 토큰 보존 + 오프라인 플래그 미설정 + null 반환.
      // build로 예외가 새지 않아 AsyncError 누출 차단 (O1 수정).
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
    return _signIn(AuthProvider.apple);
  }

  @override
  Future<void> recordTermsAgreement(TermsAgreement agreement) async {
    if (_session == null) {
      throw StateError(
        'recordTermsAgreement: 활성 세션이 없습니다. signIn 후 호출해야 합니다.',
      );
    }

    // 1) GET /consent/terms — termId 조인용 약관 목록. 하드코딩 절대 금지(규제성).
    //    폴백 없이 실패 시 재시도 유도(원인과 무관하게 동일 메시지로 통일).
    final List<TermResponseDto> terms;
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.consentTerms);
      final items = unwrap<List<dynamic>>(
        response,
        (json) => json as List<dynamic>,
      );
      terms = items
          .map((e) => TermResponseDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const NetworkFailure('약관 정보를 불러오지 못했어요. 다시 시도해 주세요');
    }

    // 2) 서버 term.code → 로컬 슬롯 매핑 + requiredButNotAgreed 로컬 검증.
    //    required=true 인데 (a) agreed=false 이거나 (b) UI 미표시(미인식) code 면
    //    무성 400 대신 여기서 명시적으로 실패시킨다.
    final consents = <ConsentItemDto>[];
    for (final term in terms) {
      final agreed = _resolveLocalAgreement(term.code, agreement);
      if (agreed == null) {
        // 로컬 UI가 표시하지 않는(미인식) code.
        if (term.isRequired) {
          throw const NetworkFailure('필수 약관에 모두 동의해야 계속할 수 있어요.');
        }
        // 선택 항목이면 대응 로컬 슬롯이 없으므로 consents에서 생략.
        continue;
      }
      if (term.isRequired && !agreed) {
        throw const NetworkFailure('필수 약관에 모두 동의해야 계속할 수 있어요.');
      }
      consents.add(ConsentItemDto(termId: term.id, agreed: agreed));
    }
    // 서버가 아직 약관을 시드하지 않은 경우(현재 dev: GET /consent/terms → [])
    // consents 는 빈 배열이 된다 — 전방호환 정상 동작(서버 시드 시 자동 반영).

    // 3) POST /consent
    final dto = ConsentRequestDto(consents: consents);
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

  /// 서버 약관 [code] → 로컬 [TermsAgreement] 슬롯 매핑.
  ///
  /// 반환값 `null`은 미인식 code(로컬 UI가 표시하지 않는 약관 항목)를 뜻하며
  /// 호출부가 [TermResponseDto.isRequired] 여부에 따라 처리한다.
  bool? _resolveLocalAgreement(String code, TermsAgreement agreement) {
    switch (code) {
      case TermsCatalogCodes.tos:
        return agreement.termsOfService;
      case TermsCatalogCodes.privacy:
        return agreement.privacy;
      case TermsCatalogCodes.healthSensitive:
        return agreement.sensitiveInfo;
      case TermsCatalogCodes.marketing:
        return agreement.marketing;
      default:
        return null;
    }
  }

  @override
  Future<AuthSession> recoverAccount(
    AuthProvider provider, {
    required String idToken,
  }) async {
    // 403 복구 경로: 로그인 시 획득한 idToken 을 재사용해 카카오 SDK 재인증 없이 복구.
    try {
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
    } on DioException catch (e) {
      // _signIn/getMe/recordTermsAgreement 와 동일 계약 유지 (M1 수정).
      throw FailureMapper.fromDioException(e);
    }
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
  /// 1. 카카오/애플 SDK 로 idToken 획득
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
        final appleResult = await _appleAuthService.signIn();
        idToken = appleResult.idToken;
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
