import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';
import 'package:can_i_eat_it/features/symptom/domain/repositories/symptom_repository.dart';

/// [SymptomRepository] 계약 테스트 스위트.
///
/// Mock·실 구현 모두 이 계약을 통과해야 한다.
///
/// 사용법:
/// ```dart
/// symptomRepositoryContract(MockSymptomRepository.empty);
/// ```
void symptomRepositoryContract(
  SymptomRepository Function() create,
) {
  // -------------------------------------------------------------------------
  group('create — 기본 동작', () {
    test('create는 Symptom을 반환한다', () async {
      final repo = create();
      final result = await repo.create(_draftBasic());
      expect(result, isA<Symptom>());
    });

    test('create 결과의 symptomId는 비어 있지 않다', () async {
      final repo = create();
      final result = await repo.create(_draftBasic());
      expect(result.symptomId, isNotEmpty);
    });

    test('create 결과의 symptomState가 입력과 일치한다', () async {
      final repo = create();
      final result = await repo.create(_draftBasic());
      expect(result.symptomState, SymptomState.uncomfortable);
    });
  });

  // -------------------------------------------------------------------------
  group('detail — 기본 동작', () {
    test('create 후 detail을 호출하면 Symptom을 반환한다', () async {
      final repo = create();
      final created = await repo.create(_draftBasic());
      final fetched = await repo.detail(created.symptomId);
      expect(fetched, isA<Symptom>());
    });

    test('create 후 detail의 symptomId가 일치한다', () async {
      final repo = create();
      final created = await repo.create(_draftBasic());
      final fetched = await repo.detail(created.symptomId);
      expect(fetched.symptomId, created.symptomId);
    });
  });

  // -------------------------------------------------------------------------
  group('update — 기본 동작', () {
    test('update는 Future<void>를 반환한다', () async {
      final repo = create();
      final created = await repo.create(_draftBasic());
      await expectLater(
        repo.update(created.symptomId, _draftForUpdate()),
        completes,
      );
    });

    test('update 후 detail의 symptomState가 변경된다', () async {
      final repo = create();
      final created = await repo.create(_draftBasic());
      await repo.update(created.symptomId, _draftForUpdate());
      final fetched = await repo.detail(created.symptomId);
      expect(fetched.symptomState, SymptomState.severe);
    });
  });

  // -------------------------------------------------------------------------
  group('updateMemo — 기본 동작', () {
    test('updateMemo는 Future<void>를 반환한다', () async {
      final repo = create();
      final created = await repo.create(_draftBasic());
      await expectLater(
        repo.updateMemo(created.symptomId, '메모 내용'),
        completes,
      );
    });

    test('updateMemo null도 Future<void>를 반환한다', () async {
      final repo = create();
      final created = await repo.create(_draftBasic());
      await expectLater(
        repo.updateMemo(created.symptomId, null),
        completes,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('delete — 기본 동작', () {
    test('delete는 Future<void>를 반환한다', () async {
      final repo = create();
      final created = await repo.create(_draftBasic());
      await expectLater(repo.delete(created.symptomId), completes);
    });

    test('delete 후 detail 호출 시 예외가 발생한다', () async {
      final repo = create();
      final created = await repo.create(_draftBasic());
      await repo.delete(created.symptomId);
      await expectLater(
        repo.detail(created.symptomId),
        throwsA(isA<Exception>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('update — occurredAt 필수 반영', () {
    test('update draft의 occurredAt이 비-null이어야 한다 (호출자 계약)', () async {
      final repo = create();
      final created = await repo.create(_draftBasic());
      // update 전용 draft: occurredAt 필수.
      final updateDraft = _draftForUpdate();
      expect(updateDraft.occurredAt, isNotNull,
          reason: 'update 시 occurredAt은 호출자가 비-null을 보장해야 한다');
      await expectLater(
        repo.update(created.symptomId, updateDraft),
        completes,
      );
    });
  });
}

// ---------------------------------------------------------------------------
// 공용 픽스처 헬퍼
// ---------------------------------------------------------------------------

SymptomDraft _draftBasic() => const SymptomDraft(
      symptomState: SymptomState.uncomfortable,
      mealRecordId: 'record-001',
      symptomTypes: [SymptomType.acidReflux],
      occurredAt: null,
    );

SymptomDraft _draftForUpdate() => SymptomDraft(
      symptomState: SymptomState.severe,
      mealRecordId: 'record-001',
      symptomTypes: const [SymptomType.cough],
      occurredAt: DateTime(2026, 6, 17, 14, 30, 0),
    );
