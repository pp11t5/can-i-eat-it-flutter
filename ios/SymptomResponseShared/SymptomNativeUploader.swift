import Foundation
import os

enum SymptomNativeUploadLog {
  private static let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.canieatthis.symptom-response",
    category: "SymptomNativeUpload"
  )

  static func debug(_ message: @autoclosure () -> String) {
    #if DEBUG
    // 토큰·전체 사용자 ID·request/response body는 호출부에서 제외한다.
    // 진단에 필요한 나머지 값은 실기기 Console에서도 <private>로 가려지지 않게 한다.
    let renderedMessage = message()
    logger.notice("[SymptomNativeUpload] \(renderedMessage, privacy: .public)")
    #endif
  }

  static func recordPrefix(_ clientRecordId: UUID) -> String {
    String(clientRecordId.uuidString.prefix(8))
  }

  static func errorDescription(_ error: Error?) -> String {
    guard let error else { return "none" }
    let nsError = error as NSError
    return "\(nsError.domain)(\(nsError.code))"
  }
}

enum SymptomNativeUploadOutcome: Equatable {
  case success
  case retryableFailure
  case permanentFailure
}

struct SymptomNativeUploadResponseClassifier {
  static func outcome(error: Error?, statusCode: Int?, responseBody: Data?) -> SymptomNativeUploadOutcome {
    guard error == nil else { return .retryableFailure }
    guard let statusCode else { return .retryableFailure }
    if (200...299).contains(statusCode) {
      return isSuccessfulEnvelope(responseBody) ? .success : .retryableFailure
    }
    if (400...499).contains(statusCode), statusCode != 401 { return .permanentFailure }
    return .retryableFailure
  }

  static func errorClass(error: Error?, statusCode: Int?, responseBody: Data?) -> String? {
    guard error == nil else { return "network" }
    guard let statusCode else { return "network" }
    if (200...299).contains(statusCode), !isSuccessfulEnvelope(responseBody) {
      return "unsuccessful_envelope"
    }
    return "http_\(statusCode)"
  }

  static func envelopeStatus(_ data: Data?) -> String {
    guard let data else { return "missing" }
    guard let envelope = try? JSONDecoder().decode(SymptomResponseEnvelope.self, from: data) else {
      return "invalid"
    }
    return envelope.isSuccess ? "true" : "false"
  }

  private static func isSuccessfulEnvelope(_ data: Data?) -> Bool {
    guard let data,
          let envelope = try? JSONDecoder().decode(SymptomResponseEnvelope.self, from: data) else { return false }
    return envelope.isSuccess
  }
}

/// Extension이 만든 background URLSession을, iOS가 이벤트를 넘겨줄 때만 Runner가 재연결한다.
final class SymptomNativeUploader: NSObject, URLSessionDataDelegate {
  static var shared: SymptomNativeUploader?
  private static let sharedLock = NSLock()

  private let config: NativeNotificationConfig
  private let store: SymptomOutboxStore
  private let tokenStore: SharedAccessTokenStore
  private var completionHandler: (() -> Void)?
  private var responseBodies = [Int: Data]()
  private var responseObservers = [UUID: (SymptomNativeUploadOutcome) -> Void]()
  private let responseObserversLock = NSLock()
  private let invalidationLock = NSLock()
  private var invalidationWaiter: DispatchSemaphore?
  lazy var session: URLSession = {
    SymptomNativeUploadLog.debug(
      "background session opening owner=\(Self.processRole) sessionID=\(config.backgroundSessionID)"
    )
    let configuration = URLSessionConfiguration.background(withIdentifier: config.backgroundSessionID)
    configuration.sharedContainerIdentifier = config.appGroupID
    configuration.sessionSendsLaunchEvents = true
    configuration.isDiscretionary = false
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()

  init(config: NativeNotificationConfig, store: SymptomOutboxStore, tokenStore: SharedAccessTokenStore) {
    self.config = config
    self.store = store
    self.tokenStore = tokenStore
    super.init()
  }

  var backgroundSessionID: String { config.backgroundSessionID }

  static func makeIfNeeded() throws -> SymptomNativeUploader {
    sharedLock.lock()
    defer { sharedLock.unlock() }
    if let shared { return shared }
    let config: NativeNotificationConfig
    do {
      config = try NativeNotificationConfig.load()
    } catch {
      SymptomNativeUploadLog.debug("configuration load failed error=\(SymptomNativeUploadLog.errorDescription(error))")
      throw error
    }
    let uploader = SymptomNativeUploader(
      config: config, store: try SymptomOutboxStore(config: config), tokenStore: SharedAccessTokenStore(config: config)
    )
    shared = uploader
    SymptomNativeUploadLog.debug(
      "uploader created host=\(config.apiBaseURL.host ?? "missing") sessionID=\(config.backgroundSessionID)"
    )
    return uploader
  }

  private static var processRole: String {
    Bundle.main.bundleURL.pathExtension == "appex" ? "extension" : "runner"
  }

  private static func releaseShared(_ uploader: SymptomNativeUploader) {
    sharedLock.lock()
    if shared === uploader { shared = nil }
    sharedLock.unlock()
  }

  func upload(
    clientRecordId: UUID,
    completion: @escaping (SymptomNativeUploadOutcome) -> Void = { _ in }
  ) throws {
    let claimed = try store.claimForNative(clientRecordId: clientRecordId)
    guard let claim = claimed.manifest.claim else { throw SymptomOutboxError.claimMismatch }
    setResponseObserver(completion, for: clientRecordId)
    let sessionResult = tokenStore.readResult()
    guard case .session(let sharedSession) = sessionResult,
          let ownerSubjectId = claimed.manifest.ownerSubjectId,
          sharedSession.subjectId == ownerSubjectId else {
      SymptomNativeUploadLog.debug(
        "upload skipped record=\(SymptomNativeUploadLog.recordPrefix(clientRecordId)) "
          + "keychain=\(sessionResult.diagnosticName) ownerPresent=\(claimed.manifest.ownerSubjectId != nil)"
      )
      do {
        try store.finishNative(
          clientRecordId: clientRecordId,
          claimToken: claim.token,
          success: false,
          errorClass: "missing_or_mismatched_session"
        )
      } catch {
        removeResponseObserver(for: clientRecordId)
        throw error
      }
      notifyResponseObserver(for: clientRecordId, outcome: .retryableFailure)
      return
    }
    let endpoint = config.apiBaseURL.appendingPathComponent("symptoms")
    var request = URLRequest(url: endpoint)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(sharedSession.accessToken)", forHTTPHeaderField: "Authorization")
    let task = session.uploadTask(with: request, fromFile: claimed.requestURL)
    task.taskDescription = "\(clientRecordId.uuidString)|\(claim.token.uuidString)"
    do {
      try store.attachNativeTask(clientRecordId: clientRecordId, claimToken: claim.token, taskIdentifier: task.taskIdentifier)
    } catch {
      SymptomNativeUploadLog.debug(
        "task attach failed record=\(SymptomNativeUploadLog.recordPrefix(clientRecordId)) "
          + "task=\(task.taskIdentifier) error=\(SymptomNativeUploadLog.errorDescription(error))"
      )
      task.cancel()
      try? store.finishNative(
        clientRecordId: clientRecordId,
        claimToken: claim.token,
        success: false,
        errorClass: "task_schedule_failed"
      )
      removeResponseObserver(for: clientRecordId)
      throw error
    }
    SymptomNativeUploadLog.debug(
      "upload started record=\(SymptomNativeUploadLog.recordPrefix(clientRecordId)) "
        + "task=\(task.taskIdentifier) host=\(endpoint.host ?? "missing")"
    )
    task.resume()
  }

  /// Extension의 응답 대기가 끝난 뒤 호출한다. 이후에 도착한 delegate callback은 Outbox만 정리한다.
  func removeResponseObserver(for clientRecordId: UUID) {
    responseObserversLock.lock()
    responseObservers.removeValue(forKey: clientRecordId)
    responseObserversLock.unlock()
  }

  func setBackgroundCompletionHandler(_ completionHandler: @escaping () -> Void) {
    self.completionHandler = completionHandler
    _ = session
  }

  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    responseBodies[dataTask.taskIdentifier, default: Data()].append(data)
  }

  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    let responseBody = responseBodies.removeValue(forKey: task.taskIdentifier)
    guard let pair = task.taskDescription?.split(separator: "|", maxSplits: 1), pair.count == 2,
          let recordID = UUID(uuidString: String(pair[0])), let claimToken = UUID(uuidString: String(pair[1])) else {
      SymptomNativeUploadLog.debug(
        "task completed without symptom metadata task=\(task.taskIdentifier) "
          + "error=\(SymptomNativeUploadLog.errorDescription(error))"
      )
      return
    }
    let statusCode = (task.response as? HTTPURLResponse)?.statusCode
    let outcome = SymptomNativeUploadResponseClassifier.outcome(
      error: error,
      statusCode: statusCode,
      responseBody: responseBody
    )
    SymptomNativeUploadLog.debug(
      "task completed record=\(SymptomNativeUploadLog.recordPrefix(recordID)) task=\(task.taskIdentifier) "
        + "http=\(statusCode.map(String.init) ?? "none") "
        + "urlError=\(SymptomNativeUploadLog.errorDescription(error)) "
        + "envelope=\(SymptomNativeUploadResponseClassifier.envelopeStatus(responseBody)) "
        + "outcome=\(outcome)"
    )
    do {
      try store.finishNative(
        clientRecordId: recordID,
        claimToken: claimToken,
        success: outcome == .success,
        errorClass: outcome == .success
          ? nil
          : SymptomNativeUploadResponseClassifier.errorClass(
            error: error,
            statusCode: statusCode,
            responseBody: responseBody
          ),
        permanent: outcome == .permanentFailure
      )
      SymptomNativeUploadLog.debug(
        "outbox finished record=\(SymptomNativeUploadLog.recordPrefix(recordID)) outcome=\(outcome)"
      )
      notifyResponseObserver(for: recordID, outcome: outcome)
    } catch {
      // Purge와 racing한 task callback은 정상 no-op이다. Extension에는 보관 안내만 보낸다.
      SymptomNativeUploadLog.debug(
        "outbox finish failed record=\(SymptomNativeUploadLog.recordPrefix(recordID)) "
          + "error=\(SymptomNativeUploadLog.errorDescription(error))"
      )
      notifyResponseObserver(for: recordID, outcome: .retryableFailure)
    }
  }

  func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
    SymptomNativeUploadLog.debug(
      "background session invalidated sessionID=\(session.configuration.identifier ?? "missing") "
        + "error=\(SymptomNativeUploadLog.errorDescription(error))"
    )
    Self.releaseShared(self)
    invalidationLock.lock()
    let waiter = invalidationWaiter
    invalidationWaiter = nil
    invalidationLock.unlock()
    waiter?.signal()
  }

  private func setResponseObserver(
    _ observer: @escaping (SymptomNativeUploadOutcome) -> Void,
    for clientRecordId: UUID
  ) {
    responseObserversLock.lock()
    responseObservers[clientRecordId] = observer
    responseObserversLock.unlock()
  }

  private func notifyResponseObserver(for clientRecordId: UUID, outcome: SymptomNativeUploadOutcome) {
    responseObserversLock.lock()
    let observer = responseObservers.removeValue(forKey: clientRecordId)
    responseObserversLock.unlock()
    guard let observer else { return }
    DispatchQueue.main.async { observer(outcome) }
  }

  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    SymptomNativeUploadLog.debug("background events finished sessionID=\(session.configuration.identifier ?? "missing")")
    session.finishTasksAndInvalidate()
    DispatchQueue.main.async { [completionHandler] in completionHandler?() }
    completionHandler = nil
  }

  func cancelAndPurge() throws {
    let group = DispatchGroup()
    group.enter()
    session.getAllTasks { tasks in
      tasks.forEach { $0.cancel() }
      group.leave()
    }
    let taskQueryCompleted = group.wait(timeout: .now() + 3) == .success
    SymptomNativeUploadLog.debug(
      "logout cleanup task query completed=\(taskQueryCompleted) sessionID=\(config.backgroundSessionID)"
    )
    let invalidationCompleted = invalidateAndWait()
    SymptomNativeUploadLog.debug(
      "logout cleanup session released=\(invalidationCompleted) sessionID=\(config.backgroundSessionID)"
    )
    try store.purgeAll()
    try tokenStore.clear()
  }

  /// 로그아웃 정리가 새 로그인 뒤 Extension upload와 session identifier를 다투지 않도록
  /// daemon 연결 해제를 확인한 뒤 MethodChannel 호출을 완료한다.
  private func invalidateAndWait(timeout: TimeInterval = 3) -> Bool {
    let waiter = DispatchSemaphore(value: 0)
    invalidationLock.lock()
    invalidationWaiter = waiter
    invalidationLock.unlock()
    session.invalidateAndCancel()
    let completed = waiter.wait(timeout: .now() + timeout) == .success
    if !completed {
      invalidationLock.lock()
      if invalidationWaiter === waiter { invalidationWaiter = nil }
      invalidationLock.unlock()
      // callback 유실 시에도 현재 프로세스가 오래된 uploader를 재사용하지 않게 한다.
      Self.releaseShared(self)
    }
    return completed
  }
}

struct SymptomResponseEnvelope: Decodable {
  let isSuccess: Bool
}

extension SharedSessionReadResult {
  var diagnosticName: String {
    switch self {
    case .session: "session"
    case .unavailableWhileLocked: "locked"
    case .notFound: "notFound"
    case .error: "error"
    }
  }
}
