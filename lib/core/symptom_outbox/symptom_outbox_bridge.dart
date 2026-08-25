import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App Group Outbox의 iOS 구현과 통신하는 작은 경계 인터페이스.
///
/// Android와 테스트에서는 [UnsupportedSymptomOutboxBridge]가 사용되어, 플랫폼
/// 분기와 MethodChannel 예외가 증상 저장 흐름으로 새지 않게 한다.
abstract interface class SymptomOutboxBridge {
  Future<List<PendingSymptomRecord>> claimPending({int limit = 10});

  Future<void> acknowledge({
    required String clientRecordId,
    required String claimToken,
  });

  Future<void> release({
    required String clientRecordId,
    required String claimToken,
    String? errorClass,
  });

  Future<void> quarantine({
    required String clientRecordId,
    required String claimToken,
    required String reasonCode,
    int? httpStatus,
    String? serverCode,
  });

  Future<void> syncSharedSession({
    required String accessToken,
    required String subjectId,
  });

  Future<void> updateSharedAccessToken(String accessToken);

  Future<void> clearSharedSession();

  Future<void> purgeAndCancelForLogout();
}

class PendingSymptomRecord {
  const PendingSymptomRecord({
    required this.clientRecordId,
    required this.claimToken,
    required this.symptomState,
    required this.symptomTypes,
    required this.occurredAt,
    required this.mealRecordId,
  });

  final String clientRecordId;
  final String claimToken;
  final String symptomState;
  final List<String> symptomTypes;
  final String occurredAt;
  final String mealRecordId;

  factory PendingSymptomRecord.fromMap(Map<Object?, Object?> map) {
    return PendingSymptomRecord(
      clientRecordId: map['clientRecordId']! as String,
      claimToken: map['claimToken']! as String,
      symptomState: map['symptomState']! as String,
      symptomTypes: (map['symptomTypes']! as List<Object?>).cast<String>(),
      occurredAt: map['occurredAt']! as String,
      mealRecordId: map['mealRecordId']! as String,
    );
  }
}

class UnsupportedSymptomOutboxBridge implements SymptomOutboxBridge {
  const UnsupportedSymptomOutboxBridge();

  @override
  Future<void> acknowledge(
      {required String clientRecordId, required String claimToken}) async {}
  @override
  Future<List<PendingSymptomRecord>> claimPending({int limit = 10}) async =>
      const [];
  @override
  Future<void> clearSharedSession() async {}
  @override
  Future<void> purgeAndCancelForLogout() async {}
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
  Future<void> updateSharedAccessToken(String accessToken) async {}
}

class MethodChannelSymptomOutboxBridge implements SymptomOutboxBridge {
  MethodChannelSymptomOutboxBridge([MethodChannel? channel])
      : _channel = channel ?? const MethodChannel(_channelName);

  static const _channelName = 'canieatit/symptom_outbox';
  final MethodChannel _channel;

  @override
  Future<List<PendingSymptomRecord>> claimPending({
    int limit = 10,
  }) async {
    final result = await _channel.invokeListMethod<Object?>(
      'claimPending',
      {'limit': limit},
    );
    return (result ?? const [])
        .map((value) => PendingSymptomRecord.fromMap(
              (value! as Map<Object?, Object?>),
            ))
        .toList(growable: false);
  }

  @override
  Future<void> acknowledge(
          {required String clientRecordId, required String claimToken}) =>
      _invokeVoid('acknowledge',
          {'clientRecordId': clientRecordId, 'claimToken': claimToken});

  @override
  Future<void> release(
          {required String clientRecordId,
          required String claimToken,
          String? errorClass}) =>
      _invokeVoid('release', {
        'clientRecordId': clientRecordId,
        'claimToken': claimToken,
        if (errorClass != null) 'errorClass': errorClass,
      });

  @override
  Future<void> quarantine(
          {required String clientRecordId,
          required String claimToken,
          required String reasonCode,
          int? httpStatus,
          String? serverCode}) =>
      _invokeVoid('quarantine', {
        'clientRecordId': clientRecordId,
        'claimToken': claimToken,
        'reasonCode': reasonCode,
        if (httpStatus != null) 'httpStatus': httpStatus,
        if (serverCode != null) 'serverCode': serverCode,
      });

  @override
  Future<void> syncSharedSession(
          {required String accessToken, required String subjectId}) =>
      _invokeVoid('syncSharedSession',
          {'accessToken': accessToken, 'subjectId': subjectId});

  @override
  Future<void> updateSharedAccessToken(String accessToken) =>
      _invokeVoid('updateSharedAccessToken', {'accessToken': accessToken});

  @override
  Future<void> clearSharedSession() => _invokeVoid('clearSharedSession');

  @override
  Future<void> purgeAndCancelForLogout() =>
      _invokeVoid('purgeAndCancelForLogout');

  Future<void> _invokeVoid(String method,
      [Map<String, Object?>? arguments]) async {
    try {
      await _channel.invokeMethod<void>(method, arguments);
    } on MissingPluginException {
      // Flutter engine이 준비되기 전/테스트의 iOS 채널 부재는 다음 lifecycle에 보완.
    }
  }
}

final symptomOutboxBridgeProvider = Provider<SymptomOutboxBridge>((ref) {
  if (!Platform.isIOS) return const UnsupportedSymptomOutboxBridge();
  return MethodChannelSymptomOutboxBridge();
});
