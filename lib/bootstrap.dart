import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'app/app.dart';
import 'core/config/flavor_config.dart';
import 'core/network/dio_client.dart';
import 'core/push/fcm_messaging_handler.dart';
import 'features/food_check/presentation/providers/add_to_diet_handler_provider.dart';
import 'features/health_profile/data/health_profile_providers.dart';
import 'features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'features/health_profile/data/sources/profile_cache.dart';
import 'features/meal_log/presentation/meal_recording.dart';

/// 플레이버 진입점 공유 부트스트랩(코어).
///
/// `main_prod.dart` / `main_dev.dart` 이 각자의 [FlavorConfig] 로 호출한다.
/// 공통 초기화(Firebase·FCM·Kakao)와 실 repository override 를 한곳에 모아
/// 진입점 중복을 제거한다.
///
/// [extraOverrides]: 플레이버/개발 전용 추가 override.
///   ⚠️ 운영(prod) 진입점은 비워둔다. UI 검수용 목 repository 는 여기로 넘기지 않고
///   로컬 미커밋 오버레이로만 주입한다(운영 빌드에 목이 물리적으로 섞이지 않도록).
Future<void> bootstrap(
  FlavorConfig config, {
  List<Override> extraOverrides = const [],
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.current = config;

  // Firebase 초기화 — GoogleService-Info.plist / google-services.json 자동 사용.
  // 설정파일 누락 등에도 앱은 계속 떠야 한다(푸시만 비활성).
  try {
    await Firebase.initializeApp();
  } catch (e, st) {
    debugPrint('[FCM] Firebase.initializeApp failed: $e\n$st');
  }

  // 백그라운드/종료 메시지 핸들러(Firebase init 직후, runApp 전 필수).
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Foreground 메시지 수신 초기화 + 알림 탭 오픈 골격.
  await initForegroundMessaging();
  await wireOpenedApp();

  // 카카오 SDK — 네이티브 앱키가 있을 때만 init.
  // dev 등 키 미설정 플레이버는 init 을 생략해 앱이 죽지 않게 한다(소셜 로그인만 비활성).
  if (config.kakaoNativeAppKey.isNotEmpty) {
    KakaoSdk.init(nativeAppKey: config.kakaoNativeAppKey);
  } else {
    debugPrint(
      '[Kakao] nativeAppKey 미설정(${config.flavor.name}) — 소셜 로그인 비활성',
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        // 실 앱에서 HealthProfileRepositoryImpl 주입 (ADR-0007 §3-1 (6-D)).
        healthProfileRepositoryProvider.overrideWith(
          (ref) => HealthProfileRepositoryImpl(
            dio: ref.watch(dioProvider),
            cache: ref.watch(profileCacheProvider),
          ),
        ),
        // 식단 추가 핸들러 — meal_log 구현으로 override.
        addToDietHandlerProvider.overrideWith(makeHandlerFromRef),
        ...extraOverrides,
      ],
      child: const App(),
    ),
  );
}
