@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_loading_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_unknown_screen.dart';

/// 골든 테스트 — 로딩·확인어려움 화면 (마스터 Figma 대조용 PNG 스냅샷).
///
/// 생성된 PNG 경로:
/// - test/features/food_check/presentation/goldens/verdict_loading.png
/// - test/features/food_check/presentation/goldens/verdict_unknown.png
///
/// 재생성: flutter test --update-goldens --tags golden
///         test/features/food_check/presentation/verdict_screens_golden_test.dart

Widget _wrapFullScreen(Widget child) {
  // VerdictLoadingScreen이 ConsumerWidget(authControllerProvider 참조)이므로
  // ProviderScope로 감싼다. nickname 명시 시에도 build에서 ref.watch가 호출됨.
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

void main() {
  group('판정 화면 골든 테스트', () {
    testWidgets('VerdictLoadingScreen 골든', (tester) async {
      // 375×812 디바이스 사이즈 (Figma 기준)
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrapFullScreen(const VerdictLoadingScreen(nickname: '철수')),
      );
      await tester.pump();

      await expectLater(
        find.byType(VerdictLoadingScreen),
        matchesGoldenFile('goldens/verdict_loading.png'),
      );
    });

    testWidgets('VerdictUnknownScreen 골든', (tester) async {
      // 375×812 디바이스 사이즈 (Figma 기준)
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrapFullScreen(VerdictUnknownScreen(onRetry: () {})),
      );
      await tester.pump();

      await expectLater(
        find.byType(VerdictUnknownScreen),
        matchesGoldenFile('goldens/verdict_unknown.png'),
      );
    });
  });
}
