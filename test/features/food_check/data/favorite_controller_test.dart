import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/favorite_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_favorite_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

void main() {
  group('FavoriteController', () {
    ProviderContainer _makeContainer({MockFavoriteRepository? repo}) {
      return ProviderContainer(
        overrides: [
          // ignore: scoped_providers_should_specify_dependencies
          favoriteRepositoryProvider
              .overrideWithValue(repo ?? MockFavoriteRepository()),
        ],
      );
    }

    test('build: 즐겨찾기 없으면 false', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final result = await container
          .read(favoriteControllerProvider('두부').future);
      expect(result, isFalse);
    });

    test('toggle(): 추가 → isFavorite true', () async {
      final repo = MockFavoriteRepository();
      final container = _makeContainer(repo: repo);
      addTearDown(container.dispose);

      final verdict = EatVerdict.recommend(foodName: '두부');
      await container
          .read(favoriteControllerProvider('두부').notifier)
          .toggle(verdict);

      expect(await repo.isFavorite('두부'), isTrue);
      expect(
        container.read(favoriteControllerProvider('두부')).valueOrNull,
        isTrue,
      );
    });

    test('toggle(): 추가 후 다시 toggle → isFavorite false', () async {
      final repo = MockFavoriteRepository();
      final container = _makeContainer(repo: repo);
      addTearDown(container.dispose);

      final verdict = EatVerdict.recommend(foodName: '두부');
      final notifier =
          container.read(favoriteControllerProvider('두부').notifier);

      await notifier.toggle(verdict); // 추가
      await notifier.toggle(verdict); // 제거

      expect(await repo.isFavorite('두부'), isFalse);
      expect(
        container.read(favoriteControllerProvider('두부')).valueOrNull,
        isFalse,
      );
    });

    test('이미 즐겨찾기된 상태에서 build: true 반환', () async {
      final repo = MockFavoriteRepository();
      final verdict = EatVerdict.risk(foodName: '커피');
      await container_read_toggle(repo, verdict); // 미리 저장

      final container = _makeContainer(repo: repo);
      addTearDown(container.dispose);

      final result = await container
          .read(favoriteControllerProvider('커피').future);
      expect(result, isTrue);
    });
  });
}

/// toggle 헬퍼 (컨테이너 없이 repo에 직접 저장).
Future<void> container_read_toggle(
    MockFavoriteRepository repo, EatVerdict verdict) async {
  final container = ProviderContainer(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      favoriteRepositoryProvider.overrideWithValue(repo),
    ],
  );
  await container
      .read(favoriteControllerProvider(verdict.foodName).notifier)
      .toggle(verdict);
  container.dispose();
}
