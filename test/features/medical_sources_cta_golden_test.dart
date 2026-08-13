@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/food_dictionary_providers.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/repositories/mock_dictionary_repository.dart';
import 'package:can_i_eat_it/features/food_dictionary/presentation/screens/food_history_screen.dart';
import 'package:can_i_eat_it/features/weekly_report/data/repositories/mock_weekly_report_repository.dart';
import 'package:can_i_eat_it/features/weekly_report/data/weekly_report_providers.dart';
import 'package:can_i_eat_it/features/weekly_report/presentation/screens/weekly_report_screen.dart';

Widget _wrap(Widget child) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      dictionaryRepositoryProvider.overrideWithValue(
        MockDictionaryRepository.seeded(),
      ),
      // ignore: scoped_providers_should_specify_dependencies
      weeklyReportRepositoryProvider.overrideWithValue(
        MockWeeklyReportRepository.seeded(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: child,
    ),
  );
}

void main() {
  group('의료 근거 CTA 골든 테스트', () {
    testWidgets('주간 리포트 — 스크롤 끝 CTA', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap(const WeeklyReportScreen()));
      await tester.pumpAndSettle();
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -1000),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(WeeklyReportScreen),
        matchesGoldenFile('goldens/weekly_report_medical_sources_link.png'),
      );
    });

    testWidgets('음식 히스토리 — 목록 마지막 CTA', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_wrap(const FoodHistoryScreen()));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView).first, const Offset(0, -500));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(FoodHistoryScreen),
        matchesGoldenFile('goldens/food_history_medical_sources_link.png'),
      );
    });
  });
}
