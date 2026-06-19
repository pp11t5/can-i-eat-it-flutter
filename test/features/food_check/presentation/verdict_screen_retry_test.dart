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
// 에러 상태 고정 VerdictController
// ---------------------------------------------------------------------------

class _ErrorVerdictController extends VerdictController {
  @override
  AsyncValue<EatVerdict> build() =>
      AsyncValue.error(Exception('테스트 에러'), StackTrace.empty);

  @override
  Future<void> judgeByText(String text) async {}

  @override
  Future<void> judgeById(String foodExternalId, {String? displayName}) async {}
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

Widget _wrapError({String foodText = '두부'}) {
  final args = VerdictArgs(text: foodText);

  return ProviderScope(
    overrides: [
      verdictControllerProvider.overrideWith(() => _ErrorVerdictController()),
      // ignore: scoped_providers_should_specify_dependencies
      verdictHistoryRepositoryProvider
          .overrideWithValue(MockVerdictHistoryRepository()),
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
  group('VerdictScreen — 에러 상태 재시도', () {
    testWidgets('에러 상태에서 "다시 시도" 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_wrapError());
      await _settle(tester);

      expect(find.text('다시 시도'), findsOneWidget);
      expect(find.text('돌아가기'), findsOneWidget);
    });
  });
}
