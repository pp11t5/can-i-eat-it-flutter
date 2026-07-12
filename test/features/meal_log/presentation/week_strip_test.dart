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
  // 고정 기준: 2026-06-17 (수요일) = today
  // 해당 주 일요일: 2026-06-14
  final today = DateTime(2026, 6, 17);
  final weekStart = DateTime(2026, 6, 14);

  // 헬퍼: WeekStrip을 고정 today로 생성
  Widget buildStrip({
    DateTime? selectedDate,
    DateTime? todayOverride,
    Map<DateTime, List<VerdictLevel>> dotsByDate = const {},
    ValueChanged<DateTime>? onDaySelected,
  }) {
    return WeekStrip(
      weekStart: weekStart,
      selectedDate: selectedDate ?? today,
      today: todayOverride ?? today,
      dotsByDate: dotsByDate,
      onDaySelected: onDaySelected ?? (_) {},
    );
  }

  // ---------------------------------------------------------------------------
  // 렌더링 기본
  // ---------------------------------------------------------------------------

  group('WeekStrip — 렌더링', () {
    testWidgets('7개 날짜 칸을 렌더한다', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));

      for (var d = 14; d <= 20; d++) {
        expect(find.text('$d'), findsOneWidget);
      }
    });

    testWidgets('오늘이 아닌 날 요일 라벨 일~토를 표시한다', (tester) async {
      // today를 이 주 밖(2026-06-21 일요일)으로 설정해 7칸 모두 과거
      final outsideToday = DateTime(2026, 6, 21);
      await tester.pumpWidget(_wrap(buildStrip(todayOverride: outsideToday)));

      for (final label in ['일', '월', '화', '수', '목', '금', '토']) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('선택일 숫자 텍스트가 존재한다', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));
      expect(find.text('17'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // '오늘' 라벨 치환
  // ---------------------------------------------------------------------------

  group('WeekStrip — 오늘 라벨', () {
    testWidgets('오늘 칸 요일 라벨이 "오늘"로 치환된다', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));

      // today = 2026-06-17 (수요일) → "수" 대신 "오늘"
      expect(find.text('오늘'), findsOneWidget);
      expect(find.text('수'), findsNothing);
    });

    testWidgets('오늘이 일요일이면 "오늘"로 치환되고 "일"은 없다', (tester) async {
      // weekStart = 2026-06-14(일) = today
      final sundayToday = DateTime(2026, 6, 14);
      await tester.pumpWidget(
        _wrap(buildStrip(
          selectedDate: sundayToday,
          todayOverride: sundayToday,
        )),
      );

      expect(find.text('오늘'), findsOneWidget);
      expect(find.text('일'), findsNothing);
    });

    testWidgets('오늘이 이 주에 없으면 "오늘" 라벨이 없다', (tester) async {
      // today를 다음 주로 설정
      final nextWeek = DateTime(2026, 6, 24);
      await tester.pumpWidget(_wrap(buildStrip(todayOverride: nextWeek)));

      expect(find.text('오늘'), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // 일요일 색상 (빨강)
  // ---------------------------------------------------------------------------

  group('WeekStrip — 일요일 빨강', () {
    testWidgets('일요일 칸 요일 라벨이 calendarSunday 색으로 렌더된다', (tester) async {
      // today를 이 주 밖으로 설정해 일요일 칸이 "일" 라벨로 표시되게 함
      final outsideToday = DateTime(2026, 6, 21);
      await tester.pumpWidget(
        _wrap(buildStrip(
          selectedDate: today,
          todayOverride: outsideToday,
        )),
      );

      // "일" 라벨 텍스트 위젯 찾기
      final sundayText = tester.widget<Text>(find.text('일'));
      expect(
        sundayText.style?.color,
        equals(AppColors.calendarSunday),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // 미래 날짜 회색
  // ---------------------------------------------------------------------------

  group('WeekStrip — 미래 날짜 회색', () {
    testWidgets('미래 날짜 요일 라벨이 textSecondary 색으로 렌더된다', (tester) async {
      // today = 2026-06-14 (일) → 15~20은 미래
      final earlyToday = DateTime(2026, 6, 14);
      await tester.pumpWidget(
        _wrap(buildStrip(
          selectedDate: earlyToday,
          todayOverride: earlyToday,
        )),
      );

      // "월"(15일) 라벨은 미래 → Figma 실측: 미래에도 요일 라벨은 textSecondary(#737380) 유지
      final mondayText = tester.widget<Text>(find.text('월'));
      expect(
        mondayText.style?.color,
        equals(AppColors.textSecondary),
      );
    });

    testWidgets('미래 날짜 숫자가 #BBBBBB 색으로 렌더된다', (tester) async {
      final earlyToday = DateTime(2026, 6, 14);
      await tester.pumpWidget(
        _wrap(buildStrip(
          selectedDate: earlyToday,
          todayOverride: earlyToday,
        )),
      );

      // 15일(미래) 숫자 텍스트 → Figma 실측: 옅은 회색 #BBBBBB
      final futureNum = tester.widget<Text>(find.text('15'));
      expect(
        futureNum.style?.color,
        equals(const Color(0xFFBBBBBB)),
      );
    });

    testWidgets('오늘 날짜 숫자는 미래가 아니라 textSecondary이다', (tester) async {
      await tester.pumpWidget(
        _wrap(buildStrip(
          selectedDate: DateTime(2026, 6, 14), // 다른 날 선택
          todayOverride: today,
        )),
      );

      // 오늘(17)은 미래가 아님 → 선택 아닐 때 Figma 실측: textSecondary(#737380)
      final todayNum = tester.widget<Text>(find.text('17'));
      expect(
        todayNum.style?.color,
        equals(AppColors.textSecondary),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // 날짜 탭 콜백
  // ---------------------------------------------------------------------------

  group('WeekStrip — 날짜 탭 콜백', () {
    testWidgets('날짜 탭 시 onDaySelected 콜백이 호출된다', (tester) async {
      DateTime? tappedDate;
      await tester.pumpWidget(
        _wrap(buildStrip(onDaySelected: (d) => tappedDate = d)),
      );

      // 2026-06-15 (월) 탭
      await tester.tap(find.text('15'));
      await tester.pump();

      expect(tappedDate, isNotNull);
      expect(tappedDate!.day, equals(15));
      expect(tappedDate!.month, equals(6));
    });

    testWidgets('일요일(14일) 탭 시 올바른 날짜 반환', (tester) async {
      DateTime? tappedDate;
      await tester.pumpWidget(
        _wrap(buildStrip(
          todayOverride: DateTime(2026, 6, 21), // 오늘 밖으로 → "일" 라벨 표시
          onDaySelected: (d) => tappedDate = d,
        )),
      );

      await tester.tap(find.text('14'));
      await tester.pump();

      expect(tappedDate!.day, equals(14));
    });

    testWidgets('토요일(20일) 탭 시 올바른 날짜 반환', (tester) async {
      DateTime? tappedDate;
      await tester.pumpWidget(
        _wrap(buildStrip(onDaySelected: (d) => tappedDate = d)),
      );

      await tester.tap(find.text('20'));
      await tester.pump();

      expect(tappedDate!.day, equals(20));
    });
  });

  // ---------------------------------------------------------------------------
  // 도트
  // ---------------------------------------------------------------------------

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
      // 도트 2개 = 원형 컨테이너 2개.
      // (선택 배지는 이제 요일+숫자+도트를 감싸는 캡슐(rounded-rect)이라 circle 아님.)
      expect(dotContainers.length, greaterThanOrEqualTo(2));
    });
  });
}
