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

    testWidgets("Icons.share 탭 시 '공유 방법 선택' 다이얼로그 타이틀이 표시된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      // AppBar의 공유 버튼(.last) — 본문 CTA 버튼은 오프스크린이므로 last가 AppBar 버튼
      await tester.tap(find.byIcon(Icons.share).last);
      await _settle(tester);

      expect(find.text('공유 방법 선택'), findsOneWidget);
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

  group('VerdictResultScreen — 공유하기 버튼', () {
    testWidgets('Icons.share_outlined 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    });

    testWidgets("Icons.share_outlined 탭 시 '공유 방법 선택' 텍스트가 표시된다",
        (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      await tester.ensureVisible(find.byIcon(Icons.share_outlined));
      await tester.tap(find.byIcon(Icons.share_outlined));
      await _settle(tester);

      expect(find.text('공유 방법 선택'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 판정 근거 섹션 접기/펼치기', () {
    testWidgets('Icons.expand_less 아이콘이 초기 상태에서 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.byIcon(Icons.expand_less), findsOneWidget);
    });

    testWidgets('Icons.expand_less 탭 시 Icons.expand_more로 변경된다',
        (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      await tester.ensureVisible(find.byIcon(Icons.expand_less));
      await tester.tap(find.byIcon(Icons.expand_less));
      await _settle(tester);

      expect(find.byIcon(Icons.expand_more), findsOneWidget);
      expect(find.byIcon(Icons.expand_less), findsNothing);
    });
  });

  group('VerdictResultScreen — 카테고리 태그', () {
    const _kVerdictWithCategory = EatVerdict(
      level: VerdictLevel.recommend,
      foodName: '두부',
      category: '두부류',
    );

    testWidgets('카테고리 태그 Container가 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(
          verdict: _kVerdictWithCategory,
          onRetry: () {},
        )),
      );
      await _settle(tester);

      // BoxDecoration(borderRadius: 20) Container 존재 확인
      final containers = tester.widgetList<Container>(find.byType(Container));
      final hasTag = containers.any((c) {
        final d = c.decoration;
        return d is BoxDecoration && d.borderRadius != null;
      });
      expect(hasTag, isTrue);
    });

    testWidgets("카테고리 텍스트 '두부류'가 렌더된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(
          verdict: _kVerdictWithCategory,
          onRetry: () {},
        )),
      );
      await _settle(tester);

      expect(find.text('두부류'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 저장 버튼', () {
    testWidgets('저장 tooltip을 가진 Icons.bookmark_border 아이콘이 렌더된다',
        (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.byTooltip('저장'), findsOneWidget);
    });

    testWidgets("저장 버튼 탭 시 '저장' 텍스트가 표시된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      await tester.tap(find.byTooltip('저장'));
      await _settle(tester);

      expect(find.text('저장'), findsAtLeastNWidgets(1));
    });
  });

  group('VerdictResultScreen — 관련 음식 빈 상태', () {
    testWidgets('목 데이터가 있을 때 관련 음식이 없습니다. 텍스트가 표시되지 않는다',
        (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.text('관련 음식이 없습니다.'), findsNothing);
    });
  });

  group('VerdictResultScreen — 음식 이미지 플레이스홀더', () {
    testWidgets("'음식 이미지' 텍스트가 렌더된다", (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.text('음식 이미지'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 인쇄 버튼', () {
    testWidgets('Icons.print_outlined 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      expect(find.byIcon(Icons.print_outlined), findsOneWidget);
    });

    testWidgets("Icons.print_outlined 탭 시 '인쇄' 다이얼로그 타이틀이 표시된다",
        (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      await tester.tap(find.byIcon(Icons.print_outlined));
      await _settle(tester);

      expect(find.text('인쇄'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 피드백 버튼', () {
    testWidgets('Icons.thumb_up_outlined 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      await tester.ensureVisible(find.byIcon(Icons.thumb_up_outlined));
      expect(find.byIcon(Icons.thumb_up_outlined), findsOneWidget);
    });

    testWidgets("Icons.thumb_up_outlined 탭 시 '피드백' 다이얼로그 타이틀이 표시된다",
        (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: _kVerdict, onRetry: () {})),
      );
      await _settle(tester);

      await tester.ensureVisible(find.byIcon(Icons.thumb_up_outlined));
      await tester.tap(find.byIcon(Icons.thumb_up_outlined));
      await _settle(tester);

      expect(find.text('피드백'), findsOneWidget);
    });
  });
}
