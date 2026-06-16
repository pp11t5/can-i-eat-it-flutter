import 'package:can_i_eat_it/core/error/failure.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/sign_in_outcome.dart';
import '../../domain/entities/terms_agreement.dart';
import '../../domain/repositories/auth_repository.dart';

/// [AuthRepository] 인메모리 Mock 구현.
///
/// 실 구현(카카오 SDK + 서버 JWT)은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// 테스트에서 시나리오별 named factory를 사용해 의도를 명확히 표현할 수 있다.
///
/// 온보딩 완료 여부는 W2부터 health_profile 피처가 소유한다(ADR-0006).
/// [MockHealthProfileRepository.noProfile]/[.completed]로 시나리오를 구성한다.
class MockAuthRepository implements AuthRepository {
  /// [initialSession]: [currentSession]이 최초 반환할 세션(null = 미인증).
  /// [kakaoOutcome]: 카카오 로그인 결과. 미지정 시 기본 NeedsTerms(newUser).
  /// [appleOutcome]: Apple 로그인 결과. 미지정 시 [kakaoOutcome] 폴백.
  /// [delay]: 테스트에서 loading 상태 관찰용 — [currentSession] 반환 전 대기 시간.
  ///   기본값 [Duration.zero]이므로 기존 동작/테스트에 영향 없음.
  MockAuthRepository({
    AuthSession? initialSession,
    SignInOutcome? kakaoOutcome,
    SignInOutcome? appleOutcome,
    Duration delay = Duration.zero,
  })  : _session = initialSession,
        _kakaoOutcome = kakaoOutcome,
        _appleOutcome = appleOutcome,
        _delay = delay;

  // ---------------------------------------------------------------------------
  // 시나리오 named factory
  // ---------------------------------------------------------------------------

  /// 미인증 상태. [currentSession]이 null을 반환한다.
  factory MockAuthRepository.signedOut() =>
      MockAuthRepository(initialSession: null);

  /// 로그인 시 신규 사용자(약관 미동의) → [NeedsTerms].
  factory MockAuthRepository.newUser() => MockAuthRepository(
        initialSession: null,
        kakaoOutcome: const NeedsTerms(requirements: {}),
      );

  /// 로그인 시 기존 사용자(약관 동의됨, active) → [Authenticated].
  ///
  /// 온보딩 완료 여부는 health_profile mock([MockHealthProfileRepository])이 담당한다.
  /// [.noProfile] → needsOnboarding, [.completed] → ready.
  /// [onboarded]: Authenticated.onboarded 값 (기본 false — health_profile mock 과 연계).
  /// [delay]: 테스트에서 loading 상태 관찰용 — [currentSession] 반환 전 대기 시간.
  factory MockAuthRepository.existing({
    bool onboarded = false,
    Duration delay = Duration.zero,
  }) =>
      MockAuthRepository(
        initialSession: null,
        kakaoOutcome: Authenticated(
          session: const AuthSession(
            userId: 'mock-existing',
            provider: AuthProvider.kakao,
            hasAgreedTerms: true,
            accountStatus: AccountStatus.active,
          ),
          onboarded: onboarded,
        ),
        delay: delay,
      );

  /// 로그인 시 계정 삭제 유예 상태 → [Recoverable].
  factory MockAuthRepository.deletionGrace() => MockAuthRepository(
        initialSession: null,
        kakaoOutcome: const Recoverable(
          reason: RecoverReason.deletionInProgress,
          provider: AuthProvider.kakao,
        ),
      );

  /// W1 데모용 시나리오.
  /// - 카카오 탭 → 신규 사용자(약관 동의 화면으로 진입)
  /// - Apple 탭 → 삭제 유예 계정(02a 다이얼로그 노출)
  /// 디자이너/PO 가 한 빌드에서 양쪽 플로우 모두 확인 가능.
  factory MockAuthRepository.w1Demo() => MockAuthRepository(
        initialSession: null,
        kakaoOutcome: const NeedsTerms(requirements: {}),
        appleOutcome: const Recoverable(
          reason: RecoverReason.deletionInProgress,
          provider: AuthProvider.apple,
        ),
      );

  // ---------------------------------------------------------------------------
  // 내부 상태
  // ---------------------------------------------------------------------------

  AuthSession? _session;
  final SignInOutcome? _kakaoOutcome;
  final SignInOutcome? _appleOutcome;
  final Duration _delay;
  TermsAgreement? _lastTermsAgreement;

  /// 마지막으로 기록된 약관 동의 이력. 테스트 검증용.
  TermsAgreement? get lastTermsAgreement => _lastTermsAgreement;

  // ---------------------------------------------------------------------------
  // 기본 SignInOutcome (newUser)
  // ---------------------------------------------------------------------------

  static const SignInOutcome _defaultOutcome = NeedsTerms(requirements: {});

  // ---------------------------------------------------------------------------
  // AuthRepository 구현
  // ---------------------------------------------------------------------------

  @override
  Future<AuthSession?> currentSession() async {
    if (_delay > Duration.zero) await Future.delayed(_delay);
    return _session;
  }

  @override
  Future<SignInOutcome> signInWithKakao() async {
    final outcome = _kakaoOutcome ?? _defaultOutcome;
    _applyOutcomeToSession(outcome, AuthProvider.kakao);
    return outcome;
  }

  @override
  Future<SignInOutcome> signInWithApple() async {
    final outcome = _appleOutcome ?? _kakaoOutcome ?? _defaultOutcome;
    _applyOutcomeToSession(outcome, AuthProvider.apple);
    return outcome;
  }

  @override
  Future<void> recordTermsAgreement(TermsAgreement agreement) async {
    if (_session == null) {
      throw StateError(
        'recordTermsAgreement: 활성 세션이 없습니다. signIn 후 호출해야 합니다.',
      );
    }
    _lastTermsAgreement = agreement;
    _session = _session!.copyWith(hasAgreedTerms: true);
  }

  @override
  Future<AuthSession> recoverAccount(AuthProvider provider) async {
    // 403 경로는 _session=null 상태. Mock 은 새 active 세션을 합성해 반환한다.
    _session = AuthSession(
      userId: 'mock-recovered',
      provider: provider,
      hasAgreedTerms: true,
      accountStatus: AccountStatus.active,
    );
    return _session!;
  }

  @override
  Future<void> refresh() async {
    // Mock: no-op
  }

  @override
  Future<AuthSession> getMe() async {
    if (_session == null) {
      throw StateError('getMe: 활성 세션이 없습니다.');
    }
    return _session!;
  }

  @override
  Future<void> logout() async {
    _session = null;
  }

  @override
  Future<void> withdraw() async {
    _session = null;
  }

  @override
  Future<void> signOut() async {
    _session = null;
  }

  // ---------------------------------------------------------------------------
  // 내부 헬퍼
  // ---------------------------------------------------------------------------

  /// [SignInOutcome] 을 내부 _session 에 반영한다.
  ///
  /// - [Authenticated]: session 을 그대로 저장 (provider override).
  /// - [NeedsTerms]: 약관 미동의 신규 세션 합성 (세션 없는 상태가 정상이나
  ///   recordTermsAgreement 등에서 세션이 필요하므로 임시 세션을 설정).
  /// - [Recoverable]: 세션 없음 (서버에서 토큰 미발급, ADR-0007 §3-1 (6-B)).
  void _applyOutcomeToSession(SignInOutcome outcome, AuthProvider provider) {
    switch (outcome) {
      case Authenticated(:final session):
        _session = session.copyWith(provider: provider);
      case NeedsTerms():
        // 약관 미동의는 임시 세션 합성 (recordTermsAgreement 가 세션 필요).
        _session = AuthSession(
          userId: 'mock-new-user',
          provider: provider,
          hasAgreedTerms: false,
          accountStatus: AccountStatus.active,
        );
      case Recoverable():
        // 복구 가능 계정은 토큰 미발급 → 세션 없음 (ADR-0007 §3-1 (6-B)).
        // recoverAccount(provider) 가 새 active 세션을 합성하므로 여기서 합성 불필요.
        _session = null;
    }
  }
}
