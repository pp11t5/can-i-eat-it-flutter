import 'package:flutter/material.dart';

/// Layer 1: 원시 타이포그래피 스케일.
///
/// 출처: docs/design/figma-tokens.md (실측 — 단일 진실 원천).
/// 위젯은 이 클래스를 직접 참조하지 말고 AppTextStyles를 경유할 것.
abstract final class TypographyPrimitives {
  /// 확정 폰트 (디자이너 한희, 2026-05-27 — Noto Sans KR 폐기).
  /// 폰트 번들/pubspec 등록은 별도 후속 작업. 미등록 시 시스템 폴백 허용.
  static const String fontFamily = 'Pretendard';

  // --- 사이즈 ---
  static const double size12 = 12;
  static const double size14 = 14;
  static const double size16 = 16;
  static const double size20 = 20;
  static const double size24 = 24;
  static const double size32 = 32;

  // --- 웨이트 ---
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;
}
