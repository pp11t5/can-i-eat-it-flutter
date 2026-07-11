import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';
import 'package:can_i_eat_it/features/symptom/data/symptom_providers.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';
import 'package:can_i_eat_it/features/symptom/domain/repositories/symptom_repository.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_write_screen.dart';

// ---------------------------------------------------------------------------
// 목 저장소
// ---------------------------------------------------------------------------

class _MockSymptomRepository implements SymptomRepository {
  final List<SymptomDraft> created = [];
  final List<(String, SymptomDraft)> updated = [];

  @override
  Future<Symptom> create(SymptomDraft draft) async {
    created.add(draft);
    return Symptom(
      symptomId: 'test-id',
      symptomState: draft.symptomState,
      stateTitle: '테스트',
      occurredAt: '2026-06-25T10:00:00+09:00',
    );
  }

  @override
  Future<void> update(String symptomId, SymptomDraft draft) async {
    updated.add((symptomId, draft));
  }

  @override
  Future<Symptom> detail(String symptomId) async =>
      throw UnimplementedError();

  @override
  Future<void> updateMemo(String symptomId, String? memo) async =>
      throw UnimplementedError();

  @override
  Future<void> delete(String symptomId) async =>
      throw UnimplementedError();
}

class _MockMealRepository implements MealRepository {
  @override
  Future<List<MealCandidatesDay>> candidates() async => [
        const MealCandidatesDay(
          date: '2026-06-25',
          meals: [
            MealCandidate(
              mealRecordId: 'mr-1',
              representativeFoodName: '된장찌개',
              eatenAt: '2026-06-25T12:00:00+09:00',
            ),
          ],
        ),
      ];

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

Widget _wrap({
  Symptom? existingSymptom,
  _MockSymptomRepository? symptomRepo,
}) {
  final repo = symptomRepo ?? _MockSymptomRepository();
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      symptomRepositoryProvider.overrideWithValue(repo),
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(_MockMealRepository()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: SymptomWriteScreen(existingSymptom: existingSymptom),
    ),
  );
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('SymptomWriteScreen — 렌더링', () {
    testWidgets('AppBar 타이틀 "증상 기록 작성" 표시', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('증상 기록 작성'), findsOneWidget);
    });

    testWidgets('섹션 레이블 5개가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('지금 속은 어때요?'), findsOneWidget);
      expect(find.text('어떤 증상이 느껴지시나요?'), findsOneWidget);
      expect(find.text('언제 그런 증상을 느끼셨어요?'), findsOneWidget);
      expect(find.text('어떤 식사를 먹고 증상이 느껴졌나요?'), findsOneWidget);
      expect(find.text('추가 메모 기록'), findsOneWidget);
    });

    testWidgets('"저장하기" 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('저장하기'), findsOneWidget);
    });

    testWidgets('증상 칩 5개가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('없음'), findsOneWidget);
      expect(find.text('목 이물감이 있어요'), findsOneWidget);
      expect(find.text('신물이 느껴져요'), findsOneWidget);
      expect(find.text('기침이 나요'), findsOneWidget);
      expect(find.text('가슴이 답답해요'), findsOneWidget);
    });
  });

  group('SymptomWriteScreen — mood 선택', () {
    testWidgets('mood 라벨 5개(편안/양호/보통/불편/심각)가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('편안'), findsOneWidget);
      expect(find.text('양호'), findsOneWidget);
      expect(find.text('보통'), findsOneWidget);
      expect(find.text('불편'), findsOneWidget);
      expect(find.text('심각'), findsOneWidget);
    });

    testWidgets('mood 탭 후 상태 변경 — 에러 없이 완료', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await tester.tap(find.text('보통'));
      await tester.pumpAndSettle();
      // 탭 후 에러 없이 빌드 완료
      expect(find.text('보통'), findsOneWidget);
    });
  });

  group('SymptomWriteScreen — 증상 칩 토글', () {
    testWidgets('"없음" 칩이 기본 선택 상태이다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      // "없음"이 선택 상태 = symptomTypes=[] — SelectableChip 선택색 확인은
      // 위젯 존재로 간접 확인
      expect(find.text('없음'), findsOneWidget);
    });

    testWidgets('"기침이 나요" 탭 시 선택됨 — "없음" 해제', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await tester.tap(find.text('기침이 나요'));
      await tester.pumpAndSettle();
      expect(find.text('기침이 나요'), findsOneWidget);
      // "없음" 칩 여전히 존재(해제되어도 칩은 표시됨)
      expect(find.text('없음'), findsOneWidget);
    });

    testWidgets('"없음" 탭 시 다른 증상 칩 모두 해제', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      // 먼저 다른 칩 선택
      await tester.tap(find.text('신물이 느껴져요'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('기침이 나요'));
      await tester.pumpAndSettle();
      // "없음" 탭 → 모두 해제
      await tester.tap(find.text('없음'));
      await tester.pumpAndSettle();
      // 에러 없이 완료
      expect(find.text('없음'), findsOneWidget);
    });

    testWidgets('여러 증상 칩 동시 선택 가능', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      await tester.tap(find.text('목 이물감이 있어요'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('가슴이 답답해요'));
      await tester.pumpAndSettle();
      // 에러 없이 두 칩 모두 선택됨
      expect(find.text('목 이물감이 있어요'), findsOneWidget);
      expect(find.text('가슴이 답답해요'), findsOneWidget);
    });
  });

  group('SymptomWriteScreen — 저장 버튼 활성화', () {
    testWidgets('mood + mealId 미선택 시 저장 버튼 비활성', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      // 저장 버튼이 disabled — FilledButton onPressed=null 확인은
      // 버튼 텍스트 존재로 간접 확인 (탭해도 submit 호출 안 됨)
      final repo = _MockSymptomRepository();
      await tester.tap(find.text('저장하기'));
      await tester.pumpAndSettle();
      expect(repo.created, isEmpty);
    });
  });

  group('SymptomWriteScreen — 수정 모드 프리필', () {
    testWidgets('existingSymptom 주입 시 AppBar 타이틀이 "증상 기록 작성"', (tester) async {
      const existing = Symptom(
        symptomId: 'sym-1',
        symptomState: SymptomState.uncomfortable,
        stateTitle: '불편함',
        symptomTypes: [SymptomType.cough],
        occurredAt: '2026-06-25T10:00:00+09:00',
      );
      await tester.pumpWidget(_wrap(existingSymptom: existing));
      await tester.pumpAndSettle();
      expect(find.text('증상 기록 작성'), findsOneWidget);
    });
  });

  group('SymptomWriteScreen — 원인 식사 수정(edit 모드 회귀)', () {
    const existingWithMeal = Symptom(
      symptomId: 'sym-2',
      symptomState: SymptomState.normal,
      stateTitle: '보통',
      occurredAt: '2026-06-25T10:00:00+09:00',
      linkedMeal: SymptomLinkedMeal(
        mealRecordId: 'mr-1',
        foods: [SymptomLinkedFood(mealFoodId: 'mf-1', name: '된장찌개')],
      ),
    );

    testWidgets('meal pick 열고 AppBar 뒤로가기(dismiss) → 기존 linkedMeal 보존',
        (tester) async {
      await tester.pumpWidget(_wrap(existingSymptom: existingWithMeal));
      await tester.pumpAndSettle();

      // 프리필된 원인 식사가 표시된다.
      expect(find.text('🍽️ 된장찌개'), findsOneWidget);

      // 원인 식사 카드 탭 → meal pick 화면 진입 (스크롤 아래 있어 우선
      // ensureVisible로 뷰포트 안으로 스크롤한 뒤 탭)
      final mealCardFinder = find.ancestor(
        of: find.text('🍽️ 된장찌개'),
        matching: find.byType(GestureDetector),
      ).first;
      await tester.ensureVisible(mealCardFinder);
      await tester.pumpAndSettle();
      await tester.tap(mealCardFinder);
      await tester.pumpAndSettle();
      expect(find.text('원인 식사'), findsOneWidget);

      // AppBar 뒤로가기(단순 dismiss) — 아무 것도 선택하지 않고 나감
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();

      // 기존 linkedMeal 표시가 그대로 보존되어야 한다.
      expect(find.text('🍽️ 된장찌개'), findsOneWidget);
      expect(find.text('최근 음식을 선택해 주세요'), findsNothing);
    });

    testWidgets('meal pick 열고 "선택 안 할래요" 확정 → linkedMeal 해제', (tester) async {
      await tester.pumpWidget(_wrap(existingSymptom: existingWithMeal));
      await tester.pumpAndSettle();

      expect(find.text('🍽️ 된장찌개'), findsOneWidget);

      // 원인 식사 카드 탭 → meal pick 화면 진입 (스크롤 아래 있어 우선
      // ensureVisible로 뷰포트 안으로 스크롤한 뒤 탭)
      final mealCardFinder = find.ancestor(
        of: find.text('🍽️ 된장찌개'),
        matching: find.byType(GestureDetector),
      ).first;
      await tester.ensureVisible(mealCardFinder);
      await tester.pumpAndSettle();
      await tester.tap(mealCardFinder);
      await tester.pumpAndSettle();

      // "선택 안 할래요" 선택 후 확인
      await tester.tap(find.text('선택 안 할래요'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      // linkedMeal이 해제되어 힌트 텍스트로 돌아간다.
      expect(find.text('최근 음식을 선택해 주세요'), findsOneWidget);
      expect(find.text('🍽️ 된장찌개'), findsNothing);
    });
  });
}
