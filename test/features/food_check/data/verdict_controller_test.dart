import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/analytics/analytics_service.dart';
import 'package:can_i_eat_it/core/analytics/funnel_once_store.dart';
import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_repository.dart';

ProviderContainer _makeContainer({FoodRepository? repo}) {
  return ProviderContainer(
    overrides: [
      if (repo != null) foodRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

void main() {
  group('VerdictController', () {
    test('초기 상태는 AsyncData(unknown, foodName: "")', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final state = container.read(verdictControllerProvider);
      expect(state, isA<AsyncData<EatVerdict>>());
      expect(state.value!.level, VerdictLevel.unknown);
      expect(state.value!.foodName, '');
    });

    test('judgeByText("두부") → recommend 반환 (AsyncData)', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('두부');

      final state = container.read(verdictControllerProvider);
      expect(state, isA<AsyncData<EatVerdict>>());
      expect(state.value!.level, VerdictLevel.recommend);
      expect(state.value!.foodName, '두부');
    });

    test('judgeByText("커피") → risk 반환 (AsyncData)', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('커피');

      final state = container.read(verdictControllerProvider);
      expect(state.value!.level, VerdictLevel.risk);
    });

    test('judgeByText("된장찌개") → caution 반환 (AsyncData)', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('된장찌개');

      final state = container.read(verdictControllerProvider);
      expect(state.value!.level, VerdictLevel.caution);
    });

    test('judgeByText("unknown") → unknown 반환 (AsyncData — 성공 응답, D1)',
        () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('unknown');

      final state = container.read(verdictControllerProvider);
      // grade=UNKNOWN은 AsyncData (성공) — AsyncError로 흘리면 안 됨 (D1, R3)
      expect(state, isA<AsyncData<EatVerdict>>());
      expect(state.value!.level, VerdictLevel.unknown);
    });

    test('judgeById("food-ext-1") → EatVerdict 반환 (AsyncData)', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeById('food-ext-1');

      final state = container.read(verdictControllerProvider);
      expect(state, isA<AsyncData<EatVerdict>>());
    });

    test('reset() 후 초기 idle 상태로 복귀', () async {
      final container = _makeContainer(repo: MockFoodRepository.empty());
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('두부');
      container.read(verdictControllerProvider.notifier).reset();

      final state = container.read(verdictControllerProvider);
      expect(state.value!.level, VerdictLevel.unknown);
      expect(state.value!.foodName, '');
    });

    test('중첩 ProviderScope의 판정 결과는 기존 화면 상태를 덮어쓰지 않는다', () async {
      final root = _makeContainer(repo: MockFoodRepository.empty());
      final nested = ProviderContainer(
        parent: root,
        overrides: [
          verdictControllerProvider.overrideWith(VerdictController.new),
        ],
      );
      addTearDown(nested.dispose);
      addTearDown(root.dispose);

      await root.read(verdictControllerProvider.notifier).judgeByText('커피');
      await nested.read(verdictControllerProvider.notifier).judgeByText('두부');

      expect(root.read(verdictControllerProvider).value!.foodName, '커피');
      expect(nested.read(verdictControllerProvider).value!.foodName, '두부');
    });

    test('저장소 예외 → AsyncError 반환 (분석실패 경로)', () async {
      final failingRepo = _FailingFoodRepository();
      final container = _makeContainer(repo: failingRepo);
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('아무거나');

      final state = container.read(verdictControllerProvider);
      // 에러는 AsyncError — grade=UNKNOWN(AsyncData)과 다른 경로 (D1, R3)
      expect(state, isA<AsyncError<EatVerdict>>());
    });

    test('FOOD 에러 Failure → AsyncError에 Failure 타입이 담긴다', () async {
      final failingRepo = _FailingWithFailureRepository();
      final container = _makeContainer(repo: failingRepo);
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('아무거나');

      final state = container.read(verdictControllerProvider);
      expect(state, isA<AsyncError<EatVerdict>>());
      expect(state.error, isA<FoodNotFoundFailure>());
    });
  });

  group('VerdictController — 판정 이벤트', () {
    test('세션이 없으면 first_verdict_checked 만 보낸다', () async {
      final analytics = _SpyAnalytics();
      final container = _analyticsContainer(analytics: analytics);
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('두부');

      expect(analytics.funnelNames, ['first_verdict_checked']);
      expect(analytics.events, isEmpty);
      expect(analytics.funnelParams.single['level'], 'recommend');
      expect(analytics.funnelParams.single['food_name'], '두부');
    });

    test('계정의 첫 성공은 두 이벤트를 보내고 다음은 first_verdict_checked 만 보낸다', () async {
      final analytics = _SpyAnalytics();
      final container = _analyticsContainer(
        analytics: analytics,
        userId: 'user-1',
      );
      addTearDown(container.dispose);
      final notifier = container.read(verdictControllerProvider.notifier);

      await notifier.judgeByText('두부');
      await notifier.judgeById('food-ext-1', displayName: '커피');

      expect(analytics.funnelNames, [
        'first_verdict_checked',
        'account_first_verdict_checked',
        'first_verdict_checked',
      ]);
      expect(analytics.events, isEmpty);
      expect(analytics.funnelParams[0]['level'], 'recommend');
      expect(analytics.funnelParams[0]['food_name'], '두부');
      expect(analytics.funnelParams[1]['food_name'], '두부');
      expect(analytics.funnelParams[2]['level'], 'recommend');
      expect(analytics.funnelParams[2]['food_name'], '커피');
    });

    test('unknown 성공도 첫 판정으로 센다', () async {
      final analytics = _SpyAnalytics();
      final container = _analyticsContainer(
        analytics: analytics,
        userId: 'user-1',
      );
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('unknown');

      expect(analytics.funnelNames, [
        'first_verdict_checked',
        'account_first_verdict_checked',
      ]);
      expect(
          analytics.funnelParams.every((p) => p['level'] == 'unknown'), isTrue);
    });

    test('판정 실패는 이벤트를 보내지 않는다', () async {
      final analytics = _SpyAnalytics();
      final container = _analyticsContainer(
        analytics: analytics,
        userId: 'user-1',
        repo: _FailingFoodRepository(),
      );
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('아무거나');

      expect(analytics.funnelNames, isEmpty);
      expect(analytics.events, isEmpty);
    });

    test('1회 저장이 실패해도 first_verdict_checked 는 보내고 판정 결과는 유지한다', () async {
      final analytics = _SpyAnalytics();
      final container = _analyticsContainer(
        analytics: analytics,
        userId: 'user-1',
        store: _ThrowingOnceStore(),
      );
      addTearDown(container.dispose);

      await container
          .read(verdictControllerProvider.notifier)
          .judgeByText('두부');

      expect(
        container.read(verdictControllerProvider).value!.foodName,
        '두부',
      );
      expect(analytics.funnelNames, ['first_verdict_checked']);
      expect(analytics.events, isEmpty);
      expect(analytics.funnelParams.single['level'], 'recommend');
    });
  });
}

class _SpyAnalytics implements AnalyticsService {
  final List<String> funnelNames = [];
  final List<Map<String, Object?>> funnelParams = [];
  final List<({String name, Map<String, Object?> params})> events = [];

  @override
  Future<void> logFunnel(
    FunnelEvent event, {
    Map<String, Object?> params = const {},
  }) async {
    funnelNames.add(event.eventName);
    funnelParams.add(params);
  }

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> params = const {},
  }) async {
    events.add((name: name, params: params));
  }

  @override
  Future<void> setUserId(String? userId) async {}
}

ProviderContainer _analyticsContainer({
  required _SpyAnalytics analytics,
  String? userId,
  FoodRepository? repo,
  FunnelOnceStore? store,
}) {
  return ProviderContainer(
    overrides: [
      foodRepositoryProvider.overrideWithValue(
        repo ?? MockFoodRepository.empty(),
      ),
      analyticsServiceProvider.overrideWithValue(analytics),
      if (userId != null) analyticsSubjectIdProvider.overrideWithValue(userId),
      funnelOnceStoreProvider.overrideWithValue(
        store ?? InMemoryFunnelOnceStore(),
      ),
    ],
  );
}

class _ThrowingOnceStore implements FunnelOnceStore {
  @override
  Future<void> clear(String userId) async {}

  @override
  Future<bool> hasFired(String userId, FunnelEvent event) async {
    throw Exception('store down');
  }

  @override
  Future<void> markFired(String userId, FunnelEvent event) async {}
}

/// judgeByText/judgeById 모두 예외를 던지는 테스트 전용 저장소.
class _FailingFoodRepository extends MockFoodRepository {
  @override
  Future<EatVerdict> judgeByText(String foodTextInput) async {
    throw Exception('서버 오류');
  }

  @override
  Future<EatVerdict> judgeById(String foodExternalId) async {
    throw Exception('서버 오류');
  }
}

/// FoodNotFoundFailure를 던지는 테스트 전용 저장소.
class _FailingWithFailureRepository extends MockFoodRepository {
  @override
  Future<EatVerdict> judgeByText(String foodTextInput) async {
    throw const FoodNotFoundFailure();
  }

  @override
  Future<EatVerdict> judgeById(String foodExternalId) async {
    throw const FoodNotFoundFailure();
  }
}
