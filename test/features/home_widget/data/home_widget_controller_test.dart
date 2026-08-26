import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/data/repositories/mock_home_repository.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_bridge.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_composer.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_controller.dart';
import 'package:can_i_eat_it/features/home_widget/domain/home_widget_snapshot.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';

class _FakeBridge implements HomeWidgetBridge {
  HomeWidgetSnapshot? written;
  int updates = 0;
  Object? writeError;

  @override
  Future<void> write(HomeWidgetSnapshot snapshot) async {
    if (writeError != null) throw writeError!;
    written = snapshot;
  }

  @override
  Future<void> update() async {
    updates += 1;
  }
}

void main() {
  test('로그인 상태에서 빈 데이터를 쓰면 recordMeal이 된다', () async {
    final bridge = _FakeBridge();
    final controller = HomeWidgetController(
      composer: HomeWidgetComposer(
        homeRepository: MockHomeRepository.empty(),
        mealRepository: MockMealRepository.empty(),
        now: () => DateTime(2026, 8, 24, 16),
      ),
      bridge: bridge,
      isLoggedIn: () => true,
    );

    await controller.sync();

    expect(bridge.written?.kind, HomeWidgetKind.recordMeal);
    expect(bridge.updates, 1);
  });

  test('브리지 실패는 던지지 않는다', () async {
    final bridge = _FakeBridge()..writeError = StateError('prefs');
    final controller = HomeWidgetController(
      composer: HomeWidgetComposer(
        homeRepository: MockHomeRepository.empty(),
        mealRepository: MockMealRepository.empty(),
      ),
      bridge: bridge,
      isLoggedIn: () => false,
    );

    await controller.sync();
    expect(bridge.updates, 0);
  });
}
