import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/util/external_link.dart';

void main() {
  Widget subject({
    required String url,
    required ExternalUrlLauncher launcher,
  }) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => openExternalUrl(
              context,
              url,
              launcher: launcher,
            ),
            child: const Text('열기'),
          ),
        ),
      ),
    );
  }

  testWidgets('유효한 HTTP(S) URL은 주입된 외부 런처로 전달한다', (tester) async {
    Uri? launchedUri;
    await tester.pumpWidget(
      subject(
        url: 'https://example.com/terms',
        launcher: (uri) async {
          launchedUri = uri;
          return true;
        },
      ),
    );

    await tester.tap(find.text('열기'));
    await tester.pump();

    expect(launchedUri, Uri.parse('https://example.com/terms'));
    expect(find.text('링크를 열 수 없어요.'), findsNothing);
  });

  testWidgets('잘못된 content는 런처를 호출하지 않고 토스트를 표시한다', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      subject(
        url: 'not-a-web-url',
        launcher: (_) async {
          calls++;
          return true;
        },
      ),
    );

    await tester.tap(find.text('열기'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(calls, 0);
    expect(find.text('링크를 열 수 없어요.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  testWidgets('런처가 열지 못하면 토스트를 표시한다', (tester) async {
    await tester.pumpWidget(
      subject(
        url: 'https://example.com/terms',
        launcher: (_) async => false,
      ),
    );

    await tester.tap(find.text('열기'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('링크를 열 수 없어요.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
