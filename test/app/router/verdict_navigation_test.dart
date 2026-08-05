import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/router/app_router.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_screen.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';

class _SubstituteFoodRepository extends MockFoodRepository {
  @override
  Future<EatVerdict> judgeById(String foodExternalId) async {
    return switch (foodExternalId) {
      'chicken' => EatVerdict.caution(foodName: '치킨').copyWith(
          substitutes: const [
            VerdictSubstitute(foodExternalId: 'baeksuk', name: '닭백숙'),
          ],
        ),
      'baeksuk' => EatVerdict.recommend(foodName: '닭백숙'),
      _ => super.judgeById(foodExternalId),
    };
  }
}

void main() {
  Widget buildApp() => ProviderScope(
        overrides: [
          // ignore: scoped_providers_should_specify_dependencies
          authRepositoryProvider
              .overrideWithValue(MockAuthRepository.existing(onboarded: true)),
          // ignore: scoped_providers_should_specify_dependencies
          healthProfileRepositoryProvider
              .overrideWithValue(MockHealthProfileRepository.completed()),
          // ignore: scoped_providers_should_specify_dependencies
          foodRepositoryProvider.overrideWithValue(_SubstituteFoodRepository()),
        ],
        child: Consumer(
          builder: (context, ref, _) => MaterialApp.router(
            routerConfig: ref.watch(appRouterProvider),
          ),
        ),
      );

  testWidgets('대체 음식 가이드에서 뒤로가면 원래 가이드가 복원된다', (tester) async {
    // 로딩 최소 5초 대기는 이 네비게이션 시나리오와 무관 — 즉시 결과로 진행.
    final originalMinLoading = VerdictScreen.minLoadingDuration;
    VerdictScreen.minLoadingDuration = Duration.zero;
    addTearDown(() {
      VerdictScreen.minLoadingDuration = originalMinLoading;
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('카카오로 로그인'));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(HomeScreen));
    GoRouter.of(context).push(
      '/verdict',
      extra: const VerdictArgs(externalId: 'chicken', text: '치킨'),
    );
    await tester.pumpAndSettle();
    expect(find.text('치킨'), findsOneWidget);

    await tester.ensureVisible(find.text('닭백숙'));
    await tester.tap(find.text('닭백숙'));
    await tester.pumpAndSettle();
    expect(find.text('닭백숙'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('뒤로'));
    await tester.pumpAndSettle();
    expect(find.text('치킨'), findsOneWidget);
    expect(find.text('닭백숙'), findsOneWidget);
  });
}
