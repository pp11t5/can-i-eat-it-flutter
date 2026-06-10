import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_repository.dart';

ProviderContainer _makeContainer({FoodRepository? repo}) {
  return ProviderContainer(
    overrides: [
      if (repo != null) foodRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

void main() {
  group('VerdictController', () {
    test('초기 상태는 AsyncData(unknown, foodName: "")', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final state = container.read(verdictControllerProvider);
      expect(state, isA<AsyncData<EatVerdict>>());
      expect(state.value!.level, VerdictLevel.unknown);
      expect(state.value!.foodName, '');
    });

    test('analyze("두부") → recommend 반환', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container.read(verdictControllerProvider.notifier).analyze('두부');

      final state = container.read(verdictControllerProvider);
      expect(state, isA<AsyncData<EatVerdict>>());
      expect(state.value!.level, VerdictLevel.recommend);
      expect(state.value!.foodName, '두부');
    });

    test('analyze("커피") → danger 반환', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container.read(verdictControllerProvider.notifier).analyze('커피');

      final state = container.read(verdictControllerProvider);
      expect(state.value!.level, VerdictLevel.danger);
    });

    test('analyze("된장찌개") → caution 반환', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container.read(verdictControllerProvider.notifier).analyze('된장찌개');

      final state = container.read(verdictControllerProvider);
      expect(state.value!.level, VerdictLevel.caution);
    });

    test('analyze("unknown") → unknown 반환', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container.read(verdictControllerProvider.notifier).analyze('unknown');

      final state = container.read(verdictControllerProvider);
      expect(state.value!.level, VerdictLevel.unknown);
    });

    test('reset() 후 초기 idle 상태로 복귀', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container.read(verdictControllerProvider.notifier).analyze('두부');
      container.read(verdictControllerProvider.notifier).reset();

      final state = container.read(verdictControllerProvider);
      expect(state.value!.level, VerdictLevel.unknown);
      expect(state.value!.foodName, '');
    });

    test('analyze 중 저장소 예외 → AsyncError 반환', () async {
      final failingRepo = _FailingFoodRepository();
      final container = _makeContainer(repo: failingRepo);
      addTearDown(container.dispose);

      await container.read(verdictControllerProvider.notifier).analyze('아무거나');

      final state = container.read(verdictControllerProvider);
      expect(state, isA<AsyncError<EatVerdict>>());
    });
  });
}

/// analyze 호출 시 예외를 던지는 테스트 전용 저장소.
class _FailingFoodRepository extends MockFoodRepository {
  @override
  Future<EatVerdict> analyze(String text) async {
    throw Exception('서버 오류');
  }
}
