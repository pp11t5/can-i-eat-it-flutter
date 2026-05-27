import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final loader = FontLoader('Pretendard');
  for (final path in const [
    'assets/fonts/Pretendard-Regular.otf',
    'assets/fonts/Pretendard-Medium.otf',
    'assets/fonts/Pretendard-Bold.otf',
  ]) {
    loader.addFont(
      File(path)
          .readAsBytes()
          .then((b) => ByteData.view(Uint8List.fromList(b).buffer)),
    );
  }
  await loader.load();

  await testMain();
}
