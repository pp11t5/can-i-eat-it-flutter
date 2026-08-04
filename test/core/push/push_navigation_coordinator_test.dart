import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/push/push_navigation_coordinator.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';

const _firstPostMealData = {'type': 'post_meal', 'targetId': 'meal-123'};
const _latestPostMealData = {'type': 'post_meal', 'targetId': 'meal-456'};
const _weeklyReportData = {'type': 'weekly_report'};
const _unrecordedMealsData = {'type': 'post_meal_delayed_bulk'};

void main() {
  group('PushNavigationCoordinator', () {
    test('ready 상태에서는 즉시 증상 작성 화면으로 이동한다', () {
      final pushed = <String>[];
      final coordinator = PushNavigationCoordinator(
        initialStatus: SessionStatus.ready,
        onPush: pushed.add,
        onGo: (_) {},
      );

      coordinator.handleData(_firstPostMealData);

      expect(pushed, ['/symptom/record?mealRecordId=meal-123']);
    });

    test('ready 상태에서는 즉시 주간 리포트 화면으로 이동한다', () {
      final pushed = <String>[];
      final coordinator = PushNavigationCoordinator(
        initialStatus: SessionStatus.ready,
        onPush: pushed.add,
        onGo: (_) {},
      );

      coordinator.handleData(_weeklyReportData);

      expect(pushed, ['/weekly-report']);
    });

    test('ready 상태에서는 즉시 미기록 식사 목록으로 이동한다', () {
      final pushed = <String>[];
      final coordinator = PushNavigationCoordinator(
        initialStatus: SessionStatus.ready,
        onPush: pushed.add,
        onGo: (_) {},
      );

      coordinator.handleData(_unrecordedMealsData);

      expect(pushed, ['/unrecorded-meals']);
    });

    test('미인증 탭은 로그인 후 목적지를 한 번 재생한다', () {
      final pushed = <String>[];
      final replaced = <String>[];
      final coordinator = PushNavigationCoordinator(
        initialStatus: SessionStatus.unauthenticated,
        onPush: pushed.add,
        onGo: replaced.add,
      );

      coordinator.handleLocalPayload(
        '{"type":"post_meal","targetId":"meal-123"}',
      );
      coordinator.onSessionStatusChanged(SessionStatus.ready);
      coordinator.onSessionStatusChanged(SessionStatus.ready);

      expect(replaced, ['/login']);
      expect(pushed, ['/symptom/record?mealRecordId=meal-123']);
    });

    test('미인증 주간 리포트 탭은 로그인 후 목적지를 한 번 재생한다', () {
      final pushed = <String>[];
      final replaced = <String>[];
      final coordinator = PushNavigationCoordinator(
        initialStatus: SessionStatus.unauthenticated,
        onPush: pushed.add,
        onGo: replaced.add,
      );

      coordinator.handleLocalPayload('{"type":"weekly_report"}');
      coordinator.onSessionStatusChanged(SessionStatus.ready);
      coordinator.onSessionStatusChanged(SessionStatus.ready);

      expect(replaced, ['/login']);
      expect(pushed, ['/weekly-report']);
    });

    test('미인증 미기록 식사 목록 탭은 로그인 후 목적지를 한 번 재생한다', () {
      final pushed = <String>[];
      final replaced = <String>[];
      final coordinator = PushNavigationCoordinator(
        initialStatus: SessionStatus.unauthenticated,
        onPush: pushed.add,
        onGo: replaced.add,
      );

      coordinator.handleLocalPayload('{"type":"post_meal_delayed_bulk"}');
      coordinator.onSessionStatusChanged(SessionStatus.ready);
      coordinator.onSessionStatusChanged(SessionStatus.ready);

      expect(replaced, ['/login']);
      expect(pushed, ['/unrecorded-meals']);
    });

    test('게이트 대기 중 여러 탭은 최신 목적지만 재생한다', () {
      final pushed = <String>[];
      final coordinator = PushNavigationCoordinator(
        initialStatus: SessionStatus.loading,
        onPush: pushed.add,
        onGo: (_) {},
      );

      coordinator.handleData(_firstPostMealData);
      coordinator.handleData(_latestPostMealData);
      coordinator.onSessionStatusChanged(SessionStatus.needsOnboarding);
      coordinator.onSessionStatusChanged(SessionStatus.ready);

      expect(pushed, ['/symptom/record?mealRecordId=meal-456']);
    });

    test('지원하지 않는 payload는 네비게이션하지 않는다', () {
      final pushed = <String>[];
      final replaced = <String>[];
      final coordinator = PushNavigationCoordinator(
        initialStatus: SessionStatus.ready,
        onPush: pushed.add,
        onGo: replaced.add,
      );

      coordinator.handleData({'type': 'unsupported'});

      expect(pushed, isEmpty);
      expect(replaced, isEmpty);
    });
  });
}
