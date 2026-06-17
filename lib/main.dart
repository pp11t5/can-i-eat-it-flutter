import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'app/app.dart';
import 'core/network/dio_client.dart';
import 'features/food_check/presentation/providers/add_to_diet_handler_provider.dart';
import 'features/health_profile/data/health_profile_providers.dart';
import 'features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'features/meal_log/presentation/meal_recording.dart';

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
        // 식단 추가 핸들러 — meal_log 구현으로 override (acyclic: app이 양쪽 import).
        addToDietHandlerProvider.overrideWith(makeHandlerFromRef),
      ],
      child: const App(),
    ),
  );
}
