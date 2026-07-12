/// 앱 전역 **SVG 아이콘** 경로 레지스트리.
///
/// 이 클래스는 `.svg` 경로만 담는다 — `AppIcon`이 `SvgPicture`로만 렌더하므로,
/// PNG 를 여기 섞으면 `AppIcon(png)` 이 컴파일은 되고 런타임에 깨진다.
/// PNG 래스터 이미지는 [AppImages] 로 분리한다.
/// 음식 카테고리 일러스트는 `CategoryIcon` 이 소유하므로 여기 포함하지 않는다.
///
/// 규칙: 모노크롬 아이콘은 `AppIcon` + 색 지정으로 렌더(BlendMode.srcIn 틴팅),
/// 브랜드·다색 SVG 는 색 미지정(원본색 유지). 이모지·`Icons.*` 사용 금지.
abstract final class AppIcons {
  static const String _figma = 'assets/figma_extracted';

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
  static const String clock = '$_figma/ic_clock.svg';

  // --- 체크박스 ---
  static const String checkboxChecked = '$_figma/checkbox_checked_on.svg';
  static const String checkboxAllOff =
      '$_figma/checkbox_allcheck_off_instance.svg';

  // --- 빈 상태 ---
  static const String foodEmpty = '$_figma/icon_food_empty.svg';

  // --- 액션 아이콘 (모노크롬, 틴팅) ---
  static const String plus = '$_figma/ic_plus.svg';
  static const String bell = '$_figma/ic_bell.svg';
  static const String lock = '$_figma/ic_lock.svg';
  static const String pill = '$_figma/ic_pill.svg';
  static const String sad = '$_figma/ic_sad.svg';
  static const String trash = '$_figma/ic_trash.svg';
  static const String pencil = '$_figma/ic_pencil.svg';
  static const String download = '$_figma/ic_download.svg';
  static const String check = '$_figma/ic_check.svg';
  static const String arrowRight = '$_figma/ic_arrow_right.svg';

  // --- 시맨틱 상태 (고정색 SVG, 원본색 유지) ---
  static const String error = '$_figma/ic_error.svg'; // #FF383C
  static const String warning = '$_figma/ic_warning.svg'; // #FF8D28

  // --- 타임라인 레일 배지 (다색 자체완결, 원본색 유지) ---
  // 32×32 둥근 배경 + 글리프. 색 미지정으로 원본 그대로 렌더.
  static const String mealSun = '$_figma/ic_meal_sun.svg'; // 식사(주간)
  static const String mealMoon = '$_figma/ic_meal_moon.svg'; // 식사(야간)
  static const String recordChecklist =
      '$_figma/ic_record_checklist.svg'; // 증상 기록

  // --- 프로필 아바타 (다색 배지, 원본색 유지) ---
  static const String userAvatar = '$_figma/ic_user.svg';

  // --- 판정 배지 (자체완결 색배지, 원본색 유지) ---
  // recommend=초록원+흰체크, caution=주황+! , risk=빨강+X (verdict 헤드라인·대체음식).
  // unknown=회색원+흰물음표 — Figma 소스 노드 부재(W6-17 주간리포트 범례 유일 사용처),
  // 나머지 3종과 동일한 원+글리프 구성으로 저작(디자이너 검수 권장).
  static const String verdictRecommend = '$_figma/ic_verdict_recommend.svg';
  static const String verdictCaution = '$_figma/ic_verdict_caution.svg';
  static const String verdictRisk = '$_figma/ic_verdict_risk.svg';
  static const String verdictUnknown = '$_figma/ic_verdict_unknown.svg';

  // --- AI 스파클 (보라 #9747FF, 원본색 유지) ---
  static const String sparkle = '$_figma/ic_sparkle.svg';

  // --- 브랜드 (다색 SVG, 원본색 유지) ---
  static const String kakaoSymbol = '$_figma/kakao_logo_symbol.svg';

  // --- 브랜드 (모노크롬, 틴팅) ---
  static const String appleLogo = '$_figma/apple_logo.svg';
}

/// 앱 전역 **PNG 래스터 이미지** 경로 레지스트리.
///
/// `Image.asset` 으로 렌더한다. 벡터 아이콘은 [AppIcons] + `AppIcon` 사용.
/// (SVG 전용 `AppIcon` 에 이 경로를 넘기면 assert 로 조기 실패한다.)
abstract final class AppImages {
  static const String _figma = 'assets/figma_extracted';
  static const String _illust = 'assets/illustrations';
  static const String _splash = 'assets/splash';

  // --- 로그인/스플래시 일러스트 ---
  static const String loginBg = '$_figma/login_bg_image.png';
  static const String loginLogo = '$_figma/login_logo_illust.png';
  static const String splashLogo = '$_splash/splash_logo.png';

  // --- 일러스트 (직접 참조) ---
  static const String pencil = '$_illust/icon_pencil.png';
  static const String fire = '$_illust/icon_fire.png';
  static const String characterGreeting = '$_illust/character_greeting.png';
  static const String mealPrompt = '$_illust/emoji_meal_prompt.png';

  // --- 무드 얼굴 (증상 상태 5단계, Figma "emoji" 세트 래스터) ---
  // SymptomState comfortable/good/normal/uncomfortable/severe = 레벨 1~5.
  // 렌더는 `MoodFace` 위젯 경유.
  static const String moodComfortable = '$_illust/mood_comfortable.png';
  static const String moodGood = '$_illust/mood_good.png';
  static const String moodNormal = '$_illust/mood_normal.png';
  static const String moodUncomfortable = '$_illust/mood_uncomfortable.png';
  static const String moodSevere = '$_illust/mood_severe.png';
}
