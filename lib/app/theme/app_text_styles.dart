import 'package:flutter/material.dart';

import 'tokens/typography_primitives.dart';

/// Layer 2: semantic TextStyle 정의.
///
/// 출처: docs/design/figma-tokens.md (실측 10종 — 단일 진실 원천).
/// 위젯은 반드시 이 클래스를 통해 텍스트 스타일을 참조한다.
/// [TypographyPrimitives]를 직접 참조하는 것을 금지한다.
///
/// color는 각 TextStyle에 포함하지 않는다.
/// 색은 위젯 또는 테마(ThemeData)에서 결정한다.
abstract final class AppTextStyles {
  /// Title_2(B) — 32/700, height 1.0, letterSpacing 0
  static const TextStyle title2 = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size32,
    fontWeight: TypographyPrimitives.bold,
    height: 1.0,
    letterSpacing: 0,
  );

  /// Header_1(B) — 24/700, height 1.5, letterSpacing 0
  static const TextStyle header1Bold = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size24,
    fontWeight: TypographyPrimitives.bold,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Header_2(B) — 20/700, height 1.2, letterSpacing 1.2
  static const TextStyle header2Bold = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size20,
    fontWeight: TypographyPrimitives.bold,
    height: 1.2,
    letterSpacing: 1.2,
  );

  /// Header1 Medium — 20/500, height 1.2, letterSpacing 0
  /// (Figma 디자인시스템 4:811: Medium=500. 이전 Regular=400 에서 갱신.)
  static const TextStyle header1Medium = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size20,
    fontWeight: TypographyPrimitives.medium,
    height: 1.2,
    letterSpacing: 0,
  );

  /// Header3 Bold — 18/700 (Figma 02a 다이얼로그 타이틀용, 디자인시스템 외 추가)
  static const TextStyle header3Bold = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size18,
    fontWeight: TypographyPrimitives.bold,
    letterSpacing: 0,
  );

  /// Body1 Regular — 16/400, height 1.6 (다이얼로그 텍스트 버튼 등)
  static const TextStyle body1Regular = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size16,
    fontWeight: TypographyPrimitives.regular,
    height: 1.6,
    letterSpacing: 0,
  );

  /// Body2 Regular — 14/400, height 1.5 (다이얼로그 본문 등)
  static const TextStyle body2Regular = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size14,
    fontWeight: TypographyPrimitives.regular,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Body_1(B) — 16/700, height 1.4, letterSpacing 0.32
  static const TextStyle body1Bold = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size16,
    fontWeight: TypographyPrimitives.bold,
    height: 1.4,
    letterSpacing: 0.32,
  );

  /// Body_1(M) — 16/500, height 1.6, letterSpacing 0
  static const TextStyle body1Medium = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size16,
    fontWeight: TypographyPrimitives.medium,
    height: 1.6,
    letterSpacing: 0,
  );

  /// Body_2(B) — 14/700, height 1.4, letterSpacing 0
  static const TextStyle body2Bold = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size14,
    fontWeight: TypographyPrimitives.bold,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Body_2(M) — 14/500, height 1.6, letterSpacing 0
  static const TextStyle body2Medium = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size14,
    fontWeight: TypographyPrimitives.medium,
    height: 1.6,
    letterSpacing: 0,
  );

  /// Caption_1(B) — 12/700, height 1.5, letterSpacing 0
  static const TextStyle caption1Bold = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size12,
    fontWeight: TypographyPrimitives.bold,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Caption_1(M) — 12/500, height 1.7, letterSpacing 0.36
  static const TextStyle caption1Medium = TextStyle(
    fontFamily: TypographyPrimitives.fontFamily,
    fontSize: TypographyPrimitives.size12,
    fontWeight: TypographyPrimitives.medium,
    height: 1.7,
    letterSpacing: 0.36,
  );
}
