import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'analytics_event.dart';

/// 계정 단위로 한 번만 보내는 퍼널을 기억한다.
///
/// 실 앱의 계정 키는 bootstrap에서 [analyticsSubjectIdProvider]를 세션 userId로
/// override한다. 기본값은 null이라 세션이 없으면 1회 이벤트를 보내지 않는다.
abstract interface class FunnelOnceStore {
  Future<bool> hasFired(String userId, FunnelEvent event);

  Future<void> markFired(String userId, FunnelEvent event);

  /// 탈퇴 시 해당 계정의 1회 기록을 지운다.
  Future<void> clear(String userId);
}

/// 키: `analytics.funnel_once_v1.<event>.<userId>`
///
/// 토큰 저장소(`canieatit_auth`)와 다른 기본 [FlutterSecureStorage]를 쓴다.
class SecureStorageFunnelOnceStore implements FunnelOnceStore {
  SecureStorageFunnelOnceStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _events = [
    FunnelEvent.accountFirstVerdictChecked,
    FunnelEvent.accountFirstMealRecorded,
  ];

  static String _key(String userId, FunnelEvent event) =>
      'analytics.funnel_once_v1.${event.eventName}.$userId';

  @override
  Future<bool> hasFired(String userId, FunnelEvent event) async {
    if (userId.isEmpty) return true;
    final raw = await _storage.read(key: _key(userId, event));
    return raw == '1';
  }

  @override
  Future<void> markFired(String userId, FunnelEvent event) async {
    if (userId.isEmpty) return;
    await _storage.write(key: _key(userId, event), value: '1');
  }

  @override
  Future<void> clear(String userId) async {
    if (userId.isEmpty) return;
    for (final event in _events) {
      await _storage.delete(key: _key(userId, event));
    }
  }
}

/// 테스트용 인메모리 저장소.
class InMemoryFunnelOnceStore implements FunnelOnceStore {
  final Set<String> _fired = {};

  static String _key(String userId, FunnelEvent event) =>
      '${event.eventName}\u0000$userId';

  @override
  Future<bool> hasFired(String userId, FunnelEvent event) async {
    if (userId.isEmpty) return true;
    return _fired.contains(_key(userId, event));
  }

  @override
  Future<void> markFired(String userId, FunnelEvent event) async {
    if (userId.isEmpty) return;
    _fired.add(_key(userId, event));
  }

  @override
  Future<void> clear(String userId) async {
    if (userId.isEmpty) return;
    _fired.removeWhere((key) => key.endsWith('\u0000$userId'));
  }
}

final funnelOnceStoreProvider = Provider<FunnelOnceStore>(
  (ref) => SecureStorageFunnelOnceStore(),
);

/// 1회 퍼널의 계정 키. 실 앱은 bootstrap에서 세션 userId로 override한다.
final analyticsSubjectIdProvider = Provider<String?>((ref) => null);

/// 이 계정에서 [event]를 아직 안 보냈으면 기록하고 true.
///
/// 세션이 없거나 이미 보냈거나 저장이 실패하면 false. 호출부의 저장 흐름을
/// 막지 않도록 예외를 삼킨다.
Future<bool> claimFunnelOnce(Ref ref, FunnelEvent event) async {
  try {
    final userId = ref.read(analyticsSubjectIdProvider);
    if (userId == null || userId.isEmpty) return false;
    final store = ref.read(funnelOnceStoreProvider);
    if (await store.hasFired(userId, event)) return false;
    await store.markFired(userId, event);
    return true;
  } catch (e, st) {
    debugPrint('[Analytics] claim ${event.eventName} failed: $e\n$st');
    return false;
  }
}
