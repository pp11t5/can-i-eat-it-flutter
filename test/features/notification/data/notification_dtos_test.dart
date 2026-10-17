import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/notification/data/dtos/notification_dtos.dart';

Map<String, dynamic> _json({Object? marketingEnabled}) => {
      'postMealNotificationEnabled': true,
      'dailyRecordNotificationEnabled': false,
      'dailyNotificationTime': 'night_9',
      'weeklyReportEnabled': true,
      if (marketingEnabled != null) 'marketingEnabled': marketingEnabled,
    };

void main() {
  // MY-005: BE `GET /notifications/settings`의 marketingEnabled를 그대로 반영한다.
  test('marketingEnabled false를 마스터 토글 OFF로 파싱한다', () {
    final entity = NotificationSettingResponseDto.fromJson(
      _json(marketingEnabled: false),
    ).toEntity();

    expect(entity.marketingPushEnabled, isFalse);
    expect(entity.postMealEnabled, isTrue);
    expect(entity.weeklyReportEnabled, isTrue);
  });

  test('marketingEnabled true를 마스터 토글 ON으로 파싱한다', () {
    final entity = NotificationSettingResponseDto.fromJson(
      _json(marketingEnabled: true),
    ).toEntity();

    expect(entity.marketingPushEnabled, isTrue);
  });
}
