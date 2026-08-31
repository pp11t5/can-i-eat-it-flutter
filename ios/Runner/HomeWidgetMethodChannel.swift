import Flutter
import Foundation
import WidgetKit

private enum HomeWidgetStorage {
  static let snapshotKey = "home_widget_snapshot"
  static let syncedAtKey = "home_widget_synced_at"

  static func defaults() throws -> UserDefaults {
    guard let appGroupID = Bundle.main.object(forInfoDictionaryKey: "HomeWidgetAppGroupID") as? String,
          !appGroupID.isEmpty,
          !appGroupID.contains("$("),
          let defaults = UserDefaults(suiteName: appGroupID) else {
      throw HomeWidgetChannelError.missingAppGroup
    }
    return defaults
  }

  static func write(_ payload: [String: Any]) throws {
    guard JSONSerialization.isValidJSONObject(payload) else {
      throw HomeWidgetChannelError.invalidPayload
    }
    let data = try JSONSerialization.data(withJSONObject: payload, options: [])
    let defaults = try defaults()
    defaults.set(data, forKey: snapshotKey)
    defaults.set(Date(), forKey: syncedAtKey)
  }
}

private enum HomeWidgetChannelError: LocalizedError {
  case missingAppGroup
  case invalidPayload

  var errorDescription: String? {
    switch self {
    case .missingAppGroup:
      return "Home widget App Group is not configured."
    case .invalidPayload:
      return "Home widget payload must be JSON serializable."
    }
  }
}

/// `canieatit://widget/...` URL을 Flutter가 준비될 때까지 보관한다.
enum HomeWidgetLinkStore {
  private static var pendingURL: String?
  private static var eventSink: FlutterEventSink?

  static func isWidgetURL(_ url: URL) -> Bool {
    url.scheme?.lowercased() == "canieatit" && url.host?.lowercased() == "widget"
  }

  @discardableResult
  static func capture(_ url: URL) -> Bool {
    guard isWidgetURL(url) else { return false }
    let value = url.absoluteString
    if let eventSink {
      eventSink(value)
    } else {
      pendingURL = value
    }
    return true
  }

  static func takePendingURL() -> String? {
    defer { pendingURL = nil }
    return pendingURL
  }

  static func setEventSink(_ sink: FlutterEventSink?) {
    eventSink = sink
    guard let pendingURL, let sink else { return }
    self.pendingURL = nil
    sink(pendingURL)
  }
}

private final class HomeWidgetClickStreamHandler: NSObject, FlutterStreamHandler {
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    HomeWidgetLinkStore.setEventSink(events)
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    HomeWidgetLinkStore.setEventSink(nil)
    return nil
  }
}

enum HomeWidgetMethodChannel {
  static let widgetKind = "TodayMealWidget"
  private static let clicks = HomeWidgetClickStreamHandler()

  static func register(binaryMessenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "canieatit/home_widget",
      binaryMessenger: binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "write":
        guard let payload = call.arguments as? [String: Any] else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Expected a string map.", details: nil))
          return
        }
        do {
          try HomeWidgetStorage.write(payload)
          WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
          result(nil)
        } catch {
          result(FlutterError(code: "WRITE_FAILED", message: error.localizedDescription, details: nil))
        }
      case "update":
        WidgetCenter.shared.reloadTimelines(ofKind: widgetKind)
        result(nil)
      case "getInitialUri":
        result(HomeWidgetLinkStore.takePendingURL())
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    FlutterEventChannel(
      name: "canieatit/home_widget/clicks",
      binaryMessenger: binaryMessenger
    ).setStreamHandler(clicks)
  }
}
