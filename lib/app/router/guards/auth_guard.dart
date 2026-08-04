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
    case SessionStatus.loading:
      // 로딩 중에는 redirect 없이 현재 화면(splash)에 잔류시킨다.
      // 이로써 인증/health_profile 로드가 완료되기 전 화면 깜빡임(이슈 #20 S1)을 차단한다.
      return null;

    case SessionStatus.unauthenticated:
      return location == '/login' ? null : '/login';

    case SessionStatus.needsTerms:
      // 소셜 로그인 직후에는 LoginScreen이 push로 진입하고, 약관 화면에서 앱이
      // 종료된 콜드스타트에는 저장된 pending 상태로 /terms를 복원한다.
      // /login 허용은 pop 애니메이션 뒤 post-frame signOut이 완료될 시간을 준다.
      return (location == '/terms' || location == '/login') ? null : '/terms';

    case SessionStatus.needsOnboarding:
      // /onboarding 하위 + /login 허용. /login 은 온보딩 1페이지 뒤로가기의 이탈 목적지로,
      // 스택 아래 /login 으로 pop(역방향 애니)한 직후 post-frame signOut 이 세션을 해제해
      // unauthenticated 로 정리한다. pop 순간엔 아직 needsOnboarding 이므로 /login 을
      // 허용해 가드가 pop 을 다시 온보딩으로 튕기지 않게 한다(온보딩은 재로그인 시 재개).
      return (location.startsWith('/onboarding') ||
              location == '/login' ||
              location == '/terms')
          ? null
          : '/onboarding/condition';

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
