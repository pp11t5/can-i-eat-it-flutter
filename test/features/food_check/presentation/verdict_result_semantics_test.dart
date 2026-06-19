import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/data/favorite_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_favorite_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_result_screen.dart';

Widget _wrap(EatVerdict verdict) => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        favoriteRepositoryProvider
            .overrideWithValue(MockFavoriteRepository()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: VerdictResultScreen(
          verdict: verdict,
          onRetry: () {},
        ),
      ),
    );

void main() {
  group('VerdictResultScreen — 시맨틱 레이블', () {
    testWidgets('recommend 케이스: HeroSection·BulletItem·CTA 버튼 시맨틱 레이블 검증',
        (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');

      await tester.pumpWidget(_wrap(verdict));
      await tester.pumpAndSettle();

      // SemanticsController로 시맨틱 트리 검사
      final semantics = tester.getSemantics(
        find.bySemanticsLabel(RegExp('두부, 판정:')),
      );
      expect(semantics.label, contains('두부'));
      expect(semantics.label, contains('판정:'));

      // "판정 결과 공유하기" 버튼 시맨틱
      expect(
        find.bySemanticsLabel('판정 결과 공유하기'),
        findsOneWidget,
      );

      // "다른 음식 검색하기" 버튼 시맨틱 (Semantics 위젯 + ElevatedButton 내부 2개 존재)
      expect(
        find.bySemanticsLabel('다른 음식 검색하기'),
        findsAtLeastNWidgets(1),
      );

      // BulletItem 시맨틱: emphasis + body 포함 (recommend items 첫 번째)
      if (verdict.items.isNotEmpty) {
        final firstItem = verdict.items.first;
        expect(
          find.bySemanticsLabel(
              RegExp('${RegExp.escape(firstItem.emphasis)}.*')),
          findsAtLeast(1),
        );
      }
    });
  });
}
