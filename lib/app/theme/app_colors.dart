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
  static const Color verdictRecommend = ColorPrimitives.green100;

  /// 주의 상태 (ADR-0003: caution)
  static const Color verdictCaution = ColorPrimitives.semanticOrange;

  /// 위험 상태 (ADR-0003: danger)
  static const Color verdictDanger = ColorPrimitives.semanticRed;

  /// 확인어려움 상태 (ADR-0003: unknown) — unknown 전용 semantic 없음 → gray80(line) 매핑
  static const Color verdictUnknown = ColorPrimitives.gray80;

  // --- 브랜드 / 주요 색 ---

  static const Color primary = ColorPrimitives.green100;
  static const Color onPrimary = ColorPrimitives.white;

  // --- Surface ---

  static const Color surface = ColorPrimitives.white;
  static const Color surfaceSelected = ColorPrimitives.green10;
  static const Color surfaceMuted = ColorPrimitives.gray30;

  // --- 텍스트 ---

  static const Color textPrimary = ColorPrimitives.fontColor100;
  static const Color textSecondary = ColorPrimitives.fontColor50;
  static const Color textTertiary = ColorPrimitives.fontColor20;

  // --- 선·구분선 ---

  static const Color border = ColorPrimitives.gray40;
  static const Color divider = ColorPrimitives.gray40;

  // --- 컴포넌트 고유 ---

  /// MedicalDisclaimer 배경 — 중립 gray30. 디자이너 tint 지정 시 갱신.
  static const Color disclaimerBg = ColorPrimitives.gray30;

  /// 카카오 로그인 버튼 배경
  static const Color kakao = ColorPrimitives.kakaoYellow;

  /// 카카오 로그인 버튼 텍스트 (카카오 공식: rgba(0,0,0,0.85))
  static const Color kakaoText = ColorPrimitives.kakaoText;

  /// 로그인 화면 배경 (Figma 실측 — 연한 민트)
  static const Color loginBackground = ColorPrimitives.loginBg;

  /// 브랜드 강조 텍스트 색 (예: 로그인 슬로건). green200 다크 그린.
  static const Color brandAccent = ColorPrimitives.green200;
}
