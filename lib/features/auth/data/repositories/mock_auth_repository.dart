import 'package:can_i_eat_it/core/error/failure.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/consent.dart';
import '../../domain/entities/sign_in_outcome.dart';
import '../../domain/repositories/auth_repository.dart';

// ---------------------------------------------------------------------------
// 실패 전용 stub Repository (테스트용)
// ---------------------------------------------------------------------------

/// 카카오/Apple 로그인 시 지정된 [Failure]를 throw 하는 테스트 stub.
///
/// Bug A 회귀 테스트에서 unhandled exception 시나리오를 재현하기 위해 사용한다.
class ThrowingAuthRepository implements AuthRepository {
  ThrowingAuthRepository({Failure? failure})
      : _failure = failure ?? const UnexpectedFailure();

  final Failure _failure;

  @override
  Future<AuthSession?> currentSession() async => null;

  @override
  bool consumeOfflineRestoreFlag() => false;

  @override
  Future<SignInOutcome> signInWithKakao() async => throw _failure;

  @override
  Future<SignInOutcome> signInWithApple() async => throw _failure;

  @override
  Future<List<ConsentTerm>> fetchConsentTerms() async =>
      MockAuthRepository.defaultConsentTerms;

  @override
  Future<void> submitConsent(List<ConsentChoice> choices) async {}

  @override
  Future<AuthSession> recoverAccount(
    AuthProvider provider, {
    required String idToken,
  }) async =>
      throw _failure;

  @override
  Future<void> refresh() async {}

  @override
  Future<AuthSession> getMe() async => throw _failure;

  @override
  void applyLocalDisplayName(String displayName) {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> withdraw() async {}

  @override
  Future<void> signOut() async {}
}

/// [AuthRepository] 인메모리 Mock 구현.
///
/// 실 구현(카카오 SDK + 서버 JWT)은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// 테스트에서 시나리오별 named factory를 사용해 의도를 명확히 표현할 수 있다.
///
/// 온보딩 완료 여부는 W2부터 health_profile 피처가 소유한다(ADR-0006).
/// [MockHealthProfileRepository.noProfile]/[.completed]로 시나리오를 구성한다.
class MockAuthRepository implements AuthRepository {
  /// [initialSession]: [currentSession]이 최초 반환할 세션(null = 미인증).
  /// [kakaoOutcome]: 카카오 로그인 결과. 미지정 시 기본 신규 사용자 인증 결과.
  /// [appleOutcome]: Apple 로그인 결과. 미지정 시 [kakaoOutcome] 폴백.
  /// [delay]: 테스트에서 loading 상태 관찰용 — [currentSession] 반환 전 대기 시간.
  ///   기본값 [Duration.zero]이므로 기존 동작/테스트에 영향 없음.
  /// [failRecoverTimes]: [recoverAccount] 호출이 실패해야 하는 횟수(재시도
  ///   어포던스 테스트용). 기본 0 — 즉시 성공(기존 동작 불변).
  MockAuthRepository({
    AuthSession? initialSession,
    SignInOutcome? kakaoOutcome,
    SignInOutcome? appleOutcome,
    Duration delay = Duration.zero,
    int failRecoverTimes = 0,
    List<ConsentTerm> consentTerms = defaultConsentTerms,
    Object? consentFetchError,
    Duration consentFetchDelay = Duration.zero,
    Object? consentSubmitError,
    Duration consentSubmitDelay = Duration.zero,
  })  : _session = initialSession,
        _kakaoOutcome = kakaoOutcome,
        _appleOutcome = appleOutcome,
        _delay = delay,
        _failRecoverTimes = failRecoverTimes,
        _consentTerms = consentTerms,
        _consentFetchError = consentFetchError,
        _consentFetchDelay = consentFetchDelay,
        _consentSubmitError = consentSubmitError,
        _consentSubmitDelay = consentSubmitDelay;

  // ---------------------------------------------------------------------------
  // 시나리오 named factory
  // ---------------------------------------------------------------------------

  /// 미인증 상태. [currentSession]이 null을 반환한다.
  factory MockAuthRepository.signedOut() =>
      MockAuthRepository(initialSession: null);

  /// 로그인 시 신규 사용자 → 토큰 발급 + 온보딩 미완료 + 약관 pending.
  factory MockAuthRepository.newUser() => MockAuthRepository(
        initialSession: null,
        kakaoOutcome: const Authenticated(
          session: AuthSession(
            userId: 'mock-new-user',
            provider: AuthProvider.kakao,
            hasAgreedTerms: false,
          ),
          onboarded: false,
        ),
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
          session: AuthSession(
            userId: 'mock-existing',
            provider: AuthProvider.kakao,
            hasAgreedTerms: onboarded,
            accountStatus: AccountStatus.active,
          ),
          onboarded: onboarded,
        ),
        delay: delay,
      );

  /// 로그인 시 계정 삭제 유예 상태 → [Recoverable].
  ///
  /// [failRecoverTimes]: recoverAccount 재시도 테스트용 — 지정 횟수만큼 실패
  /// 후 성공한다. 기본 0(즉시 성공).
  factory MockAuthRepository.deletionGrace({int failRecoverTimes = 0}) =>
      MockAuthRepository(
        initialSession: null,
        kakaoOutcome: const Recoverable(
          reason: RecoverReason.deletionInProgress,
          provider: AuthProvider.kakao,
          idToken: 'mock-id-token',
        ),
        failRecoverTimes: failRecoverTimes,
      );

  /// W1 데모용 시나리오.
  /// - 카카오 탭 → 신규 사용자(약관 동의 화면으로 진입)
  /// - Apple 탭 → 삭제 유예 계정(02a 다이얼로그 노출)
  /// 디자이너/PO 가 한 빌드에서 양쪽 플로우 모두 확인 가능.
  factory MockAuthRepository.w1Demo() => MockAuthRepository(
        initialSession: null,
        kakaoOutcome: const Authenticated(
          session: AuthSession(
            userId: 'mock-new-user',
            provider: AuthProvider.kakao,
            hasAgreedTerms: false,
          ),
          onboarded: false,
        ),
        appleOutcome: const Recoverable(
          reason: RecoverReason.deletionInProgress,
          provider: AuthProvider.apple,
          idToken: 'mock-id-token',
        ),
      );

  // ---------------------------------------------------------------------------
  // 내부 상태
  // ---------------------------------------------------------------------------

  AuthSession? _session;
  final SignInOutcome? _kakaoOutcome;
  final SignInOutcome? _appleOutcome;
  final Duration _delay;
  int _failRecoverTimes;
  final List<ConsentTerm> _consentTerms;
  final Object? _consentFetchError;
  final Duration _consentFetchDelay;
  final Object? _consentSubmitError;
  final Duration _consentSubmitDelay;
  List<ConsentChoice>? _lastConsentChoices;
  int _submitConsentCallCount = 0;

  /// 마지막으로 제출된 약관 선택값. 테스트 검증용.
  List<ConsentChoice>? get lastConsentChoices => _lastConsentChoices;
  int get submitConsentCallCount => _submitConsentCallCount;

  // ---------------------------------------------------------------------------
  // 기본 SignInOutcome (newUser)
  // ---------------------------------------------------------------------------

  static const SignInOutcome _defaultOutcome = Authenticated(
    session: AuthSession(
      userId: 'mock-new-user',
      provider: AuthProvider.kakao,
      hasAgreedTerms: false,
    ),
    onboarded: false,
  );

  static const List<ConsentTerm> defaultConsentTerms = [
    ConsentTerm(
      id: 1,
      code: 'tos',
      version: '1.0',
      title: '서비스 이용약관',
      content: 'https://example.com/tos',
      isRequired: true,
    ),
    ConsentTerm(
      id: 2,
      code: 'privacy',
      version: '1.0',
      title: '개인정보 수집·이용 동의',
      content: 'https://example.com/privacy',
      isRequired: true,
    ),
    ConsentTerm(
      id: 3,
      code: 'health_sensitive',
      version: '1.0',
      title: '민감정보(건강) 수집 동의',
      content: 'https://example.com/health',
      isRequired: true,
    ),
    ConsentTerm(
      id: 4,
      code: 'marketing',
      version: '1.0',
      title: '마케팅·푸시 알림 수신',
      content: 'https://example.com/marketing',
      isRequired: false,
    ),
  ];

  // ---------------------------------------------------------------------------
  // AuthRepository 구현
  // ---------------------------------------------------------------------------

  @override
  Future<AuthSession?> currentSession() async {
    if (_delay > Duration.zero) await Future.delayed(_delay);
    return _session;
  }

  @override
  bool consumeOfflineRestoreFlag() =>
      false; // Mock 에서는 항상 false (오프라인 시나리오 불필요).

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
  Future<List<ConsentTerm>> fetchConsentTerms() async {
    if (_consentFetchDelay > Duration.zero) {
      await Future<void>.delayed(_consentFetchDelay);
    }
    final error = _consentFetchError;
    if (error != null) throw error;
    return List.unmodifiable(_consentTerms);
  }

  @override
  Future<void> submitConsent(List<ConsentChoice> choices) async {
    if (_session == null) {
      throw StateError(
        'submitConsent: 활성 세션이 없습니다. signIn 후 호출해야 합니다.',
      );
    }
    _submitConsentCallCount++;
    if (_consentSubmitDelay > Duration.zero) {
      await Future<void>.delayed(_consentSubmitDelay);
    }
    final error = _consentSubmitError;
    if (error != null) throw error;
    _lastConsentChoices = List.unmodifiable(choices);
    _session = _session!.copyWith(hasAgreedTerms: true);
  }

  @override
  Future<AuthSession> recoverAccount(
    AuthProvider provider, {
    required String idToken,
  }) async {
    // 재시도 어포던스 테스트용: 지정 횟수만큼 실패 후 성공.
    if (_failRecoverTimes > 0) {
      _failRecoverTimes--;
      throw const UnexpectedFailure();
    }
    // 403 경로는 _session=null 상태. Mock 은 새 active 세션을 합성해 반환한다.
    // idToken 은 실 구현에서 서버로 전달되지만 Mock 에서는 무시한다.
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
  void applyLocalDisplayName(String displayName) {
    final current = _session;
    if (current == null) return;
    _session = current.copyWith(displayName: displayName);
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
  /// - [Recoverable]: 세션 없음 (서버에서 토큰 미발급, ADR-0007 §3-1 (6-B)).
  void _applyOutcomeToSession(SignInOutcome outcome, AuthProvider provider) {
    switch (outcome) {
      case Authenticated(:final session):
        _session = session.copyWith(provider: provider);
      case Recoverable():
        // 복구 가능 계정은 토큰 미발급 → 세션 없음 (ADR-0007 §3-1 (6-B)).
        // recoverAccount(provider) 가 새 active 세션을 합성하므로 여기서 합성 불필요.
        _session = null;
    }
  }
}
