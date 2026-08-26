import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/push/push_payload_resolver.dart';
import 'package:can_i_eat_it/core/push/rich_push_launch.dart';

void main() {
  group('PushPayloadResolver.isAndroidRichPushType', () {
    test('식후 단건 타입만 리치 알림 대상이다', () {
      expect(PushPayloadResolver.isAndroidRichPushType('post_meal'), isTrue);
      expect(
        PushPayloadResolver.isAndroidRichPushType('post_meal_delayed_single'),
        isTrue,
      );
      expect(
        PushPayloadResolver.isAndroidRichPushType('post_meal_delayed_bulk'),
        isFalse,
      );
      expect(PushPayloadResolver.isAndroidRichPushType('daily_record'), isFalse);
      expect(PushPayloadResolver.isAndroidRichPushType('weekly_report'), isFalse);
      expect(PushPayloadResolver.isAndroidRichPushType(null), isFalse);
    });
  });

  group('stringKeyMap', () {
    test('중첩 없는 Map을 String 키로 정규화한다', () {
      expect(
        stringKeyMap({'type': 'post_meal', 'targetId': 'm1'}),
        {'type': 'post_meal', 'targetId': 'm1'},
      );
    });

    test('null·비-Map은 빈 맵이다', () {
      expect(stringKeyMap(null), isEmpty);
      expect(stringKeyMap('x'), isEmpty);
    });
  });

  group('wireRichPushLaunch', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(richPushLaunchChannel, (call) async {
        if (call.method == 'takePendingLaunch') {
          return {'type': 'post_meal', 'targetId': 'meal-9'};
        }
        return null;
      });
    });

    tearDown(() {
      richPushLaunchChannel.setMethodCallHandler(null);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(richPushLaunchChannel, null);
    });

    test('대기 런치를 coordinator data로 전달한다', () async {
      Map<String, dynamic>? received;
      await wireRichPushLaunch((data) => received = data);
      expect(received, {'type': 'post_meal', 'targetId': 'meal-9'});
    });
  });
}
