import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
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
  group('MonthNav — canGoPrev / canGoNext', () {
    testWidgets('기본값이면 이전·다음 달 버튼이 모두 렌더·활성 색이다', (tester) async {
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

      final next = tester.widget<AppIcon>(_iconWithLabel('다음 달'));
      expect(next.color, equals(AppColors.textPrimary));
    });

    testWidgets('canGoNext=false여도 "다음 달"은 보이고 navi 색·탭 불가', (tester) async {
      var nextTapped = false;
      await tester.pumpWidget(
        _wrap(MonthNav(
          label: '2026년 7월',
          onPrevMonth: () {},
          onNextMonth: () => nextTapped = true,
          onOpenCalendar: () {},
          canGoNext: false,
        )),
      );

      expect(_iconWithLabel('다음 달'), findsOneWidget);
      final next = tester.widget<AppIcon>(_iconWithLabel('다음 달'));
      expect(next.color, equals(AppColors.navi));

      await tester.tap(_iconWithLabel('다음 달'));
      await tester.pump();
      expect(nextTapped, isFalse);
    });

    testWidgets('canGoPrev=false여도 "이전 달"은 보이고 navi 색·탭 불가', (tester) async {
      var prevTapped = false;
      await tester.pumpWidget(
        _wrap(MonthNav(
          label: '2026년 6월',
          onPrevMonth: () => prevTapped = true,
          onNextMonth: () {},
          onOpenCalendar: () {},
          canGoPrev: false,
        )),
      );

      expect(_iconWithLabel('이전 달'), findsOneWidget);
      final prev = tester.widget<AppIcon>(_iconWithLabel('이전 달'));
      expect(prev.color, equals(AppColors.navi));

      await tester.tap(_iconWithLabel('이전 달'));
      await tester.pump();
      expect(prevTapped, isFalse);
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

      await tester.tap(_iconWithLabel('이전 달'));
      await tester.tap(find.byTooltip('캘린더 열기'));
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
