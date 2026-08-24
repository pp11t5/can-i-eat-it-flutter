import 'package:flutter/services.dart';

import 'package:can_i_eat_it/features/home_widget/domain/home_widget_deep_link.dart';
import 'package:can_i_eat_it/features/home_widget/domain/home_widget_snapshot.dart';

/// 홈 위젯 저장소. 테스트에서는 메모리 Fake를 쓴다.
abstract interface class HomeWidgetBridge {
  Future<void> write(HomeWidgetSnapshot snapshot);

  Future<void> update();
}

/// Android SharedPreferences + AppWidgetManager. Glance/외부 패키지 없이 MethodChannel만 쓴다.
class HomeWidgetPluginBridge implements HomeWidgetBridge {
  const HomeWidgetPluginBridge();

  static const channel = MethodChannel('canieatit/home_widget');
  static const clicks = EventChannel('canieatit/home_widget/clicks');

  @override
  Future<void> write(HomeWidgetSnapshot snapshot) async {
    final prefs = Map<String, String>.from(snapshot.toPrefs());
    final uri = HomeWidgetDeepLink.fromKind(
      snapshot.kind,
      mealRecordId: snapshot.prompt?.mealRecordId,
    );
    prefs['uri'] = uri.toString();
    await channel.invokeMethod<void>('write', prefs);
  }

  @override
  Future<void> update() => channel.invokeMethod<void>('update');

  static Future<Uri?> initialUri() async {
    final raw = await channel.invokeMethod<String>('getInitialUri');
    if (raw == null || raw.isEmpty) return null;
    return Uri.tryParse(raw);
  }

  static Stream<Uri?> clickStream() {
    return clicks.receiveBroadcastStream().map((event) {
      if (event is! String || event.isEmpty) return null;
      return Uri.tryParse(event);
    });
  }
}
