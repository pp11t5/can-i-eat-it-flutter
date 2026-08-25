import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/security/token_store.dart';
import 'package:can_i_eat_it/core/symptom_outbox/symptom_outbox_bridge.dart';

class _SpyBridge implements SymptomOutboxBridge {
  final List<String> calls = [];

  @override
  Future<void> acknowledge(
      {required String clientRecordId, required String claimToken}) async {}
  @override
  Future<List<PendingSymptomRecord>> claimPending({int limit = 10}) async =>
      const [];
  @override
  Future<void> clearSharedSession() async => calls.add('clear');
  @override
  Future<void> purgeAndCancelForLogout() async => calls.add('purge');
  @override
  Future<void> quarantine(
      {required String clientRecordId,
      required String claimToken,
      required String reasonCode,
      int? httpStatus,
      String? serverCode}) async {}
  @override
  Future<void> release(
      {required String clientRecordId,
      required String claimToken,
      String? errorClass}) async {}
  @override
  Future<void> syncSharedSession(
      {required String accessToken, required String subjectId}) async {}
  @override
  Future<void> updateSharedAccessToken(String accessToken) async =>
      calls.add('update:$accessToken');
}

void main() {
  group('MirroringTokenStore', () {
    late InMemoryTokenStore primary;
    late _SpyBridge bridge;
    late MirroringTokenStore store;

    setUp(() {
      primary = InMemoryTokenStore();
      bridge = _SpyBridge();
      store = MirroringTokenStore(primary, bridge);
    });

    test(
        'writes primary access/refresh tokens before mirroring only access token',
        () async {
      await store.writeTokens(access: 'access-1', refresh: 'refresh-1');

      expect(await primary.readAccessToken(), 'access-1');
      expect(await primary.readRefreshToken(), 'refresh-1');
      expect(bridge.calls, ['update:access-1']);
    });

    test('clear removes primary tokens and clears the shared access session',
        () async {
      await store.writeTokens(access: 'access-1', refresh: 'refresh-1');
      await store.clear();

      expect(await primary.readAccessToken(), isNull);
      expect(await primary.readRefreshToken(), isNull);
      expect(bridge.calls, ['update:access-1', 'clear']);
    });
  });

  group('PendingSymptomRecord', () {
    test(
        'decodes the native method-channel request body without client-only fields',
        () {
      final record = PendingSymptomRecord.fromMap({
        'clientRecordId': 'record-1',
        'claimToken': 'claim-1',
        'symptomState': 'comfortable',
        'symptomTypes': ['throat_foreign_body'],
        'occurredAt': '2026-05-12T14:30:00+09:00',
        'mealRecordId': 'c4e90e6a-2b3c-4d5e-8f90-1a2b3c4d5e6f',
      });

      expect(record.symptomState, 'comfortable');
      expect(record.symptomTypes, ['throat_foreign_body']);
      expect(record.mealRecordId, 'c4e90e6a-2b3c-4d5e-8f90-1a2b3c4d5e6f');
    });
  });
}
