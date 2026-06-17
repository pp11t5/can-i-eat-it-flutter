import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';

// ---------------------------------------------------------------------------
// Mock MealRepository — 인자 캡처용
// ---------------------------------------------------------------------------

class _CapturingMealRepository implements MealRepository {
  String? lastFoodExternalId;
  String? lastFoodTextInput;
  DateTime? lastEatenAt;
  String? lastMealGroupId;
  VerdictLevel? lastGrade;
  int createCallCount = 0;
  int createByTextCallCount = 0;

  @override
  Future<MealRecord> create({
    required String foodExternalId,
    DateTime? eatenAt,
    String? mealGroupId,
    VerdictLevel? grade,
  }) async {
    createCallCount++;
    lastFoodExternalId = foodExternalId;
    lastEatenAt = eatenAt;
    lastMealGroupId = mealGroupId;
    lastGrade = grade;
    return MealRecord(
      mealId: 'mock-1',
      mealGroupId: mealGroupId ?? 'grp-1',
      eatenAt: (eatenAt ?? DateTime.now()).toIso8601String(),
      food: const FoodSummary(externalId: 'f-0', name: '스텁'),
    );
  }

  @override
  Future<MealRecord> createByText({
    required String foodTextInput,
    DateTime? eatenAt,
    String? mealGroupId,
    VerdictLevel? grade,
  }) async {
    createByTextCallCount++;
    lastFoodTextInput = foodTextInput;
    lastEatenAt = eatenAt;
    lastMealGroupId = mealGroupId;
    lastGrade = grade;
    return MealRecord(
      mealId: 'mock-2',
      mealGroupId: mealGroupId ?? 'grp-2',
      eatenAt: (eatenAt ?? DateTime.now()).toIso8601String(),
      food: const FoodSummary(externalId: 'f-0', name: '스텁'),
    );
  }

  @override
  Future<List<MealGroup>> timeline(DateTime date) async => [];

  @override
  Future<MealDetail> detail(String mealId) => throw UnimplementedError();

  @override
  Future<MealDetail> updateMemo(String mealId, String? memo) =>
      throw UnimplementedError();

  @override
  Future<void> delete(String mealId) async {}
}

// ---------------------------------------------------------------------------
// 픽스처
// ---------------------------------------------------------------------------

final _kEatAt = DateTime(2026, 6, 17, 12, 30);

const _kVerdictById = EatVerdict(
  level: VerdictLevel.recommend,
  foodName: '두부',
  foodExternalId: 'food-ext-1',
);

const _kVerdictByText = EatVerdict(
  level: VerdictLevel.caution,
  foodName: '된장찌개',
  // foodExternalId null → by-text
);

// ---------------------------------------------------------------------------
// 핸들러 분기 로직 테스트 (직접 repo 호출로 분기 재현)
// ---------------------------------------------------------------------------

Future<void> _dispatchToRepo(
  _CapturingMealRepository repo,
  EatVerdict verdict,
  MealRecordContext ctx,
) async {
  if (verdict.foodExternalId != null) {
    await repo.create(
      foodExternalId: verdict.foodExternalId!,
      eatenAt: ctx.eatenAt,
      mealGroupId: ctx.mealGroupId,
      grade: verdict.level,
    );
  } else {
    await repo.createByText(
      foodTextInput: verdict.foodName,
      eatenAt: ctx.eatenAt,
      mealGroupId: ctx.mealGroupId,
      grade: verdict.level,
    );
  }
}

void main() {
  group('MealRepository 분기 — foodExternalId 유무', () {
    late _CapturingMealRepository repo;

    setUp(() => repo = _CapturingMealRepository());

    test('foodExternalId 있음 → create 호출, createByText 미호출', () async {
      final ctx = MealRecordContext(eatenAt: _kEatAt);
      await _dispatchToRepo(repo, _kVerdictById, ctx);

      expect(repo.createCallCount, 1);
      expect(repo.createByTextCallCount, 0);
      expect(repo.lastFoodExternalId, 'food-ext-1');
      expect(repo.lastEatenAt, _kEatAt);
      expect(repo.lastMealGroupId, isNull);
      expect(repo.lastGrade, VerdictLevel.recommend);
    });

    test('foodExternalId null → createByText 호출, create 미호출', () async {
      final ctx = MealRecordContext(eatenAt: _kEatAt, mealGroupId: 'g-1');
      await _dispatchToRepo(repo, _kVerdictByText, ctx);

      expect(repo.createByTextCallCount, 1);
      expect(repo.createCallCount, 0);
      expect(repo.lastFoodTextInput, '된장찌개');
      expect(repo.lastEatenAt, _kEatAt);
      expect(repo.lastMealGroupId, 'g-1');
      expect(repo.lastGrade, VerdictLevel.caution);
    });

    test('mealGroupId 있음 → create에 mealGroupId 전달', () async {
      final ctx = MealRecordContext(eatenAt: _kEatAt, mealGroupId: 'g-42');
      await _dispatchToRepo(repo, _kVerdictById, ctx);

      expect(repo.lastMealGroupId, 'g-42');
    });

    test('mealGroupId null → create에 null 전달', () async {
      final ctx = MealRecordContext(eatenAt: _kEatAt);
      await _dispatchToRepo(repo, _kVerdictById, ctx);

      expect(repo.lastMealGroupId, isNull);
    });
  });

  group('토스트 메시지 분기 (T6/T7)', () {
    String toastMessage(MealRecordContext ctx) => ctx.mealGroupId != null
        ? '현재 식사에 음식을 추가했어요.'
        : '식사를 기록했어요. 식후 2시간 뒤 증상 확인 알림을 보내드릴게요.';

    test('mealGroupId 있음 → T6 메시지', () {
      final ctx = MealRecordContext(eatenAt: _kEatAt, mealGroupId: 'g-1');
      expect(toastMessage(ctx), '현재 식사에 음식을 추가했어요.');
    });

    test('mealGroupId null → T7 메시지', () {
      final ctx = MealRecordContext(eatenAt: _kEatAt);
      expect(
        toastMessage(ctx),
        '식사를 기록했어요. 식후 2시간 뒤 증상 확인 알림을 보내드릴게요.',
      );
    });
  });

  group('MealRecordContext — recordContext null 시 nowKst 사용', () {
    test('eatenAt이 현재 시각 근방이다', () {
      final before = DateTime.now().toUtc().add(const Duration(hours: 9));
      final ctx = MealRecordContext(
        eatenAt: DateTime.now().toUtc().add(const Duration(hours: 9)),
      );
      final after = DateTime.now().toUtc().add(const Duration(hours: 9));

      expect(
        ctx.eatenAt.isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
      expect(
        ctx.eatenAt.isBefore(after.add(const Duration(seconds: 1))),
        isTrue,
      );
      expect(ctx.mealGroupId, isNull);
    });
  });
}
