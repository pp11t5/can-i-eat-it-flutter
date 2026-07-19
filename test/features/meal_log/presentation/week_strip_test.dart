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
  // 고정 기준: 2026-06-17 (수요일) = today, 표시월 = 2026-06(30일).
  final today = DateTime(2026, 6, 17);
  final visibleMonth = DateTime(2026, 6, 1);

  // 헬퍼: WeekStrip을 고정 today/visibleMonth로 생성
  Widget buildStrip({
    DateTime? month,
    DateTime? selectedDate,
    DateTime? todayOverride,
    Map<DateTime, List<VerdictLevel>> dotsByDate = const {},
    ValueChanged<DateTime>? onDaySelected,
  }) {
    return WeekStrip(
      visibleMonth: month ?? visibleMonth,
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
    testWidgets('선택일(17) 날짜 숫자 텍스트가 존재한다', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));
      await tester.pump();

      expect(find.text('17'), findsOneWidget);
    });

    testWidgets('오늘이 아닌 날 요일 라벨 일~토가 존재한다', (tester) async {
      // today를 이 달 밖(2026-07-01)으로 설정해 "오늘" 라벨이 나오지 않게 함
      final outsideToday = DateTime(2026, 7, 1);
      await tester.pumpWidget(_wrap(buildStrip(todayOverride: outsideToday)));
      await tester.pump();

      for (final label in ['일', '월', '화', '수', '목', '금', '토']) {
        expect(find.text(label), findsWidgets);
      }
    });
  });

  // ---------------------------------------------------------------------------
  // '오늘' 라벨 치환
  // ---------------------------------------------------------------------------

  group('WeekStrip — 오늘 라벨', () {
    testWidgets('오늘 칸 요일 라벨이 "오늘"로 치환된다', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));
      await tester.pump();

      // today = 2026-06-17 (수요일) → "수" 대신 "오늘"
      expect(find.text('오늘'), findsOneWidget);
    });

    testWidgets('오늘이 이 달에 없으면 "오늘" 라벨이 없다', (tester) async {
      // today를 다음 달로 설정
      final nextMonth = DateTime(2026, 7, 1);
      await tester.pumpWidget(_wrap(buildStrip(todayOverride: nextMonth)));
      await tester.pump();

      expect(find.text('오늘'), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // 일요일 색상 (빨강)
  // ---------------------------------------------------------------------------

  group('WeekStrip — 일요일 빨강', () {
    testWidgets('일요일(14일) 칸 요일 라벨이 calendarSunday 색으로 렌더된다', (tester) async {
      // today를 이 달 밖으로 설정해 "일" 라벨이 유지되게 함. selectedDate는
      // 기본값(17일, 일요일 아님)을 유지 — 14일 칸이 선택 캡슐(흰 텍스트)에
      // 가려지지 않아야 calendarSunday 색을 확인할 수 있다. 뷰포트가 정확히
      // 7칸만 보여주므로(요구사항①) 명시적으로 스크롤해 14일을 노출시킨다.
      final outsideToday = DateTime(2026, 7, 1);
      await tester.pumpWidget(
        _wrap(buildStrip(todayOverride: outsideToday)),
      );
      await tester.pump();
      await tester.scrollUntilVisible(
        find.text('14'),
        -100.0,
        scrollable: find.byType(Scrollable),
      );
      await tester.pump();

      // 2026-06-14 는 일요일 → "일" 라벨 텍스트 위젯 찾기
      final sundayTexts = tester.widgetList<Text>(find.text('일'));
      expect(
        sundayTexts.any((t) => t.style?.color == AppColors.calendarSunday),
        isTrue,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // 미래 날짜 회색
  // ---------------------------------------------------------------------------

  group('WeekStrip — 미래 날짜 회색', () {
    testWidgets('미래 날짜 숫자가 #BBBBBB 색으로 렌더된다', (tester) async {
      // today = 2026-06-14 → 15일은 미래
      final earlyToday = DateTime(2026, 6, 14);
      await tester.pumpWidget(
        _wrap(buildStrip(
          selectedDate: earlyToday,
          todayOverride: earlyToday,
        )),
      );
      await tester.pump();

      final futureNum = tester.widget<Text>(find.text('15'));
      expect(
        futureNum.style?.color,
        equals(const Color(0xFFBBBBBB)),
      );
    });

    testWidgets('오늘 날짜 숫자는 미래가 아니라 textSecondary이다', (tester) async {
      await tester.pumpWidget(
        _wrap(buildStrip(
          selectedDate: DateTime(2026, 6, 1), // 다른 날 선택
          todayOverride: today,
        )),
      );
      await tester.pump();
      // 횡스크롤 캘린더는 selectedDate(1일)로 초기 스크롤되므로 today(17)는
      // 뷰포트 밖(ListView.builder 미빌드) — 스크롤해 노출시킨다.
      await tester.scrollUntilVisible(
        find.text('17'),
        100.0,
        scrollable: find.byType(Scrollable),
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
      await tester.pump();
      // 기본 선택일(오늘=17일)로 초기 스크롤되므로 15일은 뷰포트 밖 — 스크롤해 노출.
      await tester.scrollUntilVisible(
        find.text('15'),
        -100.0,
        scrollable: find.byType(Scrollable),
      );
      // ensureVisible 정렬(alignment 0.0)이 렌더 트리에 반영되도록 1프레임 더 pump.
      await tester.pump();

      // 2026-06-15 탭
      await tester.tap(find.text('15'));
      await tester.pump();

      expect(tappedDate, isNotNull);
      expect(tappedDate!.day, equals(15));
      expect(tappedDate!.month, equals(6));
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

  // ---------------------------------------------------------------------------
  // 횡스크롤 — 해당월 일수만큼 렌더
  // ---------------------------------------------------------------------------

  group('WeekStrip — 횡스크롤', () {
    testWidgets('해당월 마지막날(30) 숫자까지 스크롤로 도달 가능하다', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));
      await tester.pump();

      // 6월은 30일까지 — 스크롤 없이 안 보일 수 있으므로 끝까지 드래그.
      await tester.drag(
        find.byType(WeekStrip),
        const Offset(-5000, 0),
      );
      await tester.pump();

      expect(find.text('30'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // 셀 폭 — 뷰포트에 정확히 7칸 fit (요구사항①)
  // ---------------------------------------------------------------------------

  group('WeekStrip — 셀 폭 7칸 fit', () {
    testWidgets('셀 폭 = (뷰포트폭 - gap*6) / 7 로 계산되어 7칸이 정확히 들어간다', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip()));
      await tester.pump();

      // 실제 가로 스크롤 뷰포트 폭(Scrollable) — WeekStrip 카드 자체 폭에서
      // Border.all(1) 만큼 좌우로 줄어드므로 카드 폭이 아닌 뷰포트로 측정한다.
      final viewportWidth = tester.getSize(find.byType(Scrollable)).width;
      const gap = 8.0;
      final expectedCellWidth = (viewportWidth - gap * 6) / 7;

      // 기본 선택일(17일) 칸의 실측 폭이 계산식과 일치해야 한다 (17일은
      // 선택일이라 항상 빌드·가시 상태).
      final selectedCellFinder = find
          .ancestor(
            of: find.text('17'),
            matching: find.byType(SizedBox),
          )
          .first;
      final cellWidth = tester.getSize(selectedCellFinder).width;

      expect(cellWidth, closeTo(expectedCellWidth, 0.5));

      // 7칸 + gap 6개 폭 합이 뷰포트 폭과 근사(오차 1px 이내)해야 한다 —
      // 즉 스크롤 없이 정확히 7개가 화면에 맞는다는 뜻.
      final sevenCellsWidth = expectedCellWidth * 7 + gap * 6;
      expect(sevenCellsWidth, closeTo(viewportWidth, 1.0));
    });
  });

  // ---------------------------------------------------------------------------
  // 진입 시 가운데 정렬 (요구사항②)
  // ---------------------------------------------------------------------------

  group('WeekStrip — 가운데 정렬', () {
    testWidgets('월 중간 날짜 진입 시 대상일이 뷰포트 가운데 근처로 스크롤된다', (tester) async {
      await tester.pumpWidget(_wrap(buildStrip())); // selectedDate = 17일
      await tester.pumpAndSettle();

      final scrollable = find.byType(Scrollable);
      final position = tester.state<ScrollableState>(scrollable).position;

      final viewportWidth = tester.getSize(scrollable).width;
      const gap = 8.0;
      final cellWidth = (viewportWidth - gap * 6) / 7;
      const index = 16; // 17일 = index 16
      final expectedOffset =
          index * (cellWidth + gap) - (viewportWidth - cellWidth) / 2;

      expect(
        position.pixels,
        closeTo(expectedOffset.clamp(0.0, position.maxScrollExtent), 0.5),
      );
      // 좌측 정렬(offset = index*(cellWidth+gap))이 아님을 함께 확인.
      expect(position.pixels, isNot(closeTo(index * (cellWidth + gap), 1.0)));
    });

    testWidgets('월초(1일) 진입 시 가운데 정렬이 불가능해 0으로 clamp된다', (tester) async {
      await tester.pumpWidget(
        _wrap(buildStrip(selectedDate: DateTime(2026, 6, 1))),
      );
      // 라이브러리 sliver가 뒷부분 extent 추정치를 완전히 수렴시키도록
      // pumpAndSettle로 안정화(스크롤 물리 보정 애니메이션 포함) 후 검증.
      await tester.pumpAndSettle();

      final scrollable = find.byType(Scrollable);
      final position = tester.state<ScrollableState>(scrollable).position;

      expect(position.pixels, equals(0.0));
    });

    testWidgets('월말(30일) 진입 시 가운데 정렬이 불가능해 maxScrollExtent로 clamp된다',
        (tester) async {
      await tester.pumpWidget(
        _wrap(buildStrip(selectedDate: DateTime(2026, 6, 30))),
      );
      // 위와 동일 이유로 pumpAndSettle로 스크롤 위치가 최종 수렴한 뒤 검증.
      await tester.pumpAndSettle();

      final scrollable = find.byType(Scrollable);
      final position = tester.state<ScrollableState>(scrollable).position;

      expect(position.pixels, equals(position.maxScrollExtent));
    });
  });
}
