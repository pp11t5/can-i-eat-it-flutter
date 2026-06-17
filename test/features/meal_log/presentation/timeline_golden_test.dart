@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/timeline_screen.dart';

/// 골든 테스트 — 타임라인 화면 (마스터 Figma 대조용 PNG 스냅샷).
///
/// 생성된 PNG 경로:
/// - test/features/meal_log/presentation/goldens/timeline_data.png
/// - test/features/meal_log/presentation/goldens/timeline_empty.png
///
/// 재생성:
///   flutter test --update-goldens --tags golden \
///     test/features/meal_log/presentation/timeline_golden_test.dart
///
/// todayOverride = 2026-06-17(수) 고정 → 주말·미래 색이 결정적으로 렌더됨.
///   일요일(14): calendarSunday(빨강)
///   미래(18~20): textTertiary(회색)

/// 고정 오늘: 2026-06-17 (수) — 시드 데이터와 동일 날짜
final _fixedToday = DateTime(2026, 6, 17);

Widget _wrapWithMock(Widget child, {required bool seeded}) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(
        seeded ? MockMealRepository.seeded() : MockMealRepository.empty(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

void main() {
  group('타임라인 화면 골든 테스트', () {
    testWidgets('data 상태 골든', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrapWithMock(
          TimelineScreen(todayOverride: _fixedToday),
          seeded: true,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(TimelineScreen),
        matchesGoldenFile('goldens/timeline_data.png'),
      );
    });

    testWidgets('빈 상태 골든', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _wrapWithMock(
          TimelineScreen(todayOverride: _fixedToday),
          seeded: false,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(TimelineScreen),
        matchesGoldenFile('goldens/timeline_empty.png'),
      );
    });
  });
}
