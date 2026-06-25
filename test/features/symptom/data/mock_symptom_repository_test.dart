import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/data/repositories/mock_symptom_repository.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';

import 'symptom_repository_contract.dart';

void main() {
  // -------------------------------------------------------------------------
  // 계약 테스트 — empty 팩토리로 실행
  // -------------------------------------------------------------------------
  group('MockSymptomRepository — 저장소 계약', () {
    symptomRepositoryContract(MockSymptomRepository.empty);
  });

  // -------------------------------------------------------------------------
  group('empty 팩토리', () {
    test('없는 symptomId로 detail 호출 시 예외 발생', () async {
      final repo = MockSymptomRepository.empty();
      await expectLater(
        repo.detail('no-such-symptom'),
        throwsA(isA<Exception>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('seeded 팩토리', () {
    test('symptom-001은 linkedMeal을 보유한다', () async {
      final repo = MockSymptomRepository.seeded();
      final s = await repo.detail('symptom-001');
      expect(s.linkedMeal, isNotNull);
      expect(s.linkedMeal!.foods.length, 2);
    });

    test('symptom-001은 analysisItems를 보유한다', () async {
      final repo = MockSymptomRepository.seeded();
      final s = await repo.detail('symptom-001');
      expect(s.analysisItems, isNotEmpty);
      expect(s.analysisItems[0].emphasis, isNotEmpty);
    });

    test('symptom-002는 linkedMeal이 null이다', () async {
      final repo = MockSymptomRepository.seeded();
      final s = await repo.detail('symptom-002');
      expect(s.linkedMeal, isNull);
    });

    test('symptom-002는 analysisItems가 빈 목록이다', () async {
      final repo = MockSymptomRepository.seeded();
      final s = await repo.detail('symptom-002');
      expect(s.analysisItems, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('create', () {
    test('create 후 detail로 조회 가능하다', () async {
      final repo = MockSymptomRepository.empty();
      const draft = SymptomDraft(
        symptomState: SymptomState.uncomfortable,
        mealRecordId: 'record-001',
        symptomTypes: [SymptomType.acidReflux, SymptomType.cough],
      );
      final created = await repo.create(draft);
      final fetched = await repo.detail(created.symptomId);
      expect(fetched.symptomState, SymptomState.uncomfortable);
    });

    test('두 번 create 시 각각 다른 symptomId가 생성된다', () async {
      final repo = MockSymptomRepository.empty();
      final a = await repo.create(const SymptomDraft(
        symptomState: SymptomState.good,
        mealRecordId: 'r-1',
      ));
      final b = await repo.create(const SymptomDraft(
        symptomState: SymptomState.normal,
        mealRecordId: 'r-2',
      ));
      expect(a.symptomId, isNot(b.symptomId));
    });
  });

  // -------------------------------------------------------------------------
  group('update', () {
    test('update 후 symptomState가 변경된다', () async {
      final repo = MockSymptomRepository.empty();
      final created = await repo.create(const SymptomDraft(
        symptomState: SymptomState.good,
        mealRecordId: 'record-001',
      ));
      await repo.update(
        created.symptomId,
        SymptomDraft(
          symptomState: SymptomState.severe,
          mealRecordId: 'record-001',
          occurredAt: DateTime(2026, 6, 17, 14, 30),
        ),
      );
      final fetched = await repo.detail(created.symptomId);
      expect(fetched.symptomState, SymptomState.severe);
    });

    test('update 후 symptomTypes가 변경된다', () async {
      final repo = MockSymptomRepository.empty();
      final created = await repo.create(const SymptomDraft(
        symptomState: SymptomState.normal,
        mealRecordId: 'record-001',
        symptomTypes: [SymptomType.cough],
      ));
      await repo.update(
        created.symptomId,
        SymptomDraft(
          symptomState: SymptomState.normal,
          mealRecordId: 'record-001',
          symptomTypes: const [SymptomType.acidReflux, SymptomType.chestTightness],
          occurredAt: DateTime(2026, 6, 17),
        ),
      );
      final fetched = await repo.detail(created.symptomId);
      expect(fetched.symptomTypes, contains(SymptomType.acidReflux));
      expect(fetched.symptomTypes, contains(SymptomType.chestTightness));
      expect(fetched.symptomTypes, isNot(contains(SymptomType.cough)));
    });
  });

  // -------------------------------------------------------------------------
  group('delete', () {
    test('delete 후 detail 호출 시 예외 발생', () async {
      final repo = MockSymptomRepository.empty();
      final created = await repo.create(const SymptomDraft(
        symptomState: SymptomState.good,
        mealRecordId: 'record-001',
      ));
      await repo.delete(created.symptomId);
      await expectLater(
        repo.detail(created.symptomId),
        throwsA(isA<Exception>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('updateMemo', () {
    test('updateMemo null도 예외 없이 완료된다', () async {
      final repo = MockSymptomRepository.empty();
      final created = await repo.create(const SymptomDraft(
        symptomState: SymptomState.normal,
        mealRecordId: 'record-001',
      ));
      await expectLater(repo.updateMemo(created.symptomId, null), completes);
    });

    test('updateMemo 문자열도 예외 없이 완료된다', () async {
      final repo = MockSymptomRepository.empty();
      final created = await repo.create(const SymptomDraft(
        symptomState: SymptomState.normal,
        mealRecordId: 'record-001',
      ));
      await expectLater(
        repo.updateMemo(created.symptomId, '메모입니다'),
        completes,
      );
    });
  });
}
