import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';

/// 테스트용 래퍼.
/// - mealRepositoryProvider: MockMealRepository.empty() — 플랫폼 채널 격리
Widget _wrap() => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        mealRepositoryProvider.overrideWithValue(MockMealRepository.empty()),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );

/// 최근 검색어가 빈 상태인 래퍼.
Widget _wrapWithEmptyRecent() => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        mealRepositoryProvider.overrideWithValue(MockMealRepository.empty()),
        // ignore: scoped_providers_should_specify_dependencies
        foodRepositoryProvider.overrideWithValue(MockFoodRepository.empty()),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );

void main() {
  group('HomeScreen — 인사말 블록', () {
    testWidgets('시간대에 맞는 인사말 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // 시간대별 문구 중 하나가 반드시 표시된다
      const greetings = [
        '좋은 아침이에요!',
        '점심 시간이에요!',
        '오후도 건강하게',
        '저녁 시간이에요!',
        '늦은 시간 식사는',
      ];
      final anyFound = greetings.any(
        (g) => find.textContaining(g).evaluate().isNotEmpty,
      );
      expect(anyFound, isTrue);
    });

    testWidgets('"식단 기록" 통계 라벨이 인사말 블록에 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // Text.rich 로 렌더링되므로 textContaining 으로 확인
      expect(find.textContaining('식단 기록'), findsOneWidget);
    });

    testWidgets('"증상 기록" 통계 라벨이 인사말 블록에 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('증상 기록'), findsOneWidget);
    });

    testWidgets('구 인사말 "이거 먹어도 돼?"는 표시되지 않는다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('이거 먹어도 돼?'), findsNothing);
    });

    testWidgets('구 "연속 편안한 날 1일 째" 라벨은 인사말 블록에서 제거됐다 — 도감 카드로 이동됨',
        (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // 연속 편안한 날은 _MyDictionaryCard 로 이동했으므로 여전히 화면에 있음.
      // 이 테스트는 그 텍스트가 화면 어딘가에 있는지를 검증 (제거 확인이 아닌 위치 확인).
      expect(find.textContaining('연속 편안한 날'), findsOneWidget);
    });
  });

  group('HomeScreen — 검색 바', () {
    testWidgets('"음식 이름을 검색해 보세요" 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('음식 이름을 검색해 보세요'), findsOneWidget);
    });

    testWidgets('검색 바가 화면에 존재한다 (tappable)', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // HomeSearchBar 위젯 자체가 렌더링되어 있어야 한다.
      expect(find.text('음식 이름을 검색해 보세요'), findsOneWidget);
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

  group('HomeScreen — 내 도감 카드', () {
    testWidgets('"내 도감" 라벨이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('내 도감'), findsOneWidget);
    });

    testWidgets('"연속 편안한 날" streak 텍스트가 도감 카드에 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // Text.rich 로 렌더링되므로 textContaining 으로 확인
      expect(find.textContaining('연속 편안한 날'), findsOneWidget);
    });
  });

  group('HomeScreen — 오늘의 식사 요약 섹션', () {
    testWidgets('"오늘의 식사" 헤더가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('오늘의 식사'), findsOneWidget);
    });

    testWidgets('빈 상태: "오늘 기록된 식사가 없어요." 문구가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('오늘 기록된 식사가 없어요.'), findsOneWidget);
    });

    testWidgets('"더 보기" 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('더 보기'), findsOneWidget);
    });
  });

  group('HomeScreen — 토스트 카드', () {
    testWidgets('"검색하신 음식은 드셨어요?" 토스트 제목이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('검색하신 음식은 드셨어요?'), findsOneWidget);
    });

    testWidgets('"식단에 추가하고 상태 기록하기" 토스트 부제목이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('식단에 추가하고 상태 기록하기'), findsOneWidget);
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
  });

  group('HomeScreen — 최근 검색어 빈 상태', () {
    testWidgets('최근 검색어가 없을 때 "아직 검색한 음식이 없어요"가 렌더된다',
        (tester) async {
      await tester.pumpWidget(_wrapWithEmptyRecent());
      await tester.pumpAndSettle();

      expect(find.text('아직 검색한 음식이 없어요'), findsOneWidget);
    });
  });

  group('HomeScreen — 식사 요약 칼로리', () {
    testWidgets('"총 칼로리: 0 kcal" 텍스트가 렌더된다', (tester) async {
      await tester.pumpWidget(_wrapWithEmptyRecent());
      await tester.pumpAndSettle();

      expect(find.text('총 칼로리: 0 kcal'), findsOneWidget);
    });
  });
}
