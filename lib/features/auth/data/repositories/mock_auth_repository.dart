import '../../domain/entities/auth_session.dart';
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
  /// [signInResult]: 카카오/Apple 양쪽 공용. 미지정 시 기본 신규 사용자.
  /// [kakaoSignInResult]/[appleSignInResult]: 프로바이더별 개별 override(W1 데모처럼
  ///   카카오/Apple 결과를 다르게 하고 싶을 때). 미지정 시 [signInResult] 폴백.
  /// [delay]: 테스트에서 loading 상태 관찰용 — [currentSession] 반환 전 대기 시간.
  ///   기본값 [Duration.zero]이므로 기존 동작/테스트에 영향 없음.
  MockAuthRepository({
    AuthSession? initialSession,
    AuthSession? signInResult,
    AuthSession? kakaoSignInResult,
    AuthSession? appleSignInResult,
    Duration delay = Duration.zero,
  })  : _session = initialSession,
        _signInResult = signInResult,
        _kakaoSignInResult = kakaoSignInResult,
        _appleSignInResult = appleSignInResult,
        _delay = delay;

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
          accountStatus: AccountStatus.active,
        ),
      );

  /// 로그인 시 기존 사용자(약관 동의됨, active) 세션을 반환하는 시나리오.
  ///
  /// 온보딩 완료 여부는 health_profile mock([MockHealthProfileRepository])이 담당한다.
  /// [.noProfile] → needsOnboarding, [.completed] → ready.
  /// [delay]: 테스트에서 loading 상태 관찰용 — [currentSession] 반환 전 대기 시간.
  factory MockAuthRepository.existing({Duration delay = Duration.zero}) =>
      MockAuthRepository(
        initialSession: null,
        signInResult: const AuthSession(
          userId: 'mock-existing',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
          accountStatus: AccountStatus.active,
        ),
        delay: delay,
      );

  /// 로그인 시 계정 삭제 유예 상태 세션을 반환하는 시나리오.
  factory MockAuthRepository.deletionGrace() => MockAuthRepository(
        initialSession: null,
        signInResult: const AuthSession(
          userId: 'mock-deletion-grace',
          provider: AuthProvider.kakao,
          hasAgreedTerms: true,
          accountStatus: AccountStatus.deletionGrace,
        ),
      );

  /// W1 데모용 시나리오.
  /// - 카카오 탭 → 신규 사용자(약관 동의 화면으로 진입)
  /// - Apple 탭 → 삭제 유예 계정(02a 다이얼로그 노출)
  /// 디자이너/PO 가 한 빌드에서 양쪽 플로우 모두 확인 가능.
  factory MockAuthRepository.w1Demo() => MockAuthRepository(
        initialSession: null,
        kakaoSignInResult: const AuthSession(
          userId: 'mock-demo-new-kakao',
          provider: AuthProvider.kakao,
          hasAgreedTerms: false,
          accountStatus: AccountStatus.active,
        ),
        appleSignInResult: const AuthSession(
          userId: 'mock-demo-deletion-apple',
          provider: AuthProvider.apple,
          hasAgreedTerms: true,
          accountStatus: AccountStatus.deletionGrace,
        ),
      );

  // ---------------------------------------------------------------------------
  // 내부 상태
  // ---------------------------------------------------------------------------

  AuthSession? _session;
  final AuthSession? _signInResult;
  final AuthSession? _kakaoSignInResult;
  final AuthSession? _appleSignInResult;
  final Duration _delay;
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
    accountStatus: AccountStatus.active,
  );

  @override
  Future<AuthSession?> currentSession() async {
    if (_delay > Duration.zero) await Future.delayed(_delay);
    return _session;
  }

  @override
  Future<AuthSession> signInWithKakao() async {
    final base = _kakaoSignInResult ?? _signInResult ?? _defaultNewUser;
    _session = base.copyWith(provider: AuthProvider.kakao);
    return _session!;
  }

  @override
  Future<AuthSession> signInWithApple() async {
    final base = _appleSignInResult ?? _signInResult ?? _defaultNewUser;
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
