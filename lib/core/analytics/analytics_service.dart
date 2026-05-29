import 'analytics_event.dart';

/// 계측 서비스 추상 인터페이스.
/// 실제 분석 도구(Firebase/Amplitude 등) 미정 — 추후 구현체를 Riverpod override로 주입.
abstract interface class AnalyticsService {
  /// 퍼널 이벤트 로깅.
  Future<void> logFunnel(FunnelEvent event, {Map<String, Object?> params = const {}});

  /// 임의 이벤트 로깅(범용).
  Future<void> logEvent(String name, {Map<String, Object?> params = const {}});
}
