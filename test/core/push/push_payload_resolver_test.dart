import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/push/push_payload_resolver.dart';

void main() {
  group('PushPayloadResolver', () {
    test('post_meal은 targetId로 증상 입력 목적지를 만든다', () {
      final destination = PushPayloadResolver.fromData({
        'type': 'post_meal',
        'targetId': 'meal-123',
      });

      expect(destination, isA<RecordSymptomPushDestination>());
      expect(destination!.location, '/symptom/record?mealRecordId=meal-123');
    });

    test('post_meal_delayed_single은 targetId로 증상 입력 목적지를 만든다', () {
      final destination = PushPayloadResolver.fromData({
        'type': 'post_meal_delayed_single',
        'targetId': 'meal-123',
      });

      expect(destination, isA<RecordSymptomPushDestination>());
      expect(destination!.location, '/symptom/record?mealRecordId=meal-123');
    });

    test('post_meal_delayed_bulk은 미기록 식사 목록으로 이동한다', () {
      final destination = PushPayloadResolver.fromData({
        'type': 'post_meal_delayed_bulk',
      });

      expect(destination, isA<UnrecordedMealsPushDestination>());
      expect(destination!.location, '/unrecorded-meals');
    });

    test('daily_record는 식사 기록 입력으로 이동한다', () {
      final destination = PushPayloadResolver.fromData({
        'type': 'daily_record',
      });

      expect(destination, isA<RecordMealPushDestination>());
      expect(destination!.location, '/meal/record');
    });

    test('weekly_report는 주간 리포트로 이동한다', () {
      final destination = PushPayloadResolver.fromData({
        'type': 'weekly_report',
      });

      expect(destination, isA<WeeklyReportPushDestination>());
      expect(destination!.location, '/weekly-report');
    });

    test('증상 기록 타입의 targetId가 없거나 공백이면 무시한다', () {
      for (final data in [
        {'type': 'post_meal'},
        {'type': 'post_meal', 'targetId': ''},
        {'type': 'post_meal_delayed_single', 'targetId': '  '},
      ]) {
        expect(PushPayloadResolver.fromData(data), isNull);
      }
    });

    test('targetId를 받지 않는 타입에 targetId가 있으면 무시한다', () {
      for (final type in [
        'post_meal_delayed_bulk',
        'daily_record',
        'weekly_report',
      ]) {
        expect(
          PushPayloadResolver.fromData(
              {'type': type, 'targetId': 'unexpected'}),
          isNull,
        );
      }
    });

    test('지원하지 않는 타입과 URL 기반 payload는 무시한다', () {
      expect(PushPayloadResolver.fromData({'type': 'unknown'}), isNull);
      expect(
        PushPayloadResolver.fromData({
          'link': 'https://can-i-eat-it.com/app/weekly-report',
        }),
        isNull,
      );
    });

    test('로컬 알림 JSON payload를 동일한 목적지로 변환한다', () {
      final destination = PushPayloadResolver.fromLocalPayload(
        '{"type":"daily_record"}',
      );

      expect(destination, isA<RecordMealPushDestination>());
    });

    test('잘못된 로컬 알림 payload는 무시한다', () {
      expect(PushPayloadResolver.fromLocalPayload('{invalid'), isNull);
      expect(PushPayloadResolver.fromLocalPayload('[]'), isNull);
    });
  });
}
