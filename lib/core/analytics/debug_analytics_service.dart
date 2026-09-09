import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

import 'analytics_event.dart';
import 'analytics_service.dart';

/// 디버그 로깅 스텁. 테스트 기본값이며 릴리즈에서는 no-op.
class DebugAnalyticsService implements AnalyticsService {
  const DebugAnalyticsService();

  @override
  Future<void> logFunnel(
    FunnelEvent event, {
    Map<String, Object?> params = const {},
  }) async {
    if (kReleaseMode) return;
    dev.log(
      '[Analytics][funnel] ${event.eventName} params=$params',
      name: 'DebugAnalyticsService',
    );
  }

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> params = const {},
  }) async {
    if (kReleaseMode) return;
    dev.log(
      '[Analytics][event] $name params=$params',
      name: 'DebugAnalyticsService',
    );
  }
}
