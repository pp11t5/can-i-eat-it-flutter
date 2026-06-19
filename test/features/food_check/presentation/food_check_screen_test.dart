import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/features/food_check/data/food_check_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/recent_food.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/food_check_screen.dart';

/// 최소 GoRouter: /check → FoodCheckScreen, / → home stub, /verdict → verdict stub.
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
        GoRoute(
          path: '/verdict',
          builder: (_, state) {
            // extra는 VerdictArgs — text를 표시해 진입 확인
            final args = state.extra as VerdictArgs?;
            return Scaffold(
              body: Text('verdict:${args?.text ?? ''}'),
            );
          },
        ),
      ],
    );

Widget _wrap(List<Override> overrides) => ProviderScope(
      // ignore: scoped_providers_should_specify_dependencies
      overrides: overrides,
      child: MaterialApp.router(routerConfig: _testRouter()),
    );

// 샘플 최근검색 항목.
RecentFood _recentFood(String id, String name) => RecentFood(
      foodExternalId: id,
      name: name,
      searchedAt: DateTime(2026, 6, 1),
    );

// 샘플 검색결과 항목.
FoodSummary _foodSummary(String id, String name) =>
    FoodSummary(externalId: id, name: name);

void main() {
  // -------------------------------------------------------------------------
  group('FoodCheckScreen — 빈 최근검색', () {
    testWidgets('검색 필드 placeholder와 빈 상태 문구가 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap([
          foodRepositoryProvider
              .overrideWithValue(MockFoodRepository.empty()),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('음식 이름을 입력해 주세요'), findsOneWidget);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.text('아직 검색 기록이 없어요'), findsOneWidget);
    });

    testWidgets('닫기 X 아이콘이 존재한다', (tester) async {
      await tester.pumpWidget(
        _wrap([
          foodRepositoryProvider
              .overrideWithValue(MockFoodRepository.empty()),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SvgPicture), findsWidgets);
    });
  });

  // -------------------------------------------------------------------------
  group('FoodCheckScreen — 최근검색 있음 (RecentFood 엔티티)', () {
    late MockFoodRepository repo;

    setUp(() {
      repo = MockFoodRepository.withRecent([
        _recentFood('r-1', '된장찌개'),
        _recentFood('r-2', '오렌지주스'),
      ]);
    });

    testWidgets('최근검색 두 개와 전체 삭제 버튼이 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      expect(find.text('된장찌개'), findsOneWidget);
      expect(find.text('오렌지주스'), findsOneWidget);
      expect(find.text('전체 삭제'), findsOneWidget);
    });

    testWidgets('행의 X를 탭하면 해당 항목이 목록에서 사라진다', (tester) async {
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      final termFinder = find.text('된장찌개');
      expect(termFinder, findsOneWidget);

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

      // 삭제 확인 다이얼로그가 표시됨 — '삭제' 버튼 탭
      expect(find.text('검색어 삭제'), findsOneWidget);
      await tester.tap(find.text('삭제'));
      await tester.pumpAndSettle();

      expect(find.text('된장찌개'), findsNothing);
      expect(find.text('오렌지주스'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  group('FoodCheckScreen — 전체 삭제 다이얼로그 (clearRecent)', () {
    testWidgets('전체 삭제 탭 시 확인 다이얼로그가 열린다', (tester) async {
      final repo = MockFoodRepository.withRecent([
        _recentFood('r-1', '된장찌개'),
        _recentFood('r-2', '오렌지주스'),
      ]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('전체 삭제'));
      await tester.pumpAndSettle();

      expect(find.text('최근 검색 삭제'), findsOneWidget);
      expect(find.text('최근 검색 기록을 모두 삭제하시겠어요?'), findsOneWidget);
    });

    testWidgets('다이얼로그에서 삭제하기 탭 시 기록이 전부 사라진다', (tester) async {
      final repo = MockFoodRepository.withRecent([
        _recentFood('r-1', '된장찌개'),
        _recentFood('r-2', '오렌지주스'),
      ]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('전체 삭제'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('삭제'));
      await tester.pumpAndSettle();

      expect(find.text('최근 검색 기록을 모두 삭제하시겠어요?'), findsNothing);
      expect(find.text('아직 검색 기록이 없어요'), findsOneWidget);
    });

    testWidgets('다이얼로그에서 취소 탭 시 기록이 그대로 유지된다', (tester) async {
      final repo = MockFoodRepository.withRecent([
        _recentFood('r-1', '된장찌개'),
        _recentFood('r-2', '오렌지주스'),
      ]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
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

  // -------------------------------------------------------------------------
  group('FoodCheckScreen — 검색 결과 패널', () {
    testWidgets('검색어 입력 후 Submit → 결과 셀이 렌더된다', (tester) async {
      final repo = MockFoodRepository.withSearchResults([
        _foodSummary('f-1', '두부'),
        _foodSummary('f-2', '두부조림'),
      ]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      // 검색어 입력 + 엔터 (Submit)
      await tester.enterText(find.byType(TextField), '두부');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // RichText로 렌더되므로 toPlainText()로 확인
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('두부'),
        ),
        findsWidgets,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText() == '두부조림',
        ),
        findsOneWidget,
      );
    });

    testWidgets('빈 결과 → 직접분석 CTA 카드(찾는 음식이 없어요) 렌더', (tester) async {
      final repo = MockFoodRepository.withSearchResults([]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '없는음식xyz');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // _DirectAnalyzeCta 카드: 제목 + 부제에 쿼리 포함
      expect(find.text('찾는 음식이 없어요'), findsOneWidget);
      expect(find.textContaining("'없는음식xyz'로 검색하기"), findsOneWidget);
    });

    testWidgets('빈 결과 → Icons.search_off 아이콘이 표시된다', (tester) async {
      final repo = MockFoodRepository.withSearchResults([]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '없는음식xyz');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('결과 셀 탭 → addRecent 호출 후 /verdict 라우트 진입', (tester) async {
      final repo = MockFoodRepository.withSearchResults([
        _foodSummary('f-1', '두부'),
      ]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '두부');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // 결과 셀 탭 (음식 이름이 RichText로 렌더되므로 toPlainText로 찾기)
      final cardRichText = find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText() == '두부',
      );
      await tester.tap(cardRichText.first);
      await tester.pumpAndSettle();

      // /verdict 라우트로 이동했음을 확인
      expect(find.textContaining('verdict:'), findsOneWidget);
    });

    testWidgets('매칭없음 CTA 카드 탭 → /verdict 진입 (externalId 없음)', (tester) async {
      final repo = MockFoodRepository.withSearchResults([]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '특이한음식');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // _DirectAnalyzeCta 카드 전체를 탭 (GestureDetector 영역)
      await tester.tap(find.text('찾는 음식이 없어요'));
      await tester.pumpAndSettle();

      // /verdict로 이동, extra = '특이한음식'
      expect(find.text('verdict:특이한음식'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  group('FoodCheckScreen — foodRepositoryContract 통과 (MockFoodRepository)', () {
    // MockFoodRepository가 FoodRepository 계약을 통과하는지 확인.
    // 실 구현은 food_repository_impl_test.dart에서 검증.
    test('MockFoodRepository.empty search 빈 쿼리 → 빈 결과', () async {
      final repo = MockFoodRepository.empty();
      expect(await repo.search(''), isEmpty);
    });

    test('MockFoodRepository addRecent → recentSearches에 포함됨', () async {
      final repo = MockFoodRepository.empty();
      await repo.addRecent('f-1');
      final results = await repo.recentSearches();
      expect(results.map((r) => r.foodExternalId), contains('f-1'));
    });
  });

  group('FoodCheckScreen — 검색어 하이라이트', () {
    testWidgets('검색어 "두"로 검색 시 "두부" 결과에서 "두" 부분이 FontWeight.bold로 렌더된다',
        (tester) async {
      final repo = MockFoodRepository.withSearchResults([
        _foodSummary('f-1', '두부'),
      ]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '두');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // RichText 위젯이 렌더된다
      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      // '두부' 결과 카드의 RichText 중 bold TextSpan이 있는지 확인
      final hasBoldSpan = richTexts.any((rt) {
        final root = rt.text;
        if (root is TextSpan && root.children != null) {
          return root.children!.any((span) {
            if (span is TextSpan) {
              return span.style?.fontWeight == FontWeight.bold &&
                  span.text == '두';
            }
            return false;
          });
        }
        return false;
      });
      expect(hasBoldSpan, isTrue);
    });
  });

  group('FoodCheckScreen — 검색어 삭제 확인 다이얼로그', () {
    testWidgets('삭제 버튼 탭 시 "검색어 삭제" 다이얼로그 타이틀이 표시된다',
        (tester) async {
      final repo = MockFoodRepository.withRecent([
        _recentFood('r-1', '된장찌개'),
      ]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      final rowFinder = find.ancestor(
        of: find.text('된장찌개'),
        matching: find.byType(Row),
      );
      final closeInRow = find.descendant(
        of: rowFinder.first,
        matching: find.byType(SvgPicture),
      );
      await tester.tap(closeInRow.first);
      await tester.pumpAndSettle();

      expect(find.text('검색어 삭제'), findsOneWidget);
    });

    testWidgets("'취소' 탭 시 다이얼로그가 닫힌다", (tester) async {
      final repo = MockFoodRepository.withRecent([
        _recentFood('r-1', '된장찌개'),
      ]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      final rowFinder = find.ancestor(
        of: find.text('된장찌개'),
        matching: find.byType(Row),
      );
      final closeInRow = find.descendant(
        of: rowFinder.first,
        matching: find.byType(SvgPicture),
      );
      await tester.tap(closeInRow.first);
      await tester.pumpAndSettle();

      expect(find.text('검색어 삭제'), findsOneWidget);

      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      expect(find.text('검색어 삭제'), findsNothing);
      expect(find.text('된장찌개'), findsOneWidget);
    });
  });

  group('FoodCheckScreen — 검색 결과 없음 빈 상태', () {
    testWidgets("검색어 입력 후 결과 없으면 '검색 결과가 없어요' 텍스트가 표시된다",
        (tester) async {
      final repo = MockFoodRepository.withSearchResults([]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '없는음식xyz');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.text('검색 결과가 없어요'), findsOneWidget);
    });

    testWidgets("검색어 입력 후 결과 없으면 '다른 검색어로 시도해 보세요' 텍스트가 표시된다",
        (tester) async {
      final repo = MockFoodRepository.withSearchResults([]);
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(repo)]),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '없는음식xyz');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      expect(find.text('다른 검색어로 시도해 보세요'), findsOneWidget);
    });
  });

  group('FoodCheckScreen — 정렬 옵션', () {
    testWidgets('Icons.sort 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(MockFoodRepository.empty())]),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.sort), findsOneWidget);
    });

    testWidgets("Icons.sort 탭 시 '정렬 기준' 다이얼로그가 표시된다", (tester) async {
      await tester.pumpWidget(
        _wrap([foodRepositoryProvider.overrideWithValue(MockFoodRepository.empty())]),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.sort));
      await tester.pumpAndSettle();

      expect(find.text('정렬 기준'), findsOneWidget);
    });
  });
}
