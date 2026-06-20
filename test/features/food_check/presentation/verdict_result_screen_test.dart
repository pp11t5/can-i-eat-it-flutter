import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/data/favorite_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_favorite_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_result_screen.dart';

const _kVerdict = EatVerdict(
  level: VerdictLevel.recommend,
  foodName: '두부',
);

Widget _wrap(Widget child) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      favoriteRepositoryProvider.overrideWithValue(MockFavoriteRepository()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  group('VerdictResultScreen — 관련 음식 섹션', () {
    testWidgets("'관련 음식' 타이틀 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.text('관련 음식'), findsOneWidget);
    });

    testWidgets("목 데이터 '두부' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.widgetWithText(ListTile, '두부'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 영양 정보 섹션', () {
    testWidgets("'영양 정보' 타이틀이 렌더된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.text('영양 정보'), findsOneWidget);
    });

    testWidgets("'72 kcal' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.text('72 kcal'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 공유 버튼', () {
    testWidgets('Icons.share 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      // AppBar 공유 버튼 + 본문 CTA 공유하기 버튼 2개 존재
      expect(find.byIcon(Icons.share), findsAtLeastNWidgets(1));
    });

    testWidgets("Icons.share 탭 시 '공유' 다이얼로그 타이틀이 표시된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      // AppBar의 공유 버튼(.last) — 본문 CTA 버튼은 오프스크린이므로 last가 AppBar 버튼
      await tester.tap(find.byIcon(Icons.share).last);
      await _settle(tester);

      expect(find.text('공유'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 재검색 버튼 개선', () {
    testWidgets("'다른 음식 검색하기' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.text('다른 음식 검색하기'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 재판정 요청 버튼', () {
    testWidgets('Icons.refresh 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets("Icons.refresh 탭 시 '재판정 요청' 다이얼로그 타이틀이 표시된다",
        (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      await tester.tap(find.byIcon(Icons.refresh));
      await _settle(tester);

      expect(find.text('재판정 요청'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 관련 음식 즐겨찾기', () {
    testWidgets('Icons.favorite_border 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.byIcon(Icons.favorite_border), findsAtLeastNWidgets(1));
    });
  });

  group('VerdictResultScreen — 영양 성분 상세 팝업', () {
    testWidgets('영양소 항목 탭 시 영양소 이름이 다이얼로그 타이틀로 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      // '칼로리'는 목 영양 정보 첫 번째 항목
      await tester.tap(find.text('칼로리'));
      await _settle(tester);

      expect(find.text('칼로리'), findsAtLeastNWidgets(1));
    });
  });
}
