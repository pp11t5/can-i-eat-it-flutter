import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/verdict_history/data/repositories/mock_verdict_history_repository.dart';
import 'package:can_i_eat_it/features/verdict_history/data/verdict_history_providers.dart';
import 'package:can_i_eat_it/features/verdict_history/domain/entities/verdict_history_item.dart';
import 'package:can_i_eat_it/features/verdict_history/presentation/screens/verdict_history_screen.dart';

Widget _wrap(MockVerdictHistoryRepository repo) {
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

      expect(find.text('6월 17일'), findsOneWidget);
      expect(find.text('6월 18일'), findsOneWidget);
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
}
