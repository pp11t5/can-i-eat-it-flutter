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
      // /login 도 허용: LoginScreen 이 명시적 push 로 /terms 에 진입해
      // iOS Cupertino pop 애니메이션을 자연스럽게 만든다.
      // (가드가 redirect 로 /terms 를 강제하면 replace 라 pop 이 불가능.)
      if (location == '/terms' || location == '/login') return null;
      return '/terms';

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
