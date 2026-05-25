import 'package:flutter/material.dart';

/// Layer 1: 원시 타이포그래피 스케일.
///
/// 위젯은 이 클래스를 직접 참조하지 말고 AppTextStyles를 경유할 것.
abstract final class TypographyPrimitives {
  /// provisional — 폰트 번들/google_fonts는 #2 범위 밖. 시스템 폴백 허용.
  static const String notoSansKr = 'Noto Sans KR'; // provisional

  // --- 사이즈 ---
  static const double size14 = 14;
  static const double size15 = 15;
  static const double size16 = 16;
  static const double size18 = 18;
  static const double size20 = 20;
  static const double size22 = 22;

  // --- 웨이트 ---
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;
}
