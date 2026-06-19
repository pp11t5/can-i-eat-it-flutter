import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/repositories/mock_favorite_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/favorite_item.dart';

void main() {
  group('MockFavoriteRepository', () {
    late MockFavoriteRepository repo;

    setUp(() => repo = MockFavoriteRepository());

    test('초기 상태: getAll() 빈 리스트', () async {
      expect(await repo.getAll(), isEmpty);
    });

    test('save() 후 isFavorite() → true', () async {
      final item = FavoriteItem(
        foodName: '두부',
        level: VerdictLevel.recommend,
        savedAt: DateTime(2026, 6, 20),
      );

      await repo.save(item);

      expect(await repo.isFavorite('두부'), isTrue);
    });

    test('save() 후 remove() → isFavorite() false', () async {
      final item = FavoriteItem(
        foodName: '커피',
        level: VerdictLevel.risk,
        savedAt: DateTime(2026, 6, 20),
      );

      await repo.save(item);
      await repo.remove('커피');

      expect(await repo.isFavorite('커피'), isFalse);
    });

    test('동일 foodName save() 시 중복 없이 교체', () async {
      final item1 = FavoriteItem(
        foodName: '된장찌개',
        level: VerdictLevel.caution,
        savedAt: DateTime(2026, 6, 19),
      );
      final item2 = FavoriteItem(
        foodName: '된장찌개',
        level: VerdictLevel.recommend,
        savedAt: DateTime(2026, 6, 20),
      );

      await repo.save(item1);
      await repo.save(item2);

      final all = await repo.getAll();
      expect(all.length, 1);
      expect(all.first.level, VerdictLevel.recommend);
    });

    test('getAll() 최신 먼저(역순) 반환', () async {
      final older = FavoriteItem(
        foodName: '두부',
        level: VerdictLevel.recommend,
        savedAt: DateTime(2026, 6, 19),
      );
      final newer = FavoriteItem(
        foodName: '커피',
        level: VerdictLevel.risk,
        savedAt: DateTime(2026, 6, 20),
      );

      await repo.save(older);
      await repo.save(newer);

      final all = await repo.getAll();
      expect(all.first.foodName, '커피');
      expect(all.last.foodName, '두부');
    });

    test('존재하지 않는 foodName remove() — 예외 없음', () async {
      await expectLater(repo.remove('없는음식'), completes);
    });
  });
}
