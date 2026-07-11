import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_meal_pick_screen.dart';

// ---------------------------------------------------------------------------
// 목 MealRepository
// ---------------------------------------------------------------------------

class _MockMealRepository implements MealRepository {
  final List<MealCandidatesDay> candidateData;

  _MockMealRepository({List<MealCandidatesDay>? data})
      : candidateData = data ??
            [
              const MealCandidatesDay(
                date: '2026-06-25',
                meals: [
                  MealCandidate(
                    mealRecordId: 'mr-1',
                    representativeFoodName: '된장찌개',
                    eatenAt: '2026-06-25T12:00:00+09:00',
                  ),
                  MealCandidate(
                    mealRecordId: 'mr-2',
                    representativeFoodName: '비빔밥',
                    otherFoodCount: 2,
                    eatenAt: '2026-06-25T18:00:00+09:00',
                  ),
                ],
              ),
            ];

  @override
  Future<List<MealCandidatesDay>> candidates() async => candidateData;

  @override
  Future<List<TimelineItem>> timeline(DateTime date) async => [];
  @override
  Future<List<WeeklyDay>> weekly(DateTime date) async => [];
  @override
  Future<MealFood> appendFood({
    required String foodExternalId,
    DateTime? eatenAt,
    String? mealRecordId,
  }) async => throw UnimplementedError();
  @override
  Future<MealFood> appendFoodByText({
    required String foodTextInput,
    DateTime? eatenAt,
    String? mealRecordId,
  }) async => throw UnimplementedError();
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
// 헬퍼
// ---------------------------------------------------------------------------

Widget _wrap({String? initialMealRecordId, _MockMealRepository? repo}) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(repo ?? _MockMealRepository()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: SymptomMealPickScreen(initialMealRecordId: initialMealRecordId),
    ),
  );
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('SymptomMealPickScreen — 렌더링', () {
    testWidgets('AppBar 타이틀 "원인 식사" 표시', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('원인 식사'), findsOneWidget);
    });

    testWidgets('헤더 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('어떤 식사와\n관련된 증상인가요?'), findsOneWidget);
      expect(find.text('하루 동안 먹은 식사 중 선택해주세요'), findsOneWidget);
    });

    testWidgets('"선택 안 할래요" 카드가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('선택 안 할래요'), findsOneWidget);
      expect(find.text('모르겠어요, 식사와 상관없어요'), findsOneWidget);
    });

    testWidgets('candidates 로드 후 식사 목록이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('된장찌개'), findsOneWidget);
    });

    testWidgets('otherFoodCount > 0이면 "외 N개 음식" 표시', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('비빔밥 외 2개 음식'), findsOneWidget);
    });

    testWidgets('"확인" 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('확인'), findsOneWidget);
    });
  });

  group('SymptomMealPickScreen — 선택', () {
    testWidgets('초기에 "선택 안 할래요"가 선택 상태', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      // radio_button_checked 아이콘이 1개 존재 ("선택 안 할래요")
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    });

    testWidgets('식사 카드 탭 시 해당 카드 선택됨', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await tester.tap(find.text('된장찌개'));
      await tester.pumpAndSettle();
      // 된장찌개 선택 후 radio_button_checked가 된장찌개 카드에 있음
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    });

    testWidgets('"선택 안 할래요" 탭 시 다른 선택 해제', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      // 된장찌개 선택 후
      await tester.tap(find.text('된장찌개'));
      await tester.pumpAndSettle();
      // "선택 안 할래요" 탭
      await tester.tap(find.text('선택 안 할래요'));
      await tester.pumpAndSettle();
      // "선택 안 할래요"만 선택됨
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
    });

    testWidgets('initialMealRecordId 주입 시 해당 식사 프리선택', (tester) async {
      await tester.pumpWidget(_wrap(initialMealRecordId: 'mr-1'));
      await tester.pumpAndSettle();
      // mr-1(된장찌개)이 선택됨 — radio_button_checked 1개
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_unchecked), findsWidgets);
    });
  });

  group('SymptomMealPickScreen — 확인 결과 반환', () {
    testWidgets('"선택 안 할래요" 선택 후 "확인" → cleared 신호 반환(bare null 아님)',
        (tester) async {
      MealPickResult? result;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            mealRepositoryProvider
                .overrideWithValue(_MockMealRepository()),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    result = await Navigator.of(context)
                        .push<MealPickResult?>(
                      MaterialPageRoute(
                        builder: (_) =>
                            const SymptomMealPickScreen(),
                      ),
                    );
                  },
                  child: const Text('열기'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();
      expect(find.text('원인 식사'), findsOneWidget);

      // "선택 안 할래요"는 기본 선택 상태
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      // bare null(단순 dismiss)이 아니라 명시적 cleared 신호여야 한다.
      expect(result, isNotNull);
      expect(result!.cleared, isTrue);
      expect(result!.mealRecordId, isNull);
    });

    testWidgets('AppBar 뒤로가기(단순 dismiss) → bare null 반환', (tester) async {
      MealPickResult? result = const MealPickResult(
        mealRecordId: 'sentinel',
        displayName: 'sentinel',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            mealRepositoryProvider
                .overrideWithValue(_MockMealRepository()),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    result = await Navigator.of(context)
                        .push<MealPickResult?>(
                      MaterialPageRoute(
                        builder: (_) =>
                            const SymptomMealPickScreen(),
                      ),
                    );
                  },
                  child: const Text('열기'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();
      expect(find.text('원인 식사'), findsOneWidget);

      // AppBar 뒤로가기 아이콘 탭 (선택 상태 변경 없이 dismiss)
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets('식사 선택 후 "확인" → MealPickResult 반환', (tester) async {
      MealPickResult? result;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            mealRepositoryProvider
                .overrideWithValue(_MockMealRepository()),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    result = await Navigator.of(context)
                        .push<MealPickResult?>(
                      MaterialPageRoute(
                        builder: (_) =>
                            const SymptomMealPickScreen(),
                      ),
                    );
                  },
                  child: const Text('열기'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('된장찌개'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.mealRecordId, 'mr-1');
      expect(result!.displayName, '된장찌개');
    });
  });
}
