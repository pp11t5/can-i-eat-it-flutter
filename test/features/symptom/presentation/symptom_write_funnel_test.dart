import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/core/analytics/analytics_service.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/food_dictionary_providers.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/repositories/mock_dictionary_repository.dart';
import 'package:can_i_eat_it/features/home/data/home_providers.dart';
import 'package:can_i_eat_it/features/home/data/repositories/mock_home_repository.dart';
import 'package:can_i_eat_it/features/home/domain/entities/user_streak.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_controller.dart';
import 'package:can_i_eat_it/features/home_widget/data/home_widget_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/data/repositories/mock_symptom_repository.dart';
import 'package:can_i_eat_it/features/symptom/data/symptom_providers.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';
import 'package:can_i_eat_it/features/symptom/domain/repositories/symptom_repository.dart';
import 'package:can_i_eat_it/features/symptom/presentation/providers/symptom_write_controller.dart';

class _SpyAnalyticsService implements AnalyticsService {
  final List<String> funnelNames = [];

  @override
  Future<void> logFunnel(
    FunnelEvent event, {
    Map<String, Object?> params = const {},
  }) async {
    funnelNames.add(event.eventName);
  }

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> params = const {},
  }) async {}

  @override
  Future<void> setUserId(String? userId) async {}
}

class _ThrowingSymptomRepository implements SymptomRepository {
  @override
  Future<Symptom> create(SymptomDraft draft) =>
      throw Exception('create failed');

  @override
  Future<Symptom> detail(String symptomId) => throw UnimplementedError();

  @override
  Future<void> update(String symptomId, SymptomDraft draft) =>
      throw UnimplementedError();

  @override
  Future<void> updateMemo(String symptomId, String? memo) =>
      throw UnimplementedError();

  @override
  Future<void> delete(String symptomId) => throw UnimplementedError();
}

class _CountingHomeRepository extends MockHomeRepository {
  int calls = 0;

  @override
  Future<UserStreak> myStreak() async => UserStreak(streak: ++calls);
}

class _NoopHomeWidgetController implements HomeWidgetController {
  @override
  Future<void> sync() async {}
}

SymptomWriteFormState _form() => SymptomWriteFormState(
      mood: SymptomState.normal,
      occurredAt: DateTime(2026, 6, 17, 14, 30),
    );

ProviderContainer _container({
  required SymptomRepository repo,
  required _SpyAnalyticsService analytics,
  MockHomeRepository? homeRepository,
}) {
  final container = ProviderContainer(
    overrides: [
      symptomRepositoryProvider.overrideWithValue(repo),
      analyticsServiceProvider.overrideWithValue(analytics),
      // submit 성공 시 invalidate 되는 경로가 실 네트워크/플러그인을 타지 않게 한다.
      homeRepositoryProvider
          .overrideWithValue(homeRepository ?? MockHomeRepository.empty()),
      if (homeRepository != null)
        homeWidgetControllerProvider
            .overrideWithValue(_NoopHomeWidgetController()),
      mealRepositoryProvider.overrideWithValue(MockMealRepository.empty()),
      dictionaryRepositoryProvider.overrideWithValue(
        MockDictionaryRepository.empty(),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('SymptomWriteController — 홈 스트릭 갱신', () {
    for (final symptomId in [null, 'symptom-001']) {
      test('${symptomId == null ? '저장' : '수정'} 성공 직후 홈 스트릭을 재조회한다', () async {
        final home = _CountingHomeRepository();
        final container = _container(
          repo: MockSymptomRepository.seeded(),
          analytics: _SpyAnalyticsService(),
          homeRepository: home,
        );
        final subscription = container.listen(myStreakProvider, (_, __) {});
        addTearDown(subscription.close);
        expect((await container.read(myStreakProvider.future)).streak, 1);

        final result = await container
            .read(symptomWriteControllerProvider(symptomId).notifier)
            .submit(_form());

        expect(result, isNotNull);
        expect((await container.read(myStreakProvider.future)).streak, 2);
        expect(home.calls, 2);
      });

      test('${symptomId == null ? '저장' : '수정'} 실패 시 홈 스트릭을 갱신하지 않는다', () async {
        final home = _CountingHomeRepository();
        final container = _container(
          repo: _ThrowingSymptomRepository(),
          analytics: _SpyAnalyticsService(),
          homeRepository: home,
        );
        final subscription = container.listen(myStreakProvider, (_, __) {});
        addTearDown(subscription.close);
        await container.read(myStreakProvider.future);

        final result = await container
            .read(symptomWriteControllerProvider(symptomId).notifier)
            .submit(_form());

        expect(result, isNull);
        expect((await container.read(myStreakProvider.future)).streak, 1);
        expect(home.calls, 1);
      });
    }
  });

  group('SymptomWriteController — symptom_response 퍼널', () {
    test('직접 신규 생성은 symptom_response 를 보내지 않는다', () async {
      final analytics = _SpyAnalyticsService();
      final container = _container(
        repo: MockSymptomRepository.empty(),
        analytics: analytics,
      );

      await container
          .read(symptomWriteControllerProvider(null).notifier)
          .submit(_form());

      expect(analytics.funnelNames, isEmpty);
    });

    test('식후 알림으로 연 신규 생성은 symptom_response 를 보낸다', () async {
      final analytics = _SpyAnalyticsService();
      final container = _container(
        repo: MockSymptomRepository.empty(),
        analytics: analytics,
      );

      await container
          .read(symptomWriteControllerProvider(null).notifier)
          .submit(_form(), fromPush: true);

      expect(analytics.funnelNames, [FunnelEvent.symptomResponse.eventName]);
    });

    test('수정 성공 시 symptom_response 를 발화하지 않는다', () async {
      final analytics = _SpyAnalyticsService();
      final container = _container(
        repo: MockSymptomRepository.seeded(),
        analytics: analytics,
      );

      await container
          .read(symptomWriteControllerProvider('symptom-001').notifier)
          .submit(_form(), fromPush: true);

      expect(analytics.funnelNames, isEmpty);
    });

    test('생성 실패 시 symptom_response 를 발화하지 않는다', () async {
      final analytics = _SpyAnalyticsService();
      final container = _container(
        repo: _ThrowingSymptomRepository(),
        analytics: analytics,
      );

      await container
          .read(symptomWriteControllerProvider(null).notifier)
          .submit(_form(), fromPush: true);

      expect(analytics.funnelNames, isEmpty);
    });
  });
}
