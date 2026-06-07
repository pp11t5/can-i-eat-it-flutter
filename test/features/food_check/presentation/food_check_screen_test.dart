import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/food_check/data/repositories/mock_search_history_repository.dart';
import 'package:can_i_eat_it/features/food_check/data/search_history_providers.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/food_check_screen.dart';

/// 최소 GoRouter: /check → FoodCheckScreen, / → home stub (close X go('/') 용).
GoRouter _testRouter() => GoRouter(
      initialLocation: '/check',
      routes: [
        GoRoute(
          path: '/check',
          builder: (_, __) => const FoodCheckScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: Text('home stub')),
        ),
      ],
    );

Widget _wrap(List<Override> overrides) => ProviderScope(
      // ignore: scoped_providers_should_specify_dependencies
      overrides: overrides,
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

void main() {
  group('FoodCheckScreen — 빈 기록', () {
    testWidgets('검색 필드 placeholder와 빈 상태 문구가 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap([
          searchHistoryRepositoryProvider
              .overrideWithValue(MockSearchHistoryRepository.empty()),
        ]),
      );
      await tester.pumpAndSettle();

      // 검색 필드 placeholder.
      expect(find.text('음식을 검색해주세요'), findsOneWidget);
      // SVG 아이콘(빈 상태 음식 아이콘 + 닫기 X) 렌더.
      expect(find.byType(SvgPicture), findsWidgets);
      // 빈 상태 문구.
      expect(find.text('아직 검색 기록이 없어요'), findsOneWidget);
    });

    testWidgets('닫기 X 아이콘이 존재한다', (tester) async {
      await tester.pumpWidget(
        _wrap([
          searchHistoryRepositoryProvider
              .overrideWithValue(MockSearchHistoryRepository.empty()),
        ]),
      );
      await tester.pumpAndSettle();

      // 닫기 X 는 Figma SVG(icon_close.svg)로 렌더된다.
      expect(find.byType(SvgPicture), findsWidgets);
    });
  });

  group('FoodCheckScreen — 기록 있음', () {
    late MockSearchHistoryRepository repo;

    setUp(() {
      repo = MockSearchHistoryRepository.withHistory(['된장찌개', '오렌지주스']);
    });

    testWidgets('검색어 두 개와 전체 삭제 버튼이 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap([
          searchHistoryRepositoryProvider.overrideWithValue(repo),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('된장찌개'), findsOneWidget);
      expect(find.text('오렌지주스'), findsOneWidget);
      expect(find.text('전체 삭제'), findsOneWidget);
    });

    testWidgets('행의 X를 탭하면 해당 검색어가 목록에서 사라진다', (tester) async {
      await tester.pumpWidget(
        _wrap([
          searchHistoryRepositoryProvider.overrideWithValue(repo),
        ]),
      );
      await tester.pumpAndSettle();

      // 된장찌개 행의 close(SVG) 아이콘을 탭한다.
      final termFinder = find.text('된장찌개');
      expect(termFinder, findsOneWidget);

      // 된장찌개가 속한 Row 위젯 안의 close SVG 아이콘을 탭.
      final rowFinder = find.ancestor(
        of: termFinder,
        matching: find.byType(Row),
      );
      final closeInRow = find.descendant(
        of: rowFinder.first,
        matching: find.byType(SvgPicture),
      );
      await tester.tap(closeInRow.first);
      await tester.pumpAndSettle();

      expect(find.text('된장찌개'), findsNothing);
      expect(find.text('오렌지주스'), findsOneWidget);
    });
  });

  group('FoodCheckScreen — 전체 삭제 다이얼로그', () {
    testWidgets('전체 삭제 탭 시 확인 다이얼로그가 열린다', (tester) async {
      final repo =
          MockSearchHistoryRepository.withHistory(['된장찌개', '오렌지주스']);
      await tester.pumpWidget(
        _wrap([
          searchHistoryRepositoryProvider.overrideWithValue(repo),
        ]),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('전체 삭제'));
      await tester.pumpAndSettle();

      expect(find.text('검색 기록을 삭제하시겠어요?'), findsOneWidget);
    });

    testWidgets('다이얼로그에서 삭제하기 탭 시 기록이 전부 사라진다', (tester) async {
      final repo =
          MockSearchHistoryRepository.withHistory(['된장찌개', '오렌지주스']);
      await tester.pumpWidget(
        _wrap([
          searchHistoryRepositoryProvider.overrideWithValue(repo),
        ]),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('전체 삭제'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('삭제하기'));
      await tester.pumpAndSettle();

      // 다이얼로그 닫히고 빈 상태 문구 표시.
      expect(find.text('검색 기록을 삭제하시겠어요?'), findsNothing);
      expect(find.text('아직 검색 기록이 없어요'), findsOneWidget);
    });

    testWidgets('다이얼로그에서 취소 탭 시 기록이 그대로 유지된다', (tester) async {
      final repo =
          MockSearchHistoryRepository.withHistory(['된장찌개', '오렌지주스']);
      await tester.pumpWidget(
        _wrap([
          searchHistoryRepositoryProvider.overrideWithValue(repo),
        ]),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('전체 삭제'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      expect(find.text('검색 기록을 삭제하시겠어요?'), findsNothing);
      expect(find.text('된장찌개'), findsOneWidget);
      expect(find.text('오렌지주스'), findsOneWidget);
    });
  });
}
