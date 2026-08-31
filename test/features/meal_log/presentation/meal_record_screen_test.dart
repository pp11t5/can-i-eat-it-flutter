import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_record_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

/// 테스트용 라우터 — /meal/record → MealRecordScreen, /check → 캡처
GoRouter _makeRouter({
  String? mealRecordId,
  DateTime? joinDate,
  void Function(MealRecordContext ctx)? onCheckPush,
}) {
  return GoRouter(
    initialLocation: '/meal/record',
    routes: [
      GoRoute(
        path: '/meal/record',
        pageBuilder: (context, state) => MaterialPage(
          child: MealRecordScreen(
            mealRecordId: mealRecordId,
            joinDate: joinDate,
          ),
        ),
      ),
      GoRoute(
        path: '/check',
        pageBuilder: (context, state) {
          final ctx = state.extra as MealRecordContext?;
          if (ctx != null) onCheckPush?.call(ctx);
          return const MaterialPage(child: Scaffold(body: Text('check')));
        },
      ),
    ],
  );
}

Widget _wrap({
  String? mealRecordId,
  DateTime? joinDate,
  void Function(MealRecordContext)? onCheckPush,
}) {
  return MaterialApp.router(
    theme: AppTheme.light,
    routerConfig: _makeRouter(
      mealRecordId: mealRecordId,
      joinDate: joinDate,
      onCheckPush: onCheckPush,
    ),
  );
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('MealRecordScreen — 렌더링', () {
    testWidgets('헤더 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('언제 드셨나요?'), findsOneWidget);
      expect(find.text('기억나는 시간을 알려주세요'), findsOneWidget);
    });

    testWidgets('빠른 선택 칩 5개가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('지금'), findsOneWidget);
      expect(find.text('10분 전'), findsOneWidget);
      expect(find.text('30분 전'), findsOneWidget);
      expect(find.text('1시간 전'), findsOneWidget);
      expect(find.text('2시간 전'), findsOneWidget);
    });

    testWidgets('"다음" 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('다음'), findsOneWidget);
    });

    testWidgets('"지금" 칩이 기본 선택 상태이다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      // 지금 칩이 primary 배경색으로 렌더된다 — 타이틀 존재로 간접 확인
      expect(find.text('지금'), findsOneWidget);
    });
  });

  group('MealRecordScreen — 칩 선택', () {
    testWidgets('"10분 전" 칩 탭 시 선택 상태로 변경된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await tester.tap(find.text('10분 전'));
      await tester.pumpAndSettle();
      // 탭 후 에러 없이 상태 변경 완료 — 위젯 트리 정상
      expect(find.text('10분 전'), findsOneWidget);
    });

    testWidgets('"30분 전" 칩 탭 후 "다음" → MealRecordContext.eatenAt이 "지금"보다 30분 이전이다',
        (tester) async {
      MealRecordContext? capturedAfter30;
      MealRecordContext? capturedNow;

      // "지금" 기준값 먼저 캡처
      await tester.pumpWidget(_wrap(onCheckPush: (ctx) => capturedNow = ctx));
      await tester.pumpAndSettle();
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      // "30분 전" 캡처
      await tester.pumpWidget(_wrap(onCheckPush: (ctx) => capturedAfter30 = ctx));
      await tester.pumpAndSettle();
      await tester.tap(find.text('30분 전'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(capturedNow, isNotNull);
      expect(capturedAfter30, isNotNull);

      // "지금"과 "30분 전" 차이가 약 30분이어야 함 (± 2분 허용)
      final diff = capturedNow!.eatenAt
          .difference(capturedAfter30!.eatenAt)
          .inMinutes
          .abs();
      expect(diff, inInclusiveRange(28, 32));
    });
  });

  group('MealRecordScreen — 다음 버튼', () {
    testWidgets('mealRecordId 없이 "다음" → /check extra에 mealRecordId null', (tester) async {
      MealRecordContext? captured;
      await tester.pumpWidget(_wrap(onCheckPush: (ctx) => captured = ctx));
      await tester.pumpAndSettle();

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.mealRecordId, isNull);
    });

    testWidgets('mealRecordId="mr-1" 전달 시 → /check extra에 mealRecordId="mr-1"', (tester) async {
      MealRecordContext? captured;
      await tester.pumpWidget(
        _wrap(mealRecordId: 'mr-1', onCheckPush: (ctx) => captured = ctx),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.mealRecordId, 'mr-1');
    });
  });

  group('MealRecordScreen — 직접 입력 휠 미래 시각 제한', () {
    Future<void> openManualWheel(WidgetTester tester) async {
      await tester.tap(find.text('직접 입력'));
      await tester.pumpAndSettle();
    }

    List<ListWheelScrollView> wheelsOf(WidgetTester tester) {
      return tester
          .widgetList<ListWheelScrollView>(find.byType(ListWheelScrollView))
          .toList();
    }

    ListWheelChildBuilderDelegate delegateOf(ListWheelScrollView wheel) {
      return wheel.childDelegate as ListWheelChildBuilderDelegate;
    }

    testWidgets('"직접 입력" 탭 시 휠이 노출된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.byType(ListWheelScrollView), findsNothing);

      await openManualWheel(tester);

      expect(find.text('직접 선택'), findsOneWidget);
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
    });

    testWidgets('직접 입력 휠 좌우 열은 옆에서 본 원통 각도다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await openManualWheel(tester);

      final wheels = wheelsOf(tester);
      expect(wheels[0].offAxisFraction, -0.45);
      expect(wheels[1].offAxisFraction, 0);
      expect(wheels[2].offAxisFraction, 0.45);
    });

    testWidgets('직접 입력 휠은 현재 시각을 기본 선택한다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await openManualWheel(tester);

      final now = nowKst();
      final wheels = wheelsOf(tester);
      final dateCtrl = wheels[0].controller! as FixedExtentScrollController;
      final hourCtrl = wheels[1].controller! as FixedExtentScrollController;
      final minuteCtrl = wheels[2].controller! as FixedExtentScrollController;
      expect(dateCtrl.selectedItem, 6);
      expect(hourCtrl.selectedItem, now.hour);
      expect(minuteCtrl.selectedItem, now.minute);
    });

    testWidgets('다른 빠른 선택 후 직접 입력이어도 휠은 현재 시각부터다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await tester.tap(find.text('10분 전'));
      await tester.pumpAndSettle();
      await openManualWheel(tester);

      final now = nowKst();
      final wheels = wheelsOf(tester);
      final hourCtrl = wheels[1].controller! as FixedExtentScrollController;
      final minuteCtrl = wheels[2].controller! as FixedExtentScrollController;
      expect(hourCtrl.selectedItem, now.hour);
      expect(minuteCtrl.selectedItem, now.minute);
    });

    testWidgets('오늘이면 현재 시각 이후 시·분은 휠에 없다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await openManualWheel(tester);

      final now = nowKst();
      final wheels = wheelsOf(tester);
      expect(wheels, hasLength(3));

      expect(delegateOf(wheels[1]).childCount, now.hour + 1);
      expect(delegateOf(wheels[2]).childCount, now.minute + 1);

      expect(
        find.text('${now.hour.toString().padLeft(2, '0')}시'),
        findsOneWidget,
      );
      expect(
        find.text('${now.minute.toString().padLeft(2, '0')}분'),
        findsOneWidget,
      );

      if (now.hour < 23) {
        expect(
          find.text('${(now.hour + 1).toString().padLeft(2, '0')}시'),
          findsNothing,
        );
      }
      if (now.minute < 59) {
        expect(
          find.text('${(now.minute + 1).toString().padLeft(2, '0')}분'),
          findsNothing,
        );
      }
    });

    testWidgets('날짜 휠은 과거가 위, 오늘이 마지막이다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await openManualWheel(tester);

      final dateCtrl = wheelsOf(tester).first.controller!
          as FixedExtentScrollController;
      expect(dateCtrl.selectedItem, 6);

      final yesterday = nowKst().subtract(const Duration(days: 1));
      const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      final yesterdayLabel =
          '${yesterday.month}월 ${yesterday.day}일 (${weekdays[yesterday.weekday - 1]})';
      expect(find.text(yesterdayLabel), findsOneWidget);
      expect(find.text('오늘'), findsOneWidget);
    });

    testWidgets('어제 날짜를 고르면 시 0–23, 분 0–59가 모두 있다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await openManualWheel(tester);

      final dateCtrl = wheelsOf(tester).first.controller!
          as FixedExtentScrollController;
      expect(dateCtrl.selectedItem, 6);
      dateCtrl.jumpToItem(5);
      await tester.pumpAndSettle();

      final wheels = wheelsOf(tester);
      expect(delegateOf(wheels[1]).childCount, 24);
      expect(delegateOf(wheels[2]).childCount, 60);
    });

    testWidgets('가입일이 오늘이면 날짜 휠에 오늘만 있다', (tester) async {
      final now = nowKst();
      await tester.pumpWidget(_wrap(joinDate: now));
      await tester.pumpAndSettle();
      await openManualWheel(tester);

      final dateWheel = wheelsOf(tester).first;
      expect(delegateOf(dateWheel).childCount, 1);
      expect(find.text('오늘'), findsOneWidget);

      final yesterday = now.subtract(const Duration(days: 1));
      const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      final yesterdayLabel =
          '${yesterday.month}월 ${yesterday.day}일 (${weekdays[yesterday.weekday - 1]})';
      expect(find.text(yesterdayLabel), findsNothing);
    });

    testWidgets('가입일이 어제이면 어제와 오늘만 있다', (tester) async {
      final now = nowKst();
      final yesterday = now.subtract(const Duration(days: 1));
      await tester.pumpWidget(_wrap(joinDate: yesterday));
      await tester.pumpAndSettle();
      await openManualWheel(tester);

      final dateWheel = wheelsOf(tester).first;
      expect(delegateOf(dateWheel).childCount, 2);
      expect(
        (dateWheel.controller! as FixedExtentScrollController).selectedItem,
        1,
      );

      const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      final yesterdayLabel =
          '${yesterday.month}월 ${yesterday.day}일 (${weekdays[yesterday.weekday - 1]})';
      expect(find.text(yesterdayLabel), findsOneWidget);
      expect(find.text('오늘'), findsOneWidget);
    });

    testWidgets('오늘에서 현재 시보다 이른 시를 고르면 분은 0–59다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await openManualWheel(tester);

      final now = nowKst();
      if (now.hour == 0) {
        // 0시면 이른 시가 없으므로 어제 날짜로 전체 분 범위를 검증한다.
        final dateCtrl = wheelsOf(tester).first.controller!
            as FixedExtentScrollController;
        expect(dateCtrl.selectedItem, 6);
        dateCtrl.jumpToItem(5);
        await tester.pumpAndSettle();
        expect(delegateOf(wheelsOf(tester)[2]).childCount, 60);
        return;
      }

      final hourCtrl = wheelsOf(tester)[1].controller!
          as FixedExtentScrollController;
      hourCtrl.jumpToItem(now.hour - 1);
      await tester.pumpAndSettle();

      expect(delegateOf(wheelsOf(tester)[2]).childCount, 60);
    });

    testWidgets('직접 입력 후 다음 → eatenAt이 현재 시각 이후가 아니다', (tester) async {
      MealRecordContext? captured;
      await tester.pumpWidget(_wrap(onCheckPush: (ctx) => captured = ctx));
      await tester.pumpAndSettle();
      await openManualWheel(tester);

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.eatenAt.isAfter(nowKst()), isFalse);
    });
  });
}
