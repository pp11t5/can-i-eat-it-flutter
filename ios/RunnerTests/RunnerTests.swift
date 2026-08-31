import Flutter
import UIKit
import XCTest
@testable import Runner

class RunnerTests: XCTestCase {

  func testNativeUploadClassifierAcceptsOnlySuccessfulEnvelope() {
    let response = Data("{\"isSuccess\":true}".utf8)

    XCTAssertEqual(
      SymptomNativeUploadResponseClassifier.outcome(
        error: nil,
        statusCode: 201,
        responseBody: response
      ),
      .success
    )
  }

  func testNativeUploadClassifierKeepsFailedEnvelopeForRetry() {
    let response = Data("{\"isSuccess\":false}".utf8)

    XCTAssertEqual(
      SymptomNativeUploadResponseClassifier.outcome(
        error: nil,
        statusCode: 200,
        responseBody: response
      ),
      .retryableFailure
    )
    XCTAssertEqual(
      SymptomNativeUploadResponseClassifier.errorClass(
        error: nil,
        statusCode: 200,
        responseBody: response
      ),
      "unsuccessful_envelope"
    )
  }

  func testNativeUploadClassifierKeepsNetworkErrorForRetry() {
    XCTAssertEqual(
      SymptomNativeUploadResponseClassifier.outcome(
        error: URLError(.notConnectedToInternet),
        statusCode: nil,
        responseBody: nil
      ),
      .retryableFailure
    )
  }

  func testNativeUploadClassifierQuarantinesPermanentClientError() {
    XCTAssertEqual(
      SymptomNativeUploadResponseClassifier.outcome(
        error: nil,
        statusCode: 422,
        responseBody: nil
      ),
      .permanentFailure
    )
  }

  func testNativeUploadClassifierRetriesUnauthorizedForFlutterRefresh() {
    XCTAssertEqual(
      SymptomNativeUploadResponseClassifier.outcome(
        error: nil,
        statusCode: 401,
        responseBody: nil
      ),
      .retryableFailure
    )
  }

  func testExpiredNativeClaimRecoversWithoutOpeningBackgroundSession() throws {
    let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer { try? FileManager.default.removeItem(at: root) }
    let config = NativeNotificationConfig(
      appGroupID: "group.test.symptom", keychainAccessGroup: "test.keychain",
      apiBaseURL: try XCTUnwrap(URL(string: "https://example.com")),
      backgroundSessionID: "test.symptom.session"
    )
    let store = try SymptomOutboxStore(config: config, rootOverride: root)
    let recordID = try store.enqueue(
      request: SymptomRequestBody(
        symptomState: "normal", symptomTypes: [], occurredAt: "2026-08-26T12:00:00+09:00", mealRecordId: "meal-id"
      ),
      ownerSubjectId: nil
    )
    _ = try store.claimForNative(clientRecordId: recordID)

    try store.recoverExpiredNativeClaimsForFlutterFallback(now: Date().addingTimeInterval(601))

    let claimed = try store.claimPendingForFlutter(currentSubjectId: nil)
    XCTAssertEqual(claimed.map(\.manifest.clientRecordId), [recordID])
  }

}
