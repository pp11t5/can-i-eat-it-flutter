import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';

/// 테스트용 래퍼. HomeScreen은 더 이상 searchHistoryProvider에 의존하지 않으므로
/// 단순 ProviderScope + MaterialApp으로 충분하다.
Widget _wrap() => const ProviderScope(
      child: MaterialApp(home: HomeScreen()),
    );

void main() {
  group('HomeScreen — 인사말 블록', () {
    testWidgets('"이거 먹어도 돼?" 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('이거 먹어도 돼?'), findsOneWidget);
    });

    testWidgets('"식단 기록" 카운터 라벨이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('식단 기록'), findsOneWidget);
    });

    testWidgets('"증상 기록" 카운터 라벨이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.textContaining('증상 기록'), findsOneWidget);
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

  group('HomeScreen — 내 도감 카드', () {
    testWidgets('"내 도감" 라벨이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('내 도감'), findsOneWidget);
    });
  });

  group('HomeScreen — 최근 식사 섹션', () {
    testWidgets('"최근 식사" 섹션 헤더가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('최근 식사'), findsOneWidget);
    });

    testWidgets('"식단을 기록해 보세요" 플레이스홀더가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('식단을 기록해 보세요'), findsOneWidget);
    });
  });

  group('HomeScreen — 토스트 카드', () {
    testWidgets('"검색하신 음식은 드셨어요?" 토스트 제목이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('검색하신 음식은 드셨어요?'), findsOneWidget);
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
}
