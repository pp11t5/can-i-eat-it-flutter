import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/funnel_once_store.dart';

final _refProbeProvider = Provider<Ref>((ref) => ref);

void main() {
  group('InMemoryFunnelOnceStore', () {
    test('같은 계정·이벤트는 한 번만 기록되고 clear 하면 다시 비운다', () async {
      final store = InMemoryFunnelOnceStore();

      expect(
        await store.hasFired('user-1', FunnelEvent.accountFirstVerdictChecked),
        isFalse,
      );
      await store.markFired('user-1', FunnelEvent.accountFirstVerdictChecked);
      expect(
        await store.hasFired('user-1', FunnelEvent.accountFirstVerdictChecked),
        isTrue,
      );
      expect(
        await store.hasFired('user-1', FunnelEvent.accountFirstMealRecorded),
        isFalse,
      );
      expect(
        await store.hasFired('user-2', FunnelEvent.accountFirstVerdictChecked),
        isFalse,
      );

      await store.clear('user-1');
      expect(
        await store.hasFired('user-1', FunnelEvent.accountFirstVerdictChecked),
        isFalse,
      );
    });
  });

  group('claimFunnelOnce', () {
    test('세션이 없으면 false 이고 저장하지 않는다', () async {
      final store = InMemoryFunnelOnceStore();
      final container = ProviderContainer(
        overrides: [
          funnelOnceStoreProvider.overrideWithValue(store),
        ],
      );
      addTearDown(container.dispose);

      final claimed = await claimFunnelOnce(
        container.read(_refProbeProvider),
        FunnelEvent.accountFirstMealRecorded,
      );

      expect(claimed, isFalse);
      expect(
        await store.hasFired('user-1', FunnelEvent.accountFirstMealRecorded),
        isFalse,
      );
    });

    test('첫 claim 만 true 다', () async {
      final store = InMemoryFunnelOnceStore();
      final container = ProviderContainer(
        overrides: [
          analyticsSubjectIdProvider.overrideWithValue('user-1'),
          funnelOnceStoreProvider.overrideWithValue(store),
        ],
      );
      addTearDown(container.dispose);
      final ref = container.read(_refProbeProvider);

      expect(
        await claimFunnelOnce(ref, FunnelEvent.accountFirstVerdictChecked),
        isTrue,
      );
      expect(
        await claimFunnelOnce(ref, FunnelEvent.accountFirstVerdictChecked),
        isFalse,
      );
    });
  });
}
