@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_result_screen.dart';

/// VerdictResultScreen 골든 테스트 — recommend / caution / risk 3상태.
///
/// unknown 상태는 VerdictUnknownScreen으로 위임되므로 여기서는 제외.
/// CTA "다시 검색"·"내 식단에 추가" 두 버튼이 모두 보여야 한다 (W3-3 완료 기준).

Widget _wrap(EatVerdict verdict) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: VerdictResultScreen(
        verdict: verdict,
        onRetry: () {},
        // onAddToDiet 미설정 → 스낵바 placeholder (F3)
      ),
    ),
  );
}

void main() {
  group('VerdictResultScreen 골든 테스트 — 3상태', () {
    testWidgets('recommend 상태를 골든과 일치하게 렌더한다', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap(EatVerdict.recommend()));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(VerdictResultScreen),
        matchesGoldenFile('goldens/verdict_result_recommend.png'),
      );
    });

    testWidgets('caution 상태를 골든과 일치하게 렌더한다', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap(EatVerdict.caution()));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(VerdictResultScreen),
        matchesGoldenFile('goldens/verdict_result_caution.png'),
      );
    });

    testWidgets('risk 상태를 골든과 일치하게 렌더한다', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap(EatVerdict.risk()));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(VerdictResultScreen),
        matchesGoldenFile('goldens/verdict_result_risk.png'),
      );
    });
  });
}
