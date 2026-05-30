import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';

/// 라우트 접근 가드 순수 함수 (ADR-0002 §4).
/// BuildContext/위젯 비의존 — 단위 테스트 가능.
///
/// 반환 값:
///   null   → 리다이렉트 없음 (현재 location 유지)
///   String → 리다이렉트 목적지
String? resolveRedirect({
  required SessionStatus status,
  required String location,
}) {
  switch (status) {
    case SessionStatus.unauthenticated:
      return location == '/login' ? null : '/login';

    case SessionStatus.needsTerms:
      // **가드는 절대 /terms 로 redirect 하지 않는다** (모든 location 허용).
      // 이유: 가드 redirect 는 replace 라 iOS pop 애니메이션 불가능 + pop 직후
      // 가드 재평가로 인한 /terms 재진입 버그 회피. LoginScreen 이 imperative
      // context.push('/terms') 로만 진입을 관리한다. pop = signOut(가입취소).
      return null;

    case SessionStatus.needsOnboarding:
      return location.startsWith('/onboarding') ? null : '/onboarding/intro';

    case SessionStatus.ready:
      if (location == '/splash' ||
          location == '/login' ||
          location == '/terms' ||
          location.startsWith('/onboarding')) {
        return '/';
      }
      return null;
  }
}
