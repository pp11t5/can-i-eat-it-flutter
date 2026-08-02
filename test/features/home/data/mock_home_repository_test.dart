import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/data/repositories/mock_home_repository.dart';

void main() {
  group('MockHomeRepository.seeded', () {
    test('myStreak는 0보다 크다', () async {
      final repo = MockHomeRepository.seeded();
      expect(await repo.myStreak(), greaterThan(0));
    });

    test('unrecordedMealCount는 0보다 크다', () async {
      final repo = MockHomeRepository.seeded();
      expect(await repo.unrecordedMealCount(), greaterThan(0));
    });

    test('recentFoods는 비어 있지 않다', () async {
      final repo = MockHomeRepository.seeded();
      final result = await repo.recentFoods();
      expect(result, isNotEmpty);
    });

    test('topSearchedFoods는 비어 있지 않다', () async {
      final repo = MockHomeRepository.seeded();
      expect(await repo.topSearchedFoods(), isNotEmpty);
    });
  });

  group('MockHomeRepository.empty', () {
    test('myStreak는 0이다', () async {
      final repo = MockHomeRepository.empty();
      expect(await repo.myStreak(), 0);
    });

    test('unrecordedMealCount는 0이다', () async {
      final repo = MockHomeRepository.empty();
      expect(await repo.unrecordedMealCount(), 0);
    });

    test('recentFoods는 빈 목록이다', () async {
      final repo = MockHomeRepository.empty();
      final result = await repo.recentFoods();
      expect(result, isEmpty);
    });

    test('topSearchedFoods는 빈 목록이다', () async {
      final repo = MockHomeRepository.empty();
      expect(await repo.topSearchedFoods(), isEmpty);
    });
  });
}
