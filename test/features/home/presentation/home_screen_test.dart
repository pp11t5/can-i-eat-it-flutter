import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/repositories/mock_search_history_repository.dart';
import 'package:can_i_eat_it/features/food_check/data/search_history_providers.dart';
import 'package:can_i_eat_it/features/home/presentation/screens/home_screen.dart';

Widget _wrap(MockSearchHistoryRepository repo) => ProviderScope(
      // 테스트 루트 ProviderScope override — dependencies 불필요.
      // ignore: scoped_providers_should_specify_dependencies
      overrides: [searchHistoryRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: HomeScreen()),
    );

void main() {
  group('HomeScreen — 검색 진입 바', () {
    testWidgets('검색 플레이스홀더 텍스트 "음식을 검색해주세요"가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(MockSearchHistoryRepository.empty()));
      await tester.pumpAndSettle();

      expect(find.text('음식을 검색해주세요'), findsOneWidget);
    });

    testWidgets('검색 아이콘(Icons.search)이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(MockSearchHistoryRepository.empty()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });

  group('HomeScreen — 빈 검색 기록', () {
    testWidgets('검색 기록이 없으면 "아직 검색 기록이 없어요"가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(MockSearchHistoryRepository.empty()));
      await tester.pumpAndSettle();

      expect(find.text('아직 검색 기록이 없어요'), findsOneWidget);
    });

    testWidgets('검색 기록이 없으면 삭제 버튼(Icons.close)이 없다', (tester) async {
      await tester.pumpWidget(_wrap(MockSearchHistoryRepository.empty()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsNothing);
    });
  });

  group('HomeScreen — 검색 기록 있음', () {
    testWidgets('검색 기록이 있으면 각 항목이 화면에 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(MockSearchHistoryRepository.withHistory(['된장찌개', '커피'])),
      );
      await tester.pumpAndSettle();

      expect(find.text('된장찌개'), findsOneWidget);
      expect(find.text('커피'), findsOneWidget);
    });

    testWidgets('검색 기록이 있으면 "아직 검색 기록이 없어요"는 표시되지 않는다', (tester) async {
      await tester.pumpWidget(
        _wrap(MockSearchHistoryRepository.withHistory(['된장찌개'])),
      );
      await tester.pumpAndSettle();

      expect(find.text('아직 검색 기록이 없어요'), findsNothing);
    });

    testWidgets('각 항목 옆에 삭제 버튼(Icons.close)이 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(MockSearchHistoryRepository.withHistory(['된장찌개', '커피'])),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsNWidgets(2));
    });

    testWidgets('삭제 버튼을 누르면 해당 항목이 목록에서 사라진다', (tester) async {
      await tester.pumpWidget(
        _wrap(MockSearchHistoryRepository.withHistory(['된장찌개', '커피'])),
      );
      await tester.pumpAndSettle();

      // 된장찌개 항목의 삭제 버튼 — 첫 번째 Icons.close를 탭
      final closeButtons = find.byIcon(Icons.close);
      await tester.tap(closeButtons.first);
      await tester.pumpAndSettle();

      // 된장찌개가 첫 번째이므로 삭제 후 사라져야 한다
      expect(find.text('된장찌개'), findsNothing);
      // 커피는 그대로 남아야 한다
      expect(find.text('커피'), findsOneWidget);
    });
  });

  group('HomeScreen — 오늘의 기록 플레이스홀더', () {
    testWidgets('"오늘의 기록" 카드 제목이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(MockSearchHistoryRepository.empty()));
      await tester.pumpAndSettle();

      expect(find.text('오늘의 기록'), findsOneWidget);
    });

    testWidgets('"오늘의 기록" 카드 본문 문구가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(MockSearchHistoryRepository.empty()));
      await tester.pumpAndSettle();

      expect(
        find.text('식사와 증상을 기록하면 여기에서 한눈에 볼 수 있어요'),
        findsOneWidget,
      );
    });
  });

  group('HomeScreen — 최근 검색 섹션 타이틀', () {
    testWidgets('"최근 검색" 섹션 타이틀이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(MockSearchHistoryRepository.empty()));
      await tester.pumpAndSettle();

      expect(find.text('최근 검색'), findsOneWidget);
    });
  });
}
