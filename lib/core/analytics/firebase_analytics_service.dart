import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import 'analytics_event.dart';
import 'analytics_params.dart';
import 'analytics_service.dart';

/// Firebase Analytics 구현체. 실패해도 앱 흐름을 막지 않는다.
class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService({
    Future<void> Function(String name, Map<String, Object> parameters)? send,
  }) : _send = send ?? _sendToFirebase;

  final Future<void> Function(String name, Map<String, Object> parameters)
      _send;

  static Future<void> _sendToFirebase(
    String name,
    Map<String, Object> parameters,
  ) {
    return FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: parameters.isEmpty ? null : parameters,
    );
  }

  @override
  Future<void> logFunnel(
    FunnelEvent event, {
    Map<String, Object?> params = const {},
  }) {
    return logEvent(event.eventName, params: params);
  }

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> params = const {},
  }) async {
    try {
      await _send(name, sanitizeAnalyticsParameters(params));
    } catch (e, st) {
      debugPrint('[Analytics] logEvent($name) failed: $e\n$st');
    }
  }
}

/// 수집은 켜고 광고 동의는 끈다. Firebase init 성공 후에만 호출한다.
Future<void> configureFirebaseAnalytics(FirebaseAnalytics analytics) async {
  await analytics.setAnalyticsCollectionEnabled(true);
  await analytics.setConsent(
    analyticsStorageConsentGranted: true,
    adStorageConsentGranted: false,
    adUserDataConsentGranted: false,
    adPersonalizationSignalsConsentGranted: false,
  );
}
