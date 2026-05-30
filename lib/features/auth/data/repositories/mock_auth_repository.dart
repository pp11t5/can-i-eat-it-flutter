import '../../domain/entities/auth_session.dart';
import '../../domain/entities/terms_agreement.dart';
import '../../domain/repositories/auth_repository.dart';

/// [AuthRepository] 인메모리 Mock 구현.
///
/// 실 구현(카카오 SDK + 서버 JWT)은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// 테스트에서 시나리오별 named factory를 사용해 의도를 명확히 표현할 수 있다.
class MockAuthRepository implements AuthRepository {
  /// [initialSession]: [currentSession]이 최초 반환할 세션(null = 미인증).
  /// [signInResult]: [signInWithKakao]/[signInWithApple]이 반환·설정할 세션.
  ///   미지정 시 기본 신규 사용자(hasAgreedTerms=false, hasCompletedOnboarding=false, active).
  MockAuthRepository({
    AuthSession? initialSession,
    AuthSession? signInResult,
  })  : _session = initialSession,
        _signInResult = signInResult;

  // ---------------------------------------------------------------------------
  // 시나리오 named factory
  // ---------------------------------------------------------------------------

  /// 미인증 상태. [currentSession]이 null을 반환한다.
  factory MockAuthRepository.signedOut() =>
      MockAuthRepository(initialSession: null);

  /// 로그인 시 신규 사용자(약관 미동의) 세션을 반환하는 시나리오.
  factory MockAuthRepository.newUser() => MockAuthRepository(
        initialSession: null,
        signInResult: const AuthSession(
          userId: 'mock-new-user',
          provider: AuthProvider.kakao,
          hasAgreedTerms: false,
          hasCompletedOnboarding: false,
          accountStatus: AccountStatus.active,
        ),
      );

  /// 로그인 시 기존 사용자(약관 동의됨, 온보딩 미완료) 세션을 반환하는 시나리오.
  factory MockAuthRepository.existingNotOnboarded() => MockAuthRepository(
        initialSession: null,
        signInResult: const AuthSession(
          userId: 'mock-existing-not-onboarded',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
          hasCompletedOnboarding: false,
          accountStatus: AccountStatus.active,
        ),
      );

  /// 로그인 시 기존 사용자(약관·온보딩 완료, ready) 세션을 반환하는 시나리오.
  factory MockAuthRepository.existingOnboarded() => MockAuthRepository(
        initialSession: null,
        signInResult: const AuthSession(
          userId: 'mock-existing-onboarded',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
          hasCompletedOnboarding: true,
          accountStatus: AccountStatus.active,
        ),
      );

  /// 로그인 시 계정 삭제 유예 상태 세션을 반환하는 시나리오.
  factory MockAuthRepository.deletionGrace() => MockAuthRepository(
        initialSession: null,
        signInResult: const AuthSession(
          userId: 'mock-deletion-grace',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
          hasCompletedOnboarding: true,
          accountStatus: AccountStatus.deletionGrace,
        ),
      );

  // ---------------------------------------------------------------------------
  // 내부 상태
  // ---------------------------------------------------------------------------

  AuthSession? _session;
  final AuthSession? _signInResult;
  TermsAgreement? _lastTermsAgreement;

  /// 마지막으로 기록된 약관 동의 이력. 테스트 검증용.
  TermsAgreement? get lastTermsAgreement => _lastTermsAgreement;

  // ---------------------------------------------------------------------------
  // AuthRepository 구현
  // ---------------------------------------------------------------------------

  static const AuthSession _defaultNewUser = AuthSession(
    userId: 'mock-new-user',
    provider: AuthProvider.kakao,
    hasAgreedTerms: false,
    hasCompletedOnboarding: false,
    accountStatus: AccountStatus.active,
  );

  @override
  Future<AuthSession?> currentSession() async => _session;

  @override
  Future<AuthSession> signInWithKakao() async {
    final base = _signInResult ?? _defaultNewUser;
    _session = base.copyWith(provider: AuthProvider.kakao);
    return _session!;
  }

  @override
  Future<AuthSession> signInWithApple() async {
    final base = _signInResult ?? _defaultNewUser;
    _session = base.copyWith(provider: AuthProvider.apple);
    return _session!;
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
  Future<AuthSession> recoverAccount() async {
    if (_session == null) {
      throw StateError(
        'recoverAccount: 활성 세션이 없습니다.',
      );
    }
    _session = _session!.copyWith(accountStatus: AccountStatus.active);
    return _session!;
  }

  @override
  Future<void> signOut() async {
    _session = null;
  }
}
