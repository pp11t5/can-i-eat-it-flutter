import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

import 'analytics_event.dart';
import 'analytics_service.dart';

/// 실제 분석 도구(Firebase/Amplitude 등) 미정 — 인터페이스 확정 + 디버그 로깅 스텁.
/// 실 구현은 이 인터페이스를 구현해 Riverpod override로 주입.
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
