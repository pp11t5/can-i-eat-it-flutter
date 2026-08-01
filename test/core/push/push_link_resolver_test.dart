import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/push/push_link_resolver.dart';

void main() {
  const validLink =
      'https://can-i-eat-it.com/app/symptoms/new?mealRecordId=meal-123';
  const weeklyReportLink = 'https://can-i-eat-it.com/app/weekly-report';
  const unrecordedMealsLink = 'https://can-i-eat-it.com/app/unrecorded-meals';

  group('PushLinkResolver', () {
    test('식후 증상 기록 링크를 내부 목적지로 변환한다', () {
      final destination = PushLinkResolver.parse(validLink);

      expect(destination, isA<RecordSymptomPushDestination>());
      final recordDestination = destination! as RecordSymptomPushDestination;
      expect(recordDestination.mealRecordId, 'meal-123');
      expect(
        recordDestination.location,
        '/symptom/record?mealRecordId=meal-123',
      );
    });

    test('data.link에서 식후 증상 기록 목적지를 읽는다', () {
      final destination = PushLinkResolver.fromData({'link': validLink});

      expect(destination, isA<RecordSymptomPushDestination>());
    });

    test('주간 리포트 링크를 내부 목적지로 변환한다', () {
      final destination = PushLinkResolver.parse(weeklyReportLink);

      expect(destination, isA<WeeklyReportPushDestination>());
      expect(destination!.location, '/weekly-report');
    });

    test('미기록 식사 목록 링크를 내부 목적지로 변환한다', () {
      final destination = PushLinkResolver.parse(unrecordedMealsLink);

      expect(destination, isA<UnrecordedMealsPushDestination>());
      expect(destination!.location, '/unrecorded-meals');
    });

    test('지원하지 않는 host, path, scheme은 무시한다', () {
      const invalidLinks = [
        'http://can-i-eat-it.com/app/symptoms/new?mealRecordId=meal-123',
        'https://other.example/app/symptoms/new?mealRecordId=meal-123',
        'https://can-i-eat-it.com/app/symptoms/meal-123',
        'https://can-i-eat-it.com/app/unrecorded-meal',
      ];

      for (final link in invalidLinks) {
        expect(PushLinkResolver.parse(link), isNull, reason: link);
      }
    });

    test('mealRecordId가 없거나 중복되면 무시한다', () {
      expect(
        PushLinkResolver.parse('https://can-i-eat-it.com/app/symptoms/new'),
        isNull,
      );
      expect(
        PushLinkResolver.parse(
          'https://can-i-eat-it.com/app/symptoms/new?mealRecordId=&mealRecordId=meal-123',
        ),
        isNull,
      );
    });

    test('주간 리포트의 특정 주 query는 지원하지 않는다', () {
      expect(
        PushLinkResolver.parse(
          'https://can-i-eat-it.com/app/weekly-report?week=2026-W31',
        ),
        isNull,
      );
    });

    test('미기록 식사 목록은 무인자 링크만 지원한다', () {
      expect(
        PushLinkResolver.parse(
          'https://can-i-eat-it.com/app/unrecorded-meals?mealCount=2',
        ),
        isNull,
      );
    });
  });
}
