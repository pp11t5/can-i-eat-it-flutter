import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'app/app.dart';
import 'core/network/dio_client.dart';
import 'core/push/fcm_messaging_handler.dart';
import 'features/food_check/presentation/providers/add_to_diet_handler_provider.dart';
import 'features/health_profile/data/health_profile_providers.dart';
import 'features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'features/health_profile/data/sources/profile_cache.dart';
import 'features/meal_log/presentation/meal_recording.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화 — GoogleService-Info.plist / google-services.json 자동 사용.
  // APNs 추후이나 init 자체는 설정파일만 필요하므로 성공한다.
  try {
    await Firebase.initializeApp();
  } catch (e, st) {
    // 설정파일 누락 등 — 앱은 계속 떠야 한다 (푸시만 비활성).
    debugPrint('[FCM] Firebase.initializeApp failed: $e\n$st');
  }

  // 백그라운드/종료 상태 메시지 핸들러 등록 (Firebase init 직후, runApp 전 필수).
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Foreground 메시지 수신 초기화 (채널 생성 + onMessage 구독).
  await initForegroundMessaging();

  // 알림 탭 → 앱 오픈 골격 초기화.
  await wireOpenedApp();

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
          (ref) => HealthProfileRepositoryImpl(
            dio: ref.watch(dioProvider),
            cache: ref.watch(profileCacheProvider),
          ),
        ),
        // 식단 추가 핸들러 — meal_log 구현으로 override (acyclic: app이 양쪽 import).
        addToDietHandlerProvider.overrideWith(makeHandlerFromRef),
      ],
      child: const App(),
    ),
  );
}
