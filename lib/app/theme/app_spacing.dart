import 'tokens/spacing_primitives.dart';

/// Layer 2: 여백·반경 semantic 별칭.
///
/// 위젯은 반드시 이 클래스를 통해 여백·반경을 참조한다.
/// [SpacingPrimitives] / [RadiusPrimitives]를 직접 참조하는 것을 금지한다.
abstract final class AppSpacing {
  // --- 여백 ---

  /// 화면 좌우 패딩
  static const double screenPadding = SpacingPrimitives.s16;

  /// 카드 내부 패딩
  static const double cardPadding = SpacingPrimitives.s16;

  /// 칩 가로 패딩
  static const double chipPaddingH = SpacingPrimitives.s12;

  /// 칩 세로 패딩
  static const double chipPaddingV = SpacingPrimitives.s8;

  /// 아이템 간 기본 간격
  static const double itemGap = SpacingPrimitives.s8;

  /// 섹션 간 간격
  static const double sectionGap = SpacingPrimitives.s24;

  /// 콘텐츠 블록 간 간격
  static const double contentGap = SpacingPrimitives.s32;

  /// 아이콘·텍스트 사이 좁은 간격 (MedicalDisclaimer 등)
  static const double iconTextGap = SpacingPrimitives.s6;

  /// 내부 소간격
  static const double xs = SpacingPrimitives.s4;

  // --- 반경 ---

  /// 카드 모서리 반경
  static const double radiusCard = RadiusPrimitives.r8;

  /// 내부 통계 카드(StatCard) 모서리 반경 (Figma 1718:6140 · 알림 카드 577:10290)
  static const double radiusStatCard = RadiusPrimitives.r14;

  /// 모달 모서리 반경
  static const double radiusModal = RadiusPrimitives.r16;

  /// 알약형(Pill) 반경
  static const double radiusPill = RadiusPrimitives.rPill;
}
