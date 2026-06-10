// ADR-0007 §3-1 (C): SearchHistoryRepository(String 기반)를 FoodRepository로 흡수.
// 이 파일은 MockFoodRepository의 recent CRUD 동작을 검증하며,
// 기존 MockSearchHistoryRepository 테스트를 RecentFood 엔티티 기반으로 마이그레이션한다.
//
// 실 구현(FoodRepositoryImpl) 계약 검증은 food_repository_impl_test.dart 참조.

import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/recent_food.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_repository.dart';

// ---------------------------------------------------------------------------
// helpers
// ---------------------------------------------------------------------------

RecentFood _item(String id, String name, DateTime searchedAt) => RecentFood(
      foodExternalId: id,
      name: name,
      searchedAt: searchedAt,
    );

// ---------------------------------------------------------------------------
// tests
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  group('MockFoodRepository — empty 팩토리', () {
    test('empty 팩토리는 recentSearches가 빈 목록을 반환한다', () async {
      final repo = MockFoodRepository.empty();
      expect(await repo.recentSearches(), isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('MockFoodRepository — withRecent 팩토리', () {
    test('withRecent 팩토리는 recentSearches가 초기 목록을 반환한다', () async {
      final now = DateTime(2026, 6, 1);
      final items = [
        _item('r-1', '된장찌개', now),
        _item('r-2', '커피', now),
        _item('r-3', '라면', now),
      ];
      final repo = MockFoodRepository.withRecent(items);
      final results = await repo.recentSearches();
      expect(results.map((r) => r.foodExternalId).toList(),
          ['r-1', 'r-2', 'r-3']);
    });
  });

  // -------------------------------------------------------------------------
  group('addRecent — 기본 동작', () {
    test('새 항목을 추가하면 목록 맨 앞에 삽입된다', () async {
      final repo = MockFoodRepository.empty();
      await repo.addRecent('f-1');
      final results = await repo.recentSearches();
      expect(results.map((r) => r.foodExternalId).toList(), ['f-1']);
    });

    test('여러 항목을 순서대로 추가하면 가장 최근 것이 맨 앞이다', () async {
      final repo = MockFoodRepository.empty();
      await repo.addRecent('f-1');
      await repo.addRecent('f-2');
      await repo.addRecent('f-3');
      final results = await repo.recentSearches();
      expect(
          results.map((r) => r.foodExternalId).toList(), ['f-3', 'f-2', 'f-1']);
    });
  });

  // -------------------------------------------------------------------------
  group('addRecent — 중복 제거 + 최신순 정렬', () {
    test('이미 존재하는 항목을 추가하면 중복 없이 맨 앞으로 이동한다', () async {
      final now = DateTime(2026, 6, 1);
      final repo = MockFoodRepository.withRecent([
        _item('f-1', 'A', now),
        _item('f-2', 'B', now),
        _item('f-3', 'C', now),
      ]);
      await repo.addRecent('f-2');
      final results = await repo.recentSearches();
      expect(results.first.foodExternalId, 'f-2');
      expect(results.where((r) => r.foodExternalId == 'f-2').length, 1);
    });
  });

  // -------------------------------------------------------------------------
  group('addRecent — 최대 개수(kRecentFoodMaxCount=10) 제한', () {
    test('10개 이하일 때는 모두 유지된다', () async {
      final repo = MockFoodRepository.empty();
      for (var i = 1; i <= 10; i++) {
        await repo.addRecent('f-$i');
      }
      expect((await repo.recentSearches()).length, 10);
    });

    test('11번째 항목을 추가하면 오래된 항목이 잘려 목록이 10개로 유지된다', () async {
      final repo = MockFoodRepository.empty();
      for (var i = 1; i <= kRecentFoodMaxCount; i++) {
        await repo.addRecent('f-$i');
      }
      await repo.addRecent('f-new');
      final results = await repo.recentSearches();
      expect(results.length, kRecentFoodMaxCount);
      expect(results.first.foodExternalId, 'f-new');
      expect(results.map((r) => r.foodExternalId), isNot(contains('f-1')));
    });
  });

  // -------------------------------------------------------------------------
  group('removeRecent', () {
    test('존재하는 항목을 removeRecent하면 목록에서 사라진다', () async {
      final now = DateTime(2026, 6, 1);
      final repo = MockFoodRepository.withRecent([
        _item('f-1', 'A', now),
        _item('f-2', 'B', now),
      ]);
      await repo.removeRecent('f-1');
      final results = await repo.recentSearches();
      expect(results.map((r) => r.foodExternalId), isNot(contains('f-1')));
      expect(results.map((r) => r.foodExternalId), contains('f-2'));
    });

    test('존재하지 않는 항목을 removeRecent해도 오류 없이 무시된다', () async {
      final now = DateTime(2026, 6, 1);
      final repo = MockFoodRepository.withRecent([_item('f-1', 'A', now)]);
      await expectLater(repo.removeRecent('없는항목'), completes);
      expect(
        (await repo.recentSearches()).map((r) => r.foodExternalId),
        contains('f-1'),
      );
    });

    test('빈 목록에서 removeRecent를 호출해도 오류가 없다', () async {
      final repo = MockFoodRepository.empty();
      await expectLater(repo.removeRecent('f-1'), completes);
    });
  });

  // -------------------------------------------------------------------------
  group('clearRecent', () {
    test('clearRecent 호출 후 recentSearches는 빈 목록을 반환한다', () async {
      final now = DateTime(2026, 6, 1);
      final repo = MockFoodRepository.withRecent([
        _item('f-1', 'A', now),
        _item('f-2', 'B', now),
      ]);
      await repo.clearRecent();
      expect(await repo.recentSearches(), isEmpty);
    });

    test('빈 목록에서 clearRecent를 호출해도 오류가 없다', () async {
      final repo = MockFoodRepository.empty();
      await expectLater(repo.clearRecent(), completes);
      expect(await repo.recentSearches(), isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('recentSearches — 독립 복사본 반환', () {
    test('recentSearches는 두 번 호출해도 동일한 내용을 반환한다', () async {
      final now = DateTime(2026, 6, 1);
      final repo = MockFoodRepository.withRecent([_item('f-1', 'A', now)]);
      final first = await repo.recentSearches();
      final second = await repo.recentSearches();
      expect(
        first.map((r) => r.foodExternalId).toList(),
        equals(second.map((r) => r.foodExternalId).toList()),
      );
      expect(identical(first, second), isFalse);
    });
  });
}
