import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/verdict_history/data/repositories/mock_verdict_history_repository.dart';
import 'package:can_i_eat_it/features/verdict_history/data/verdict_history_providers.dart';
import 'package:can_i_eat_it/features/verdict_history/domain/entities/verdict_history_item.dart';
import 'package:can_i_eat_it/features/verdict_history/presentation/screens/verdict_history_screen.dart';

Widget _wrap([MockVerdictHistoryRepository? repo]) {
  repo ??= MockVerdictHistoryRepository();
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      verdictHistoryRepositoryProvider.overrideWithValue(repo),
    ],
    child: const MaterialApp(home: VerdictHistoryScreen()),
  );
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

VerdictHistoryItem _item(String name, String verdict) => VerdictHistoryItem(
      foodName: name,
      verdict: verdict,
      checkedAt: DateTime(2026, 6, 20, 12, 0),
    );

void main() {
  group('VerdictHistoryScreen', () {
    testWidgets('이력 없으면 "아직 판정 이력이 없어요" 타이틀 표시', (tester) async {
      final repo = MockVerdictHistoryRepository();
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.text('아직 판정 이력이 없어요'), findsOneWidget);
      expect(find.text('음식을 검색해 판정을 받아보세요'), findsOneWidget);
    });

    testWidgets('항목 있으면 foodName이 표시된다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [
          _item('두부', 'safe'),
          _item('커피', 'avoid'),
        ],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.text('두부'), findsOneWidget);
      expect(find.text('커피'), findsOneWidget);
    });

    testWidgets('날짜가 "M월 D일 HH:mm" 포맷으로 표시된다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [_item('두부', 'safe')],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // _item의 checkedAt: DateTime(2026, 6, 20, 12, 0) → "6월 20일 12:00"
      expect(find.text('6월 20일 12:00'), findsOneWidget);
    });

    testWidgets('삭제 버튼 탭 시 clear가 호출되어 목록이 비워진다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [_item('두부', 'safe')],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // 삭제 아이콘 버튼 탭
      await tester.tap(find.byIcon(Icons.delete_outline));
      await _settle(tester);

      expect(find.text('아직 판정 이력이 없어요'), findsOneWidget);
    });

    testWidgets('항목 endToStart 스와이프 시 해당 항목이 목록에서 제거된다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [
          _item('두부', 'safe'),
          _item('커피', 'avoid'),
        ],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // '두부' 항목을 endToStart 방향으로 스와이프
      await tester.drag(find.text('두부'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      expect(find.text('두부'), findsNothing);
    });

    testWidgets('verdict 배지 텍스트가 표시된다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [
          _item('두부', 'safe'),
          _item('커피', 'avoid'),
          _item('된장찌개', 'caution'),
        ],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // 필터 칩(권장/주의/위험)과 배지가 동시에 존재하므로 1개 이상 확인
      expect(find.text('권장'), findsAtLeastNWidgets(1));
      expect(find.text('위험'), findsAtLeastNWidgets(1));
      expect(find.text('주의'), findsAtLeastNWidgets(1));
    });

    testWidgets('권장 필터 선택 시 safe 항목만 표시된다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [
          _item('두부', 'safe'),
          _item('커피', 'avoid'),
          _item('된장찌개', 'caution'),
        ],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // '권장' 필터 칩 탭
      await tester.tap(find.text('권장').first);
      await _settle(tester);

      expect(find.text('두부'), findsOneWidget);
      expect(find.text('커피'), findsNothing);
      expect(find.text('된장찌개'), findsNothing);
    });

    testWidgets('전체 필터로 돌아오면 모든 항목이 표시된다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [
          _item('두부', 'safe'),
          _item('커피', 'avoid'),
          _item('된장찌개', 'caution'),
        ],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // 먼저 '권장' 필터 선택
      await tester.tap(find.text('권장').first);
      await _settle(tester);

      // '전체' 필터로 복귀
      await tester.tap(find.text('전체'));
      await _settle(tester);

      expect(find.text('두부'), findsOneWidget);
      expect(find.text('커피'), findsOneWidget);
      expect(find.text('된장찌개'), findsOneWidget);
    });
  });

  group('VerdictHistoryScreen — 날짜별 그룹화', () {
    testWidgets('서로 다른 날짜의 항목 2개가 있을 때 각 날짜 헤더가 표시된다',
        (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [
          VerdictHistoryItem(
            foodName: '두부',
            verdict: 'safe',
            checkedAt: DateTime(2026, 6, 17, 12, 0),
          ),
          VerdictHistoryItem(
            foodName: '커피',
            verdict: 'avoid',
            checkedAt: DateTime(2026, 6, 18, 9, 0),
          ),
        ],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.text('2026.06.17'), findsOneWidget);
      expect(find.text('2026.06.18'), findsOneWidget);
    });
  });

  group('VerdictHistoryScreen — 검색 기능', () {
    testWidgets("'음식 이름으로 검색' 힌트 텍스트가 렌더된다", (tester) async {
      final repo = MockVerdictHistoryRepository();
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.widgetWithText(TextField, '음식 이름으로 검색'), findsOneWidget);
    });

    testWidgets("검색어 '두' 입력 시 '두부'가 표시되고 '커피'는 숨겨진다", (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [
          _item('두부', 'safe'),
          _item('커피', 'avoid'),
        ],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      await tester.enterText(find.byType(TextField).first, '두');
      await _settle(tester);

      expect(find.text('두부'), findsOneWidget);
      expect(find.text('커피'), findsNothing);
    });
  });

  group('VerdictHistoryScreen — 정렬 기능', () {
    testWidgets('정렬 아이콘(Icons.sort)이 렌더된다', (tester) async {
      final repo = MockVerdictHistoryRepository();
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.byIcon(Icons.sort), findsOneWidget);
    });

    testWidgets('정렬 버튼 탭 시 항목 순서가 뒤집힌다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [
          VerdictHistoryItem(
            foodName: '두부',
            verdict: 'safe',
            checkedAt: DateTime(2026, 6, 17, 8, 0),
          ),
          VerdictHistoryItem(
            foodName: '커피',
            verdict: 'avoid',
            checkedAt: DateTime(2026, 6, 17, 10, 0),
          ),
        ],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // 초기 최신순: 커피(10:00) → 두부(08:00)
      final initialItems = tester.widgetList<Text>(
        find.descendant(
          of: find.byType(ListTile),
          matching: find.byWidgetPredicate(
            (w) => w is Text && (w.data == '두부' || w.data == '커피'),
          ),
        ),
      ).toList();
      expect(initialItems.first.data, '커피');

      // 정렬 버튼 탭 → 오래된순
      await tester.tap(find.byIcon(Icons.sort));
      await _settle(tester);

      final sortedItems = tester.widgetList<Text>(
        find.descendant(
          of: find.byType(ListTile),
          matching: find.byWidgetPredicate(
            (w) => w is Text && (w.data == '두부' || w.data == '커피'),
          ),
        ),
      ).toList();
      expect(sortedItems.first.data, '두부');
    });
  });

  group('VerdictHistoryScreen — 빈 상태 일러스트', () {
    testWidgets('빈 상태에서 Image 위젯 또는 fallback Icons.history가 렌더된다',
        (tester) async {
      final repo = MockVerdictHistoryRepository();
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // 테스트 환경에서 asset 미등록 → errorBuilder의 Icons.history fallback 확인
      final hasImage = find.byType(Image).evaluate().isNotEmpty;
      final hasFallback = find.byIcon(Icons.history).evaluate().isNotEmpty;
      expect(hasImage || hasFallback, isTrue);
    });
  });

  group('VerdictHistoryScreen — 즐겨찾기', () {
    testWidgets('Icons.favorite_border 아이콘이 렌더된다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [_item('두부', 'safe')],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('즐겨찾기 버튼 탭 시 Icons.favorite로 변경된다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [_item('두부', 'safe')],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await _settle(tester);

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  group('VerdictHistoryScreen — 즐겨찾기 토글', () {
    testWidgets('Icons.favorite_border 아이콘이 초기 상태에서 렌더된다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [_item('두부', 'safe')],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('Icons.favorite_border 탭 시 Icons.favorite로 변경된다',
        (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [_item('두부', 'safe')],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await _settle(tester);

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });
  });

  group('VerdictHistoryScreen — 내보내기 버튼', () {
    testWidgets('Icons.ios_share 아이콘이 렌더된다', (tester) async {
      final repo = MockVerdictHistoryRepository();
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.byIcon(Icons.ios_share), findsOneWidget);
    });

    testWidgets("Icons.ios_share 탭 시 '내보내기' 다이얼로그 타이틀이 표시된다",
        (tester) async {
      final repo = MockVerdictHistoryRepository();
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      await tester.tap(find.byIcon(Icons.ios_share));
      await _settle(tester);

      expect(find.text('내보내기'), findsAtLeastNWidgets(1));
    });

    testWidgets("'파일 형식: CSV' 텍스트가 표시된다", (tester) async {
      final repo = MockVerdictHistoryRepository();
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      await tester.tap(find.byIcon(Icons.ios_share));
      await _settle(tester);

      expect(find.textContaining('CSV'), findsOneWidget);
    });
  });

  group('VerdictHistoryScreen — 항목 상세 바텀시트', () {
    testWidgets('항목 탭 시 foodName이 바텀시트에 표시된다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [_item('두부', 'safe')],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      await tester.tap(find.text('두부'));
      await _settle(tester);

      // 바텀시트에 foodName이 표시됨 (ListTile title + 바텀시트 내부 = 2개 이상)
      expect(find.text('두부'), findsAtLeastNWidgets(2));
    });
  });

  group('VerdictHistoryScreen — 즐겨찾기 필터 칩', () {
    testWidgets("'즐겨찾기' 텍스트가 렌더된다", (tester) async {
      final repo = MockVerdictHistoryRepository();
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.text('즐겨찾기'), findsOneWidget);
    });

    testWidgets("'즐겨찾기' 칩 탭 시 selected 상태가 토글된다", (tester) async {
      final repo = MockVerdictHistoryRepository();
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      // 초기에는 미선택 상태
      final chipBefore = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, '즐겨찾기'),
      );
      expect(chipBefore.selected, isFalse);

      // 탭 후 선택 상태
      await tester.tap(find.widgetWithText(FilterChip, '즐겨찾기'));
      await _settle(tester);

      final chipAfter = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, '즐겨찾기'),
      );
      expect(chipAfter.selected, isTrue);
    });
  });

  group('VerdictHistoryScreen — 통계 요약 배너', () {
    testWidgets("이력이 2개일 때 '총 2개의 판정 기록' 텍스트가 표시된다", (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [
          _item('두부', 'safe'),
          _item('커피', 'avoid'),
        ],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.text('총 2개의 판정 기록'), findsOneWidget);
    });
  });

  group('VerdictHistoryScreen — 필터 초기화 버튼', () {
    testWidgets('Icons.filter_list_off 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.byIcon(Icons.filter_list_off), findsOneWidget);
    });

    testWidgets('필터 초기화 버튼 탭 시 필터가 초기화된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      // '즐겨찾기' 필터 선택
      await tester.tap(find.text('즐겨찾기'));
      await _settle(tester);

      // 필터 초기화
      await tester.tap(find.byIcon(Icons.filter_list_off));
      await _settle(tester);

      // '전체' 칩이 selected 상태여야 함
      final allChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, '전체'),
      );
      expect(allChip.selected, isTrue);
    });
  });

  group('VerdictHistoryScreen — 날짜 헤더 포맷', () {
    testWidgets("날짜 헤더 '2026.06.20'이 렌더된다", (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [
          VerdictHistoryItem(
            foodName: '두부',
            verdict: 'safe',
            checkedAt: DateTime(2026, 6, 20, 12, 0),
          ),
        ],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.text('2026.06.20'), findsOneWidget);
    });
  });

  group('VerdictHistoryScreen — 검색 기능', () {
    testWidgets('Icons.search 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.byIcon(Icons.search), findsAtLeastNWidgets(1));
    });

    testWidgets("Icons.search AppBar 버튼 탭 시 '검색' 텍스트가 표시된다", (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      // AppBar의 search IconButton — tooltip '검색'으로 특정
      await tester.tap(find.byTooltip('검색'));
      await _settle(tester);

      expect(find.text('검색'), findsAtLeastNWidgets(1));
    });
  });

  group('VerdictHistoryScreen — 즐겨찾기 내보내기', () {
    testWidgets(
        "Icons.ios_share 탭 시 '즐겨찾기한 판정 결과를 내보냅니다.' 텍스트가 표시된다",
        (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      await tester.tap(find.byTooltip('내보내기'));
      await _settle(tester);

      expect(find.textContaining('즐겨찾기한 판정 결과를 내보냅니다.'), findsOneWidget);
    });
  });

  group('VerdictHistoryScreen — 스와이프 삭제', () {
    testWidgets('항목이 있을 때 Dismissible 위젯이 렌더된다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [_item('두부', 'safe')],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      expect(find.byType(Dismissible), findsAtLeastNWidgets(1));
    });
  });

  group('VerdictHistoryScreen — 롱프레스 메뉴', () {
    testWidgets('항목 롱프레스 시 Icons.share_outlined 아이콘이 표시된다', (tester) async {
      final repo = MockVerdictHistoryRepository(
        initialItems: [_item('두부', 'safe')],
      );
      await tester.pumpWidget(_wrap(repo));
      await _settle(tester);

      await tester.longPress(find.text('두부'));
      await _settle(tester);

      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    });
  });
}
