/// 아이콘 한 변 크기 토큰.
///
/// 위젯은 아이콘 크기를 하드코딩하지 말고 이 클래스를 경유한다.
/// 값은 Figma 아이콘 프레임 실측 기준(16/18/20/24/32).
abstract final class AppIconSizes {
  /// 소형 인라인 글리프 (칩 내부, 캡션 옆)
  static const double s16 = 16;

  /// 브랜드 로고 심볼 (카카오 등)
  static const double s18 = 18;

  /// 리스트 리딩·본문 인라인 아이콘
  static const double s20 = 20;

  /// 표준 아이콘 (내비·앱바 액션·chevron)
  static const double s24 = 24;

  /// 강조 아이콘 (식사 상세 증상 기록 섹션 등)
  static const double s32 = 32;
}
