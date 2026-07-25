import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/recent_food.dart';

import '../domain/food_repository_contract.dart';

void main() {
  // ---------------------------------------------------------------------------
  // 계약 테스트 — empty 팩토리로 실행
  // ---------------------------------------------------------------------------
  group('MockFoodRepository — 저장소 계약', () {
    foodRepositoryContract(MockFoodRepository.empty);
  });

  // ---------------------------------------------------------------------------
  group('empty 팩토리', () {
    test('empty 팩토리는 recentSearches가 빈 목록이다', () async {
      final repo = MockFoodRepository.empty();
      expect(await repo.recentSearches(), isEmpty);
    });

    test('empty 팩토리는 빈 검색 결과 객체를 반환한다', () async {
      final repo = MockFoodRepository.empty();
      expect((await repo.search('두부')).foods, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('withRecent 팩토리', () {
    test('withRecent 팩토리는 초기 최근검색 목록을 반환한다', () async {
      final items = [
        RecentFood(
          id: 1,
          query: '두부',
          searchedAt: DateTime(2026, 6, 1),
        ),
        RecentFood(
          id: 2,
          query: '된장찌개',
          searchedAt: DateTime(2026, 6, 2),
        ),
      ];
      final repo = MockFoodRepository.withRecent(items);
      final results = await repo.recentSearches();
      expect(results.map((r) => r.id), equals([1, 2]));
    });
  });

  // ---------------------------------------------------------------------------
  group('withSearchResults 팩토리', () {
    test('withSearchResults 팩토리는 빈 쿼리에서 빈 목록을 반환한다', () async {
      final repo = MockFoodRepository.withSearchResults([
        const FoodSummary(externalId: 'f-1', name: '두부'),
      ]);
      expect((await repo.search('')).foods, isEmpty);
    });

    test('withSearchResults 팩토리는 쿼리가 있으면 고정 결과를 반환한다', () async {
      final repo = MockFoodRepository.withSearchResults([
        const FoodSummary(externalId: 'f-1', name: '두부'),
        const FoodSummary(externalId: 'f-2', name: '두부조림'),
      ]);
      final result = await repo.search('두부');
      expect(result.foods.length, equals(2));
      expect(result.foods.first.name, equals('두부'));
    });

    test('size 인수가 결과 개수를 제한한다', () async {
      final repo = MockFoodRepository.withSearchResults(
        List.generate(
          5,
          (i) => FoodSummary(externalId: 'f-$i', name: '음식$i'),
        ),
      );
      final result = await repo.search('음식', size: 3);
      expect(result.foods.length, equals(3));
    });

    test('hasExactMatch 설정을 검색 결과에 유지한다', () async {
      final repo = MockFoodRepository.withSearchResults(
        [const FoodSummary(externalId: 'f-1', name: '두부')],
        hasExactMatch: true,
      );

      expect((await repo.search('두부')).hasExactMatch, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  group('judgeByText — Mock 결정론적 매핑 (W3-3)', () {
    test('recommend 판정 named factory와 동일 level을 반환한다', () async {
      final repo = MockFoodRepository.empty();
      final result = await repo.judgeByText('두부');
      final sample = EatVerdict.recommend(foodName: '두부');
      expect(result.level, equals(sample.level));
      expect(result.substitutes, isEmpty); // by-text 규약
    });

    test('caution 판정 named factory와 동일 level을 반환한다', () async {
      final repo = MockFoodRepository.empty();
      final result = await repo.judgeByText('된장찌개');
      final sample = EatVerdict.caution(foodName: '된장찌개');
      expect(result.level, equals(sample.level));
    });

    test('risk 판정 named factory와 동일 level을 반환한다', () async {
      final repo = MockFoodRepository.empty();
      final result = await repo.judgeByText('커피');
      final sample = EatVerdict.risk(foodName: '커피');
      expect(result.level, equals(sample.level));
    });

    test('unknown 판정 named factory와 동일 level을 반환한다', () async {
      final repo = MockFoodRepository.empty();
      final result = await repo.judgeByText('모름');
      final sample = EatVerdict.unknown(foodName: '모름');
      expect(result.level, equals(sample.level));
      expect(result.substitutes, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('judgeById — Mock 결정론적 매핑 (W3-3)', () {
    test('judgeById는 EatVerdict를 반환한다', () async {
      final repo = MockFoodRepository.empty();
      final result = await repo.judgeById('food-ext-1');
      expect(result, isA<EatVerdict>());
    });
  });
}
