import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/home/data/home_providers.dart';
import 'package:can_i_eat_it/features/home/data/repositories/mock_home_repository.dart';
import 'package:can_i_eat_it/features/home/domain/entities/recent_meal.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';
import 'package:can_i_eat_it/features/mypage/data/my_page_providers.dart';
import 'package:can_i_eat_it/features/mypage/data/repositories/mock_my_page_repository.dart';

/// 테스트용 래퍼. mySummaryProvider(streak)·homeRepositoryProvider(미기록·최근식사)를
/// 결정적 Mock으로 override한다(W7 — 실제 Dio 호출 방지).
Widget _wrap({bool withData = false}) => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        myPageRepositoryProvider.overrideWithValue(
          withData
              ? MockMyPageRepository.seeded()
              : MockMyPageRepository.empty(),
        ),
        // ignore: scoped_providers_should_specify_dependencies
        homeRepositoryProvider.overrideWithValue(
          withData ? MockHomeRepository.seeded() : MockHomeRepository.empty(),
        ),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );

/// 네비게이션 검증용 최소 GoRouter — symptom_detail_screen_test.dart의
/// `_testRouter` 패턴을 재사용(스텁 라우트로 push 목적지만 확인).
GoRouter _testRouter() => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          path: '/unrecorded-meals',
          builder: (_, __) =>
              const Scaffold(body: Text('unrecorded-meals-stub')),
        ),
        GoRoute(
          path: '/food-history',
          builder: (_, __) => const Scaffold(body: Text('food-history-stub')),
        ),
      ],
    );

Widget _wrapWithRouter() => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        myPageRepositoryProvider.overrideWithValue(
          MockMyPageRepository.empty(),
        ),
        // ignore: scoped_providers_should_specify_dependencies
        homeRepositoryProvider.overrideWithValue(MockHomeRepository.empty()),
      ],
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

void main() {
  group('HomeScreen — 인사말 블록', () {
    testWidgets('"편안하신가요?" 인사말 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('편안하신가요?'), findsOneWidget);
    });

    testWidgets('"연속 편안한 날" streak 텍스트가 인사말 블록에 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // Text.rich 로 렌더링되므로 textContaining 으로 확인
      expect(find.textContaining('연속 편안한 날'), findsOneWidget);
    });

    testWidgets('구 인사말 "이거 먹어도 돼?"는 표시되지 않는다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('이거 먹어도 돼?'), findsNothing);
    });
  });

  group('HomeScreen — 검색 바', () {
    testWidgets('"이 음식 먹어도 돼?" 플레이스홀더가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('이 음식 먹어도 돼?'), findsOneWidget);
    });

    testWidgets('검색 바가 화면에 존재한다 (tappable)', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // HomeSearchBar 위젯 자체가 렌더링되어 있어야 한다.
      expect(find.text('이 음식 먹어도 돼?'), findsOneWidget);
    });
  });

  group('HomeScreen — 제안 칩', () {
    testWidgets('"된장찌개" 칩이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('된장찌개'), findsOneWidget);
    });

    testWidgets('"아메리카노" 칩이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('아메리카노'), findsOneWidget);
    });

    testWidgets('"김치볶음밥" 칩이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('김치볶음밥'), findsOneWidget);
    });
  });

  group('HomeScreen — 2-up 진입 카드', () {
    testWidgets('"증상 기록하기" 카드 타이틀 + "미기록 식단 0" 부제가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('증상 기록하기'), findsOneWidget);
      expect(find.text('미기록 식단 0'), findsOneWidget);
    });

    testWidgets('"음식 히스토리" 카드 타이틀 + "식단과 증상 요약" 부제가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('음식 히스토리'), findsOneWidget);
      expect(find.text('식단과 증상 요약'), findsOneWidget);
    });

    testWidgets('unrecordedMealCountProvider 실카운트로 "미기록 식단 N" 배지가 표시된다',
        (tester) async {
      await tester.pumpWidget(_wrap(withData: true));
      await tester.pumpAndSettle();

      // MockHomeRepository.seeded() — unrecordedCount:2.
      expect(find.text('미기록 식단 2'), findsOneWidget);
    });
  });

  group('HomeScreen — 인사말 블록 streak 실데이터', () {
    testWidgets('mySummaryProvider seeded 값이면 "4일"이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(withData: true));
      await tester.pumpAndSettle();

      // MockMyPageRepository.seeded() — weeklySummary.streakCount:4.
      expect(find.textContaining('4일'), findsOneWidget);
    });
  });

  group('HomeScreen — 2-up 진입 카드 네비게이션', () {
    testWidgets('"증상 기록하기" 카드 탭 → /unrecorded-meals로 push', (tester) async {
      await tester.pumpWidget(_wrapWithRouter());
      await tester.pumpAndSettle();

      await tester.tap(find.text('증상 기록하기'));
      await tester.pumpAndSettle();

      expect(find.text('unrecorded-meals-stub'), findsOneWidget);
    });

    testWidgets('"음식 히스토리" 카드 탭 → /food-history로 push', (tester) async {
      await tester.pumpWidget(_wrapWithRouter());
      await tester.pumpAndSettle();

      await tester.tap(find.text('음식 히스토리'));
      await tester.pumpAndSettle();

      expect(find.text('food-history-stub'), findsOneWidget);
    });
  });

  group('HomeScreen — 최근 식사 섹션', () {
    testWidgets('"최근 식사" 섹션 헤더가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('최근 식사'), findsOneWidget);
    });

    testWidgets('"먹은 음식이 있으신가요?" 플레이스홀더가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('먹은 음식이 있으신가요?'), findsOneWidget);
    });

    testWidgets('recentMealsProvider 데이터가 있으면 실제 목록으로 교체되고 placeholder는 사라진다',
        (tester) async {
      await tester.pumpWidget(_wrap(withData: true));
      await tester.pumpAndSettle();

      // MockHomeRepository.seeded() — 계란찜(comfortable)·카페라떼.
      expect(find.text('계란찜'), findsOneWidget);
      expect(find.text('카페라떼'), findsOneWidget);
      expect(find.text('편안함'), findsOneWidget);
      expect(find.text('먹은 음식이 있으신가요?'), findsNothing);
    });

    // pr-review 수정4: parseKst가 무가드로 호출돼 malformed eatenAt 시
    // FormatException 레드스크린이 나던 회귀를 막는다. 시간 표시만 실패하고
    // 타일(음식명 등) 자체는 렌더돼야 한다.
    testWidgets('eatenAt이 malformed여도 타일은 렌더되고 시간은 "—"로 폴백된다',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            myPageRepositoryProvider
                .overrideWithValue(MockMyPageRepository.empty()),
            // ignore: scoped_providers_should_specify_dependencies
            homeRepositoryProvider.overrideWithValue(
              MockHomeRepository(
                recentFoods: const [
                  RecentMeal(
                    foodName: '두부',
                    category: 'regular',
                    eatenAt: 'not-a-date',
                  ),
                ],
              ),
            ),
          ],
          child: const MaterialApp(home: HomeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('두부'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
    });
  });

  group('HomeScreen — 삭제된 구 홈 요소 부재 확인', () {
    testWidgets('"아직 검색 기록이 없어요"는 표시되지 않는다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('아직 검색 기록이 없어요'), findsNothing);
    });

    testWidgets('"오늘의 기록" 카드가 표시되지 않는다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('오늘의 기록'), findsNothing);
    });

    testWidgets('"내 도감" pill 카드가 표시되지 않는다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('내 도감'), findsNothing);
    });

    testWidgets('"식단 기록" 통계 라벨이 표시되지 않는다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('식단 기록'), findsNothing);
    });

    testWidgets('토스트 카드 "검색하신 음식은 드셨어요?"가 표시되지 않는다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('검색하신 음식은 드셨어요?'), findsNothing);
      expect(find.text('식단에 추가하고 상태 기록하기'), findsNothing);
    });
  });
}
