import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/timeline_screen.dart';

/// 타임라인 화면의 월 이동 테스트.
/// 규칙: 오늘 이전 월 이동 금지 / 오늘·이후(미래 월) 이동·선택 가능.
///
/// 고정 오늘: 2026-06-17 (수).

final _fixedToday = DateTime(2026, 6, 17);

Finder _iconWithLabel(String label) => find.byWidgetPredicate(
      (w) => w is AppIcon && w.semanticsLabel == label,
    );

Widget _wrapWithMock(Widget child) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(
        MockMealRepository.seeded(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

/// 현재 선택 캡슐(검정 배경) 안의 날짜 숫자 텍스트를 찾는다.
String _selectedDayNumber(WidgetTester tester) {
  final capsule = find
      .byWidgetPredicate((w) {
        if (w is! Container) return false;
        final deco = w.decoration;
        return deco is BoxDecoration &&
            deco.color == const Color(0xFF222222) &&
            deco.borderRadius != null;
      })
      .first;
  final numberText = find
      .descendant(of: capsule, matching: find.byType(Text))
      .evaluate()
      .map((e) => (e.widget as Text).data)
      .whereType<String>()
      .firstWhere((s) => int.tryParse(s) != null);
  return numberText;
}

void main() {
  group('TimelineScreen — 월 이동 선택일 규칙', () {
    testWidgets('다음 달 이동 시 선택일 = 그 달의 1일로 바뀐다', (tester) async {
      await tester.pumpWidget(
        _wrapWithMock(TimelineScreen(todayOverride: _fixedToday)),
      );
      await tester.pumpAndSettle();

      await tester.tap(_iconWithLabel('다음 달'));
      await tester.pumpAndSettle();

      expect(find.text('2026년 7월'), findsOneWidget);
      expect(_selectedDayNumber(tester), equals('1'));
    });

    testWidgets('미래 달에서 이전 달로 돌아오면 오늘 월·오늘 날짜로 보정된다', (tester) async {
      await tester.pumpWidget(
        _wrapWithMock(TimelineScreen(todayOverride: _fixedToday)),
      );
      await tester.pumpAndSettle();

      // 7월로 이동 후 다시 6월로.
      await tester.tap(_iconWithLabel('다음 달'));
      await tester.pumpAndSettle();
      expect(find.text('2026년 7월'), findsOneWidget);

      await tester.tap(_iconWithLabel('이전 달'));
      await tester.pumpAndSettle();

      expect(find.text('2026년 6월'), findsOneWidget);
      // 6월 1일은 과거이므로 선택일이 오늘(17)로 보정.
      expect(find.text('오늘'), findsOneWidget);
    });
  });

  group('TimelineScreen — 과거 월 이동 금지 / 미래 월 허용', () {
    testWidgets('현재 월이면 "이전 달"은 보이되 탭해도 이동하지 않는다', (tester) async {
      await tester.pumpWidget(
        _wrapWithMock(TimelineScreen(todayOverride: _fixedToday)),
      );
      await tester.pumpAndSettle();

      expect(_iconWithLabel('이전 달'), findsOneWidget);
      expect(_iconWithLabel('다음 달'), findsOneWidget);

      await tester.tap(_iconWithLabel('이전 달'));
      await tester.pumpAndSettle();

      // 여전히 6월 — 비활성 탭 무시.
      expect(find.text('2026년 6월'), findsOneWidget);
    });

    testWidgets('미래 달로 이동 후 "이전 달" 탭 시 오늘 월로 돌아온다', (tester) async {
      await tester.pumpWidget(
        _wrapWithMock(TimelineScreen(todayOverride: _fixedToday)),
      );
      await tester.pumpAndSettle();

      await tester.tap(_iconWithLabel('다음 달'));
      await tester.pumpAndSettle();
      expect(find.text('2026년 7월'), findsOneWidget);

      await tester.tap(_iconWithLabel('이전 달'));
      await tester.pumpAndSettle();
      expect(find.text('2026년 6월'), findsOneWidget);
    });
  });
}
