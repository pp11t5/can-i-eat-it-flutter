import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:can_i_eat_it/core/app_info/app_info_provider.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/app_version_widget.dart';

Widget _wrap(PackageInfo info) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      appInfoProvider.overrideWith((_) async => info),
    ],
    child: const MaterialApp(
      home: Scaffold(body: Center(child: AppVersionWidget())),
    ),
  );
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  group('AppVersionWidget', () {
    testWidgets('"버전 1.2.3 (42)" 텍스트가 표시된다', (tester) async {
      final info = PackageInfo(
        appName: 'can_i_eat_it',
        packageName: 'com.example.can_i_eat_it',
        version: '1.2.3',
        buildNumber: '42',
        buildSignature: '',
      );
      await tester.pumpWidget(_wrap(info));
      await _settle(tester);

      expect(find.text('버전 1.2.3 (42)'), findsOneWidget);
    });
  });
}
