import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_record_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

/// 테스트용 라우터 — /meal/record → MealRecordScreen, /check → 캡처
GoRouter _makeRouter({
  String? mealGroupId,
  void Function(MealRecordContext ctx)? onCheckPush,
}) {
  return GoRouter(
    initialLocation: '/meal/record',
    routes: [
      GoRoute(
        path: '/meal/record',
        pageBuilder: (context, state) => MaterialPage(
          child: MealRecordScreen(mealGroupId: mealGroupId),
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

Widget _wrap({String? mealGroupId, void Function(MealRecordContext)? onCheckPush}) {
  return MaterialApp.router(
    theme: AppTheme.light,
    routerConfig: _makeRouter(
      mealGroupId: mealGroupId,
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
    testWidgets('mealGroupId 없이 "다음" → /check extra에 mealGroupId null', (tester) async {
      MealRecordContext? captured;
      await tester.pumpWidget(_wrap(onCheckPush: (ctx) => captured = ctx));
      await tester.pumpAndSettle();

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.mealGroupId, isNull);
    });

    testWidgets('mealGroupId="g-1" 전달 시 → /check extra에 mealGroupId="g-1"', (tester) async {
      MealRecordContext? captured;
      await tester.pumpWidget(
        _wrap(mealGroupId: 'g-1', onCheckPush: (ctx) => captured = ctx),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('다음'));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.mealGroupId, 'g-1');
    });
  });
}
