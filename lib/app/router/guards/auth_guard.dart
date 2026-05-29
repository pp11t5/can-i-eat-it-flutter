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
      return location == '/terms' ? null : '/terms';

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
