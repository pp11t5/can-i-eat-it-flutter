import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_coordinator.dart';
import 'package:can_i_eat_it/features/home_widget/domain/home_widget_deep_link.dart';

void main() {
  test('ready면 위젯 URI를 즉시 연다', () {
    final opened = <String>[];
    final coordinator = HomeWidgetCoordinator(
      initialStatus: SessionStatus.ready,
      onNavigate: opened.add,
      onGo: (_) {},
      onSync: () {},
    );

    coordinator.handleUri(HomeWidgetDeepLink.mealRecord());

    expect(opened, ['/meal/record']);
  });

  test('미인증이면 목적지를 보관하고 로그인으로 보낸다', () {
    final opened = <String>[];
    final gone = <String>[];
    final coordinator = HomeWidgetCoordinator(
      initialStatus: SessionStatus.unauthenticated,
      onNavigate: opened.add,
      onGo: gone.add,
      onSync: () {},
    );

    coordinator.handleUri(HomeWidgetDeepLink.foodHistory());
    expect(opened, isEmpty);
    expect(gone, ['/login']);

    coordinator.onSessionStatusChanged(SessionStatus.ready);
    expect(opened, ['/food-history']);
  });
}
