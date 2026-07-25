import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/recent_food.dart';

RecentFood _item(int id, String query, DateTime searchedAt) => RecentFood(
      id: id,
      query: query,
      searchedAt: searchedAt,
    );

void main() {
  group('MockFoodRepository — 최근 검색', () {
    test('서버가 제공한 초기 목록을 순서대로 반환한다', () async {
      final now = DateTime(2026, 6, 1);
      final repo = MockFoodRepository.withRecent([
        _item(1, '된장찌개', now),
        _item(2, '커피', now),
        _item(3, '라면', now),
      ]);

      final results = await repo.recentSearches();

      expect(results.map((item) => item.id), [1, 2, 3]);
      expect(results.map((item) => item.query), ['된장찌개', '커피', '라면']);
    });

    test('id로 단건 삭제한다', () async {
      final now = DateTime(2026, 6, 1);
      final repo = MockFoodRepository.withRecent([
        _item(1, '된장찌개', now),
        _item(2, '커피', now),
      ]);

      await repo.removeRecent(1);

      expect((await repo.recentSearches()).map((item) => item.id), [2]);
    });

    test('없는 id 삭제는 오류 없이 무시한다', () async {
      final repo = MockFoodRepository.empty();

      await expectLater(repo.removeRecent(999), completes);
    });

    test('전체 삭제 후 빈 목록을 반환한다', () async {
      final repo = MockFoodRepository.withRecent([
        _item(1, '된장찌개', DateTime(2026, 6, 1)),
      ]);

      await repo.clearRecent();

      expect(await repo.recentSearches(), isEmpty);
    });

    test('조회 결과는 독립된 읽기 전용 목록이다', () async {
      final repo = MockFoodRepository.withRecent([
        _item(1, '된장찌개', DateTime(2026, 6, 1)),
      ]);

      final first = await repo.recentSearches();
      final second = await repo.recentSearches();

      expect(first.map((item) => item.id), second.map((item) => item.id));
      expect(identical(first, second), isFalse);
      expect(() => first.add(_item(2, '커피', DateTime(2026, 6, 1))),
          throwsUnsupportedError);
    });
  });
}
