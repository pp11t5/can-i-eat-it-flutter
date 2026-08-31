import 'package:flutter/foundation.dart';

import 'package:can_i_eat_it/features/home_widget/data/home_widget_bridge.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_composer.dart';

/// 스냅샷 계산 후 네이티브 위젯을 갱신한다. 실패해도 앱 흐름을 막지 않는다.
class HomeWidgetController {
  HomeWidgetController({
    required HomeWidgetComposer composer,
    required HomeWidgetBridge bridge,
    required bool Function() isLoggedIn,
  })  : _composer = composer,
        _bridge = bridge,
        _isLoggedIn = isLoggedIn;

  final HomeWidgetComposer _composer;
  final HomeWidgetBridge _bridge;
  final bool Function() _isLoggedIn;

  Future<void> sync() async {
    try {
      final snapshot = await _composer.compose(isLoggedIn: _isLoggedIn());
      await _bridge.write(snapshot);
      await _bridge.update();
    } catch (e, st) {
      debugPrint('[HomeWidget] sync failed: $e\n$st');
    }
  }
}
