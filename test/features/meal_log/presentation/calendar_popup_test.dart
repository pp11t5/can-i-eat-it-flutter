import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/calendar_popup.dart';

void main() {
  final today = DateTime(2026, 8, 1);
  // 가입일: 2026-07-16
  final minDate = DateTime(2026, 7, 16);

  Future<void> openPopup(
    WidgetTester tester, {
    DateTime? min,
    DateTime? initialMonth,
    DateTime? initialSelected,
  }) async {
    final month = initialMonth ?? DateTime(2026, 7, 1);
    final selected = initialSelected ?? DateTime(2026, 7, 20);
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  showCalendarPopup(
                    context,
                    initialMonth: month,
                    initialSelectedDate: selected,
                    today: today,
                    minDate: min,
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('CalendarPopup — minDate(가입일)', () {
    testWidgets('가입일 이전 날짜는 탭해도 선택값이 바뀌지 않는다', (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    picked = await showCalendarPopup(
                      context,
                      initialMonth: DateTime(2026, 7, 1),
                      initialSelectedDate: DateTime(2026, 7, 20),
                      today: today,
                      minDate: minDate,
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('15').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      expect(picked, isNotNull);
      expect(picked!.day, 20); // 15 탭 무시 → 초기 선택 유지
    });

    testWidgets('가입일 당일은 탭 가능하다', (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    picked = await showCalendarPopup(
                      context,
                      initialMonth: DateTime(2026, 7, 1),
                      initialSelectedDate: DateTime(2026, 7, 20),
                      today: today,
                      minDate: minDate,
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('16').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      expect(picked, isNotNull);
      expect(picked!.year, 2026);
      expect(picked!.month, 7);
      expect(picked!.day, 16);
    });

    testWidgets('가입월에서 이전 달 chevron onPressed는 null이다', (tester) async {
      await openPopup(
        tester,
        min: minDate,
        initialMonth: DateTime(2026, 7, 1),
      );

      final buttons = tester.widgetList<IconButton>(find.byType(IconButton));
      expect(buttons.length, greaterThanOrEqualTo(2));
      expect(buttons.first.onPressed, isNull);
      expect(buttons.elementAt(1).onPressed, isNotNull);
      // gray60 #BBBBBB
      expect(AppColors.controlDisabled, const Color(0xFFBBBBBB));
    });

    testWidgets('minDate null이면 이전 달 이동 가능하다', (tester) async {
      await openPopup(
        tester,
        min: null,
        initialMonth: DateTime(2026, 7, 1),
      );

      final buttons = tester.widgetList<IconButton>(find.byType(IconButton));
      expect(buttons.first.onPressed, isNotNull);
    });
  });
}
