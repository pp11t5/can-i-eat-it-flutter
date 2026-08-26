import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/symptom_outbox/symptom_outbox_bridge.dart';
import 'package:can_i_eat_it/core/symptom_outbox/symptom_outbox_retry_coordinator.dart';

const _baseUrl = 'https://test.example.com';

const _record = PendingSymptomRecord(
  clientRecordId: 'record-1',
  claimToken: 'claim-1',
  symptomState: 'normal',
  symptomTypes: ['cough'],
  occurredAt: '2026-08-25T12:00:00+09:00',
  mealRecordId: 'meal-1',
);

class _RecordingBridge implements SymptomOutboxBridge {
  _RecordingBridge(this.records);

  final List<PendingSymptomRecord> records;
  final List<String> acknowledgements = [];
  final List<String> releases = [];

  @override
  Future<List<PendingSymptomRecord>> claimPending({int limit = 10}) async =>
      records.take(limit).toList(growable: false);

  @override
  Future<void> acknowledge({
    required String clientRecordId,
    required String claimToken,
  }) async {
    acknowledgements.add('$clientRecordId:$claimToken');
  }

  @override
  Future<void> release({
    required String clientRecordId,
    required String claimToken,
    String? errorClass,
  }) async {
    releases.add('$clientRecordId:$claimToken:$errorClass');
  }

  @override
  Future<void> quarantine({
    required String clientRecordId,
    required String claimToken,
    required String reasonCode,
    int? httpStatus,
    String? serverCode,
  }) async {}

  @override
  Future<void> clearSharedSession() async {}

  @override
  Future<void> purgeAndCancelForLogout() async {}

  @override
  Future<void> syncSharedSession({
    required String accessToken,
    required String subjectId,
  }) async {}

  @override
  Future<void> updateSharedAccessToken(String accessToken) async {}
}

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late _RecordingBridge bridge;
  late SymptomOutboxRetryCoordinator coordinator;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: _baseUrl));
    adapter = DioAdapter(
        dio: dio, matcher: const UrlRequestMatcher(matchMethod: true));
    bridge = _RecordingBridge([_record]);
    coordinator = SymptomOutboxRetryCoordinator(bridge: bridge, dio: dio);
  });

  test('2xx and isSuccess=true acknowledges the pending record', () async {
    adapter.onPost(
      ApiEndpoints.symptoms,
      (server) => server.reply(200, {'isSuccess': true, 'result': {}}),
    );

    await coordinator.drain();

    expect(bridge.acknowledgements, ['record-1:claim-1']);
    expect(bridge.releases, isEmpty);
  });

  test('2xx and isSuccess=false retains the pending record', () async {
    adapter.onPost(
      ApiEndpoints.symptoms,
      (server) => server.reply(200, {'isSuccess': false, 'result': null}),
    );

    await coordinator.drain();

    expect(bridge.acknowledgements, isEmpty);
    expect(bridge.releases, ['record-1:claim-1:unsuccessful_envelope']);
  });
}
