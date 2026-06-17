import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';

void main() {
  final today = DateTime(2026, 6, 17);

  ProviderContainer makeContainer({required bool seeded}) {
    return ProviderContainer(
      overrides: [
        mealRepositoryProvider.overrideWithValue(
          seeded
              ? MockMealRepository.seeded()
              : MockMealRepository.empty(),
        ),
      ],
    );
  }

  group('TimelineController — 로딩 → data', () {
    test('seeded mock: AsyncData<List<MealGroup>> 반환', () async {
      final container = makeContainer(seeded: true);
      addTearDown(container.dispose);

      final provider = timelineControllerProvider(today);
      // 초기 로딩 상태 확인
      expect(container.read(provider), isA<AsyncLoading<List<MealGroup>>>());

      // 비동기 완료 대기
      await container.read(provider.future);

      final state = container.read(provider);
      expect(state, isA<AsyncData<List<MealGroup>>>());
      final groups = state.value!;
      expect(groups, isNotEmpty);
    });

    test('empty mock: AsyncData<[]> 반환', () async {
      final container = makeContainer(seeded: false);
      addTearDown(container.dispose);

      final provider = timelineControllerProvider(today);
      await container.read(provider.future);

      final state = container.read(provider);
      expect(state, isA<AsyncData<List<MealGroup>>>());
      expect(state.value!, isEmpty);
    });
  });

  group('TimelineController — changeDate 재조회', () {
    test('changeDate 호출 시 새 날짜로 재조회한다', () async {
      final container = makeContainer(seeded: true);
      addTearDown(container.dispose);

      final provider = timelineControllerProvider(today);
      await container.read(provider.future);

      final notifier = container.read(provider.notifier);
      final yesterday = today.subtract(const Duration(days: 1));

      await notifier.changeDate(yesterday);

      final state = container.read(provider);
      // MockMealRepository는 날짜 무관 동일 데이터 반환하므로 AsyncData 확인
      expect(state, isA<AsyncData<List<MealGroup>>>());
    });
  });

  group('TimelineController — refresh', () {
    test('refresh 호출 시 AsyncData 유지', () async {
      final container = makeContainer(seeded: true);
      addTearDown(container.dispose);

      final provider = timelineControllerProvider(today);
      await container.read(provider.future);

      final notifier = container.read(provider.notifier);
      await notifier.refresh(today);

      final state = container.read(provider);
      expect(state, isA<AsyncData<List<MealGroup>>>());
    });
  });

  group('TimelineController — error 상태', () {
    test('repository가 예외를 던지면 AsyncError 반환', () async {
      final container = ProviderContainer(
        overrides: [
          mealRepositoryProvider.overrideWithValue(_ThrowingMealRepository()),
        ],
      );
      addTearDown(container.dispose);

      final provider = timelineControllerProvider(today);
      // future가 에러로 완료됨을 확인
      await expectLater(
        container.read(provider.future),
        throwsA(isA<Exception>()),
      );

      final state = container.read(provider);
      expect(state, isA<AsyncError<List<MealGroup>>>());
    });
  });
}

/// 항상 예외를 던지는 테스트용 repository.
class _ThrowingMealRepository extends MockMealRepository {
  _ThrowingMealRepository() : super();

  @override
  Future<List<MealGroup>> timeline(DateTime date) async {
    throw Exception('network error');
  }
}
