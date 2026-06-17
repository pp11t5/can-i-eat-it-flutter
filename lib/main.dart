import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'app/app.dart';
import 'core/network/dio_client.dart';
import 'features/health_profile/data/health_profile_providers.dart';
import 'features/health_profile/data/repositories/health_profile_repository_impl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 카카오 SDK 초기화 (네이티브 앱키). 키는 --dart-define=KAKAO_NATIVE_APP_KEY 로 주입.
  KakaoSdk.init(
    nativeAppKey: const String.fromEnvironment('KAKAO_NATIVE_APP_KEY'),
  );
  runApp(
    ProviderScope(
      overrides: [
        // 실 앱에서 HealthProfileRepositoryImpl 을 주입한다 (ADR-0007 §3-1 (6-D)).
        // 테스트에서는 MockHealthProfileRepository 를 override 로 주입한다.
        healthProfileRepositoryProvider.overrideWith(
          (ref) => HealthProfileRepositoryImpl(dio: ref.watch(dioProvider)),
        ),
      ],
      child: const App(),
    ),
  );
}
