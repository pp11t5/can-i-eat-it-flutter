import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';

void main() {
  ProviderContainer makeContainer() {
    return ProviderContainer(
      overrides: [
        mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded()),
      ],
    );
  }

  group('MealDetailController — detail 로딩', () {
    test('seeded meal-001: AsyncData<MealDetail> 반환', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final provider = mealDetailControllerProvider('meal-001');
      expect(container.read(provider), isA<AsyncLoading<MealDetail>>());

      await container.read(provider.future);

      final state = container.read(provider);
      expect(state, isA<AsyncData<MealDetail>>());
      expect(state.value!.mealId, 'meal-001');
      expect(state.value!.food.name, '두부');
    });

    test('존재하지 않는 mealId: AsyncError 반환', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final provider = mealDetailControllerProvider('nonexistent');
      await expectLater(
        container.read(provider.future),
        throwsA(isA<Exception>()),
      );
      expect(container.read(provider), isA<AsyncError<MealDetail>>());
    });
  });

  group('MealDetailController — updateMemo', () {
    test('메모 수정 후 AsyncData 갱신', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final provider = mealDetailControllerProvider('meal-001');
      await container.read(provider.future);

      await container.read(provider.notifier).updateMemo('테스트 메모');

      final state = container.read(provider);
      expect(state, isA<AsyncData<MealDetail>>());
      expect(state.value!.memo, '테스트 메모');
    });

    test('null 메모 전달 시 memo 필드 null', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final provider = mealDetailControllerProvider('meal-003');
      await container.read(provider.future);

      await container.read(provider.notifier).updateMemo(null);

      final state = container.read(provider);
      expect(state.value!.memo, isNull);
    });
  });

  group('MealDetailController — delete', () {
    test('삭제 후 해당 mealId detail 조회 시 예외', () async {
      final repo = MockMealRepository.seeded();
      final container = ProviderContainer(
        overrides: [mealRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final provider = mealDetailControllerProvider('meal-001');
      await container.read(provider.future);

      await container.read(provider.notifier).delete();

      // 삭제된 mealId 직접 조회 시 예외
      await expectLater(
        repo.detail('meal-001'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
