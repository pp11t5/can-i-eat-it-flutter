import Flutter
import UserNotifications

final class SymptomOutboxMethodChannel {
  static func register(binaryMessenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "canieatit/symptom_outbox", binaryMessenger: binaryMessenger)
    channel.setMethodCallHandler { call, result in
      do {
        let uploader = try SymptomNativeUploader.makeIfNeeded()
        let config = try NativeNotificationConfig.load()
        let store = try SymptomOutboxStore(config: config)
        let keychain = SharedAccessTokenStore(config: config)
        let arguments = call.arguments as? [String: Any] ?? [:]
        switch call.method {
        case "claimPending":
          let limit = min(arguments["limit"] as? Int ?? 10, 10)
          let currentSubjectId: String?
          if case .session(let session) = keychain.readResult() {
            currentSubjectId = session.subjectId
          } else {
            currentSubjectId = nil
          }
          try uploader.reconcileBeforeFlutterClaim()
          let records = try store.claimPendingForFlutter(currentSubjectId: currentSubjectId, limit: limit).compactMap { record -> [String: Any]? in
            guard let claim = record.manifest.claim else { return nil }
            return [
              "clientRecordId": record.manifest.clientRecordId.uuidString,
              "claimToken": claim.token.uuidString,
              "symptomState": record.request.symptomState,
              "symptomTypes": record.request.symptomTypes,
              "occurredAt": record.request.occurredAt,
              "mealRecordId": record.request.mealRecordId
            ]
          }
          result(records)
        case "acknowledge":
          try store.finishFlutter(clientRecordId: try uuid(arguments, "clientRecordId"), claimToken: try uuid(arguments, "claimToken"), outcome: .nativeUploading)
          result(nil)
        case "release":
          try store.finishFlutter(clientRecordId: try uuid(arguments, "clientRecordId"), claimToken: try uuid(arguments, "claimToken"), outcome: .pending, errorClass: arguments["errorClass"] as? String)
          result(nil)
        case "quarantine":
          try store.finishFlutter(clientRecordId: try uuid(arguments, "clientRecordId"), claimToken: try uuid(arguments, "claimToken"), outcome: .quarantine, errorClass: arguments["reasonCode"] as? String)
          result(nil)
        case "syncSharedSession":
          guard let access = arguments["accessToken"] as? String, let subject = arguments["subjectId"] as? String else { throw SymptomOutboxError.invalidPayload }
          try keychain.sync(accessToken: access, subjectId: subject); result(nil)
        case "updateSharedAccessToken":
          guard let access = arguments["accessToken"] as? String else { throw SymptomOutboxError.invalidPayload }
          try keychain.updateAccessTokenIfSessionExists(access); result(nil)
        case "clearSharedSession":
          try keychain.clear(); result(nil)
        case "purgeAndCancelForLogout":
          try uploader.cancelAndPurge(); removeDeliveredCheckins(); result(nil)
        default: result(FlutterMethodNotImplemented)
        }
      } catch SymptomOutboxError.claimMismatch {
        result(FlutterError(code: "claimMismatch", message: "이미 다른 처리자가 기록을 처리했어요.", details: nil))
      } catch {
        result(FlutterError(code: "outboxError", message: "증상 기록 보관소를 처리할 수 없어요.", details: nil))
      }
    }
  }

  private static func uuid(_ arguments: [String: Any], _ key: String) throws -> UUID {
    guard let value = arguments[key] as? String, let uuid = UUID(uuidString: value) else { throw SymptomOutboxError.invalidPayload }
    return uuid
  }

  private static func removeDeliveredCheckins() {
    UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
      let checkinCategories: Set<String> = ["post_meal", "post_meal_delayed_single"]
      let ids = notifications.filter { checkinCategories.contains($0.request.content.categoryIdentifier) }.map { $0.request.identifier }
      UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ids)
    }
  }
}
