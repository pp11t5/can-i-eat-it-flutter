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

  /// 카드 안에 삽입되는 통계/설정 카드 배경 (Figma gray/20 #FCFCFC)
  static const Color surfaceInset = ColorPrimitives.gray20;

  /// 모든 화면(Scaffold)의 기본 배경 — #FEFEFE 흰색으로 통일.
  /// 회색(surfaceBackground=#F5F5F5)을 스캐폴드 배경으로 쓰지 않는다.
  static const Color scaffoldBackground = Color(0xFFFEFEFE);

  // --- 텍스트 ---

  static const Color textPrimary = ColorPrimitives.fontColor100;
  static const Color textSecondary = ColorPrimitives.fontColor50;
  static const Color textTertiary = ColorPrimitives.fontColor20;

  // --- 선·구분선 ---

  static const Color border = ColorPrimitives.gray40;
  static const Color divider = ColorPrimitives.gray40;

  /// 홈 카드 테두리 (Figma 1207:6590 도감·최근식사 stroke #EDEDF5)
  static const Color borderCard = ColorPrimitives.cardBorderSubtle;

  // --- 컴포넌트 고유 ---

  /// MedicalDisclaimer 배경 — 중립 gray30. 디자이너 tint 지정 시 갱신.
  static const Color disclaimerBg = ColorPrimitives.gray30;

  /// 카카오 로그인 버튼 배경
  static const Color kakao = ColorPrimitives.kakaoYellow;

  /// 카카오 로그인 버튼 텍스트 (카카오 공식: rgba(0,0,0,0.85))
  static const Color kakaoText = ColorPrimitives.kakaoText;

  /// 파괴적 액션 (삭제·취소) 색 — Figma 13a 전체삭제 #F04545.
  // TODO(token): 디자이너 확정 후 ColorPrimitives.danger 로 이동.
  static const Color danger = Color(0xFFF04545);

  /// 체크박스 OFF 상태 테두리 — gray50 (Figma 마케팅 행 #D0D0D0 ≈ 우리 #D3D3D3)
  static const Color checkboxBorder = ColorPrimitives.gray50;

  /// 로그인 화면 배경 (Figma 실측 — 연한 민트)
  static const Color loginBackground = ColorPrimitives.loginBg;

  /// 브랜드 강조 텍스트 색 (예: 로그인 슬로건). green200 다크 그린.
  static const Color brandAccent = ColorPrimitives.green200;

  // --- OptionCard / SelectableChip 전용 (Figma onboarding 실측) ---

  /// 비선택 OptionCard 배경 (#F7F7FA)
  static const Color cardUnselectedBg = ColorPrimitives.cardUnselectedBg;

  /// 비선택 OptionCard 테두리 (#DBDBE5)
  static const Color cardUnselectedBorder = ColorPrimitives.cardUnselectedBorder;

  /// 비활성 카드 라벨 색 (#D6D6D6)
  static const Color disabledLabel = ColorPrimitives.disabledLabel;

  /// 바텀 내비 비활성 아이콘·레이블 (Figma nav component 실측 #C5C5C6)
  static const Color navInactive = ColorPrimitives.navInactive;

  /// 강조 텍스트 색 (Figma fontColor80 #10111A — 숫자·강조 라벨 등)
  static const Color textStrong = ColorPrimitives.fontColor80;

  // --- 타임라인 WeekStrip 전용 ---

  /// 화면 배경 (타임라인 등 카드가 뜨는 화면) — gray30(#F5F5F5)
  static const Color surfaceBackground = ColorPrimitives.gray30;

  /// 주간 스트립 카드 그림자 색 — black 4% opacity (Figma 타임라인 실측)
  static const Color weekStripShadow = Color(0x0A000000);

  /// 일요일 요일 라벨 색 — semanticRed(#FF383C)
  static const Color calendarSunday = ColorPrimitives.semanticRed;

  /// 토요일 요일 라벨·활성 날짜 색 — semanticBlue(#007AFF) (Figma 캘린더 2794-26223)
  static const Color calendarSaturday = ColorPrimitives.semanticBlue;

  /// AI 분석 배지 배경 (Figma 증상 상세 1324:13865 실측 #F8F2FF)
  static const Color aiAccentSurface = ColorPrimitives.purple10;
}
