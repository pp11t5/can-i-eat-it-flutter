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

    test('empty 팩토리는 search 결과가 빈 목록이다', () async {
      final repo = MockFoodRepository.empty();
      expect(await repo.search('두부'), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('withRecent 팩토리', () {
    test('withRecent 팩토리는 초기 최근검색 목록을 반환한다', () async {
      final items = [
        RecentFood(
          foodExternalId: 'food-1',
          name: '두부',
          searchedAt: DateTime(2026, 6, 1),
        ),
        RecentFood(
          foodExternalId: 'food-2',
          name: '된장찌개',
          searchedAt: DateTime(2026, 6, 2),
        ),
      ];
      final repo = MockFoodRepository.withRecent(items);
      final results = await repo.recentSearches();
      expect(results.map((r) => r.foodExternalId), equals(['food-1', 'food-2']));
    });
  });

  // ---------------------------------------------------------------------------
  group('withSearchResults 팩토리', () {
    test('withSearchResults 팩토리는 빈 쿼리에서 빈 목록을 반환한다', () async {
      final repo = MockFoodRepository.withSearchResults([
        const FoodSummary(externalId: 'f-1', name: '두부'),
      ]);
      expect(await repo.search(''), isEmpty);
    });

    test('withSearchResults 팩토리는 쿼리가 있으면 고정 결과를 반환한다', () async {
      final repo = MockFoodRepository.withSearchResults([
        const FoodSummary(externalId: 'f-1', name: '두부'),
        const FoodSummary(externalId: 'f-2', name: '두부조림'),
      ]);
      final result = await repo.search('두부');
      expect(result.length, equals(2));
      expect(result.first.name, equals('두부'));
    });

    test('size 인수가 결과 개수를 제한한다', () async {
      final repo = MockFoodRepository.withSearchResults(
        List.generate(
          5,
          (i) => FoodSummary(externalId: 'f-$i', name: '음식$i'),
        ),
      );
      final result = await repo.search('음식', size: 3);
      expect(result.length, equals(3));
    });
  });

  // ---------------------------------------------------------------------------
  group('analyze — Mock 전용 결정론적 매핑', () {
    test('recommend 판정 named factory와 동일 구조를 반환한다', () async {
      final repo = MockFoodRepository.empty();
      final result = await repo.analyze('두부');
      final sample = EatVerdict.recommend(foodName: '두부');
      expect(result.level, equals(sample.level));
      expect(result.alternatives, isEmpty);
    });

    test('caution 판정 named factory와 동일 구조를 반환한다', () async {
      final repo = MockFoodRepository.empty();
      final result = await repo.analyze('된장찌개');
      final sample = EatVerdict.caution(foodName: '된장찌개');
      expect(result.level, equals(sample.level));
    });

    test('danger 판정 named factory와 동일 구조를 반환한다', () async {
      final repo = MockFoodRepository.empty();
      final result = await repo.analyze('커피');
      final sample = EatVerdict.danger(foodName: '커피');
      expect(result.level, equals(sample.level));
    });

    test('unknown 판정 named factory와 동일 구조를 반환한다', () async {
      final repo = MockFoodRepository.empty();
      final result = await repo.analyze('모름');
      final sample = EatVerdict.unknown(foodName: '모름');
      expect(result.level, equals(sample.level));
      expect(result.alternatives, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('addRecent — 최대 개수 제한', () {
    test('10개 이하일 때는 모두 유지된다', () async {
      final repo = MockFoodRepository.empty();
      for (var i = 1; i <= 10; i++) {
        await repo.addRecent('food-$i');
      }
      expect((await repo.recentSearches()).length, equals(10));
    });

    test('11번째 항목을 추가하면 오래된 항목이 잘려 목록이 10개로 유지된다', () async {
      final repo = MockFoodRepository.empty();
      for (var i = 1; i <= 10; i++) {
        await repo.addRecent('food-$i');
      }
      await repo.addRecent('food-new');
      final results = await repo.recentSearches();
      expect(results.length, equals(10));
      expect(results.first.foodExternalId, equals('food-new'));
      expect(
        results.map((r) => r.foodExternalId),
        isNot(contains('food-1')),
      );
    });
  });
}
