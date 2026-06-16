import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_repository.dart';

/// [FoodRepository] 계약 테스트 스위트 (W3-3 충실 정합).
///
/// Mock·실 구현 모두 이 계약을 통과해야 한다.
/// judgeByText/judgeById 2메서드 기반으로 재작성.
///
/// 사용법:
/// ```dart
/// foodRepositoryContract(MockFoodRepository.empty);
/// ```
void foodRepositoryContract(
  FoodRepository Function() create,
) {
  // ---------------------------------------------------------------------------
  group('judgeByText — 4상태 결과', () {
    test('일반 텍스트는 recommend 판정을 반환한다', () async {
      final repo = create();
      final result = await repo.judgeByText('두부');
      expect(result.level, equals(VerdictLevel.recommend));
    });

    test('caution 키워드 텍스트는 caution 판정을 반환한다', () async {
      final repo = create();
      final result = await repo.judgeByText('된장찌개');
      expect(result.level, equals(VerdictLevel.caution));
    });

    test('risk 키워드 텍스트는 risk 판정을 반환한다', () async {
      final repo = create();
      final result = await repo.judgeByText('커피');
      expect(result.level, equals(VerdictLevel.risk));
    });

    test('unknown 키워드 텍스트는 unknown 판정을 반환한다', () async {
      final repo = create();
      final result = await repo.judgeByText('모름');
      expect(result.level, equals(VerdictLevel.unknown));
    });

    test('judgeByText 결과의 foodName이 입력 텍스트와 동일하다', () async {
      final repo = create();
      const input = '두부';
      final result = await repo.judgeByText(input);
      expect(result.foodName, equals(input));
    });
  });

  // ---------------------------------------------------------------------------
  group('judgeByText — substitutes 규약', () {
    test('recommend 판정에서 substitutes는 비어 있다', () async {
      final repo = create();
      final result = await repo.judgeByText('두부');
      expect(result.level, equals(VerdictLevel.recommend));
      expect(result.substitutes, isEmpty);
    });

    test('unknown 판정에서 substitutes는 비어 있다', () async {
      final repo = create();
      final result = await repo.judgeByText('모름');
      expect(result.level, equals(VerdictLevel.unknown));
      expect(result.substitutes, isEmpty);
    });

    test('caution 판정에서 substitutes는 List<VerdictSubstitute> 타입이다', () async {
      final repo = create();
      final result = await repo.judgeByText('된장찌개');
      expect(result.level, equals(VerdictLevel.caution));
      expect(result.substitutes, isA<List<VerdictSubstitute>>());
    });

    test('risk 판정에서 substitutes는 List<VerdictSubstitute> 타입이다', () async {
      final repo = create();
      final result = await repo.judgeByText('커피');
      expect(result.level, equals(VerdictLevel.risk));
      expect(result.substitutes, isA<List<VerdictSubstitute>>());
    });
  });

  // ---------------------------------------------------------------------------
  group('judgeByText — personalTitle·items 구조', () {
    test('recommend 판정에서 personalTitle이 비어 있지 않다', () async {
      final repo = create();
      final result = await repo.judgeByText('두부');
      expect(result.personalTitle, isNotEmpty);
    });

    test('recommend 판정에서 items 길이가 2이다', () async {
      final repo = create();
      final result = await repo.judgeByText('두부');
      expect(result.items.length, equals(2));
    });
  });

  // ---------------------------------------------------------------------------
  group('judgeById — 결과 반환', () {
    test('judgeById는 EatVerdict를 반환한다', () async {
      final repo = create();
      final result = await repo.judgeById('food-ext-1');
      expect(result, isA<EatVerdict>());
    });

    test('judgeById 결과의 level은 VerdictLevel 중 하나이다', () async {
      final repo = create();
      final result = await repo.judgeById('food-ext-1');
      expect(VerdictLevel.values, contains(result.level));
    });
  });

  // ---------------------------------------------------------------------------
  group('search — 결과 반환', () {
    test('빈 쿼리는 빈 목록을 반환한다', () async {
      final repo = create();
      final result = await repo.search('');
      expect(result, isEmpty);
    });

    test('공백만 있는 쿼리는 빈 목록을 반환한다', () async {
      final repo = create();
      final result = await repo.search('   ');
      expect(result, isEmpty);
    });

    test('search 결과는 List 타입이다', () async {
      final repo = create();
      final result = await repo.search('두부');
      expect(result, isA<List>());
    });
  });

  // ---------------------------------------------------------------------------
  group('recentSearches — 초기 상태', () {
    test('초기 상태에서 recentSearches는 빈 목록을 반환한다', () async {
      final repo = create();
      expect(await repo.recentSearches(), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('addRecent → recentSearches 순서·중복', () {
    test('addRecent 후 recentSearches에 해당 항목이 포함된다', () async {
      final repo = create();
      await repo.addRecent('food-1');
      final results = await repo.recentSearches();
      expect(results.map((r) => r.foodExternalId), contains('food-1'));
    });

    test('복수 addRecent는 가장 최근 항목이 맨 앞이다', () async {
      final repo = create();
      await repo.addRecent('food-1');
      await repo.addRecent('food-2');
      await repo.addRecent('food-3');
      final results = await repo.recentSearches();
      expect(results.first.foodExternalId, equals('food-3'));
    });

    test('동일 foodExternalId를 addRecent하면 중복 없이 맨 앞으로 이동한다', () async {
      final repo = create();
      await repo.addRecent('food-1');
      await repo.addRecent('food-2');
      await repo.addRecent('food-1'); // 중복
      final results = await repo.recentSearches();
      expect(results.first.foodExternalId, equals('food-1'));
      expect(
        results.where((r) => r.foodExternalId == 'food-1').length,
        equals(1),
      );
    });
  });

  // ---------------------------------------------------------------------------
  group('removeRecent', () {
    test('존재하는 항목을 removeRecent하면 목록에서 사라진다', () async {
      final repo = create();
      await repo.addRecent('food-1');
      await repo.addRecent('food-2');
      await repo.removeRecent('food-1');
      final results = await repo.recentSearches();
      expect(results.map((r) => r.foodExternalId), isNot(contains('food-1')));
    });

    test('존재하지 않는 항목을 removeRecent해도 오류 없이 무시된다', () async {
      final repo = create();
      await repo.addRecent('food-1');
      await expectLater(repo.removeRecent('없는항목'), completes);
      expect(
        (await repo.recentSearches()).map((r) => r.foodExternalId),
        contains('food-1'),
      );
    });

    test('빈 목록에서 removeRecent를 호출해도 오류가 없다', () async {
      final repo = create();
      await expectLater(repo.removeRecent('food-1'), completes);
    });
  });

  // ---------------------------------------------------------------------------
  group('clearRecent', () {
    test('clearRecent 호출 후 recentSearches는 빈 목록을 반환한다', () async {
      final repo = create();
      await repo.addRecent('food-1');
      await repo.addRecent('food-2');
      await repo.clearRecent();
      expect(await repo.recentSearches(), isEmpty);
    });

    test('빈 목록에서 clearRecent를 호출해도 오류가 없다', () async {
      final repo = create();
      await expectLater(repo.clearRecent(), completes);
      expect(await repo.recentSearches(), isEmpty);
    });
  });
}
