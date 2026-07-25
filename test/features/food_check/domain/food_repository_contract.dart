import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_search_result.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_repository.dart';

/// [FoodRepository] 계약 테스트 스위트.
void foodRepositoryContract(FoodRepository Function() create) {
  group('judgeByText — 4상태 결과', () {
    test('일반 텍스트는 recommend 판정을 반환한다', () async {
      expect((await create().judgeByText('두부')).level, VerdictLevel.recommend);
    });

    test('caution·risk·unknown 키워드를 각각 매핑한다', () async {
      expect((await create().judgeByText('된장찌개')).level, VerdictLevel.caution);
      expect((await create().judgeByText('커피')).level, VerdictLevel.risk);
      expect((await create().judgeByText('모름')).level, VerdictLevel.unknown);
    });

    test('by-text 결과는 대체 음식 없이 입력명을 보존한다', () async {
      const input = '두부';
      final result = await create().judgeByText(input);
      expect(result.foodName, input);
      expect(result.substitutes, isEmpty);
    });
  });

  group('judgeById', () {
    test('EatVerdict를 반환한다', () async {
      expect(await create().judgeById('food-ext-1'), isA<EatVerdict>());
    });
  });

  group('search', () {
    test('빈 쿼리는 빈 FoodSearchResult를 반환한다', () async {
      final result = await create().search('   ');
      expect(result, isA<FoodSearchResult>());
      expect(result.foods, isEmpty);
    });
  });

  group('recentSearches', () {
    test('초기 상태에서 빈 목록을 반환한다', () async {
      expect(await create().recentSearches(), isEmpty);
    });

    test('빈 목록도 전체 삭제할 수 있다', () async {
      final repo = create();
      await expectLater(repo.clearRecent(), completes);
      expect(await repo.recentSearches(), isEmpty);
    });
  });
}
