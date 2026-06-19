import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/food_check/presentation/providers/add_to_diet_handler_provider.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_screen.dart';
import 'package:can_i_eat_it/features/verdict_history/data/repositories/mock_verdict_history_repository.dart';
import 'package:can_i_eat_it/features/verdict_history/data/verdict_history_providers.dart';

// ---------------------------------------------------------------------------
// 고정 상태 VerdictController
// ---------------------------------------------------------------------------

/// VerdictController를 고정 AsyncData 상태로 override하는 notifier.
/// 실제 API 호출 없이 특정 판정 결과를 주입할 때 사용한다.
class _FixedVerdictController extends VerdictController {
  _FixedVerdictController(this._fixed);
  final EatVerdict _fixed;

  @override
  AsyncValue<EatVerdict> build() => AsyncValue.data(_fixed);
}

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

GoRouter _testRouter(VerdictArgs args) => GoRouter(
      initialLocation: '/verdict',
      routes: [
        GoRoute(
          path: '/verdict',
          builder: (_, __) => VerdictScreen(args: args),
        ),
        GoRoute(
          path: '/check',
          builder: (_, __) => const Scaffold(body: Text('check stub')),
        ),
      ],
    );

Widget _wrap({
  required EatVerdict verdict,
  required MockVerdictHistoryRepository historyRepo,
  String foodText = '두부',
}) {
  final args = VerdictArgs(text: foodText); // externalId=null → isById=false

  return ProviderScope(
    overrides: [
      // 판정 컨트롤러: 고정 상태(실제 API 호출 없음)
      verdictControllerProvider
          .overrideWith(() => _FixedVerdictController(verdict)),
      // ignore: scoped_providers_should_specify_dependencies
      verdictHistoryRepositoryProvider.overrideWithValue(historyRepo),
      // addToDietHandler: null (이 테스트에서는 식단 추가 불필요)
      // ignore: scoped_providers_should_specify_dependencies
      addToDietHandlerProvider.overrideWithValue(null),
    ],
    child: MaterialApp.router(routerConfig: _testRouter(args)),
  );
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('VerdictScreen — 이력 저장 로직 (F11 버그 수정)', () {
    testWidgets('unknown 판정은 이력에 저장되지 않는다', (tester) async {
      final repo = MockVerdictHistoryRepository();

      await tester.pumpWidget(_wrap(
        verdict: EatVerdict.unknown(foodName: '정체불명'),
        historyRepo: repo,
        foodText: '정체불명',
      ));
      await _settle(tester);

      final items = await repo.getHistory();
      expect(items, isEmpty,
          reason: 'unknown 판정은 이력에 저장되지 않아야 한다');
    });

    testWidgets('recommend 판정은 verdict=safe 로 이력에 저장된다', (tester) async {
      final repo = MockVerdictHistoryRepository();

      await tester.pumpWidget(_wrap(
        verdict: EatVerdict.recommend(foodName: '두부'),
        historyRepo: repo,
        foodText: '두부',
      ));
      await _settle(tester);

      final items = await repo.getHistory();
      expect(items.length, 1);
      expect(items.first.foodName, '두부');
      expect(items.first.verdict, 'safe');
    });

    testWidgets('caution 판정은 verdict=caution 으로 이력에 저장된다', (tester) async {
      final repo = MockVerdictHistoryRepository();

      await tester.pumpWidget(_wrap(
        verdict: EatVerdict.caution(foodName: '된장찌개'),
        historyRepo: repo,
        foodText: '된장찌개',
      ));
      await _settle(tester);

      final items = await repo.getHistory();
      expect(items.length, 1);
      expect(items.first.verdict, 'caution');
    });

    testWidgets('risk 판정은 verdict=avoid 로 이력에 저장된다', (tester) async {
      final repo = MockVerdictHistoryRepository();

      await tester.pumpWidget(_wrap(
        verdict: EatVerdict.risk(foodName: '커피'),
        historyRepo: repo,
        foodText: '커피',
      ));
      await _settle(tester);

      final items = await repo.getHistory();
      expect(items.length, 1);
      expect(items.first.verdict, 'avoid');
    });

    testWidgets('동일 화면 리빌드 시 이력이 중복 저장되지 않는다 (_historyAdded 플래그)',
        (tester) async {
      final repo = MockVerdictHistoryRepository();

      await tester.pumpWidget(_wrap(
        verdict: EatVerdict.recommend(foodName: '두부'),
        historyRepo: repo,
      ));
      // 복수 settle — 리빌드 시뮬레이션
      await _settle(tester);
      await _settle(tester);

      final items = await repo.getHistory();
      expect(items.length, 1,
          reason: '_historyAdded 플래그로 같은 인스턴스에서는 1회만 저장된다');
    });
  });
}
