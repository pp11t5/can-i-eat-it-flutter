// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/meal_recording.dart';

// ---------------------------------------------------------------------------
// Spy MealRepository — 호출 횟수·인자 기록용
// ---------------------------------------------------------------------------

class _SpyMealRepository implements MealRepository {
  String? lastFoodExternalId;
  String? lastFoodTextInput;
  DateTime? lastEatenAt;
  String? lastMealRecordId;
  int appendFoodCallCount = 0;
  int appendFoodByTextCallCount = 0;

  @override
  Future<MealFood> appendFood({
    required String foodExternalId,
    DateTime? eatenAt,
    String? mealRecordId,
  }) async {
    appendFoodCallCount++;
    lastFoodExternalId = foodExternalId;
    lastEatenAt = eatenAt;
    lastMealRecordId = mealRecordId;
    return MealFood(
      mealFoodId: 'mock-1',
      name: foodExternalId,
      eatenAt: (eatenAt ?? DateTime.now()).toIso8601String(),
      mealRecordExternalId: mealRecordId ?? 'mr-1',
    );
  }

  @override
  Future<MealFood> appendFoodByText({
    required String foodTextInput,
    DateTime? eatenAt,
    String? mealRecordId,
  }) async {
    appendFoodByTextCallCount++;
    lastFoodTextInput = foodTextInput;
    lastEatenAt = eatenAt;
    lastMealRecordId = mealRecordId;
    return MealFood(
      mealFoodId: 'mock-2',
      name: foodTextInput,
      eatenAt: (eatenAt ?? DateTime.now()).toIso8601String(),
      mealRecordExternalId: mealRecordId ?? 'mr-2',
    );
  }

  @override
  Future<List<TimelineItem>> timeline(DateTime date) async => [];

  @override
  Future<List<WeeklyDay>> weekly(DateTime date) async => [];

  @override
  Future<MealRecord> mealDetail(String mealRecordId) =>
      throw UnimplementedError();

  @override
  Future<MealFood> foodDetail(String mealFoodId) => throw UnimplementedError();

  @override
  Future<void> deleteMeal(String mealRecordId) async {}

  @override
  Future<void> deleteFood(String mealFoodId) async {}

  @override
  Future<List<MealCandidatesDay>> candidates() async => [];
}

// ---------------------------------------------------------------------------
// _FakeRef — makeHandlerFromRef가 사용하는 read/invalidate만 구현.
//
// Ref<Object?>는 abstract이므로 ProviderContainer를 래핑해 최소 구현한다.
// read()는 container에 위임, invalidate()는 no-op(테스트에서 검증 불필요).
// 나머지 abstract 메서드는 UnimplementedError(실제로 호출되지 않음).
// ---------------------------------------------------------------------------

class _FakeRef implements Ref<Object?> {
  _FakeRef(this._container);

  final ProviderContainer _container;

  @override
  ProviderContainer get container => _container;

  @override
  T read<T>(ProviderListenable<T> provider) => _container.read(provider);

  @override
  void invalidate(ProviderOrFamily provider) {
    // no-op: 테스트에서 invalidation 부작용을 검증하지 않는다.
  }

  // ---- 아래는 makeHandlerFromRef에서 호출되지 않는 메서드들 ----

  @override
  T refresh<T>(Refreshable<T> provider) => throw UnimplementedError();

  @override
  T watch<T>(ProviderListenable<T> provider) => throw UnimplementedError();

  @override
  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> provider,
    void Function(T?, T) listener, {
    bool fireImmediately = false,
    void Function(Object, StackTrace)? onError,
  }) =>
      throw UnimplementedError();

  @override
  void listenSelf(
    void Function(Object?, Object?) listener, {
    void Function(Object, StackTrace)? onError,
  }) =>
      throw UnimplementedError();

  @override
  void invalidateSelf() => throw UnimplementedError();

  @override
  void notifyListeners() => throw UnimplementedError();

  @override
  void onDispose(void Function() cb) {}

  @override
  void onCancel(void Function() cb) {}

  @override
  void onResume(void Function() cb) {}

  @override
  void onAddListener(void Function() cb) {}

  @override
  void onRemoveListener(void Function() cb) {}

  @override
  bool exists(ProviderBase<Object?> provider) => throw UnimplementedError();

  @override
  KeepAliveLink keepAlive() => throw UnimplementedError();

  bool mounted = true;
}

// ---------------------------------------------------------------------------
// 픽스처
// ---------------------------------------------------------------------------

final _kEatAt = DateTime(2026, 6, 17, 12, 30);

const _kVerdictById = EatVerdict(
  level: VerdictLevel.recommend,
  foodName: '두부',
  foodExternalId: 'food-ext-1',
);

const _kVerdictByText = EatVerdict(
  level: VerdictLevel.caution,
  foodName: '된장찌개',
  // foodExternalId null → by-text
);

// ---------------------------------------------------------------------------
// 헬퍼: 실제 makeHandlerFromRef를 _FakeRef 경유로 실행.
//
// BuildContext는 최소 위젯 트리에서 획득한다.
// ---------------------------------------------------------------------------

Future<void> _runHandler({
  required WidgetTester tester,
  required _SpyMealRepository spy,
  required EatVerdict verdict,
  required MealRecordContext ctx,
}) async {
  final container = ProviderContainer(
    overrides: [mealRepositoryProvider.overrideWithValue(spy)],
  );
  addTearDown(container.dispose);

  // 실제 makeHandlerFromRef를 _FakeRef(container 래핑)로 호출한다.
  final handler = makeHandlerFromRef(_FakeRef(container));

  bool called = false;
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Builder(
          builder: (innerCtx) {
            if (!called) {
              called = true;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await handler(innerCtx, verdict, ctx);
              });
            }
            return const Scaffold(body: SizedBox.shrink());
          },
        ),
      ),
    ),
  );
  // showAppToast 내부의 2.5초 타이머를 소진한다.
  // pumpAndSettle은 pending timer가 있으면 실패하므로 pump로 직접 진행한다.
  await tester.pump(const Duration(seconds: 3));
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('makeHandlerFromRef — by-id 케이스 (foodExternalId != null)', () {
    testWidgets(
        'appendFood가 1회 호출되고 foodExternalId·eatenAt·mealRecordId가 전달된다',
        (tester) async {
      final spy = _SpyMealRepository();
      await _runHandler(
        tester: tester,
        spy: spy,
        verdict: _kVerdictById,
        ctx: MealRecordContext(eatenAt: _kEatAt),
      );

      expect(spy.appendFoodCallCount, 1);
      expect(spy.appendFoodByTextCallCount, 0);
      expect(spy.lastFoodExternalId, 'food-ext-1');
      expect(spy.lastEatenAt, _kEatAt);
      expect(spy.lastMealRecordId, isNull);
    });

    testWidgets('mealRecordId 있으면 appendFood에 mealRecordId가 전달된다',
        (tester) async {
      final spy = _SpyMealRepository();
      await _runHandler(
        tester: tester,
        spy: spy,
        verdict: _kVerdictById,
        ctx: MealRecordContext(eatenAt: _kEatAt, mealRecordId: 'mr-42'),
      );

      expect(spy.appendFoodCallCount, 1);
      expect(spy.lastMealRecordId, 'mr-42');
    });
  });

  group('makeHandlerFromRef — by-text 케이스 (foodExternalId == null)', () {
    testWidgets(
        'appendFoodByText가 1회 호출되고 foodTextInput·eatenAt·mealRecordId가 전달된다',
        (tester) async {
      final spy = _SpyMealRepository();
      await _runHandler(
        tester: tester,
        spy: spy,
        verdict: _kVerdictByText,
        ctx: MealRecordContext(eatenAt: _kEatAt, mealRecordId: 'mr-1'),
      );

      expect(spy.appendFoodByTextCallCount, 1);
      expect(spy.appendFoodCallCount, 0);
      expect(spy.lastFoodTextInput, '된장찌개');
      expect(spy.lastEatenAt, _kEatAt);
      expect(spy.lastMealRecordId, 'mr-1');
    });

    testWidgets('mealRecordId 없으면 appendFoodByText에 mealRecordId가 전달되지 않는다',
        (tester) async {
      final spy = _SpyMealRepository();
      await _runHandler(
        tester: tester,
        spy: spy,
        verdict: _kVerdictByText,
        ctx: MealRecordContext(eatenAt: _kEatAt),
      );

      expect(spy.appendFoodByTextCallCount, 1);
      expect(spy.lastMealRecordId, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // 빈 이름 방어 (의료성 — 이름 없는 식사 기록 금지, pr-review 소소 수정 ③)
  // ---------------------------------------------------------------------------
  group('makeHandlerFromRef — foodName 빈 문자열 방어', () {
    testWidgets('foodName이 공백뿐이면 appendFoodByText를 호출하지 않는다', (tester) async {
      final spy = _SpyMealRepository();
      const blankVerdict = EatVerdict(
        level: VerdictLevel.caution,
        foodName: '   ',
        // foodExternalId null → by-text
      );

      await _runHandler(
        tester: tester,
        spy: spy,
        verdict: blankVerdict,
        ctx: MealRecordContext(eatenAt: _kEatAt),
      );

      expect(spy.appendFoodByTextCallCount, 0);
      expect(spy.appendFoodCallCount, 0);
    });

    testWidgets('foodName이 빈 문자열이면 appendFoodByText를 호출하지 않는다', (tester) async {
      final spy = _SpyMealRepository();
      const emptyVerdict = EatVerdict(
        level: VerdictLevel.caution,
        foodName: '',
      );

      await _runHandler(
        tester: tester,
        spy: spy,
        verdict: emptyVerdict,
        ctx: MealRecordContext(eatenAt: _kEatAt),
      );

      expect(spy.appendFoodByTextCallCount, 0);
      expect(spy.appendFoodCallCount, 0);
    });
  });
}
