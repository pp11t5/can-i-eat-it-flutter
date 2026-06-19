import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/today_meal_summary_widget.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

/// 오늘 KST 날짜 기준 eatenAt ISO-8601 문자열 생성.
String _todayEatenAt(int hour, int minute) {
  final today = nowKst();
  final h = hour.toString().padLeft(2, '0');
  final m = minute.toString().padLeft(2, '0');
  final y = today.year.toString().padLeft(4, '0');
  final mo = today.month.toString().padLeft(2, '0');
  final d = today.day.toString().padLeft(2, '0');
  return '$y-$mo-${d}T$h:$m:00+09:00';
}

/// 오늘 날짜 기록이 있는 MockMealRepository.
MockMealRepository _todaySeeded() {
  final group = MealGroup(
    mealGroupId: 'g-today',
    eatenAt: _todayEatenAt(8, 0),
    records: [
      MealRecord(
        mealId: 'm-001',
        mealGroupId: 'g-today',
        eatenAt: _todayEatenAt(8, 0),
        food: const FoodSummary(externalId: 'f-001', name: '두부'),
        judgedGrade: VerdictLevel.recommend,
      ),
      MealRecord(
        mealId: 'm-002',
        mealGroupId: 'g-today',
        eatenAt: _todayEatenAt(12, 30),
        food: const FoodSummary(externalId: 'f-002', name: '된장찌개'),
        judgedGrade: VerdictLevel.caution,
      ),
    ],
  );
  return MockMealRepository(initialGroups: [group]);
}

GoRouter _testRouter() => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(
            body: TodayMealSummaryWidget(),
          ),
        ),
        GoRoute(
          path: '/meal-log',
          builder: (_, __) =>
              const Scaffold(body: Text('meal-log stub')),
        ),
      ],
    );

Widget _wrap(MockMealRepository repo) => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        mealRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('TodayMealSummaryWidget', () {
    testWidgets('로딩 중: CircularProgressIndicator 표시', (tester) async {
      // SlowMealRepository: timeline()이 완료되기 전까지 loading 상태 유지
      final slowRepo = _SlowMealRepository();
      await tester.pumpWidget(_wrap(slowRepo));
      // 첫 프레임만 pump — async 완료 전이므로 loading
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('에러 상태: 에러 메시지 표시', (tester) async {
      final errorRepo = _ThrowingMealRepository();
      await tester.pumpWidget(_wrap(errorRepo));
      await _settle(tester);

      expect(find.text('식사 기록을 불러오지 못했어요.'), findsOneWidget);
    });

    testWidgets('빈 상태: "오늘 기록된 식사가 없어요." + "더 보기" 버튼 표시', (tester) async {
      await tester.pumpWidget(_wrap(MockMealRepository.empty()));
      await _settle(tester);

      expect(find.text('오늘 기록된 식사가 없어요.'), findsOneWidget);
      expect(find.text('더 보기'), findsOneWidget);
    });

    testWidgets('데이터 있음: 식사 수·마지막 시간·헤더·더보기 표시', (tester) async {
      await tester.pumpWidget(_wrap(_todaySeeded()));
      await _settle(tester);

      // 헤더
      expect(find.text('오늘의 식사'), findsOneWidget);
      // 식사 수: RichText 내 "2개" 텍스트 스팬
      expect(find.textContaining('2개'), findsOneWidget);
      // 마지막 식사 시간 (12:30)
      expect(find.text('마지막: 12:30'), findsOneWidget);
      // 더 보기 버튼
      expect(find.text('더 보기'), findsOneWidget);
    });
  });
}

// ---------------------------------------------------------------------------
// 픽스처
// ---------------------------------------------------------------------------

/// timeline()이 완료되지 않는 mock — 로딩 상태 검증용.
class _SlowMealRepository extends MockMealRepository {
  _SlowMealRepository() : super();

  @override
  Future<List<MealGroup>> timeline(DateTime date) =>
      Completer<List<MealGroup>>().future; // never completes
}

/// timeline()이 throw하는 mock — 에러 상태 검증용.
class _ThrowingMealRepository extends MockMealRepository {
  _ThrowingMealRepository() : super();

  @override
  Future<List<MealGroup>> timeline(DateTime date) async {
    throw Exception('테스트용 에러');
  }
}
