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

      expect(find.text('권장'), findsOneWidget);
      expect(find.text('위험'), findsOneWidget);
      expect(find.text('주의'), findsOneWidget);
    });
  });
}
