import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_write_screen.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/unrecorded_meals_screen.dart';

// ---------------------------------------------------------------------------
// 목 MealRepository — symptom_meal_pick_screen_test.dart 패턴 재사용
// ---------------------------------------------------------------------------

class _MockMealRepository implements MealRepository {
  _MockMealRepository({List<MealCandidatesDay>? data}) : candidateData = data ?? const [];

  final List<MealCandidatesDay> candidateData;

  @override
  Future<List<MealCandidatesDay>> candidates() async => candidateData;

  @override
  Future<List<TimelineItem>> timeline(DateTime date) async => [];
  @override
  Future<List<MonthlyDay>> getMonthly(DateTime month) async => [];
  @override
  Future<MealFood> appendFood({
    required String foodExternalId,
    DateTime? eatenAt,
    String? mealRecordId,
  }) async =>
      throw UnimplementedError();
  @override
  Future<MealFood> appendFoodByText({
    required String foodTextInput,
    DateTime? eatenAt,
    String? mealRecordId,
  }) async =>
      throw UnimplementedError();
  @override
  Future<MealRecord> mealDetail(String mealRecordId) async =>
      throw UnimplementedError();
  @override
  Future<MealFood> foodDetail(String mealFoodId) async =>
      throw UnimplementedError();
  @override
  Future<void> deleteMeal(String mealRecordId) async =>
      throw UnimplementedError();
  @override
  Future<void> deleteFood(String mealFoodId) async =>
      throw UnimplementedError();
}

// ---------------------------------------------------------------------------
// 샘플 데이터 — nowKst() 기준 상대 날짜로 구성해 실행 시점에 무관하게
// "오늘"/"어제" 섹션 라벨이 항상 일치하도록 한다(하드코딩 날짜는 flaky).
// ---------------------------------------------------------------------------

List<MealCandidatesDay> _sampleCandidates() {
  final today = nowKst();
  final yesterday = today.subtract(const Duration(days: 1));

  return [
    MealCandidatesDay(
      date: toServerDate(today),
      meals: [
        MealCandidate(
          mealRecordId: 'mr-today-1',
          representativeFoodName: '된장찌개',
          eatenAt: toServerOffset(
            DateTime(today.year, today.month, today.day, 12, 30),
          ),
        ),
      ],
    ),
    MealCandidatesDay(
      date: toServerDate(yesterday),
      meals: [
        MealCandidate(
          mealRecordId: 'mr-yesterday-1',
          representativeFoodName: '김치찌개',
          eatenAt: toServerOffset(
            DateTime(
              yesterday.year,
              yesterday.month,
              yesterday.day,
              19,
              5,
            ),
          ),
        ),
      ],
    ),
  ];
}

// ---------------------------------------------------------------------------
// 헬퍼 — 렌더링 전용 테스트는 GoRouter 없이 단순 MaterialApp으로 충분하다.
// 네비게이션(push 목적지 + extra 캡처) 검증은 각 테스트에서
// symptom_detail_screen_test.dart의 _testRouter 패턴을 인라인으로 재사용한다.
// ---------------------------------------------------------------------------

Widget _wrap({required MealRepository repo}) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(repo),
    ],
    child: const MaterialApp(home: UnrecordedMealsScreen()),
  );
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('UnrecordedMealsScreen — 데이터 有', () {
    testWidgets('AppBar 타이틀 "증상 미기록 식단" 표시', (tester) async {
      await tester.pumpWidget(
        _wrap(repo: _MockMealRepository(data: _sampleCandidates())),
      );
      await tester.pumpAndSettle();

      expect(find.text('증상 미기록 식단'), findsOneWidget);
    });

    testWidgets('"오늘"/"어제" 날짜 섹션이 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(repo: _MockMealRepository(data: _sampleCandidates())),
      );
      await tester.pumpAndSettle();

      expect(find.text('오늘'), findsOneWidget);
      expect(find.text('어제'), findsOneWidget);
    });

    testWidgets('식사 카드 — 음식명이 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(repo: _MockMealRepository(data: _sampleCandidates())),
      );
      await tester.pumpAndSettle();

      expect(find.text('된장찌개'), findsOneWidget);
      expect(find.text('김치찌개'), findsOneWidget);
    });

    testWidgets('식사 카드 — "HH:MM에 식사" 시간 라벨이 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(repo: _MockMealRepository(data: _sampleCandidates())),
      );
      await tester.pumpAndSettle();

      expect(find.text('12:30에 식사'), findsOneWidget);
      expect(find.text('19:05에 식사'), findsOneWidget);
    });

    testWidgets('식사 카드마다 "증상 기록하기" 액션 라벨이 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(repo: _MockMealRepository(data: _sampleCandidates())),
      );
      await tester.pumpAndSettle();

      // 식사 카드 2개 → 카드당 1개씩 "증상 기록하기" 라벨.
      expect(find.text('증상 기록하기'), findsNWidgets(2));
    });

    testWidgets('"증상만 기록하기" 카드가 항상 최상단에 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(repo: _MockMealRepository(data: _sampleCandidates())),
      );
      await tester.pumpAndSettle();

      expect(find.text('증상만 기록하기'), findsOneWidget);
      expect(find.text('음식 상관없이 기록'), findsOneWidget);
    });
  });

  group('UnrecordedMealsScreen — 미기록 식단 없음', () {
    testWidgets('빈 상태 "아직 식단 기록이 없어요"가 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(repo: _MockMealRepository(data: const [])),
      );
      await tester.pumpAndSettle();

      expect(find.text('아직 식단 기록이 없어요'), findsOneWidget);
    });

    testWidgets('"증상만 기록하기" 카드는 데이터 없어도 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(repo: _MockMealRepository(data: const [])),
      );
      await tester.pumpAndSettle();

      expect(find.text('증상만 기록하기'), findsOneWidget);
    });

    testWidgets('날짜 섹션·식사 카드는 렌더되지 않는다', (tester) async {
      await tester.pumpWidget(
        _wrap(repo: _MockMealRepository(data: const [])),
      );
      await tester.pumpAndSettle();

      expect(find.text('오늘'), findsNothing);
      expect(find.text('증상 기록하기'), findsNothing);
    });
  });

  group('UnrecordedMealsScreen — 네비게이션', () {
    testWidgets('식사 카드 탭 → /symptom/record push, extra는 SymptomWriteArgs(mealRecordId, mealName)',
        (tester) async {
      Object? capturedExtra;
      GoRouterState? capturedState;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const UnrecordedMealsScreen(),
          ),
          GoRoute(
            path: '/symptom/record',
            builder: (_, state) {
              capturedState = state;
              capturedExtra = state.extra;
              return const Scaffold(body: Text('symptom-record-stub'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            mealRepositoryProvider.overrideWithValue(
              _MockMealRepository(data: _sampleCandidates()),
            ),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('된장찌개'));
      await tester.pumpAndSettle();

      expect(find.text('symptom-record-stub'), findsOneWidget);
      expect(capturedState!.matchedLocation, '/symptom/record');
      expect(capturedExtra, isA<SymptomWriteArgs>());
      final args = capturedExtra! as SymptomWriteArgs;
      expect(args.initialMealRecordId, 'mr-today-1');
      expect(args.initialMealName, '된장찌개');
    });

    testWidgets('"증상만 기록하기" 탭 → /symptom/record push, extra 없음', (tester) async {
      Object? capturedExtra = 'sentinel';

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const UnrecordedMealsScreen(),
          ),
          GoRoute(
            path: '/symptom/record',
            builder: (_, state) {
              capturedExtra = state.extra;
              return const Scaffold(body: Text('symptom-record-stub'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            mealRepositoryProvider.overrideWithValue(
              _MockMealRepository(data: _sampleCandidates()),
            ),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('증상만 기록하기'));
      await tester.pumpAndSettle();

      expect(find.text('symptom-record-stub'), findsOneWidget);
      expect(capturedExtra, isNull);
    });
  });
}
