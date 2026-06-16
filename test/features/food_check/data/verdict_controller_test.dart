import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
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

    test('judgeByText("두부") → recommend 반환 (AsyncData)', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('두부');

      final state = container.read(verdictControllerProvider);
      expect(state, isA<AsyncData<EatVerdict>>());
      expect(state.value!.level, VerdictLevel.recommend);
      expect(state.value!.foodName, '두부');
    });

    test('judgeByText("커피") → risk 반환 (AsyncData)', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('커피');

      final state = container.read(verdictControllerProvider);
      expect(state.value!.level, VerdictLevel.risk);
    });

    test('judgeByText("된장찌개") → caution 반환 (AsyncData)', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('된장찌개');

      final state = container.read(verdictControllerProvider);
      expect(state.value!.level, VerdictLevel.caution);
    });

    test('judgeByText("unknown") → unknown 반환 (AsyncData — 성공 응답, D1)', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('unknown');

      final state = container.read(verdictControllerProvider);
      // grade=UNKNOWN은 AsyncData (성공) — AsyncError로 흘리면 안 됨 (D1, R3)
      expect(state, isA<AsyncData<EatVerdict>>());
      expect(state.value!.level, VerdictLevel.unknown);
    });

    test('judgeById("food-ext-1") → EatVerdict 반환 (AsyncData)', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeById('food-ext-1');

      final state = container.read(verdictControllerProvider);
      expect(state, isA<AsyncData<EatVerdict>>());
    });

    test('reset() 후 초기 idle 상태로 복귀', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('두부');
      container.read(verdictControllerProvider.notifier).reset();

      final state = container.read(verdictControllerProvider);
      expect(state.value!.level, VerdictLevel.unknown);
      expect(state.value!.foodName, '');
    });

    test('저장소 예외 → AsyncError 반환 (분석실패 경로)', () async {
      final failingRepo = _FailingFoodRepository();
      final container = _makeContainer(repo: failingRepo);
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('아무거나');

      final state = container.read(verdictControllerProvider);
      // 에러는 AsyncError — grade=UNKNOWN(AsyncData)과 다른 경로 (D1, R3)
      expect(state, isA<AsyncError<EatVerdict>>());
    });

    test('FOOD 에러 Failure → AsyncError에 Failure 타입이 담긴다', () async {
      final failingRepo = _FailingWithFailureRepository();
      final container = _makeContainer(repo: failingRepo);
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('아무거나');

      final state = container.read(verdictControllerProvider);
      expect(state, isA<AsyncError<EatVerdict>>());
      expect(state.error, isA<FoodNotFoundFailure>());
    });
  });
}

/// judgeByText/judgeById 모두 예외를 던지는 테스트 전용 저장소.
class _FailingFoodRepository extends MockFoodRepository {
  @override
  Future<EatVerdict> judgeByText(String foodTextInput) async {
    throw Exception('서버 오류');
  }

  @override
  Future<EatVerdict> judgeById(String foodExternalId) async {
    throw Exception('서버 오류');
  }
}

/// FoodNotFoundFailure를 던지는 테스트 전용 저장소.
class _FailingWithFailureRepository extends MockFoodRepository {
  @override
  Future<EatVerdict> judgeByText(String foodTextInput) async {
    throw const FoodNotFoundFailure();
  }

  @override
  Future<EatVerdict> judgeById(String foodExternalId) async {
    throw const FoodNotFoundFailure();
  }
}
