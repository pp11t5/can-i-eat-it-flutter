import 'package:flutter/material.dart';

import 'tokens/color_primitives.dart';

/// Layer 2: 의미 단위 색상 매핑.
///
/// 위젯은 반드시 이 클래스를 통해 색상을 참조한다.
/// [ColorPrimitives]를 직접 참조하는 것을 금지한다.
///
/// verdict 상태는 ADR-0003 기준: recommend / caution / danger / unknown
abstract final class AppColors {
  // --- EatVerdict 신호등 ---

  /// 권장 상태 (ADR-0003: recommend)
  static const Color verdictRecommend = ColorPrimitives.green500;

  /// 주의 상태 (ADR-0003: caution)
  static const Color verdictCaution = ColorPrimitives.amber400; // provisional

  /// 위험 상태 (ADR-0003: danger)
  static const Color verdictDanger = ColorPrimitives.red500; // provisional

  /// 확인어려움 상태 (ADR-0003: unknown)
  static const Color verdictUnknown = ColorPrimitives.grayUnknown; // provisional

  // --- 브랜드 / 주요 색 ---

  static const Color primary = ColorPrimitives.green500;
  static const Color onPrimary = ColorPrimitives.white;

  // --- Surface ---

  static const Color surface = ColorPrimitives.white;
  static const Color surfaceSelected = ColorPrimitives.green50;
  static const Color surfaceMuted = ColorPrimitives.gray100;

  // --- 텍스트 ---

  static const Color textPrimary = ColorPrimitives.gray900;
  static const Color textSecondary = ColorPrimitives.gray700;
  static const Color textTertiary = ColorPrimitives.gray600;

  // --- 선·구분선 ---

  static const Color border = ColorPrimitives.gray300;
  static const Color divider = ColorPrimitives.gray350;

  // --- 컴포넌트 고유 ---

  /// MedicalDisclaimer 배경
  static const Color disclaimerBg = ColorPrimitives.amber50; // provisional

  /// 카카오 로그인 버튼 배경
  static const Color kakao = ColorPrimitives.kakaoYellow;
}
