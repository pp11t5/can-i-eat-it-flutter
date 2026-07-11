/// 앱 전역 에셋 경로 레지스트리.
///
/// 모든 아이콘·이미지 경로는 이 클래스를 경유한다(문자열 중복·오타 방지).
/// 음식 카테고리 일러스트는 `CategoryIcon` 이 소유하므로 여기 포함하지 않는다.
///
/// 규칙: 모노크롬 아이콘은 `AppIcon` + 색 지정으로 렌더(BlendMode.srcIn 틴팅),
/// 브랜드·다색 에셋은 색 미지정(원본색 유지). 이모지·`Icons.*` 사용 금지.
abstract final class AppIcons {
  static const String _figma = 'assets/figma_extracted';
  static const String _illust = 'assets/illustrations';
  static const String _splash = 'assets/splash';

  // --- 내비게이션 (app_shell) ---
  static const String navHome = '$_figma/nav_home.svg';
  static const String navTimeline = '$_figma/nav_timeline.svg';
  static const String navMy = '$_figma/nav_my.svg';

  // --- 공용 액션 아이콘 (모노크롬, 틴팅) ---
  static const String chevronLeft = '$_figma/chevron_left.svg';
  static const String chevronRight = '$_figma/chevron_right.svg';
  static const String close = '$_figma/icon_close.svg';
  static const String closeSmall = '$_figma/icon_close_small.svg';
  static const String search = '$_figma/icon_search.svg';
  static const String plusCircle = '$_figma/icon_plus_circle.svg';

  // --- 체크박스 ---
  static const String checkboxChecked = '$_figma/checkbox_checked_on.svg';
  static const String checkboxAllOff =
      '$_figma/checkbox_allcheck_off_instance.svg';

  // --- 빈 상태 ---
  static const String foodEmpty = '$_figma/icon_food_empty.svg';

  // --- 브랜드 (다색, 원본색 유지) ---
  static const String kakaoSymbol = '$_figma/kakao_logo_symbol.svg';

  // --- 로그인/스플래시 일러스트 (PNG) ---
  static const String loginBg = '$_figma/login_bg_image.png';
  static const String loginLogo = '$_figma/login_logo_illust.png';
  static const String splashLogo = '$_splash/splash_logo.png';

  // --- 일러스트 (PNG, 직접 참조) ---
  static const String pencil = '$_illust/icon_pencil.png';
  static const String fire = '$_illust/icon_fire.png';
  static const String characterGreeting = '$_illust/character_greeting.png';
  static const String mealPrompt = '$_illust/emoji_meal_prompt.png';
}
