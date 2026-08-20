import Foundation

enum SymptomOutboxError: Error {
  case invalidPayload
  case claimMismatch
  case cleanupRequired
  case missingRecord
}

struct SymptomPushPayload {
  let schemaVersion: Int
  let type: String
  let mealRecordId: String
  let notificationEventId: String
  let subjectId: String

  init?(userInfo: [AnyHashable: Any]) {
    guard let schema = Self.string(userInfo["schemaVersion"]), Int(schema) == 1,
          let type = Self.string(userInfo["type"]),
          type == "post_meal" || type == "post_meal_delayed_single",
          let mealRecordId = Self.string(userInfo["targetId"]), UUID(uuidString: mealRecordId) != nil,
          let notificationEventId = Self.string(userInfo["notificationEventId"]),
          let subjectId = Self.string(userInfo["subjectId"]), !subjectId.isEmpty else { return nil }
    self.schemaVersion = 1
    self.type = type
    self.mealRecordId = mealRecordId
    self.notificationEventId = notificationEventId
    self.subjectId = subjectId
  }

  private static func string(_ value: Any?) -> String? {
    if let value = value as? String { return value }
    if let value = value as? NSNumber { return value.stringValue }
    return nil
  }
}

struct SymptomRequestBody: Codable {
  let symptomState: String
  let symptomTypes: [String]
  let occurredAt: String
  let mealRecordId: String
}

enum PendingSymptomState: String, Codable { case pending, nativeUploading, flutterClaimed, quarantine }

struct PendingSymptomManifest: Codable {
  let clientRecordId: UUID
  let subjectId: String
  let notificationEventId: String
  var state: PendingSymptomState
  var claim: OutboxClaim?
  var attemptCount: Int
  var lastErrorClass: String?
  let createdAt: Date
}

struct OutboxClaim: Codable {
  let owner: String
  let token: UUID
  let claimedAt: Date
  let expiresAt: Date?
  var taskIdentifier: Int?
}

struct ClaimedSymptomRecord {
  let manifest: PendingSymptomManifest
  let request: SymptomRequestBody
  let requestURL: URL
}

/// App Group 안에서 record별 directory를 소유한다. public 호출은 serial queue와
/// process file lock을 모두 사용해 Extension과 Runner의 동시 수정도 막는다.
final class SymptomOutboxStore {
  private let queue = DispatchQueue(label: "com.canieatthis.symptom-outbox")
  private let coordinator = NSFileCoordinator(filePresenter: nil)
  private let root: URL
  private let cleanupMarker: URL

  init(config: NativeNotificationConfig, rootOverride: URL? = nil) throws {
    let resolvedRoot: URL
    if let rootOverride {
      resolvedRoot = rootOverride
    } else if let groupRoot = FileManager.default
      .containerURL(forSecurityApplicationGroupIdentifier: config.appGroupID) {
      resolvedRoot = groupRoot.appendingPathComponent("symptom-outbox", isDirectory: true)
    } else {
      throw SymptomOutboxError.invalidPayload
    }
    self.root = resolvedRoot
    self.cleanupMarker = resolvedRoot.appendingPathComponent("cleanup-required")
    try FileManager.default.createDirectory(at: resolvedRoot, withIntermediateDirectories: true)
  }

  func enqueue(payload: SymptomPushPayload, request: SymptomRequestBody) throws -> UUID {
    try locked {
      if FileManager.default.fileExists(atPath: cleanupMarker.path) { throw SymptomOutboxError.cleanupRequired }
      let id = UUID()
      let directory = root.appendingPathComponent(id.uuidString, isDirectory: true)
      try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: false)
      let manifest = PendingSymptomManifest(
        clientRecordId: id, subjectId: payload.subjectId, notificationEventId: payload.notificationEventId,
        state: .pending, claim: nil, attemptCount: 0, lastErrorClass: nil, createdAt: Date()
      )
      try write(request, to: directory.appendingPathComponent("request.json"))
      try write(manifest, to: directory.appendingPathComponent("manifest.json"))
      return id
    }
  }

  func claimForNative(clientRecordId: UUID) throws -> ClaimedSymptomRecord {
    try locked {
      var manifest = try readManifest(clientRecordId)
      guard manifest.state == .pending else { throw SymptomOutboxError.claimMismatch }
      let token = UUID()
      manifest.state = .nativeUploading
      manifest.attemptCount += 1
      manifest.claim = OutboxClaim(owner: "native", token: token, claimedAt: Date(), expiresAt: nil, taskIdentifier: nil)
      try writeManifest(manifest)
      return ClaimedSymptomRecord(manifest: manifest, request: try readRequest(clientRecordId), requestURL: requestURL(clientRecordId))
    }
  }

  func attachNativeTask(clientRecordId: UUID, claimToken: UUID, taskIdentifier: Int) throws {
    try locked {
      var manifest = try readManifest(clientRecordId)
      guard manifest.state == .nativeUploading, manifest.claim?.token == claimToken else { throw SymptomOutboxError.claimMismatch }
      manifest.claim?.taskIdentifier = taskIdentifier
      try writeManifest(manifest)
    }
  }

  func finishNative(clientRecordId: UUID, claimToken: UUID, success: Bool, errorClass: String? = nil, permanent: Bool = false) throws {
    try locked {
      var manifest = try readManifest(clientRecordId)
      guard manifest.claim?.token == claimToken else { throw SymptomOutboxError.claimMismatch }
      if success { try FileManager.default.removeItem(at: recordURL(clientRecordId)); return }
      manifest.state = permanent ? .quarantine : .pending
      manifest.claim = nil
      manifest.lastErrorClass = errorClass
      try writeManifest(manifest)
    }
  }

  /// Runner가 background session task 목록을 읽은 뒤 호출한다. callback 유실로
  /// task 없는 native claim이 남아도 10분 뒤 Flutter fallback으로 회수한다.
  func reconcileNativeTasks(_ taskDescriptions: Set<String>, now: Date = Date()) throws {
    try locked {
      for id in try records() {
        guard var manifest = try? readManifest(id), manifest.state == .nativeUploading,
              let claim = manifest.claim else { continue }
        let description = "\(id.uuidString)|\(claim.token.uuidString)"
        guard !taskDescriptions.contains(description), now.timeIntervalSince(claim.claimedAt) >= 600 else { continue }
        manifest.state = .pending
        manifest.claim = nil
        manifest.lastErrorClass = "native_task_missing"
        try writeManifest(manifest)
      }
    }
  }

  func claimPendingForFlutter(subjectId: String, limit: Int = 10) throws -> [ClaimedSymptomRecord] {
    try locked {
      let now = Date()
      return try records().compactMap { id in
        guard var manifest = try? readManifest(id), manifest.subjectId == subjectId else { return nil }
        let canClaim = manifest.state == .pending || (manifest.state == .flutterClaimed && (manifest.claim?.expiresAt ?? .distantFuture) <= now)
        guard canClaim else { return nil }
        manifest.state = .flutterClaimed
        manifest.attemptCount += 1
        manifest.claim = OutboxClaim(owner: "flutter", token: UUID(), claimedAt: now, expiresAt: now.addingTimeInterval(300), taskIdentifier: nil)
        try writeManifest(manifest)
        return ClaimedSymptomRecord(manifest: manifest, request: try readRequest(id), requestURL: requestURL(id))
      }.prefix(limit).map { $0 }
    }
  }

  func finishFlutter(clientRecordId: UUID, claimToken: UUID, outcome: PendingSymptomState, errorClass: String? = nil) throws {
    try locked {
      var manifest = try readManifest(clientRecordId)
      guard manifest.state == .flutterClaimed, manifest.claim?.token == claimToken else { throw SymptomOutboxError.claimMismatch }
      if outcome == .pending || outcome == .quarantine {
        manifest.state = outcome; manifest.claim = nil; manifest.lastErrorClass = errorClass; try writeManifest(manifest)
      } else {
        try FileManager.default.removeItem(at: recordURL(clientRecordId))
      }
    }
  }

  func purgeAll() throws {
    try locked {
      FileManager.default.createFile(atPath: cleanupMarker.path, contents: Data())
      for item in try FileManager.default.contentsOfDirectory(at: root, includingPropertiesForKeys: nil) where item != cleanupMarker {
        try FileManager.default.removeItem(at: item)
      }
      try? FileManager.default.removeItem(at: cleanupMarker)
    }
  }

  private func records() throws -> [UUID] {
    try FileManager.default.contentsOfDirectory(at: root, includingPropertiesForKeys: nil)
      .compactMap { UUID(uuidString: $0.lastPathComponent) }
  }
  private func recordURL(_ id: UUID) -> URL { root.appendingPathComponent(id.uuidString, isDirectory: true) }
  private func requestURL(_ id: UUID) -> URL { recordURL(id).appendingPathComponent("request.json") }
  private func manifestURL(_ id: UUID) -> URL { recordURL(id).appendingPathComponent("manifest.json") }
  private func readManifest(_ id: UUID) throws -> PendingSymptomManifest { try read(PendingSymptomManifest.self, from: manifestURL(id)) }
  private func readRequest(_ id: UUID) throws -> SymptomRequestBody { try read(SymptomRequestBody.self, from: requestURL(id)) }
  private func writeManifest(_ manifest: PendingSymptomManifest) throws { try write(manifest, to: manifestURL(manifest.clientRecordId)) }
  private func read<T: Decodable>(_ type: T.Type, from url: URL) throws -> T { try JSONDecoder.symptom.decode(T.self, from: Data(contentsOf: url)) }
  private func write<T: Encodable>(_ value: T, to url: URL) throws { try JSONEncoder.symptom.encode(value).write(to: url, options: .atomic) }
  private func locked<T>(_ action: () throws -> T) throws -> T {
    try queue.sync {
      var result: Result<T, Error>!
      var coordinationError: NSError?
      coordinator.coordinate(writingItemAt: root, options: [], error: &coordinationError) { _ in
        result = Result { try action() }
      }
      if let coordinationError { throw coordinationError }
      return try result.get()
    }
  }
}
