import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/timeline_screen.dart';

/// 타임라인 화면의 월 이동(요구사항③ 선택일 규칙, 요구사항④ 미래월 이동 금지) 테스트.
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
  group('TimelineScreen — 월 이동 선택일 규칙 (요구사항③)', () {
    testWidgets('이전 달 이동 시 선택일 = 그 달의 말일(5월 31일)로 바뀐다', (tester) async {
      await tester.pumpWidget(
        _wrapWithMock(TimelineScreen(todayOverride: _fixedToday)),
      );
      await tester.pumpAndSettle();

      await tester.tap(_iconWithLabel('이전 달'));
      await tester.pumpAndSettle();

      expect(find.text('2026년 5월'), findsOneWidget);
      expect(_selectedDayNumber(tester), equals('31'));
    });

    testWidgets('다음 달 이동 시 선택일 = 그 달의 1일로 바뀐다', (tester) async {
      await tester.pumpWidget(
        _wrapWithMock(TimelineScreen(todayOverride: _fixedToday)),
      );
      await tester.pumpAndSettle();

      // 6월(오늘의 달)에서는 다음 달로 갈 수 없으므로, 먼저 이전 달(5월)로
      // 이동한 뒤 다시 다음 달(6월)로 돌아오며 selectedDate=1일 규칙을 검증한다.
      await tester.tap(_iconWithLabel('이전 달'));
      await tester.pumpAndSettle();
      expect(find.text('2026년 5월'), findsOneWidget);

      await tester.tap(_iconWithLabel('다음 달'));
      await tester.pumpAndSettle();

      expect(find.text('2026년 6월'), findsOneWidget);
      expect(_selectedDayNumber(tester), equals('1'));
    });
  });

  group('TimelineScreen — 미래월 이동 금지 (요구사항④)', () {
    testWidgets('visibleMonth가 현재 월이면 "다음 달" 버튼이 숨겨진다', (tester) async {
      await tester.pumpWidget(
        _wrapWithMock(TimelineScreen(todayOverride: _fixedToday)),
      );
      await tester.pumpAndSettle();

      // 진입 시 visibleMonth = 오늘의 달(2026-06) = today 월 → 다음 달 숨김.
      expect(_iconWithLabel('다음 달'), findsNothing);
      expect(_iconWithLabel('이전 달'), findsOneWidget);
    });

    testWidgets('과거 달로 이동하면 "다음 달" 버튼이 다시 나타난다', (tester) async {
      await tester.pumpWidget(
        _wrapWithMock(TimelineScreen(todayOverride: _fixedToday)),
      );
      await tester.pumpAndSettle();

      await tester.tap(_iconWithLabel('이전 달'));
      await tester.pumpAndSettle();

      expect(find.text('2026년 5월'), findsOneWidget);
      expect(_iconWithLabel('다음 달'), findsOneWidget);
    });
  });
}
