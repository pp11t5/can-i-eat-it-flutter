import 'package:flutter/material.dart';

import 'tokens/typography_primitives.dart';

/// Layer 2: semantic TextStyle 정의.
///
/// 위젯은 반드시 이 클래스를 통해 텍스트 스타일을 참조한다.
/// [TypographyPrimitives]를 직접 참조하는 것을 금지한다.
///
/// color는 각 TextStyle에 포함하지 않는다.
/// 색은 위젯 또는 테마(ThemeData)에서 결정한다.
abstract final class AppTextStyles {
  /// 메인 타이틀 (size22 / bold)
  static const TextStyle heading1 = TextStyle(
    fontFamily: TypographyPrimitives.notoSansKr,
    fontSize: TypographyPrimitives.size22,
    fontWeight: TypographyPrimitives.bold,
  );

  /// 화면 헤더 (size20 / bold, height 1.5)
  static const TextStyle heading2 = TextStyle(
    fontFamily: TypographyPrimitives.notoSansKr,
    fontSize: TypographyPrimitives.size20,
    fontWeight: TypographyPrimitives.bold,
    height: 1.5,
  );

  /// 모달 타이틀 (size18 / bold)
  static const TextStyle title = TextStyle(
    fontFamily: TypographyPrimitives.notoSansKr,
    fontSize: TypographyPrimitives.size18,
    fontWeight: TypographyPrimitives.bold,
  );

  /// CTA 버튼 라벨 (size16 / bold)
  static const TextStyle button = TextStyle(
    fontFamily: TypographyPrimitives.notoSansKr,
    fontSize: TypographyPrimitives.size16,
    fontWeight: TypographyPrimitives.bold,
  );

  /// 로그인 라벨 등 큰 본문 (size16 / regular)
  static const TextStyle bodyLg = TextStyle(
    fontFamily: TypographyPrimitives.notoSansKr,
    fontSize: TypographyPrimitives.size16,
    fontWeight: TypographyPrimitives.regular,
  );

  /// 섹션 라벨 / 아이템 제목 (size14 / bold)
  static const TextStyle labelBold = TextStyle(
    fontFamily: TypographyPrimitives.notoSansKr,
    fontSize: TypographyPrimitives.size14,
    fontWeight: TypographyPrimitives.bold,
  );

  /// 기본 본문 (size14 / regular, height 1.5)
  static const TextStyle body = TextStyle(
    fontFamily: TypographyPrimitives.notoSansKr,
    fontSize: TypographyPrimitives.size14,
    fontWeight: TypographyPrimitives.regular,
    height: 1.5,
  );

  /// 중간 굵기 본문 (size14 / medium)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: TypographyPrimitives.notoSansKr,
    fontSize: TypographyPrimitives.size14,
    fontWeight: TypographyPrimitives.medium,
  );

  /// 보조 설명 캡션 (size14 / regular)
  static const TextStyle caption = TextStyle(
    fontFamily: TypographyPrimitives.notoSansKr,
    fontSize: TypographyPrimitives.size14,
    fontWeight: TypographyPrimitives.regular,
  );
}
