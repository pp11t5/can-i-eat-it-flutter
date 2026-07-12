import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';
import 'package:can_i_eat_it/features/symptom/data/symptom_providers.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';
import 'package:can_i_eat_it/features/symptom/domain/repositories/symptom_repository.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_detail_screen.dart';

// ---------------------------------------------------------------------------
// 목 저장소
// ---------------------------------------------------------------------------

class _MockSymptomRepository implements SymptomRepository {
  _MockSymptomRepository({required this.symptom});

  final Symptom symptom;
  final List<String> deletedIds = [];

  @override
  Future<Symptom> detail(String symptomId) async => symptom;

  @override
  Future<void> delete(String symptomId) async {
    deletedIds.add(symptomId);
  }

  @override
  Future<Symptom> create(SymptomDraft draft) async =>
      throw UnimplementedError();

  @override
  Future<void> update(String symptomId, SymptomDraft draft) async =>
      throw UnimplementedError();

  @override
  Future<void> updateMemo(String symptomId, String? memo) async =>
      throw UnimplementedError();
}

class _MockMealRepository implements MealRepository {
  @override
  Future<List<MealCandidatesDay>> candidates() async => [];

  @override
  Future<MealRecord> mealDetail(String mealRecordId) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteMeal(String mealRecordId) async =>
      throw UnimplementedError();

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
  Future<MealFood> foodDetail(String mealFoodId) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteFood(String mealFoodId) async =>
      throw UnimplementedError();

  @override
  Future<List<TimelineItem>> timeline(DateTime date) async => [];

  @override
  Future<List<WeeklyDay>> weekly(DateTime date) async => [];
}

// ---------------------------------------------------------------------------
// 샘플 데이터
// ---------------------------------------------------------------------------

const _kOccurredAt = '2026-06-17T14:30:00+09:00';

const _symptomWithMealAndAnalysis = Symptom(
  symptomId: 'symptom-001',
  symptomState: SymptomState.uncomfortable,
  stateTitle: '조금 불편해요',
  symptomTypes: [SymptomType.acidReflux, SymptomType.cough],
  occurredAt: _kOccurredAt,
  linkedMeal: SymptomLinkedMeal(
    mealRecordId: 'record-001',
    foods: [
      SymptomLinkedFood(
        mealFoodId: 'food-001',
        name: '된장찌개',
        category: '한식',
      ),
      SymptomLinkedFood(
        mealFoodId: 'food-002',
        name: '커피',
        category: '음료',
      ),
    ],
  ),
  analysisItems: [
    SymptomAnalysisItem(
      emphasis: '카페인이 위산을 자극해요',
      body: '커피는 하부식도괄약근을 이완시켜 역류를 악화할 수 있어요.',
    ),
  ],
);

const _symptomNoMealNoAnalysis = Symptom(
  symptomId: 'symptom-002',
  symptomState: SymptomState.good,
  stateTitle: '컨디션이 좋아요',
  symptomTypes: [],
  occurredAt: _kOccurredAt,
  linkedMeal: null,
  analysisItems: [],
);

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

/// 최소 GoRouter: /symptom/:id → SymptomDetailScreen, /symptom/record → stub.
/// [afterMealMinutes] 를 직접 위젯에 주입하기 위해 builder에서 override 한다.
GoRouter _testRouter({
  required String symptomId,
  int? afterMealMinutes,
}) =>
    GoRouter(
      initialLocation: '/symptom/$symptomId',
      routes: [
        GoRoute(
          path: '/symptom/record',
          builder: (_, __) => const Scaffold(body: Text('write-stub')),
        ),
        GoRoute(
          path: '/symptom/:symptomId',
          builder: (_, state) {
            final id = state.pathParameters['symptomId']!;
            return SymptomDetailScreen(
              symptomId: id,
              afterMealMinutes: afterMealMinutes,
            );
          },
        ),
      ],
    );

Widget _wrap({
  required Symptom symptom,
  required String symptomId,
  int? afterMealMinutes,
  List<Override> extraOverrides = const [],
}) {
  final repo = _MockSymptomRepository(symptom: symptom);
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      symptomRepositoryProvider.overrideWithValue(repo),
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(_MockMealRepository()),
      ...extraOverrides,
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: _testRouter(
        symptomId: symptomId,
        afterMealMinutes: afterMealMinutes,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  group('SymptomDetailScreen — linkedMeal 有 + analysis 有', () {
    testWidgets('증상 유형 한국어 join 렌더', (tester) async {
      await tester.pumpWidget(
        _wrap(
          symptom: _symptomWithMealAndAnalysis,
          symptomId: 'symptom-001',
        ),
      );
      await tester.pumpAndSettle();

      // 증상 유형 join (역류, 기침)
      expect(find.text('역류, 기침'), findsOneWidget);
    });

    testWidgets('linkedMeal 식사 카드 렌더 (된장찌개 외 1개)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          symptom: _symptomWithMealAndAnalysis,
          symptomId: 'symptom-001',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('된장찌개 외 1개'), findsOneWidget);
    });

    testWidgets('AI 분석 섹션 렌더 (emphasis 굵게)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          symptom: _symptomWithMealAndAnalysis,
          symptomId: 'symptom-001',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('카페인이 위산을 자극해요'), findsOneWidget);
      expect(
        find.text('커피는 하부식도괄약근을 이완시켜 역류를 악화할 수 있어요.'),
        findsOneWidget,
      );
    });

    testWidgets('afterMealMinutes 인자 있으면 "식후 N분" 부제에 포함', (tester) async {
      await tester.pumpWidget(
        _wrap(
          symptom: _symptomWithMealAndAnalysis,
          symptomId: 'symptom-001',
          afterMealMinutes: 30,
        ),
      );
      await tester.pumpAndSettle();

      // 부제에 "식후 30분" 포함
      expect(
        find.textContaining('식후 30분'),
        findsOneWidget,
      );
    });

    testWidgets('afterMealMinutes 없으면 "식후" 문구 미노출', (tester) async {
      await tester.pumpWidget(
        _wrap(
          symptom: _symptomWithMealAndAnalysis,
          symptomId: 'symptom-001',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('식후'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  group('SymptomDetailScreen — linkedMeal 無 + analysis 無', () {
    testWidgets('symptomTypes 비어있으면 "특별한 불편이 없었어요" 렌더', (tester) async {
      await tester.pumpWidget(
        _wrap(
          symptom: _symptomNoMealNoAnalysis,
          symptomId: 'symptom-002',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('특별한 불편이 없었어요'), findsOneWidget);
    });

    testWidgets('linkedMeal null → "연결된 음식이 없어요" 렌더', (tester) async {
      await tester.pumpWidget(
        _wrap(
          symptom: _symptomNoMealNoAnalysis,
          symptomId: 'symptom-002',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('연결된 음식이 없어요'), findsOneWidget);
    });

    testWidgets('analysis 빈 목록 → AI 분석 섹션 미표시', (tester) async {
      await tester.pumpWidget(
        _wrap(
          symptom: _symptomNoMealNoAnalysis,
          symptomId: 'symptom-002',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('AI 맞춤 분석이에요'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  group('SymptomDetailScreen — 삭제 다이얼로그', () {
    testWidgets('삭제 버튼 탭 → 다이얼로그 표시', (tester) async {
      await tester.pumpWidget(
        _wrap(
          symptom: _symptomWithMealAndAnalysis,
          symptomId: 'symptom-001',
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('기록 삭제하기'));
      await tester.pumpAndSettle();

      expect(find.text('기록을 삭제하시겠어요?'), findsOneWidget);
      // showConfirmModal: Primary(채움 green)='취소하기', Secondary(빨강 텍스트)='삭제하기'.
      expect(find.text('취소하기'), findsOneWidget);
      expect(find.text('삭제하기'), findsOneWidget);
    });

    testWidgets('다이얼로그 취소 → 다이얼로그 닫힘', (tester) async {
      await tester.pumpWidget(
        _wrap(
          symptom: _symptomWithMealAndAnalysis,
          symptomId: 'symptom-001',
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('기록 삭제하기'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('취소하기'));
      await tester.pumpAndSettle();

      expect(find.text('기록을 삭제하시겠어요?'), findsNothing);
    });

    testWidgets('다이얼로그 삭제 확인 → repository.delete 호출', (tester) async {
      late _MockSymptomRepository capturedRepo;

      await tester.pumpWidget(
        ProviderScope(
          // ignore: scoped_providers_should_specify_dependencies
          overrides: [
            symptomRepositoryProvider.overrideWith((ref) {
              capturedRepo = _MockSymptomRepository(
                symptom: _symptomWithMealAndAnalysis,
              );
              return capturedRepo;
            }),
            mealRepositoryProvider
                .overrideWithValue(_MockMealRepository()),
          ],
          child: MaterialApp.router(
            theme: AppTheme.light,
            routerConfig: _testRouter(symptomId: 'symptom-001'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('기록 삭제하기'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('삭제하기'));
      // showAppToast 가 2.5s 타이머를 생성하므로 pumpAndSettle 대신 pump 사용.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(capturedRepo.deletedIds, contains('symptom-001'));
    });

    testWidgets('취소하기 탭 → repository.delete 미호출 (매핑 반전 회귀 가드)',
        (tester) async {
      late _MockSymptomRepository capturedRepo;

      await tester.pumpWidget(
        ProviderScope(
          // ignore: scoped_providers_should_specify_dependencies
          overrides: [
            symptomRepositoryProvider.overrideWith((ref) {
              capturedRepo = _MockSymptomRepository(
                symptom: _symptomWithMealAndAnalysis,
              );
              return capturedRepo;
            }),
            mealRepositoryProvider.overrideWithValue(_MockMealRepository()),
          ],
          child: MaterialApp.router(
            theme: AppTheme.light,
            routerConfig: _testRouter(symptomId: 'symptom-001'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('기록 삭제하기'));
      await tester.pumpAndSettle();

      // Primary(green) '취소하기' 탭 → ConfirmModalAction.primary → 삭제 안 함.
      // 매핑이 반전돼 취소가 삭제를 트리거하면 이 단언이 실패한다(안전 가드).
      await tester.tap(find.text('취소하기'));
      await tester.pumpAndSettle();

      expect(capturedRepo.deletedIds, isEmpty);
      expect(find.text('기록을 삭제하시겠어요?'), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  group('SymptomDetailScreen — 수정 버튼', () {
    testWidgets('수정하기 탭 → /symptom/record 라우트로 이동', (tester) async {
      await tester.pumpWidget(
        _wrap(
          symptom: _symptomWithMealAndAnalysis,
          symptomId: 'symptom-001',
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('수정하기'));
      await tester.pumpAndSettle();

      // write-stub 화면이 나타나야 함
      expect(find.text('write-stub'), findsOneWidget);
    });
  });
}
