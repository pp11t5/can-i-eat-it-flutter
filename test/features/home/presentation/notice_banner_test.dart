import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/home/presentation/widgets/notice_banner.dart';

void main() {
  group('NoticeBanner', () {
    testWidgets('기본 메시지 텍스트가 렌더된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: NoticeBanner())),
      );

      expect(
        find.text('오늘의 건강 팁: 식사 후 바로 눕지 마세요.'),
        findsOneWidget,
      );
    });

    testWidgets('Icons.info_outline 아이콘이 렌더된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: NoticeBanner())),
      );

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });
}
