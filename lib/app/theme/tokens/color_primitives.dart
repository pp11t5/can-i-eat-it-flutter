import 'package:flutter/material.dart';

/// Layer 1: 원시 색상 팔레트.
///
/// 출처: docs/design/figma-tokens.md (실측 — 단일 진실 원천).
/// 값 변경 시 이 파일 → AppColors(semantic) → ThemeData 순으로 자동 연동.
/// 위젯이 이 클래스를 직접 참조하는 것을 금지한다. AppColors를 경유할 것.
abstract final class ColorPrimitives {
  // --- Green 스케일 ---

  static const Color green10 = Color(0xFFF0FFF4);
  static const Color green50 = Color(0xFFD9F5EA);
  static const Color green80 = Color(0xFFB1EBD3);

  /// primary / 권장 상태 색 / semanticGreen
  static const Color green100 = Color(0xFF00BF72);

  static const Color green200 = Color(0xFF02995B);
  static const Color green300 = Color(0xFF027344);

  // --- Semantic ---

  /// 위험(danger)
  static const Color semanticRed = Color(0xFFFF383C);

  /// 주의(caution)
  static const Color semanticOrange = Color(0xFFFF8D28);

  /// 토요일/주말 강조 (Figma 캘린더 2794-26223 실측 #007AFF)
  static const Color semanticBlue = Color(0xFF007AFF);

  // semanticGreen = green100

  // --- Foundation ---

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF222222);

  // --- Font color ---

  /// tertiary / placeholder
  static const Color fontColor20 = Color(0xFF8C8C99);

  /// secondary
  static const Color fontColor50 = Color(0xFF737380);

  /// strong
  static const Color fontColor80 = Color(0xFF10111A);

  /// primary 텍스트
  static const Color fontColor100 = Color(0xFF1A1A1F);

  // --- Gray (Figma 라벨: background/disable/stroke/border/navi/line/check) ---

  static const Color gray10 = Color(0xFFFDFDFD);

  /// background
  static const Color gray20 = Color(0xFFFCFCFC);

  /// disable
  static const Color gray30 = Color(0xFFF5F5F5);

  /// stroke / border
  static const Color gray40 = Color(0xFFEAEAEA);

  static const Color gray50 = Color(0xFFD3D3D3);

  /// navi
  static const Color gray60 = Color(0xFFBBBBBB);

  static const Color gray70 = Color(0xFFB0B0B0);

  /// line
  static const Color gray80 = Color(0xFF8C8C8C);

  static const Color gray90 = Color(0xFF696969);

  /// check
  static const Color gray100 = Color(0xFF525252);

  // --- 브랜드 (Figma foundation 외 — 고정 브랜드값) ---

  /// 카카오 로그인 버튼 배경
  static const Color kakaoYellow = Color(0xFFFEE500);

  /// 로그인 화면 배경 (Figma node 365:1552 실측 #F7FFFB — 연한 민트)
  static const Color loginBg = Color(0xFFF7FFFB);

  /// 카카오 버튼 텍스트 색 (카카오 공식 가이드: rgba(0,0,0,0.85) = alpha 0xD9)
  static const Color kakaoText = Color(0xD9000000);

  /// 보라 강조 (Figma 디자인시스템 신규 — 용도 미정, 디자이너 확정 시 semantic 추가)
  static const Color purple400 = Color(0xFF9321EC);

  /// 보라 연한 배경 (Figma AI 분석 배지 실측 #F8F2FF)
  static const Color purple10 = Color(0xFFF8F2FF);

  // --- OptionCard / SelectableChip 전용 (Figma onboarding 실측) ---

  /// 비선택 카드 배경 (Figma #F7F7FA)
  static const Color cardUnselectedBg = Color(0xFFF7F7FA);

  /// 비선택 카드 테두리 (Figma #DBDBE5)
  static const Color cardUnselectedBorder = Color(0xFFDBDBE5);

  /// 비활성 카드 라벨 색 (Figma #D6D6D6)
  static const Color disabledLabel = Color(0xFFD6D6D6);

  /// 바텀 내비 비활성 아이콘·레이블 (Figma nav component 실측 #C5C5C6)
  static const Color navInactive = Color(0xFFC5C5C6);

  /// 홈 카드 테두리 (Figma 1207:6590 도감·최근식사 stroke #EDEDF5)
  static const Color cardBorderSubtle = Color(0xFFEDEDF5);
}
