import 'package:can_i_eat_it/features/notification/domain/repositories/notification_repository.dart';

/// [NotificationRepository] 목 구현 (테스트·오프라인용). 서버처럼 flip한다.
class MockNotificationRepository implements NotificationRepository {
  MockNotificationRepository({this.marketingEnabled = false});

  bool marketingEnabled;

  /// 마케팅 동의 토글 호출 횟수 (테스트 검증용).
  int marketingToggleCalls = 0;

  @override
  Future<bool> fetchMarketingEnabled() async => marketingEnabled;

  @override
  Future<bool> toggleMarketingConsent() async {
    marketingToggleCalls += 1;
    return marketingEnabled = !marketingEnabled;
  }
}
