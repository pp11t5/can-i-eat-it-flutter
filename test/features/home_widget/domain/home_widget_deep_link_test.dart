import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home_widget/domain/home_widget_deep_link.dart';
import 'package:can_i_eat_it/features/home_widget/domain/home_widget_snapshot.dart';

void main() {
  group('HomeWidgetDeepLink.toLocation', () {
    test('meal-record는 /meal/record로 연다', () {
      expect(
        HomeWidgetDeepLink.toLocation(HomeWidgetDeepLink.mealRecord()),
        '/meal/record',
      );
    });

    test('food-history는 /food-history로 연다', () {
      expect(
        HomeWidgetDeepLink.toLocation(HomeWidgetDeepLink.foodHistory()),
        '/food-history',
      );
    });

    test('symptom-record는 mealRecordId 쿼리로 작성 화면을 연다', () {
      expect(
        HomeWidgetDeepLink.toLocation(
          HomeWidgetDeepLink.symptomRecord('mr-1'),
        ),
        '/symptom/record?mealRecordId=mr-1',
      );
    });

    test('symptom-record에 id가 없으면 미기록 목록으로 연다', () {
      final uri = Uri(
        scheme: HomeWidgetDeepLink.scheme,
        host: HomeWidgetDeepLink.host,
        path: '/symptom-record',
      );
      expect(HomeWidgetDeepLink.toLocation(uri), '/unrecorded-meals');
    });

    test('지원하지 않는 URI는 null이다', () {
      expect(HomeWidgetDeepLink.toLocation(Uri.parse('https://example.com')), isNull);
      expect(HomeWidgetDeepLink.toLocation(null), isNull);
    });

    test('GoRouter가 스킴을 떼고 경로만 넘겨도 앱 경로로 바꾼다', () {
      expect(
        HomeWidgetDeepLink.toLocation(Uri.parse('/meal-record')),
        '/meal/record',
      );
      expect(
        HomeWidgetDeepLink.toLocation(Uri.parse('/home')),
        '/',
      );
      expect(
        HomeWidgetDeepLink.toLocation(
          Uri.parse('/symptom-record?mealRecordId=mr-1'),
        ),
        '/symptom/record?mealRecordId=mr-1',
      );
    });
  });

  group('HomeWidgetDeepLink.fromKind', () {
    test('증상 유도는 mealRecordId를 담는다', () {
      final uri = HomeWidgetDeepLink.fromKind(
        HomeWidgetKind.promptSymptom,
        mealRecordId: 'mr-9',
      );
      expect(uri.path, '/symptom-record');
      expect(uri.queryParameters['mealRecordId'], 'mr-9');
    });
  });
}
