import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/verdict_history/data/repositories/mock_verdict_history_repository.dart';
import 'package:can_i_eat_it/features/verdict_history/data/verdict_history_providers.dart';
import 'package:can_i_eat_it/features/verdict_history/domain/entities/verdict_history_item.dart';

ProviderContainer _makeContainer({List<VerdictHistoryItem>? initial}) {
  final repo = MockVerdictHistoryRepository(initialItems: initial);
  return ProviderContainer(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      verdictHistoryRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

VerdictHistoryItem _item(String name) => VerdictHistoryItem(
      foodName: name,
      verdict: 'safe',
      checkedAt: DateTime.now(),
    );

void main() {
  group('VerdictHistoryController', () {
    test('build: 초기 이력 목록 반환', () async {
      final container = _makeContainer(initial: [_item('두부'), _item('커피')]);
      addTearDown(container.dispose);

      final items =
          await container.read(verdictHistoryControllerProvider.future);
      expect(items.length, 2);
    });

    test('add 후 invalidate — 목록에 추가됨', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      await container.read(verdictHistoryControllerProvider.future);

      await container
          .read(verdictHistoryControllerProvider.notifier)
          .add(_item('된장찌개'));

      final items =
          await container.read(verdictHistoryControllerProvider.future);
      expect(items.length, 1);
      expect(items.first.foodName, '된장찌개');
    });

    test('clear 후 invalidate — 빈 목록 반환', () async {
      final container = _makeContainer(initial: [_item('두부')]);
      addTearDown(container.dispose);

      await container.read(verdictHistoryControllerProvider.future);
      await container
          .read(verdictHistoryControllerProvider.notifier)
          .clear();

      final items =
          await container.read(verdictHistoryControllerProvider.future);
      expect(items, isEmpty);
    });
  });
}
