import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    registerSymptomCheckinCategory()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "canieatit/app_settings",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      if call.method == "openNotificationSettings" {
        if let url = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    SymptomOutboxMethodChannel.register(binaryMessenger: engineBridge.applicationRegistrar.messenger())
    HomeWidgetMethodChannel.register(binaryMessenger: engineBridge.applicationRegistrar.messenger())
  }

  override func application(
    _ application: UIApplication,
    handleEventsForBackgroundURLSession identifier: String,
    completionHandler: @escaping () -> Void
  ) {
    guard let uploader = try? SymptomNativeUploader.makeIfNeeded(),
          uploader.backgroundSessionID == identifier else {
      completionHandler()
      return
    }
    SymptomNativeUploadLog.debug("Runner received background session handoff sessionID=\(identifier)")
    uploader.setBackgroundCompletionHandler(completionHandler)
  }

  private func registerSymptomCheckinCategory() {
    let open = UNNotificationAction(
      identifier: "SYMPTOM_OPEN_APP_ACTION", title: "앱에서 자세히", options: [.foreground]
    )
    let checkinCategories = ["post_meal", "post_meal_delayed_single"].map {
      UNNotificationCategory(identifier: $0, actions: [open], intentIdentifiers: [], options: [.customDismissAction])
    }
    UNUserNotificationCenter.current().getNotificationCategories { categories in
      var updated = categories.filter { !["post_meal", "post_meal_delayed_single"].contains($0.identifier) }
      updated.formUnion(checkinCategories)
      UNUserNotificationCenter.current().setNotificationCategories(updated)
    }
  }
}

/// UIScene 라이프사이클에서 OAuth 콜백 URL(예: 카카오톡 앱 스위치 로그인
/// `kakao<APP_KEY>://oauth?code=...`)을 Flutter 플러그인으로 브리징한다.
///
/// 배경: 이 프로젝트에는 네이티브 Kakao iOS SDK(KakaoSDKAuth 등)가 없다.
/// 로그인은 순수 Flutter 플러그인 `kakao_flutter_sdk_common` 이 담당하며,
/// 이 플러그인은 레거시 `registrar.addApplicationDelegate` + `application(_:open:)`
/// 로만 콜백을 받는다. 그런데 Info.plist 의 UIScene 라이프사이클에서는 리다이렉트
/// URL 이 `scene(_:openURLContexts:)` 로 전달되고, 기본 `FlutterSceneDelegate` 는
/// 이를 "신규 scene 프로토콜(FlutterSceneLifeCycleDelegate)" 을 구현한 플러그인에만
/// 포워딩한다. Kakao 플러그인은 레거시 경로만 쓰므로 콜백을 못 받아 auth code 가
/// 유실된다. 여기서 URL 을 FlutterAppDelegate 의 `application(_:open:options:)` 로
/// 되넘겨 레거시 포워딩 체인(→ Kakao 플러그인)을 태운다.
class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    for context in connectionOptions.urlContexts {
      _ = HomeWidgetLinkStore.capture(context.url)
    }
    super.scene(scene, willConnectTo: session, options: connectionOptions)
  }

  override func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {
    let nonWidgetContexts = Set(URLContexts.filter { !HomeWidgetLinkStore.capture($0.url) })
    for context in nonWidgetContexts {
      #if DEBUG
      // 진단 로그(디버그 전용). 인가 code 노출 방지 위해 scheme 만 기록한다.
      NSLog("[KakaoBridge] openURL scheme: \(context.url.scheme ?? "nil")")
      #endif
      if let appDelegate = UIApplication.shared.delegate as? FlutterAppDelegate {
        _ = appDelegate.application(
          UIApplication.shared,
          open: context.url,
          options: [:]
        )
      }
    }
    if !nonWidgetContexts.isEmpty {
      super.scene(scene, openURLContexts: nonWidgetContexts)
    }
  }
}
