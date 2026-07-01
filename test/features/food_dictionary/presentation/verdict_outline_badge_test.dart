import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_dictionary/presentation/widgets/verdict_outline_badge.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: Center(child: child)),
  );
}

/// 배지의 [Container] 테두리 색을 추출한다. 이 배지는 [VerdictOutlineBadge]
/// build() 내 최상위 [Container] 하나만 렌더하므로 byType 단건 조회로 충분하다.
Color _borderColorOf(WidgetTester tester) {
  final container = tester.widget<Container>(find.byType(Container));
  final decoration = container.decoration! as BoxDecoration;
  return decoration.border!.top.color;
}

void main() {
  group('VerdictOutlineBadge — 레벨별 라벨', () {
    testWidgets('recommend → "권장" 텍스트를 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(const VerdictOutlineBadge(level: VerdictLevel.recommend)),
      );

      expect(find.text('권장'), findsOneWidget);
      expect(find.text(VerdictLevel.recommend.label), findsOneWidget);
    });

    testWidgets('caution → "주의" 텍스트를 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(const VerdictOutlineBadge(level: VerdictLevel.caution)),
      );

      expect(find.text('주의'), findsOneWidget);
    });

    testWidgets('risk → "위험" 텍스트를 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(const VerdictOutlineBadge(level: VerdictLevel.risk)),
      );

      expect(find.text('위험'), findsOneWidget);
    });

    testWidgets('unknown → "확인어려움" 텍스트를 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(const VerdictOutlineBadge(level: VerdictLevel.unknown)),
      );

      expect(find.text('확인어려움'), findsOneWidget);
    });
  });

  group('VerdictOutlineBadge — 레벨별 색상', () {
    testWidgets('recommend·caution·risk 테두리 색이 서로 다르다', (tester) async {
      await tester.pumpWidget(
        _wrap(const VerdictOutlineBadge(level: VerdictLevel.recommend)),
      );
      final recommendColor = _borderColorOf(tester);

      await tester.pumpWidget(
        _wrap(const VerdictOutlineBadge(level: VerdictLevel.caution)),
      );
      final cautionColor = _borderColorOf(tester);

      await tester.pumpWidget(
        _wrap(const VerdictOutlineBadge(level: VerdictLevel.risk)),
      );
      final riskColor = _borderColorOf(tester);

      expect(recommendColor, isNot(equals(cautionColor)));
      expect(cautionColor, isNot(equals(riskColor)));
      expect(recommendColor, isNot(equals(riskColor)));
    });

    testWidgets('recommend 텍스트 색은 테두리 색과 동일하다(진한 텍스트)', (tester) async {
      await tester.pumpWidget(
        _wrap(const VerdictOutlineBadge(level: VerdictLevel.recommend)),
      );

      final borderColor = _borderColorOf(tester);
      final textWidget = tester.widget<Text>(find.text('권장'));
      expect(textWidget.style!.color, borderColor);
    });
  });
}
