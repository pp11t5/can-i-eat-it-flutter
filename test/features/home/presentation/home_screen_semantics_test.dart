import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/home_search_bar.dart';
import 'package:can_i_eat_it/features/home/presentation/widgets/suggestion_chip.dart';

Widget _wrapWidget(Widget child) => ProviderScope(
      child: MaterialApp(home: Scaffold(body: child)),
    );

void main() {
  group('홈 화면 접근성 — 시맨틱 레이블', () {
    testWidgets('HomeSearchBar: 시맨틱 레이블 "음식 검색창, 탭하면 음식 이름을 검색할 수 있어요" 검증',
        (tester) async {
      await tester.pumpWidget(
        _wrapWidget(HomeSearchBar(onTap: () {})),
      );
      await tester.pump();

      final semantics = tester.getSemantics(find.byType(HomeSearchBar));
      expect(semantics.label, '음식 검색창, 탭하면 음식 이름을 검색할 수 있어요');
    });

    testWidgets('HomeSuggestionChip: 시맨틱 레이블 "{label} 검색하기" 검증',
        (tester) async {
      await tester.pumpWidget(
        _wrapWidget(
          HomeSuggestionChip(
            label: '된장찌개',
            iconAsset: 'assets/illustrations/food_soup.png',
            onTap: () {},
          ),
        ),
      );
      await tester.pump();

      final semantics = tester.getSemantics(find.byType(HomeSuggestionChip));
      expect(semantics.label, '된장찌개 검색하기');
    });
  });
}
