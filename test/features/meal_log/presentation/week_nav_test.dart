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
  group('MonthNav', () {
    testWidgets('이전·다음·캘린더 버튼이 항상 렌더된다', (tester) async {
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

  group('MonthNav — canGoPrev', () {
    testWidgets('canGoPrev=false면 이전 달 탭 불가·controlDisabled(gray60) 색',
        (tester) async {
      var prevTapped = false;
      await tester.pumpWidget(
        _wrap(MonthNav(
          label: '2026년 7월',
          onPrevMonth: () => prevTapped = true,
          onNextMonth: () {},
          onOpenCalendar: () {},
          canGoPrev: false,
        )),
      );

      final prevIcon = tester.widget<AppIcon>(_iconWithLabel('이전 달'));
      expect(prevIcon.color, AppColors.controlDisabled);

      final prevBtn =
          tester.widgetList<IconButton>(find.byType(IconButton)).first;
      expect(prevBtn.onPressed, isNull);

      await tester.tap(find.byType(IconButton).first);
      await tester.pump();
      expect(prevTapped, isFalse);
    });

    testWidgets('canGoPrev=true면 이전 달 textPrimary 색·탭 가능', (tester) async {
      var prevTapped = false;
      await tester.pumpWidget(
        _wrap(MonthNav(
          label: '2026년 8월',
          onPrevMonth: () => prevTapped = true,
          onNextMonth: () {},
          onOpenCalendar: () {},
          canGoPrev: true,
        )),
      );

      final prevIcon = tester.widget<AppIcon>(_iconWithLabel('이전 달'));
      expect(prevIcon.color, AppColors.textPrimary);

      await tester.tap(find.byType(IconButton).first);
      await tester.pump();
      expect(prevTapped, isTrue);
    });
  });
}
