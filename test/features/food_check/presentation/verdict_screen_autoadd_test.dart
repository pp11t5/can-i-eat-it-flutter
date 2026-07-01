import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_screen.dart';

/// [addRecent] 호출을 기록하는 스파이 저장소.
///
/// 판정(judgeByText/judgeById)은 [MockFoodRepository]의 결정론적 키워드 로직을
/// 그대로 상속해 사용한다. addRecent만 오버라이드해 호출 횟수·인자를 기록한다.
class _SpyFoodRepository extends MockFoodRepository {
  final List<String> addRecentCalls = [];

  @override
  Future<void> addRecent(String foodExternalId) async {
    addRecentCalls.add(foodExternalId);
  }
}

Widget _wrapVerdict(_SpyFoodRepository repo, VerdictArgs args) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      foodRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: VerdictScreen(args: args),
    ),
  );
}

void main() {
  group('VerdictScreen — 도감 자동추가', () {
    testWidgets(
      'by-id + 판정 성공(recommend) → addRecent 1회 호출 + 토스트 표시',
      (tester) async {
        final repo = _SpyFoodRepository();
        await tester.pumpWidget(
          _wrapVerdict(
            repo,
            const VerdictArgs(text: '두부', externalId: 'food-ext-1'),
          ),
        );
        await tester.pumpAndSettle();

        expect(repo.addRecentCalls, ['food-ext-1']);
        expect(find.text('내 도감에 담았어요'), findsOneWidget);

        // 토스트 생명주기 전체 소진 (등장 250ms + 표시 2500ms + 퇴장 250ms + 여유).
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 2600));
        await tester.pump(const Duration(milliseconds: 300));
      },
    );

    testWidgets(
      'by-id + 판정 성공(caution) → addRecent 1회 호출',
      (tester) async {
        final repo = _SpyFoodRepository();
        await tester.pumpWidget(
          _wrapVerdict(
            repo,
            const VerdictArgs(text: '된장찌개', externalId: 'caution-된장-ext'),
          ),
        );
        await tester.pumpAndSettle();

        expect(repo.addRecentCalls, ['caution-된장-ext']);

        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 2600));
        await tester.pump(const Duration(milliseconds: 300));
      },
    );

    testWidgets(
      'by-id + 판정 성공(risk) → addRecent 1회 호출',
      (tester) async {
        final repo = _SpyFoodRepository();
        await tester.pumpWidget(
          _wrapVerdict(
            repo,
            const VerdictArgs(text: '커피', externalId: 'risk-커피-ext'),
          ),
        );
        await tester.pumpAndSettle();

        expect(repo.addRecentCalls, ['risk-커피-ext']);

        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 2600));
        await tester.pump(const Duration(milliseconds: 300));
      },
    );

    testWidgets('by-text 진입 → addRecent 미호출', (tester) async {
      final repo = _SpyFoodRepository();
      await tester.pumpWidget(
        _wrapVerdict(
          repo,
          const VerdictArgs(text: '두부'), // externalId 없음 → by-text
        ),
      );
      await tester.pumpAndSettle();

      expect(repo.addRecentCalls, isEmpty);
      expect(find.text('내 도감에 담았어요'), findsNothing);
    });

    testWidgets('by-id + unknown 판정 → addRecent 미호출', (tester) async {
      final repo = _SpyFoodRepository();
      await tester.pumpWidget(
        _wrapVerdict(
          repo,
          const VerdictArgs(text: '모름음식', externalId: 'unknown'),
        ),
      );
      await tester.pumpAndSettle();

      expect(repo.addRecentCalls, isEmpty);
      expect(find.text('내 도감에 담았어요'), findsNothing);
    });
  });
}
