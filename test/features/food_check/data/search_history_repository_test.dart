import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_search_history_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/search_history_repository.dart';

void main() {
  // ---------------------------------------------------------------------------
  group('MockSearchHistoryRepository — empty 팩토리', () {
    test('empty 팩토리는 recentSearches가 빈 목록을 반환한다', () async {
      final repo = MockSearchHistoryRepository.empty();
      expect(await repo.recentSearches(), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('MockSearchHistoryRepository — withHistory 팩토리', () {
    test('withHistory 팩토리는 recentSearches가 초기 목록을 최신순으로 반환한다', () async {
      final repo =
          MockSearchHistoryRepository.withHistory(['된장찌개', '커피', '라면']);
      expect(await repo.recentSearches(), equals(['된장찌개', '커피', '라면']));
    });
  });

  // ---------------------------------------------------------------------------
  group('add — 기본 동작', () {
    test('새 검색어를 추가하면 목록 맨 앞에 삽입된다', () async {
      final repo = MockSearchHistoryRepository.empty();
      await repo.add('된장찌개');
      expect(await repo.recentSearches(), equals(['된장찌개']));
    });

    test('여러 검색어를 순서대로 추가하면 가장 최근 것이 맨 앞이다', () async {
      final repo = MockSearchHistoryRepository.empty();
      await repo.add('된장찌개');
      await repo.add('커피');
      await repo.add('라면');
      expect(
        await repo.recentSearches(),
        equals(['라면', '커피', '된장찌개']),
      );
    });

    test('공백만 있는 문자열은 추가하지 않는다', () async {
      final repo = MockSearchHistoryRepository.empty();
      await repo.add('   ');
      expect(await repo.recentSearches(), isEmpty);
    });

    test('빈 문자열은 추가하지 않는다', () async {
      final repo = MockSearchHistoryRepository.empty();
      await repo.add('');
      expect(await repo.recentSearches(), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('add — 중복 제거 + 최신순 정렬', () {
    test('이미 존재하는 검색어를 추가하면 기존 위치에서 제거되고 맨 앞으로 이동한다', () async {
      final repo =
          MockSearchHistoryRepository.withHistory(['된장찌개', '커피', '라면']);
      await repo.add('커피');
      expect(
        await repo.recentSearches(),
        equals(['커피', '된장찌개', '라면']),
      );
    });

    test('맨 앞 항목과 동일한 검색어를 추가해도 중복 없이 맨 앞에만 있다', () async {
      final repo = MockSearchHistoryRepository.withHistory(['커피', '라면']);
      await repo.add('커피');
      expect(await repo.recentSearches(), equals(['커피', '라면']));
    });
  });

  // ---------------------------------------------------------------------------
  group('add — 최대 개수(10개) 제한', () {
    test('10개 이하일 때는 모두 유지된다', () async {
      final repo = MockSearchHistoryRepository.empty();
      for (var i = 1; i <= 10; i++) {
        await repo.add('항목$i');
      }
      expect((await repo.recentSearches()).length, equals(10));
    });

    test('11번째 항목을 추가하면 오래된 항목이 잘려 목록이 10개로 유지된다', () async {
      final repo = MockSearchHistoryRepository.empty();
      for (var i = 1; i <= kSearchHistoryMaxCount; i++) {
        await repo.add('항목$i');
      }
      await repo.add('새항목');
      final result = await repo.recentSearches();
      expect(result.length, equals(kSearchHistoryMaxCount));
      expect(result.first, equals('새항목'));
      // 가장 오래된 '항목1'은 잘려나간다
      expect(result, isNot(contains('항목1')));
    });
  });

  // ---------------------------------------------------------------------------
  group('remove', () {
    test('존재하는 검색어를 제거하면 목록에서 사라진다', () async {
      final repo =
          MockSearchHistoryRepository.withHistory(['된장찌개', '커피', '라면']);
      await repo.remove('커피');
      expect(await repo.recentSearches(), equals(['된장찌개', '라면']));
    });

    test('존재하지 않는 검색어를 제거해도 오류 없이 무시된다', () async {
      final repo = MockSearchHistoryRepository.withHistory(['된장찌개']);
      await repo.remove('없는항목');
      expect(await repo.recentSearches(), equals(['된장찌개']));
    });

    test('목록이 빈 상태에서 remove를 호출해도 오류가 없다', () async {
      final repo = MockSearchHistoryRepository.empty();
      await repo.remove('없는항목');
      expect(await repo.recentSearches(), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('clearAll', () {
    test('clearAll 호출 후 recentSearches는 빈 목록을 반환한다', () async {
      final repo =
          MockSearchHistoryRepository.withHistory(['된장찌개', '커피', '라면']);
      await repo.clearAll();
      expect(await repo.recentSearches(), isEmpty);
    });

    test('빈 목록에서 clearAll을 호출해도 오류가 없다', () async {
      final repo = MockSearchHistoryRepository.empty();
      await repo.clearAll();
      expect(await repo.recentSearches(), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('recentSearches — 순서 보장', () {
    test('recentSearches는 항상 최신순(most-recent-first)을 반환한다', () async {
      final repo = MockSearchHistoryRepository.empty();
      await repo.add('첫번째');
      await repo.add('두번째');
      await repo.add('세번째');
      final results = await repo.recentSearches();
      expect(results, equals(['세번째', '두번째', '첫번째']));
    });

    test('recentSearches는 독립 복사본을 반환한다 — 두 번 호출해도 동일한 결과를 반환한다',
        () async {
      final repo = MockSearchHistoryRepository.withHistory(['된장찌개']);
      final first = await repo.recentSearches();
      final second = await repo.recentSearches();
      expect(first, equals(second));
      expect(identical(first, second), isFalse);
    });
  });
}
