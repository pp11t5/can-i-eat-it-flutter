import Foundation

enum SymptomConfigurationError: Error {
  case missing(String)
  case invalid(String)
}

struct NativeNotificationConfig {
  let appGroupID: String
  let keychainAccessGroup: String
  let apiBaseURL: URL
  let backgroundSessionID: String

  static func load(bundle: Bundle = .main) throws -> NativeNotificationConfig {
    func value(_ key: String) throws -> String {
      guard let value = bundle.object(forInfoDictionaryKey: key) as? String,
            !value.isEmpty,
            !value.contains("$(") else { throw SymptomConfigurationError.missing(key) }
      return value
    }
    let appGroupID = try value("SymptomAppGroupID")
    let keychainAccessGroup = try value("SymptomKeychainAccessGroup")
    let backgroundSessionID = try value("SymptomBackgroundSessionID")
    let apiBase = try value("SymptomAPIBaseURL")
    guard let apiBaseURL = URL(string: apiBase), apiBaseURL.scheme == "https" else {
      throw SymptomConfigurationError.invalid("SymptomAPIBaseURL")
    }
    let isDev = appGroupID.contains(".dev.")
    let isStaging = apiBaseURL.host.map { $0.contains("staging") } ?? false
    if isDev != isStaging {
      throw SymptomConfigurationError.invalid("flavor mismatch")
    }
    return NativeNotificationConfig(
      appGroupID: appGroupID,
      keychainAccessGroup: keychainAccessGroup,
      apiBaseURL: apiBaseURL,
      backgroundSessionID: backgroundSessionID
    )
  }
}
