import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/onboarding/presentation/screens/onboarding_intro_screen.dart';

Widget _wrap({VoidCallback? onStart}) => MaterialApp(
      home: OnboardingIntroScreen(onStart: onStart),
    );

void main() {
  group('OnboardingIntroScreen', () {
    testWidgets('타이틀·서브타이틀·CTA 버튼을 렌더한다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('먹어도 돼?'), findsOneWidget);
      expect(find.text('내 건강 상태에 맞는 음식을 찾아드려요'), findsOneWidget);
      expect(find.text('시작하기'), findsOneWidget);
    });

    testWidgets('"시작하기" 버튼 탭 시 onStart 콜백이 호출된다', (tester) async {
      var called = false;
      await tester.pumpWidget(_wrap(onStart: () => called = true));
      await tester.pump();

      await tester.tap(find.text('시작하기'));
      await tester.pump();

      expect(called, isTrue);
    });
  });
}
