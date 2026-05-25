/// Layer 1: 원시 여백·반경 스케일.
///
/// 위젯은 이 클래스를 직접 참조하지 말고 AppSpacing을 경유할 것.
abstract final class SpacingPrimitives {
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
}

/// Layer 1: 원시 반경 스케일.
///
/// 위젯은 이 클래스를 직접 참조하지 말고 AppSpacing을 경유할 것.
abstract final class RadiusPrimitives {
  static const double r8 = 8;
  static const double r16 = 16;
  static const double rPill = 999;
}
