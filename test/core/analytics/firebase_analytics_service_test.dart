import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_params.dart';
import 'package:can_i_eat_it/core/analytics/firebase_analytics_service.dart';

void main() {
  group('sanitizeAnalyticsParameters', () {
    test('food_name 은 제거하고 level 은 남긴다', () {
      final sanitized = sanitizeAnalyticsParameters({
        'food_name': '라면',
        'level': 'caution',
      });

      expect(sanitized, {'level': 'caution'});
    });

    test('null 과 빈 문자열은 제거한다', () {
      final sanitized = sanitizeAnalyticsParameters({
        'provider': 'kakao',
        'empty': '',
        'missing': null,
      });

      expect(sanitized, {'provider': 'kakao'});
    });

    test('bool 은 0/1, 긴 문자열은 100자로 자른다', () {
      final sanitized = sanitizeAnalyticsParameters({
        'flag': true,
        'off': false,
        'note': 'a' * 120,
      });

      expect(sanitized['flag'], 1);
      expect(sanitized['off'], 0);
      expect(sanitized['note'], 'a' * 100);
    });

    test('예약 prefix 와 잘못된 키는 버린다', () {
      final sanitized = sanitizeAnalyticsParameters({
        'firebase_screen': 'home',
        '1invalid': 'x',
        'provider': 'apple',
      });

      expect(sanitized, {'provider': 'apple'});
    });
  });

  group('FirebaseAnalyticsService', () {
    test('logFunnel 은 이벤트 키와 정제된 params 를 보낸다', () async {
      final calls = <({String name, Map<String, Object> params})>[];
      final svc = FirebaseAnalyticsService(
        send: (name, params) async {
          calls.add((name: name, params: params));
        },
      );

      await svc.logFunnel(
        FunnelEvent.firstVerdictChecked,
        params: {'food_name': '김치찌개', 'level': 'recommend'},
      );

      expect(calls, hasLength(1));
      expect(calls.single.name, 'first_verdict_checked');
      expect(calls.single.params, {'level': 'recommend'});
    });

    test('전송 실패해도 예외를 밖으로 던지지 않는다', () async {
      final svc = FirebaseAnalyticsService(
        send: (name, params) async {
          throw StateError('plugin missing');
        },
      );

      await expectLater(
        svc.logEvent('sign_up', params: {'provider': 'google'}),
        completes,
      );
    });
  });
}
