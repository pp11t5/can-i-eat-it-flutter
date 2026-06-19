import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/observers/route_observer.dart';
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

/// 어제 KST 날짜 기준 eatenAt ISO-8601 문자열 생성.
String _yesterdayEatenAt(int hour, int minute) {
  final yesterday = nowKst().subtract(const Duration(days: 1));
  final h = hour.toString().padLeft(2, '0');
  final m = minute.toString().padLeft(2, '0');
  final y = yesterday.year.toString().padLeft(4, '0');
  final mo = yesterday.month.toString().padLeft(2, '0');
  final d = yesterday.day.toString().padLeft(2, '0');
  return '$y-$mo-${d}T$h:$m:00+09:00';
}

/// 어제 날짜 기록만 있는 MockMealRepository.
MockMealRepository _yesterdaySeeded() {
  final group = MealGroup(
    mealGroupId: 'g-yesterday',
    eatenAt: _yesterdayEatenAt(8, 0),
    records: [
      MealRecord(
        mealId: 'm-y001',
        mealGroupId: 'g-yesterday',
        eatenAt: _yesterdayEatenAt(8, 0),
        food: const FoodSummary(externalId: 'f-001', name: '두부'),
        judgedGrade: VerdictLevel.recommend,
      ),
      MealRecord(
        mealId: 'm-y002',
        mealGroupId: 'g-yesterday',
        eatenAt: _yesterdayEatenAt(12, 0),
        food: const FoodSummary(externalId: 'f-002', name: '커피'),
        judgedGrade: VerdictLevel.risk,
      ),
      MealRecord(
        mealId: 'm-y003',
        mealGroupId: 'g-yesterday',
        eatenAt: _yesterdayEatenAt(18, 0),
        food: const FoodSummary(externalId: 'f-003', name: '된장찌개'),
        judgedGrade: VerdictLevel.caution,
      ),
    ],
  );
  return MockMealRepository(initialGroups: [group]);
}

/// 오늘(2건) + 어제(3건) 혼합 MockMealRepository.
MockMealRepository _mixedSeeded() {
  final todayGroup = MealGroup(
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
  final yesterdayGroup = MealGroup(
    mealGroupId: 'g-yesterday',
    eatenAt: _yesterdayEatenAt(8, 0),
    records: [
      MealRecord(
        mealId: 'm-y001',
        mealGroupId: 'g-yesterday',
        eatenAt: _yesterdayEatenAt(8, 0),
        food: const FoodSummary(externalId: 'f-003', name: '커피'),
        judgedGrade: VerdictLevel.risk,
      ),
      MealRecord(
        mealId: 'm-y002',
        mealGroupId: 'g-yesterday',
        eatenAt: _yesterdayEatenAt(12, 0),
        food: const FoodSummary(externalId: 'f-004', name: '라면'),
      ),
      MealRecord(
        mealId: 'm-y003',
        mealGroupId: 'g-yesterday',
        eatenAt: _yesterdayEatenAt(18, 0),
        food: const FoodSummary(externalId: 'f-005', name: '치킨'),
      ),
    ],
  );
  return MockMealRepository(initialGroups: [todayGroup, yesterdayGroup]);
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

    testWidgets('빈 상태: Icons.restaurant_menu 아이콘이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(MockMealRepository.empty()));
      await _settle(tester);

      expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
    });

    testWidgets('데이터 있음: 식사 수·마지막 시간·헤더·더보기 표시', (tester) async {
      await tester.pumpWidget(_wrap(_todaySeeded()));
      await _settle(tester);

      // 헤더
      expect(find.text('오늘의 식사'), findsOneWidget);
      // 식사 수
      expect(find.textContaining('2개'), findsOneWidget);
      // 마지막 식사 시간 (12:30)
      expect(find.text('마지막: 12:30'), findsOneWidget);
      // 더 보기 버튼
      expect(find.text('더 보기'), findsOneWidget);
    });

    testWidgets('어제 기록은 오늘 카운트에 포함되지 않는다 — 빈 상태 표시', (tester) async {
      await tester.pumpWidget(_wrap(_yesterdaySeeded()));
      await _settle(tester);

      // 어제 기록만 있으므로 오늘 빈 상태
      expect(find.text('오늘 기록된 식사가 없어요.'), findsOneWidget);
      // 식사 수 표시 없음
      expect(find.textContaining('개'), findsNothing);
    });

    testWidgets('오늘(2건)+어제(3건) 혼합 시 오늘 것만 카운트 — "2개" 표시', (tester) async {
      await tester.pumpWidget(_wrap(_mixedSeeded()));
      await _settle(tester);

      // 오늘 2건만 카운트
      expect(find.textContaining('2개'), findsOneWidget);
      // 어제 건수(3)는 포함되지 않음
      expect(find.textContaining('5개'), findsNothing);
      expect(find.textContaining('3개'), findsNothing);
    });

    testWidgets('"더 보기" 탭 시 /meal-log 라우트로 이동한다', (tester) async {
      await tester.pumpWidget(_wrap(MockMealRepository.empty()));
      await _settle(tester);

      // "더 보기" 버튼 탭
      await tester.tap(find.text('더 보기'));
      await _settle(tester);

      // /meal-log stub 텍스트 확인
      expect(find.text('meal-log stub'), findsOneWidget);
    });

    testWidgets('didPopNext: 다른 라우트에서 홈으로 돌아오면 provider가 invalidate된다',
        (tester) async {
      // Navigator + RouteObserver를 사용하는 테스트.
      // ProviderScope는 단일 루트에만 두어 scoped provider 충돌 방지.
      final repo = MockMealRepository.empty();
      int buildCount = 0;

      final testRouter = GoRouter(
        observers: [routeObserver],
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => Scaffold(
              body: Builder(builder: (ctx) {
                buildCount++;
                return const TodayMealSummaryWidget();
              }),
            ),
          ),
          GoRoute(
            path: '/other',
            builder: (_, __) =>
                const Scaffold(body: Text('other screen')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            mealRepositoryProvider.overrideWithValue(repo),
          ],
          child: MaterialApp.router(routerConfig: testRouter),
        ),
      );
      await _settle(tester);

      final countBefore = buildCount;

      // /other로 push
      testRouter.push('/other');
      await _settle(tester);

      // /other에서 pop → 홈으로 복귀 → didPopNext 호출
      testRouter.pop();
      await _settle(tester);

      // didPopNext 후 provider invalidate → widget rebuild
      expect(buildCount, greaterThan(countBefore));
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
