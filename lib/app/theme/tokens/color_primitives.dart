import 'package:flutter/material.dart';

/// Layer 1: 원시 색상 팔레트.
///
/// 완성 GUI Figma(node 82:178) 도착 시 이 파일의 값만 교체하면
/// semantic(AppColors) → ThemeData 전체에 자동 반영된다.
/// 위젯이 이 클래스를 직접 참조하는 것을 금지한다. AppColors를 경유할 것.
abstract final class ColorPrimitives {
  // --- 실제 Figma 추출값 (node 82:178) ---

  /// primary / 권장 상태 색
  static const Color green500 = Color(0xFF00BF72);

  /// 선택 surface
  static const Color green50 = Color(0xFFE5FFEC);

  /// 주 텍스트
  static const Color gray900 = Color(0xFF1A1A1F);

  /// 보조 텍스트
  static const Color gray700 = Color(0xFF595966);

  /// placeholder / 3차 텍스트
  static const Color gray600 = Color(0xFF737380);

  static const Color gray400 = Color(0xFFD0D0D0);

  /// divider
  static const Color gray350 = Color(0xFFDBDBE5);

  /// 기본 border
  static const Color gray300 = Color(0xFFE9E9E9);

  static const Color gray200 = Color(0xFFEFEFEF);

  static const Color gray150 = Color(0xFFF2F2F7);

  /// 미선택 surface
  static const Color gray100 = Color(0xFFF4F4F4);

  static const Color gray50 = Color(0xFFF7F7FA);

  static const Color white = Color(0xFFFFFFFF);

  /// 카카오 로그인 버튼 배경
  static const Color kakaoYellow = Color(0xFFFEE500);

  /// 로그인 배경
  static const Color loginBg = Color(0xFFF7FFFB);

  // --- provisional (결과화면 Figma 도착 시 교체 대상) ---

  /// provisional — 주의(caution) 상태 색
  static const Color amber400 = Color(0xFFF5A623); // provisional

  /// provisional — 위험(danger) 상태 색
  static const Color red500 = Color(0xFFE5484D); // provisional

  /// provisional — 확인어려움(unknown) 상태 색
  static const Color grayUnknown = Color(0xFF8A8A8F); // provisional

  /// provisional — MedicalDisclaimer 배경
  static const Color amber50 = Color(0xFFFFF8E1); // provisional
}
