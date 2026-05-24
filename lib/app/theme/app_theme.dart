import 'package:flutter/material.dart';

/// 앱 테마와 디자인 토큰의 단일 출처.
///
/// Figma(Framelink MCP)에서 추출한 색·간격·타이포 토큰을 여기로 흡수한다.
/// 화면 위젯은 색/간격을 하드코딩하지 말고 Theme 또는 [AppSpacing] 을 참조한다.
class AppTheme {
  const AppTheme._();

  // 디자인 확정 전 placeholder seed. Figma 1차 토큰 도착 시 교체.
  static const Color _seed = Color(0xFF2E7D32); // 음식/건강 톤

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seed),
        useMaterial3: true,
      );

  static ThemeData get dark => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      );
}

/// 간격 토큰. Figma 8pt 그리드 기준 placeholder.
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}
