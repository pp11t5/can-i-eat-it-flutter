import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/analytics/analytics_service.dart';
import 'package:can_i_eat_it/core/analytics/debug_analytics_service.dart';

// ---------------------------------------------------------------------------
// 계약 검증용 기록 구현체 — 테스트 파일 내 한정.
// 미래의 실제 분석 도구 구현이 이 인터페이스를 충족하는지 확인하는 기준.
// ---------------------------------------------------------------------------
class RecordingAnalyticsService implements AnalyticsService {
  final List<({String name, Map<String, Object?> params})> calls = [];

  @override
  Future<void> logFunnel(
    FunnelEvent event, {
    Map<String, Object?> params = const {},
  }) async {
    calls.add((name: event.eventName, params: params));
  }

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> params = const {},
  }) async {
    calls.add((name: name, params: params));
  }
}

void main() {
  // -------------------------------------------------------------------------
  // group 1: FunnelEvent 키 문자열 고정 (드리프트 방지)
  // PRD US-SYS-2 — 대시보드 키가 코드 변경으로 drift 되는 것을 방지한다.
  // -------------------------------------------------------------------------
  group('FunnelEvent 키 문자열 고정', () {
    test('가입 이벤트 키는 sign_up 으로 고정된다', () {
      expect(FunnelEvent.signUp.eventName, 'sign_up');
    });

    test('온보딩 완료 이벤트 키는 onboarding_completed 으로 고정된다', () {
      expect(FunnelEvent.onboardingCompleted.eventName, 'onboarding_completed');
    });

    test('첫 판정 이벤트 키는 first_verdict_checked 으로 고정된다', () {
      expect(FunnelEvent.firstVerdictChecked.eventName, 'first_verdict_checked');
    });

    test('첫 기록 이벤트 키는 first_meal_recorded 으로 고정된다', () {
      expect(FunnelEvent.firstMealRecorded.eventName, 'first_meal_recorded');
    });

    test('증상 응답 이벤트 키는 symptom_response 으로 고정된다', () {
      expect(FunnelEvent.symptomResponse.eventName, 'symptom_response');
    });

    test('리포트 열람 이벤트 키는 report_viewed 으로 고정된다', () {
      expect(FunnelEvent.reportViewed.eventName, 'report_viewed');
    });

    test('퍼널 이벤트는 정확히 6종이다', () {
      expect(FunnelEvent.values.length, 6);
    });
  });

  // -------------------------------------------------------------------------
  // group 2: AnalyticsService 계약 (RecordingAnalyticsService 로 검증)
  // 이 그룹이 통과하는 구현은 실제 분석 도구로 교체해도 인터페이스를 충족한다.
  // -------------------------------------------------------------------------
  group('AnalyticsService 계약', () {
    late RecordingAnalyticsService svc;

    setUp(() {
      svc = RecordingAnalyticsService();
    });

    test('logFunnel 호출 시 해당 퍼널 이벤트가 기록된다', () async {
      await svc.logFunnel(FunnelEvent.firstVerdictChecked);

      expect(svc.calls.length, 1);
      expect(svc.calls.first.name, 'first_verdict_checked');
    });

    test('logEvent 호출 시 임의 이벤트 이름과 params가 기록된다', () async {
      await svc.logEvent('custom', params: {'k': 1});

      expect(svc.calls.length, 1);
      expect(svc.calls.first.name, 'custom');
      expect(svc.calls.first.params, {'k': 1});
    });

    test('logFunnel은 params 없이도 호출된다', () async {
      await svc.logFunnel(FunnelEvent.signUp);

      expect(svc.calls.length, 1);
      expect(svc.calls.first.params, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // group 3: provider 기본값 + 스텁 안전성
  // -------------------------------------------------------------------------
  group('analyticsServiceProvider 기본값 및 스텁 안전성', () {
    test('analyticsServiceProvider 기본값은 DebugAnalyticsService 다', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final svc = container.read(analyticsServiceProvider);

      expect(svc, isA<DebugAnalyticsService>());
    });

    test('DebugAnalyticsService.logFunnel 은 예외 없이 완료된다', () async {
      const svc = DebugAnalyticsService();

      await expectLater(
        svc.logFunnel(FunnelEvent.onboardingCompleted, params: {'source': 'test'}),
        completes,
      );
    });

    test('DebugAnalyticsService.logEvent 는 예외 없이 완료된다', () async {
      const svc = DebugAnalyticsService();

      await expectLater(
        svc.logEvent('arbitrary_event', params: {'count': 42}),
        completes,
      );
    });
  });
}
