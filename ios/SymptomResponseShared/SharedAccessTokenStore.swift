import Foundation
import Security

struct SharedAuthSession: Codable, Equatable {
  let schemaVersion: Int
  let accessToken: String
  let subjectId: String
  let updatedAt: Date
}

enum SharedSessionReadResult {
  case session(SharedAuthSession)
  case unavailableWhileLocked
  case notFound
  case error
}

final class SharedAccessTokenStore {
  private let accessGroup: String
  private let service = "com.canieatthis.symptom-response.shared-auth"
  private let account = "current-session-v1"

  init(config: NativeNotificationConfig) { accessGroup = config.keychainAccessGroup }

  func readResult() -> SharedSessionReadResult {
    var query = baseQuery
    query[kSecReturnData as String] = true
    query[kSecMatchLimit as String] = kSecMatchLimitOne
    var result: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    if status == errSecItemNotFound { return .notFound }
    if status == errSecInteractionNotAllowed { return .unavailableWhileLocked }
    guard status == errSecSuccess, let data = result as? Data,
          let session = try? JSONDecoder.symptom.decode(SharedAuthSession.self, from: data) else { return .error }
    return .session(session)
  }

  func sync(accessToken: String, subjectId: String) throws {
    let value = try JSONEncoder.symptom.encode(SharedAuthSession(
      schemaVersion: 1, accessToken: accessToken, subjectId: subjectId, updatedAt: Date()
    ))
    let attributes: [String: Any] = [kSecValueData as String: value]
    let status = SecItemUpdate(baseQuery as CFDictionary, attributes as CFDictionary)
    if status == errSecItemNotFound {
      var add = baseQuery
      add[kSecValueData as String] = value
      add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
      add[kSecAttrSynchronizable as String] = false
      let addStatus = SecItemAdd(add as CFDictionary, nil)
      guard addStatus == errSecSuccess else { throw NSError(domain: "SymptomKeychain", code: Int(addStatus)) }
    } else if status != errSecSuccess {
      throw NSError(domain: "SymptomKeychain", code: Int(status))
    }
  }

  func updateAccessTokenIfSessionExists(_ accessToken: String) throws {
    guard case .session(let session) = readResult() else { return }
    try sync(accessToken: accessToken, subjectId: session.subjectId)
  }

  func clear() throws {
    let status = SecItemDelete(baseQuery as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw NSError(domain: "SymptomKeychain", code: Int(status))
    }
  }

  private var baseQuery: [String: Any] {
    [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
      kSecAttrAccessGroup as String: accessGroup
    ]
  }
}

extension JSONEncoder {
  static let symptom: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
  }()
}

extension JSONDecoder {
  static let symptom: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }()
}
