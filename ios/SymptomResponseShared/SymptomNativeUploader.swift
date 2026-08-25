import Foundation

/// Extension과 Runner가 같은 identifier로 재생성하는 background URLSession uploader.
final class SymptomNativeUploader: NSObject, URLSessionTaskDelegate {
  static var shared: SymptomNativeUploader?

  private let config: NativeNotificationConfig
  private let store: SymptomOutboxStore
  private let tokenStore: SharedAccessTokenStore
  private var completionHandler: (() -> Void)?
  lazy var session: URLSession = {
    let configuration = URLSessionConfiguration.background(withIdentifier: config.backgroundSessionID)
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

  static func makeIfNeeded() throws -> SymptomNativeUploader {
    if let shared { return shared }
    let config = try NativeNotificationConfig.load()
    let uploader = SymptomNativeUploader(
      config: config, store: try SymptomOutboxStore(config: config), tokenStore: SharedAccessTokenStore(config: config)
    )
    shared = uploader
    return uploader
  }

  func upload(clientRecordId: UUID) throws {
    let claimed = try store.claimForNative(clientRecordId: clientRecordId)
    guard let claim = claimed.manifest.claim else { throw SymptomOutboxError.claimMismatch }
    guard case .session(let sharedSession) = tokenStore.readResult(),
          let ownerSubjectId = claimed.manifest.ownerSubjectId,
          sharedSession.subjectId == ownerSubjectId else {
      try store.finishNative(clientRecordId: clientRecordId, claimToken: claim.token, success: false, errorClass: "missing_or_mismatched_session")
      return
    }
    let endpoint = config.apiBaseURL.appendingPathComponent("symptoms")
    var request = URLRequest(url: endpoint)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(sharedSession.accessToken)", forHTTPHeaderField: "Authorization")
    let task = session.uploadTask(with: request, fromFile: claimed.requestURL)
    task.taskDescription = "\(clientRecordId.uuidString)|\(claim.token.uuidString)"
    try store.attachNativeTask(clientRecordId: clientRecordId, claimToken: claim.token, taskIdentifier: task.taskIdentifier)
    task.resume()
  }

  func setBackgroundCompletionHandler(_ completionHandler: @escaping () -> Void) {
    self.completionHandler = completionHandler
    _ = session
  }

  func reconcileBeforeFlutterClaim() throws {
    let group = DispatchGroup()
    var descriptions = Set<String>()
    group.enter()
    session.getAllTasks { tasks in
      descriptions = Set(tasks.compactMap(\.taskDescription))
      group.leave()
    }
    group.wait()
    try store.reconcileNativeTasks(descriptions)
  }

  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    guard let pair = task.taskDescription?.split(separator: "|", maxSplits: 1), pair.count == 2,
          let recordID = UUID(uuidString: String(pair[0])), let claimToken = UUID(uuidString: String(pair[1])) else { return }
    let status = (task.response as? HTTPURLResponse)?.statusCode
    let success = error == nil && (200...299).contains(status ?? 0)
    let permanent = status.map { $0 >= 400 && $0 < 500 && $0 != 401 } ?? false
    try? store.finishNative(
      clientRecordId: recordID, claimToken: claimToken, success: success,
      errorClass: success ? nil : (status.map { "http_\($0)" } ?? "network"), permanent: permanent
    )
  }

  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
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
    group.wait()
    try store.purgeAll()
    try tokenStore.clear()
  }
}
