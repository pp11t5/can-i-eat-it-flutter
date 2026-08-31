import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';

import 'symptom_outbox_bridge.dart';

/// 앱이 ready 상태가 되거나 resume될 때 iOS extension의 미완료 기록을 비운다.
class SymptomOutboxRetryCoordinator {
  SymptomOutboxRetryCoordinator({
    required SymptomOutboxBridge bridge,
    required Dio dio,
  })  : _bridge = bridge,
        _dio = dio;

  final SymptomOutboxBridge _bridge;
  final Dio _dio;
  bool _draining = false;

  Future<void> drain() async {
    if (_draining) return;
    _draining = true;
    try {
      final records = await _bridge.claimPending();
      for (final record in records) {
        try {
          final response = await _dio.post<dynamic>(
            ApiEndpoints.symptoms,
            data: {
              'symptomState': record.symptomState,
              'symptomTypes': record.symptomTypes,
              'occurredAt': record.occurredAt,
              'mealRecordId': record.mealRecordId,
            },
          );
          if (_isSuccessfulEnvelope(response)) {
            await _bridge.acknowledge(
              clientRecordId: record.clientRecordId,
              claimToken: record.claimToken,
            );
          } else {
            await _bridge.release(
              clientRecordId: record.clientRecordId,
              claimToken: record.claimToken,
              errorClass: _is2xx(response.statusCode)
                  ? 'unsuccessful_envelope'
                  : 'unexpected_status',
            );
          }
        } on DioException catch (error) {
          final status = error.response?.statusCode;
          if (status != null &&
              status >= 400 &&
              status < 500 &&
              status != 401) {
            await _bridge.quarantine(
              clientRecordId: record.clientRecordId,
              claimToken: record.claimToken,
              reasonCode: 'http_$status',
              httpStatus: status,
            );
          } else {
            await _bridge.release(
              clientRecordId: record.clientRecordId,
              claimToken: record.claimToken,
              errorClass: status == 401 ? 'session_expired' : 'network',
            );
            if (status == 401) return;
          }
        }
      }
    } finally {
      _draining = false;
    }
  }

  static bool _isSuccessfulEnvelope(Response<dynamic> response) =>
      _is2xx(response.statusCode) &&
      response.data is Map &&
      (response.data as Map)['isSuccess'] == true;

  static bool _is2xx(int? statusCode) =>
      statusCode != null && statusCode >= 200 && statusCode < 300;
}

final symptomOutboxRetryCoordinatorProvider =
    Provider<SymptomOutboxRetryCoordinator>(
        (ref) => SymptomOutboxRetryCoordinator(
              bridge: ref.watch(symptomOutboxBridgeProvider),
              dio: ref.watch(dioProvider),
            ));

/// Session ready 전환 시 drain한다. 앱 resume은 [SymptomOutboxLifecycle]가 호출한다.
final symptomOutboxReadyListenerProvider = Provider<void>((ref) {
  ref.listen<SessionStatus>(sessionStatusProvider, (previous, next) {
    if (next != SessionStatus.ready || previous == SessionStatus.ready) return;
    final session = ref.read(authControllerProvider).valueOrNull;
    if (session != null) {
      unawaited(ref.read(symptomOutboxRetryCoordinatorProvider).drain());
    }
  }, fireImmediately: true);
});
