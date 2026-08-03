// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/home/data/home_providers.dart';
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
  Future<List<MonthlyDay>> getMonthly(DateTime month) async => [];

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
  final invalidatedProviders = <ProviderOrFamily>[];

  @override
  ProviderContainer get container => _container;

  @override
  T read<T>(ProviderListenable<T> provider) => _container.read(provider);

  @override
  void invalidate(ProviderOrFamily provider) {
    invalidatedProviders.add(provider);
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
// BuildContext는 GoRouter 트리에서 획득한다.
// 성공 시 모달 스택을 전부 pop 하므로 셸 경로(/ 또는 /timeline)가 남는다.
// ---------------------------------------------------------------------------

Future<({_FakeRef ref, GoRouter router})> _runHandler({
  required WidgetTester tester,
  required _SpyMealRepository spy,
  required EatVerdict verdict,
  required MealRecordContext ctx,
  /// 셸 기준 경로 — 홈 `/` 또는 타임라인 `/timeline`.
  String shellLocation = '/',
  /// 유사 음식처럼 /check → /verdict → /verdict-sub 스택 위에서 호출할지.
  bool fromNestedVerdict = false,
}) async {
  final container = ProviderContainer(
    overrides: [mealRepositoryProvider.overrideWithValue(spy)],
  );
  addTearDown(container.dispose);

  // 실제 makeHandlerFromRef를 _FakeRef(container 래핑)로 호출한다.
  final ref = _FakeRef(container);
  final handler = makeHandlerFromRef(ref);

  // 중첩 자식 라우트로 스택을 만들어 canPop 이 동작하게 한다.
  // (실앱은 형제 fullscreen push 스택이지만, pop-until-shell 검증 목적엔 동일)
  List<RouteBase> modalStack() => [
        GoRoute(
          path: 'check',
          builder: (_, __) => const Scaffold(body: Text('check')),
          routes: [
            GoRoute(
              path: 'verdict',
              builder: (_, __) => const Scaffold(body: Text('verdict')),
              routes: [
                GoRoute(
                  path: 'sub',
                  builder: (_, __) =>
                      const Scaffold(body: Text('verdict-sub')),
                ),
              ],
            ),
          ],
        ),
      ];

  final nestedLocation = shellLocation == '/timeline'
      ? '/timeline/check/verdict/sub'
      : '/check/verdict/sub';

  final router = GoRouter(
    initialLocation: fromNestedVerdict ? nestedLocation : shellLocation,
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const Scaffold(body: Text('home')),
        routes: modalStack(),
      ),
      GoRoute(
        path: '/timeline',
        builder: (_, __) => const Scaffold(body: Text('timeline')),
        routes: modalStack(),
      ),
    ],
  );

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pump();

  final shellLabel = shellLocation == '/timeline' ? 'timeline' : 'home';
  final startFinder =
      fromNestedVerdict ? find.text('verdict-sub') : find.text(shellLabel);
  final context = tester.element(startFinder);
  await handler(context, verdict, ctx);

  // showAppToast: fade 250ms + 표시 2.5s + reverse 250ms.
  // AnimationController.forward().then → delayed 가 프레임 단위로 이어지므로
  // 한 번에 큰 duration 이 아니라 단계적으로 소진한다.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(seconds: 3));
  await tester.pump(const Duration(milliseconds: 300));
  return (ref: ref, router: router);
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('makeHandlerFromRef — by-id 케이스 (foodExternalId != null)', () {
    testWidgets('저장 성공 시 홈 식사 provider를 무효화한다', (tester) async {
      final result = await _runHandler(
        tester: tester,
        spy: _SpyMealRepository(),
        verdict: _kVerdictById,
        ctx: MealRecordContext(eatenAt: _kEatAt),
      );

      expect(result.ref.invalidatedProviders, contains(recentMealsProvider));
      expect(
        result.ref.invalidatedProviders,
        contains(unrecordedMealCountProvider),
      );
    });

    testWidgets('홈에서 중첩 판정 추가 후 홈(/)으로 복귀한다', (tester) async {
      final result = await _runHandler(
        tester: tester,
        spy: _SpyMealRepository(),
        verdict: _kVerdictById,
        ctx: MealRecordContext(eatenAt: _kEatAt),
        shellLocation: '/',
        fromNestedVerdict: true,
      );

      expect(result.router.state.uri.path, '/');
      expect(find.text('home'), findsOneWidget);
      expect(find.text('verdict-sub'), findsNothing);
      expect(find.text('check'), findsNothing);
    });

    testWidgets('타임라인에서 중첩 판정 추가 후 타임라인으로 복귀한다', (tester) async {
      final result = await _runHandler(
        tester: tester,
        spy: _SpyMealRepository(),
        verdict: _kVerdictById,
        ctx: MealRecordContext(eatenAt: _kEatAt),
        shellLocation: '/timeline',
        fromNestedVerdict: true,
      );

      expect(result.router.state.uri.path, '/timeline');
      expect(find.text('timeline'), findsOneWidget);
      expect(find.text('verdict-sub'), findsNothing);
      expect(find.text('check'), findsNothing);
    });

    testWidgets('appendFood가 1회 호출되고 foodExternalId·eatenAt·mealRecordId가 전달된다',
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
