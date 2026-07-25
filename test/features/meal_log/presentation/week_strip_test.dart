import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/week_strip.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: child),
  );
}

void main() {
  // 고정 기준: 2026-06-17 (수) = today. 연속 스트립은 17일부터 이어짐.
  final today = DateTime(2026, 6, 17);

  Widget buildStrip({
    DateTime? selectedDate,
    DateTime? todayOverride,
    int dayCount = 60,
    Map<DateTime, List<VerdictLevel>> dotsByDate = const {},
    ValueChanged<DateTime>? onDaySelected,
  }) {
    return WeekStrip(
      selectedDate: selectedDate ?? today,
      today: todayOverride ?? today,
      dayCount: dayCount,
      dotsByDate: dotsByDate,
      onDaySelected: onDaySelected ?? (_) {},
    );
  }

  group('WeekStrip — 렌더링', () {
    testWidgets('선택일(17) 날짜 숫자 텍스트가 존재한다', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));
      await tester.pump();

      expect(find.text('17'), findsOneWidget);
    });

    testWidgets('월 경계를 넘어 다음 달 1일이 연속으로 선택·표시된다', (tester) async {
      // 6/17 시작 목록에 7/1 포함 (index 14). 선택하면 빌드·가시.
      final july1 = DateTime(2026, 7, 1);
      await tester.pumpWidget(
        _wrap(buildStrip(selectedDate: july1, dayCount: 30)),
      );
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
      // 같은 연속 목록에 6월 말·7월 초가 공존 (월로 끊기지 않음).
      expect(find.text('30'), findsOneWidget); // 6/30
    });
  });

  group('WeekStrip — 오늘 라벨', () {
    testWidgets('오늘 칸 요일 라벨이 "오늘"로 치환된다', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));
      await tester.pump();

      expect(find.text('오늘'), findsOneWidget);
    });
  });

  group('WeekStrip — 과거 숨김', () {
    testWidgets('오늘 이전 날짜는 목록에 없다', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));
      await tester.pump();

      expect(find.text('15'), findsNothing);
      expect(find.text('17'), findsOneWidget);
    });
  });

  group('WeekStrip — 일요일 빨강', () {
    testWidgets('일요일(21일) 칸 요일 라벨이 calendarSunday 색으로 렌더된다',
        (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));
      await tester.pump();
      await tester.scrollUntilVisible(
        find.text('21'),
        100.0,
        scrollable: find.byType(Scrollable),
      );
      await tester.pump();

      final sundayTexts = tester.widgetList<Text>(find.text('일'));
      expect(
        sundayTexts.any((t) => t.style?.color == AppColors.calendarSunday),
        isTrue,
      );
    });
  });

  group('WeekStrip — 날짜 탭 콜백', () {
    testWidgets('날짜 탭 시 onDaySelected 콜백이 호출된다', (tester) async {
      DateTime? tappedDate;
      await tester.pumpWidget(
        _wrap(buildStrip(onDaySelected: (d) => tappedDate = d)),
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.text('18'),
        100.0,
        scrollable: find.byType(Scrollable),
      );
      await tester.pump();

      await tester.tap(find.text('18'));
      await tester.pump();

      expect(tappedDate, isNotNull);
      expect(tappedDate!.day, equals(18));
      expect(tappedDate!.month, equals(6));
    });
  });

  group('WeekStrip — 도트', () {
    testWidgets('dotsByDate에 데이터가 있으면 도트 컨테이너가 렌더된다', (tester) async {
      final dots = {
        DateTime(2026, 6, 17): [VerdictLevel.recommend, VerdictLevel.risk],
      };
      await tester.pumpWidget(
        _wrap(buildStrip(dotsByDate: dots)),
      );
      await tester.pump();

      final containers = tester.widgetList<Container>(find.byType(Container));
      final dotContainers = containers.where((c) {
        final deco = c.decoration;
        return deco is BoxDecoration && deco.shape == BoxShape.circle;
      });
      expect(dotContainers.length, greaterThanOrEqualTo(2));
    });
  });

  group('WeekStrip — 셀 폭 7칸 fit', () {
    testWidgets('셀 폭 = (뷰포트폭 - gap*6) / 7', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));
      await tester.pump();

      final viewportWidth = tester.getSize(find.byType(Scrollable)).width;
      const gap = 8.0;
      final expectedCellWidth = (viewportWidth - gap * 6) / 7;

      final selectedCellFinder = find
          .ancestor(
            of: find.text('17'),
            matching: find.byType(SizedBox),
          )
          .first;
      final cellWidth = tester.getSize(selectedCellFinder).width;

      expect(cellWidth, closeTo(expectedCellWidth, 0.5));
    });
  });

  group('WeekStrip — 가운데 정렬', () {
    testWidgets('목록 첫 칸(오늘) 진입 시 offset은 0', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));
      await tester.pumpAndSettle();

      final position =
          tester.state<ScrollableState>(find.byType(Scrollable)).position;
      expect(position.pixels, equals(0.0));
    });

    testWidgets('중간 날짜 선택 시 가운데 근처로 스크롤', (tester) async {
      final mid = DateTime(2026, 6, 24); // index 7 from 17
      await tester.pumpWidget(
        _wrap(buildStrip(selectedDate: mid)),
      );
      await tester.pumpAndSettle();

      final scrollable = find.byType(Scrollable);
      final position = tester.state<ScrollableState>(scrollable).position;
      final viewportWidth = tester.getSize(scrollable).width;
      const gap = 8.0;
      final cellWidth = (viewportWidth - gap * 6) / 7;
      const index = 7;
      final expectedOffset =
          index * (cellWidth + gap) - (viewportWidth - cellWidth) / 2;

      expect(
        position.pixels,
        closeTo(expectedOffset.clamp(0.0, position.maxScrollExtent), 0.5),
      );
    });
  });
}
