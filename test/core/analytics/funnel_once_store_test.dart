import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/funnel_once_store.dart';

final _refProbeProvider = Provider<Ref>((ref) => ref);

/// read/write 에 await 틈을 줘서 동시 호출 경합을 재현하는 저장소.
class _SlowStorage extends FlutterSecureStorage {
  final Map<String, String> _data = {};

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return _data[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    if (value != null) _data[key] = value;
  }
}

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

  group('FunnelOnceStore.claim', () {
    test('InMemory: 동시에 호출해도 true는 한 번만 나온다', () async {
      final store = InMemoryFunnelOnceStore();
      final results = await Future.wait([
        store.claim('user-1', FunnelEvent.accountFirstMealRecorded),
        store.claim('user-1', FunnelEvent.accountFirstMealRecorded),
      ]);
      expect(results.where((r) => r).length, 1);
    });

    test('SecureStorage: 저장이 느려도 동시 호출 중 하나만 true', () async {
      final store = SecureStorageFunnelOnceStore(storage: _SlowStorage());
      final results = await Future.wait([
        store.claim('user-1', FunnelEvent.accountFirstMealRecorded),
        store.claim('user-1', FunnelEvent.accountFirstMealRecorded),
      ]);
      expect(results.where((r) => r).length, 1);
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
