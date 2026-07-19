import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/week_nav.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );
}

/// [AppIcon] 위젯 트리에서 특정 semanticsLabel 을 가진 위젯 존재 여부.
Finder _iconWithLabel(String label) => find.byWidgetPredicate(
      (w) => w is AppIcon && w.semanticsLabel == label,
    );

void main() {
  group('MonthNav — canGoNext', () {
    testWidgets('canGoNext=true(기본값)면 "다음 달" 챕비 버튼이 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(MonthNav(
          label: '2026년 6월',
          onPrevMonth: () {},
          onNextMonth: () {},
          onOpenCalendar: () {},
        )),
      );

      expect(_iconWithLabel('이전 달'), findsOneWidget);
      expect(_iconWithLabel('다음 달'), findsOneWidget);
      expect(find.byType(IconButton), findsNWidgets(3)); // 이전/다음/캘린더
    });

    testWidgets('canGoNext=false면 "다음 달" 챕비 버튼이 렌더되지 않는다(공간도 차지 안 함)',
        (tester) async {
      await tester.pumpWidget(
        _wrap(MonthNav(
          label: '2026년 7월',
          onPrevMonth: () {},
          onNextMonth: () {},
          onOpenCalendar: () {},
          canGoNext: false,
        )),
      );

      expect(_iconWithLabel('이전 달'), findsOneWidget);
      expect(_iconWithLabel('다음 달'), findsNothing);
      // 이전 + 캘린더 2개만 남는다 (다음 달 버튼은 공간도 차지하지 않음).
      expect(find.byType(IconButton), findsNWidgets(2));
    });

    testWidgets('canGoNext=false여도 "이전 달"·캘린더 버튼은 그대로 탭 가능하다', (tester) async {
      var prevTapped = false;
      var calendarTapped = false;
      await tester.pumpWidget(
        _wrap(MonthNav(
          label: '2026년 7월',
          onPrevMonth: () => prevTapped = true,
          onNextMonth: () {},
          onOpenCalendar: () => calendarTapped = true,
          canGoNext: false,
        )),
      );

      await tester.tap(find.byType(IconButton).first);
      await tester.tap(find.byType(IconButton).last);
      await tester.pump();

      expect(prevTapped, isTrue);
      expect(calendarTapped, isTrue);
    });

    testWidgets('label 텍스트가 그대로 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(MonthNav(
          label: '2026년 6월',
          onPrevMonth: () {},
          onNextMonth: () {},
          onOpenCalendar: () {},
        )),
      );

      expect(find.text('2026년 6월'), findsOneWidget);
    });

    testWidgets('chevronRight 아이콘 asset은 AppIcons.chevronRight를 사용한다',
        (tester) async {
      await tester.pumpWidget(
        _wrap(MonthNav(
          label: '2026년 6월',
          onPrevMonth: () {},
          onNextMonth: () {},
          onOpenCalendar: () {},
        )),
      );

      final icon = tester.widget<AppIcon>(_iconWithLabel('다음 달'));
      expect(icon.asset, equals(AppIcons.chevronRight));
    });
  });
}
