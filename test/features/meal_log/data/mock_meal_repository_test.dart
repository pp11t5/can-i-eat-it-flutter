import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';

import 'meal_repository_contract.dart';

void main() {
  // -------------------------------------------------------------------------
  // 계약 테스트 — empty 팩토리로 실행
  // -------------------------------------------------------------------------
  group('MockMealRepository — 저장소 계약', () {
    mealRepositoryContract(MockMealRepository.empty);
  });

  // -------------------------------------------------------------------------
  group('empty 팩토리', () {
    test('empty 팩토리는 timeline이 빈 목록이다', () async {
      final repo = MockMealRepository.empty();
      expect(await repo.timeline(DateTime(2026, 6, 17)), isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('seeded 팩토리', () {
    test('seeded 팩토리는 timeline이 2그룹을 반환한다', () async {
      final repo = MockMealRepository.seeded();
      final groups = await repo.timeline(DateTime(2026, 6, 17));
      expect(groups.length, 2);
    });

    test('seeded 팩토리 첫 그룹에 2건의 식사 기록이 있다', () async {
      final repo = MockMealRepository.seeded();
      final groups = await repo.timeline(DateTime(2026, 6, 17));
      expect(groups[0].records.length, 2);
    });

    test('seeded 팩토리 두 번째 그룹에 1건의 식사 기록이 있다', () async {
      final repo = MockMealRepository.seeded();
      final groups = await repo.timeline(DateTime(2026, 6, 17));
      expect(groups[1].records.length, 1);
    });

    test('seeded detail meal-002는 stateRecords 2건을 보유한다', () async {
      final repo = MockMealRepository.seeded();
      final detail = await repo.detail('meal-002');
      expect(detail.stateRecords.length, 2);
    });

    test('seeded detail meal-003은 memo를 보유한다', () async {
      final repo = MockMealRepository.seeded();
      final detail = await repo.detail('meal-003');
      expect(detail.memo, isNotNull);
      expect(detail.memo, isNotEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('delete', () {
    test('delete 후 timeline에서 해당 기록이 사라진다', () async {
      final repo = MockMealRepository.seeded();
      await repo.delete('meal-001');
      final groups = await repo.timeline(DateTime(2026, 6, 17));
      final allMealIds =
          groups.expand((g) => g.records).map((r) => r.mealId).toList();
      expect(allMealIds, isNot(contains('meal-001')));
    });

    test('그룹의 모든 기록을 삭제하면 해당 그룹도 사라진다', () async {
      // group-002에는 meal-003 하나뿐
      final repo = MockMealRepository.seeded();
      await repo.delete('meal-003');
      final groups = await repo.timeline(DateTime(2026, 6, 17));
      expect(
        groups.map((g) => g.mealGroupId),
        isNot(contains('group-002')),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('updateMemo — 빈 문자열은 null로 처리된다', () {
    test('빈 문자열 memo는 null로 저장된다', () async {
      final repo = MockMealRepository.seeded();
      await repo.updateMemo('meal-003', '');
      final detail = await repo.detail('meal-003');
      expect(detail.memo, isNull);
    });
  });

  // -------------------------------------------------------------------------
  group('create — judgedGrade 전달', () {
    test('risk grade로 create한 결과의 judgedGrade는 risk이다', () async {
      final repo = MockMealRepository.empty();
      final record = await repo.create(
        foodExternalId: 'f-coffee',
        grade: VerdictLevel.risk,
      );
      expect(record.judgedGrade, VerdictLevel.risk);
    });

    test('grade 없이 create한 결과의 judgedGrade는 null이다', () async {
      final repo = MockMealRepository.empty();
      final record = await repo.create(foodExternalId: 'f-water');
      expect(record.judgedGrade, isNull);
    });
  });

  // -------------------------------------------------------------------------
  group('detail — 존재하지 않는 mealId는 예외를 던진다', () {
    test('없는 mealId로 detail 호출 시 예외가 발생한다', () async {
      final repo = MockMealRepository.empty();
      await expectLater(
        repo.detail('no-such-meal'),
        throwsA(isA<Exception>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('create → mealGroupId 지정', () {
    test('mealGroupId를 지정하면 같은 그룹에 기록이 추가된다', () async {
      final repo = MockMealRepository.empty();
      final first = await repo.create(foodExternalId: 'f-1');
      await repo.create(
        foodExternalId: 'f-2',
        mealGroupId: first.mealGroupId,
      );
      final groups = await repo.timeline(DateTime(2026, 6, 17));
      final targetGroup = groups.firstWhere(
        (g) => g.mealGroupId == first.mealGroupId,
      );
      expect(targetGroup.records.length, 2);
    });
  });

  // -------------------------------------------------------------------------
  group('timeline — 날짜 인수 무관 동작 (mock은 날짜 무시)', () {
    test('다른 날짜를 넘겨도 동일한 그룹 목록을 반환한다', () async {
      final repo = MockMealRepository.seeded();
      final a = await repo.timeline(DateTime(2026, 6, 17));
      final b = await repo.timeline(DateTime(2026, 1, 1));
      expect(a.length, b.length);
    });
  });

  // -------------------------------------------------------------------------
  group('createByText — 기본 동작', () {
    test('createByText 결과의 mealId는 비어 있지 않다', () async {
      final repo = MockMealRepository.empty();
      final result = await repo.createByText(foodTextInput: '아메리카노');
      expect(result.mealId, isNotEmpty);
    });

    test('createByText 후 detail을 조회할 수 있다', () async {
      final repo = MockMealRepository.empty();
      final result = await repo.createByText(foodTextInput: '아메리카노');
      final detail = await repo.detail(result.mealId);
      expect(detail, isA<MealDetail>());
    });
  });
}
