# iOS 리치 푸시 증상 기록 구현 명세

> 상태: 구현 착수용
> 기준 branch: `codex/ios-rich-push`
> 기준 commit: `develop`의 `f0ba2fa6800b0a4d1a4e81aff065ee763a7bb2f5` (app version `1.0.0+11`)
> 상위 계획: [`ios-rich-push-implementation-plan.md`](./ios-rich-push-implementation-plan.md)

## 1. 문서 목적

이 문서는 iOS Notification Content Extension에서 증상을 입력하고, App Group Outbox와 background `URLSession`으로 전송한 뒤 Flutter 앱에서 미완료 건을 재전송하는 기능의 구현 계약이다.

상위 계획서는 범위와 의사결정의 정본이고, 이 문서는 구현 방법의 정본이다. 구현 중 두 문서가 충돌하면 다음 순서로 처리한다.

1. 제품·데이터 계약은 상위 계획서를 따른다.
2. 타입, 인터페이스, 상태 전이, 파일 배치는 이 문서를 따른다.
3. 서버 OpenAPI나 실제 signed entitlement가 문서와 다르면 구현을 추정하지 말고 문서를 먼저 갱신한다.

## 2. 고정 범위와 불변 조건

### 2.1 V1 포함

- `post_meal` 및 `post_meal_delayed_single` Notification Content Extension
- 앱과 동일한 5단계 증상 상태
- 앱과 동일한 증상 4종 및 명시적 `없음`
- 알림 안의 `기록 완료`
- 시스템 `앱에서 자세히` action
- App Group 파일 Outbox
- Extension background upload
- Flutter cold start·session ready·resume 재전송
- access token만 공유하는 Keychain session
- dev/prod 완전 격리

### 2.2 V1 제외

- `나중에 알림`과 snooze action/API/스케줄러
- Notification Service Extension
- 이미지 다운로드와 `mutable-content`
- 알림 안의 메모·발생 시각 수정
- 서버 idempotency key
- 정상 로그인 세션에서 pending 자동 만료

### 2.3 절대 불변 조건

1. Outbox 저장 성공 전에는 알림을 성공으로 닫거나 delivered notification 목록에서 제거하지 않는다.
2. 서버 2xx와 성공 envelope를 모두 확인하기 전에는 record를 삭제하지 않는다.
3. Extension은 refresh token을 읽거나 저장하지 않는다.
4. 토큰은 App Group 파일과 로그에 저장하지 않는다.
5. Flutter는 App Group 파일을 직접 열지 않는다. Swift store만 파일을 소유한다.
6. 한 record는 native upload 또는 Flutter upload 중 한 owner만 claim한다.
7. logout·withdraw·offline signOut·session expiry에서 background task, Outbox, 공유 Keychain session을 purge한다.
8. dev target은 prod App Group·Keychain group·API를 참조하지 않고 반대도 동일하다.
9. snooze 관련 UI, action ID, schema, API 코드를 추가하지 않는다.

## 3. 구현 순서와 PR 경계

의존성을 아래 순서로 구현한다. 뒤 단계는 앞 단계 테스트가 통과한 뒤 시작한다.

| Slice | 내용 | 완료 조건 |
|---|---|---|
| 1 | Xcode target, xcconfig, entitlement, category 등록 | dev/prod simulator build와 unsigned archive 구조 검사 통과 |
| 2 | 공유 Swift contract, Outbox, Keychain store | Swift 단위 테스트 전체 통과 |
| 3 | Native uploader, AppDelegate callback, Content Extension UI | 오프라인 enqueue와 stub server 분류 테스트 통과 |
| 4 | MethodChannel, Flutter retry, 인증 lifecycle 배선 | Flutter 단위·widget 회귀 테스트 통과 |
| 5 | 실제 APNs, background callback, logout, flavor 격리 | 실기기/TestFlight 수용 기준 통과 |

각 Slice는 독립 리뷰가 가능한 커밋 또는 PR로 유지한다. `.pbxproj` 변경과 기능 코드를 한 커밋에 섞지 않는다.

## 4. 최종 파일 배치

### 4.1 신규 iOS 파일

```text
ios/
├── Config/
│   ├── NotificationResponse-dev.xcconfig
│   └── NotificationResponse-prod.xcconfig
├── SharedNotificationResponse/
│   ├── NotificationResponseContract.swift
│   ├── NotificationResponseDateFormatter.swift
│   ├── NativeNotificationConfig.swift
│   ├── AppGroupOutboxStore.swift
│   ├── CrossProcessFileLock.swift
│   ├── SharedAccessTokenStore.swift
│   ├── BackgroundResponseClassifier.swift
│   ├── BackgroundSymptomUploader.swift
│   ├── BackgroundSessionRegistry.swift
│   └── SymptomOutboxMethodChannel.swift
└── SymptomNotificationContent/
    ├── NotificationViewController.swift
    ├── SymptomCheckInViewModel.swift
    ├── MainInterface.storyboard
    ├── Info.plist
    └── SymptomNotificationContent.entitlements
```

`SharedNotificationResponse`는 framework를 만들지 않고 source target membership으로 공유한다.

| 파일 | Runner | Extension |
|---|---:|---:|
| contract/date/config/outbox/lock/keychain/classifier/uploader | O | O |
| `BackgroundSessionRegistry` | O | O |
| `SymptomOutboxMethodChannel` | O | X |
| `SymptomCheckInViewModel` | O | O |
| `NotificationViewController` | X | O |

`SymptomCheckInViewModel`은 UIKit과 `UNNotificationExtensionContext`를 직접 참조하지 않는 순수 상태 객체로 만들고 dismiss/uploader는 closure 또는 protocol로 주입한다. 그래야 Runner target의 `RunnerTests`에서 테스트할 수 있다.

### 4.2 신규 Dart 파일

```text
lib/
├── core/native/
│   ├── symptom_outbox_bridge.dart
│   └── method_channel_symptom_outbox_bridge.dart
└── features/notification/
    ├── domain/pending_symptom_record.dart
    ├── data/symptom_pending_upload_service.dart
    ├── application/symptom_outbox_retry_coordinator.dart
    └── application/symptom_outbox_providers.dart
```

### 4.3 신규 테스트·fixture

```text
ios/RunnerTests/
├── NotificationResponseContractTests.swift
├── AppGroupOutboxStoreTests.swift
├── BackgroundResponseClassifierTests.swift
├── BackgroundSessionRegistryTests.swift
└── SymptomCheckInViewModelTests.swift
test/
├── core/native/method_channel_symptom_outbox_bridge_test.dart
├── features/notification/data/symptom_pending_upload_service_test.dart
├── features/notification/application/symptom_outbox_retry_coordinator_test.dart
└── fixtures/notification_response/
    ├── valid-payload-v1.json
    ├── pending-record-v1.json
    └── symptom-request-v1.json
```

Swift와 Dart 테스트는 같은 fixture 내용을 복제해서 만들지 않는다. Xcode test target에 `test/fixtures/notification_response`를 folder reference 또는 copy resource로 연결해 같은 JSON을 읽는다.

### 4.4 수정 파일

| 파일 | 변경 |
|---|---|
| `ios/Runner.xcodeproj/project.pbxproj` | Extension target/configuration/dependency/embed/test membership |
| `ios/Runner/AppDelegate.swift` | category 등록, background session callback, MethodChannel 등록 |
| `ios/Runner/Runner.entitlements` | flavor별 App Group·Keychain access group |
| `ios/Runner/Info.plist` | native config build-setting 키 |
| `ios/Flutter/*-dev.xcconfig` | dev native config include |
| `ios/Flutter/*-prod.xcconfig` | prod native config include |
| `lib/app/app.dart` | retry coordinator 활성화 |
| `lib/core/security/token_store.dart` | access token mirror decorator/provider |
| `lib/core/network/auth_interceptor.dart` | async session-expiry cleanup seam |
| `lib/core/network/dio_client.dart` | request/response body debug logging 비활성화 |
| `lib/core/push/fcm_messaging_handler.dart` | FCM data 전체 로그 제거 |
| `lib/features/auth/presentation/providers/auth_providers.dart` | session sync와 모든 auth exit purge |
| `lib/features/symptom/presentation/providers/symptom_write_controller.dart` | 공통 cache invalidation helper 사용 |

`push_payload_resolver.dart`의 `post_meal → /symptom/record` 계약은 변경하지 않는다. `앱에서 자세히` 회귀 테스트만 추가한다.

현재 Dio logger는 request/response body를 출력하고 FCM handler는 `message.data` 전체를 출력하므로 그대로 두면 `mealRecordId`와 증상 값이 debug log에 남는다. V1에서는 `LogInterceptor.requestBody`와 `responseBody`를 모두 `false`로 바꾸고, FCM 로그는 message ID와 `type`만 출력한다. `targetId`, `subjectId`, token, 증상 입력값, API body/response body를 출력하지 않는다.

## 5. Xcode와 flavor 설정

### 5.1 target

`SymptomNotificationContent` target을 다음 값으로 생성한다.

| 항목 | 값 |
|---|---|
| Product | Notification Content Extension (`.appex`) |
| Deployment Target | iOS 15.0 |
| Swift | 5.0 |
| Team | `SXJPM9PRM7` |
| Signing | Automatically manage signing |
| Host | `Runner` |
| Embed | Runner `Embed App Extensions`에 `.appex` 추가 |

Extension target configuration은 프로젝트와 동일한 여섯 개를 둔다.

- `Debug-dev`
- `Release-dev`
- `Profile-dev`
- `Debug-prod`
- `Release-prod`
- `Profile-prod`

Extension target에는 CocoaPods, Flutter framework, `Generated.xcconfig`를 연결하지 않는다.

### 5.2 flavor 정본

등록 완료된 식별자는 아래 값을 구현 정본으로 사용한다. Developer Portal에 실제 등록한 값이 다르면 첫 Xcode 변경 전에 이 표를 실제 값으로 고친다.

| 설정 | dev | prod |
|---|---|---|
| Runner bundle | `com.canieatthis.canIEatThis.dev` | `com.canieatthis.canIEatThis1` |
| Extension bundle | `com.canieatthis.canIEatThis.dev.SymptomNotificationContent` | `com.canieatthis.canIEatThis1.SymptomNotificationContent` |
| App Group | `group.com.canieatthis.canIEatThis.dev.symptom-response` | `group.com.canieatthis.canIEatThis1.symptom-response` |
| Keychain suffix | `com.canieatthis.canIEatThis.dev.extension-auth` | `com.canieatthis.canIEatThis1.extension-auth` |
| API base | `https://staging.can-i-eat-it.com/api/v1` | `https://prod.can-i-eat-it.com/api/v1` |
| background session | `com.canieatthis.symptom-response.dev.extension` | `com.canieatthis.symptom-response.prod.extension` |

Runner가 별도 background session ID를 만들지 않는다. Extension이 만든 session ID 하나를 Runner가 background callback과 resume reconciliation에서 같은 identifier로 재생성한다. Flutter fallback은 Dio를 사용한다.

### 5.3 xcconfig

`NotificationResponse-dev.xcconfig`:

```xcconfig
SYMPTOM_EXTENSION_BUNDLE_ID = com.canieatthis.canIEatThis.dev.SymptomNotificationContent
SYMPTOM_APP_GROUP_ID = group.com.canieatthis.canIEatThis.dev.symptom-response
SYMPTOM_KEYCHAIN_ACCESS_GROUP = $(AppIdentifierPrefix)com.canieatthis.canIEatThis.dev.extension-auth
SYMPTOM_API_BASE_URL = https:/$()/staging.can-i-eat-it.com/api/v1
SYMPTOM_BACKGROUND_SESSION_ID = com.canieatthis.symptom-response.dev.extension
```

`NotificationResponse-prod.xcconfig`:

```xcconfig
SYMPTOM_EXTENSION_BUNDLE_ID = com.canieatthis.canIEatThis1.SymptomNotificationContent
SYMPTOM_APP_GROUP_ID = group.com.canieatthis.canIEatThis1.symptom-response
SYMPTOM_KEYCHAIN_ACCESS_GROUP = $(AppIdentifierPrefix)com.canieatthis.canIEatThis1.extension-auth
SYMPTOM_API_BASE_URL = https:/$()/prod.can-i-eat-it.com/api/v1
SYMPTOM_BACKGROUND_SESSION_ID = com.canieatthis.symptom-response.prod.extension
```

xcconfig에서 `//`가 주석으로 해석되는 문제를 피하기 위해 URL의 두 번째 slash를 `$()`로 분리한다.

각 `ios/Flutter/Debug-dev.xcconfig`, `Release-dev.xcconfig`, `Profile-dev.xcconfig`는 dev config를 include하고, prod의 세 파일도 같은 방식으로 include한다. Extension target은 `Extension-dev.xcconfig` 또는 `Extension-prod.xcconfig`를 base configuration으로 직접 사용하며 Flutter·CocoaPods·Generated.xcconfig를 include하지 않는다.

`--dart-define=API_BASE_URL`로 Flutter API를 override하는 빌드는 반드시 같은 값의 `SYMPTOM_API_BASE_URL` Xcode build setting도 함께 넘긴다. 두 값이 다를 수 있는 임의 QA build에서는 rich-push category 발송을 금지한다.

### 5.4 Info.plist runtime config

Runner와 Extension `Info.plist`에 동일 키를 둔다.

```xml
<key>SymptomAppGroupIdentifier</key>
<string>$(SYMPTOM_APP_GROUP_ID)</string>
<key>SymptomKeychainAccessGroup</key>
<string>$(SYMPTOM_KEYCHAIN_ACCESS_GROUP)</string>
<key>SymptomAPIBaseURL</key>
<string>$(SYMPTOM_API_BASE_URL)</string>
<key>SymptomBackgroundSessionIdentifier</key>
<string>$(SYMPTOM_BACKGROUND_SESSION_ID)</string>
```

`NativeNotificationConfig.load(bundle:)`는 네 값을 읽고 빈 값, 미확장 `$(`, URL parse 실패를 감지하면 `configurationInvalid`를 반환한다. prod에서 dev 문자열이 포함되거나 dev에서 prod App Group이 들어오면 debug assertion과 release 오류를 모두 발생시킨다.

### 5.5 entitlement

Runner와 Extension의 같은 flavor가 다음 값을 공유한다.

```xml
<key>com.apple.security.application-groups</key>
<array>
  <string>$(SYMPTOM_APP_GROUP_ID)</string>
</array>
<key>keychain-access-groups</key>
<array>
  <string>$(SYMPTOM_KEYCHAIN_ACCESS_GROUP)</string>
</array>
```

기존 Runner의 `aps-environment`는 유지한다. Extension entitlement에는 `aps-environment`와 `UIBackgroundModes`를 추가하지 않는다.

## 6. Notification payload 계약

### 6.1 FCM/APNs

백엔드는 iOS 식후 증상 알림에 다음 필드를 보낸다.

```json
{
  "notification": {
    "title": "지금 속은 어때요?",
    "body": "13:24 점심 후 6시간 · 된장찌개 · 잡곡밥"
  },
  "data": {
    "type": "post_meal",
    "targetId": "c4e90e6a-2b3c-4d5e-8f90-1a2b3c4d5e6f"
  },
  "apns": {
    "payload": {
      "aps": {
        "category": "post_meal",
        "thread-id": "post-meal-checkin"
      }
    }
  }
}
```

위 JSON은 FCM HTTP v1 발송 형식이다. 실제 Content Extension의 `UNNotificationContent.userInfo`에서는 FCM `data` 필드가 top-level key로 전달되므로 decoder는 `userInfo["type"]`, `userInfo["targetId"]`를 읽는다. `userInfo["data"]` 중첩 객체를 기대하지 않는다. `aps.category`와 `data.type`은 같아야 하며 둘 다 `post_meal` 또는 `post_meal_delayed_single`이어야 한다. 화면 제목과 본문은 `notification.request.content.title/body`에서 읽는다.

검증 규칙:

| 필드 | 규칙 | 실패 시 |
|---|---|---|
| `type` | `post_meal` 또는 `post_meal_delayed_single` | 동일 |
| `targetId` | trim 후 비어 있지 않은 문자열 | 동일 |

`targetId`를 `mealRecordId`로 그대로 사용한다. UUID 형식 검사는 클라이언트에서 강제하지 않는다. 서버가 외부 ID 형식을 변경해도 비어 있지 않은 문자열이면 전달한다.

### 6.2 category와 action

Runner launch에서 다음 category를 등록한다.

```swift
let openApp = UNNotificationAction(
  identifier: "SYMPTOM_OPEN_APP_ACTION",
  title: "앱에서 자세히",
  options: [.foreground]
)
let categories = ["post_meal", "post_meal_delayed_single"].map {
  UNNotificationCategory(identifier: $0, actions: [openApp], intentIdentifiers: [], options: [])
}
```

`setNotificationCategories`는 기존 category 전체를 교체하므로 현재 등록 목록을 조회해 두 category만 upsert한 뒤 합쳐서 설정한다. 다른 Flutter plugin 또는 향후 category를 제거하지 않는다.

`SYMPTOM_SNOOZE_ACTION`은 등록하지 않는다. `NotificationViewController.didReceive(_:completionHandler:)`에서 `SYMPTOM_OPEN_APP_ACTION`을 받으면 `.dismissAndForwardAction`을 반환해 containing app으로 전달한다. Runner는 기존 Firebase `getInitialMessage`/`onMessageOpenedApp` 경로에서 `post_meal` payload를 처리한다. V1에 별도 native→Flutter navigation channel을 만들지 않으며, 이 경로가 실기기에서 실패하면 release를 차단하고 계약을 다시 검토한다.

## 7. 데이터 계약

### 7.1 enum

```swift
enum SymptomStateCode: String, Codable, CaseIterable {
  case comfortable, good, normal, uncomfortable, severe
}

enum SymptomTypeCode: String, Codable, CaseIterable {
  case throatForeignBody = "throat_foreign_body"
  case acidReflux = "acid_reflux"
  case cough
  case chestTightness = "chest_tightness"
}
```

Slider index mapping은 다음과 같다.

| index | UI | API |
|---:|---|---|
| 0 | 편안 | `comfortable` |
| 1 | 양호 | `good` |
| 2 | 보통 | `normal` |
| 3 | 불편 | `uncomfortable` |
| 4 | 심각 | `severe` |

증상 chip은 앱의 문구를 사용한다.

| UI | API |
|---|---|
| 없음 | `[]` |
| 목 이물감이 있어요 | `throat_foreign_body` |
| 신물이 느껴져요 | `acid_reflux` |
| 기침이 나요 | `cough` |
| 가슴이 답답해요 | `chest_tightness` |

`없음`은 저장 enum이 아니라 view state의 `selectedNone: Bool`이다. `selectedNone == true`이면 다른 type을 모두 해제한다. type을 선택하면 `selectedNone = false`로 바꾼다.

### 7.2 API request body

`request-body.json`은 아래 네 필드만 가진다.

```json
{
  "symptomState": "normal",
  "symptomTypes": ["acid_reflux"],
  "occurredAt": "2026-08-13T21:10:03+09:00",
  "mealRecordId": "c4e90e6a-2b3c-4d5e-8f90-1a2b3c4d5e6f"
}
```

- `memo`, `recordedAt`, `source`, `clientRecordId`를 API body에 넣지 않는다.
- `symptomTypes`는 0~4개 unique 값이다.
- `occurredAt`은 `기록 완료` 첫 탭 시점의 `Date()`를 `Asia/Seoul`, `en_US_POSIX`, Gregorian calendar로 `yyyy-MM-dd'T'HH:mm:ssXXX` 형식화한다.
- Flutter fallback은 문자열을 `DateTime.toLocal()`로 변환하지 않고 저장된 ISO 문자열을 그대로 보낸다.
- endpoint는 `{SymptomAPIBaseURL}/symptoms`다.

### 7.3 manifest

```json
{
  "schemaVersion": 1,
  "clientRecordId": "9A489D3E-5CB5-4F53-B6BB-ED8A2BB385E2",
  "notificationRequestId": "UNNotificationRequest.identifier",
  "ownerSubjectId": "shared-session-user-id 또는 null",
  "state": "pending",
  "claim": null,
  "attemptCount": 0,
  "lastAttemptAt": null,
  "lastErrorClass": null,
  "createdAt": "2026-08-13T21:10:03+09:00"
}
```

Claim이 있을 때:

```json
{
  "owner": "native",
  "token": "claim-uuid",
  "claimedAt": "2026-08-13T21:10:04+09:00",
  "expiresAt": null,
  "sessionIdentifier": "com.canieatthis.symptom-response.dev.extension",
  "taskIdentifier": 17
}
```

Flutter claim은 `owner: "flutter"`, 5분 뒤 `expiresAt`, `sessionIdentifier/taskIdentifier: null`을 사용한다.

허용 값:

```swift
enum OutboxState: String, Codable {
  case pending
  case nativeUploading
  case flutterClaimed
}

enum UploadOwner: String, Codable {
  case native
  case flutter
}
```

`lastErrorClass`는 아래 code만 저장하고 서버 message나 request body를 넣지 않는다.

- `offline`
- `timeout`
- `rateLimited`
- `server5xx`
- `unauthorized`
- `permanent4xx`
- `invalidEnvelope`
- `configuration`
- `unknown`

## 8. Outbox 파일과 상태 머신

### 8.1 디렉터리

```text
<AppGroup>/NotificationOutbox/v1/
├── .lock
├── cleanup-required
├── staging/
├── pending/
│   └── <clientRecordId>/
│       ├── manifest.json
│       └── request-body.json
├── tombstone/
└── quarantine/
    └── <clientRecordId>/
        ├── manifest.json
        ├── request-body.json
        └── quarantine.json
```

모든 디렉터리와 파일은 `NSFileProtectionCompleteUntilFirstUserAuthentication`을 적용한다. `quarantine.json`에는 `reasonCode`, HTTP status, 서버 envelope code만 저장하고 message/body/token은 저장하지 않는다.

### 8.2 저장 protocol

```swift
enum UploadDisposition {
  case success
  case retry(errorClass: String?)
  case quarantine(reason: QuarantineReason)
}

protocol AppGroupOutboxStoring {
  func enqueue(
    manifest: PendingSymptomManifest,
    request: SymptomCreateRequest
  ) throws -> EnqueueResult

  func claimPendingForFlutter(
    currentSubjectId: String?,
    limit: Int,
    leaseDuration: TimeInterval,
    excluding activeNativeRecordIds: Set<UUID>
  ) throws -> [ClaimedSymptomRecord]

  func claimForNative(clientRecordId: UUID) throws -> ClaimedSymptomRecord

  func attachNativeTask(
    clientRecordId: UUID,
    claimToken: UUID,
    sessionIdentifier: String,
    taskIdentifier: Int
  ) throws

  func releaseNativeClaim(
    clientRecordId: UUID,
    claimToken: UUID,
    errorClass: String?
  ) throws

  func finishNative(
    clientRecordId: UUID,
    sessionIdentifier: String,
    taskIdentifier: Int,
    disposition: UploadDisposition
  ) throws

  func finishFlutter(
    clientRecordId: UUID,
    claimToken: UUID,
    disposition: UploadDisposition
  ) throws

  func reconcileNativeTasks(_ tasks: [NativeTaskSnapshot], now: Date) throws
  func recoverStaging(now: Date) throws
  func purgeAll() throws
  func pendingCount() throws -> Int
}
```

모든 mutation은 `.lock`을 잡은 상태에서 manifest를 다시 읽고 precondition을 확인한다. 읽기 때 얻은 객체를 lock 밖에서 그대로 덮어쓰지 않는다.

`CrossProcessFileLock`은 `.lock` 파일 descriptor에 `flock`을 사용한다. `LOCK_EX | LOCK_NB`를 25ms 간격으로 최대 2초 재시도하고, 그 안에 획득하지 못하면 `lockTimeout`을 반환한다. 네트워크 요청이나 URLSession callback 대기 중에는 lock을 보유하지 않는다.

`attemptCount`와 `lastAttemptAt`은 native task attach 또는 Flutter claim 성공 때 갱신한다. retry disposition은 `lastErrorClass`를 갱신하고 state를 `pending`으로 되돌린다. success/quarantine에서는 attempt metadata를 별도 analytics로 보내지 않는다.

### 8.3 enqueue

1. payload와 입력값을 검증한다.
2. 첫 탭에서 `clientRecordId`와 `occurredAt`을 한 번 생성한다.
3. `staging/<clientRecordId>`에 두 JSON을 임시 파일로 쓴다.
4. file handle을 synchronize하고 file protection을 적용한다.
5. lock 안에서 `notificationRequestId`가 pending/quarantine에 이미 있는지 확인한다.
6. 기존 record가 있으면 새 staging을 지우고 `.duplicate(existingClientRecordId)`를 반환한다.
7. 없으면 directory를 같은 volume의 `pending`으로 atomic rename한다.
8. rename 성공 후에만 native upload를 예약한다.

같은 알림의 연속 탭은 view button 비활성화와 `notificationRequestId` local dedupe 두 단계로 막는다. 서버에 전송이 끝난 뒤 발생하는 중복은 서버 idempotency가 없으므로 막지 않는다.

`recoverStaging`은 수정 시각이 60초 이상 지난 directory만 처리한다. 두 JSON이 모두 유효하면 lock 안에서 pending/quarantine duplicate를 확인한 뒤 pending으로 이동하고, 불완전하거나 손상된 staging은 quarantine으로 이동한다. 60초 미만 staging은 다른 프로세스가 쓰는 중일 수 있으므로 건드리지 않는다.

### 8.4 native claim

1. `claimForNative`가 pending record를 lock 안에서 `nativeUploading`으로 변경하고 claim token을 만든다.
2. claim 결과에 포함된 request body file로 upload task를 `resume()`하지 않은 상태로 생성한다.
3. `attachNativeTask`가 같은 claim token을 검증한 뒤 `taskIdentifier`, session identifier를 manifest에 저장한다.
4. manifest 저장이 성공하면 task를 resume한다.
5. task 생성·manifest 저장 실패 시 task를 cancel하고 `releaseNativeClaim`으로 record를 `pending`으로 되돌린다.

`taskDescription`은 `clientRecordId.uuidString`이다.

### 8.5 Flutter claim

Runner의 일반 ready/resume claim은 Extension background session을 재생성하거나 `getAllTasks`를 호출하지 않는다. Extension이 같은 session identifier를 소유한 동안 Runner가 연결하면 `NSURLErrorBackgroundSessionInUseByAnotherProcess(-996)`로 native upload가 실패하기 때문이다. 이 경로에서는 App Group Outbox 파일만 읽고 다음 조건을 만족하는 record를 claim한다.

- `ownerSubjectId`가 현재 공유 Keychain 사용자와 동일하거나 `null`
- state가 `pending`
- 또는 `flutterClaimed` lease가 만료됨
- active native task 집합에 없음
- `nativeUploading`이 아님

한 번에 최대 10건을 claim하며 각 record에 임의 claim token과 5분 lease를 기록한다. Flutter의 success/retry/quarantine `finishFlutter`는 같은 claim token을 보내야 한다. token mismatch는 아무 파일도 바꾸지 않고 `claimMismatch` 오류를 반환한다.

### 8.6 native reconciliation

iOS가 `application(_:handleEventsForBackgroundURLSession:completionHandler:)`를 호출해 session 이벤트를 Runner에 넘긴 경우에만 Runner가 해당 session을 재연결한다. 일반 앱 launch/resume에서는 session을 열지 않는다. callback 유실로 남은 native claim은 Outbox 파일의 `claimedAt`만 기준으로 10분 뒤 Flutter fallback으로 복구한다.

Runner가 background 이벤트 처리를 마치면 `finishTasksAndInvalidate()`로 session 소유권을 반환하고 uploader singleton을 해제한다. 로그아웃·탈퇴·세션 만료의 `cancelAndPurge`도 task cancel 후 `invalidateAndCancel()`의 invalidation callback을 최대 3초 기다린 다음 singleton을 해제한다. 따라서 로그아웃 후 재로그인한 같은 Runner 프로세스가 Extension session identifier를 계속 점유하지 않는다.

- manifest는 nativeUploading이고 `claimedAt` 후 10분 미만이면 callback 유예로 유지
- 10분 이상이면 task 조회 없이 `pending`으로 복구한다. 이때 실제 task가 늦게 살아 있으면 서버 idempotency 부재로 중복 전송될 수 있으며, 기존 수용 리스크로 관리한다.

Flutter claim은 위의 파일 기반 stale-claim 복구 후에만 실행한다.

### 8.7 terminal 처리

```text
pending
  ├─ native claim ───────> nativeUploading ── 2xx success ──> tombstone ──> delete
  │                              └─ retryable ───────────────> pending
  │                              └─ permanent ───────────────> quarantine
  └─ Flutter claim ──────> flutterClaimed ─── 2xx success ──> tombstone ──> delete
                                 └─ retryable/crash ─────────> pending/lease expiry
                                 └─ permanent ───────────────> quarantine
```

Ack는 lock 안에서 `pending/<id>`를 `tombstone/<id>`로 rename한 뒤 lock을 풀고 삭제한다. tombstone 삭제 실패는 다음 bootstrap에서 재시도하며 서버 재전송 대상에는 포함하지 않는다.

## 9. 공유 Keychain session

### 9.1 item

```swift
struct SharedAuthSession: Codable, Equatable {
  let schemaVersion: Int // 1
  let accessToken: String
  let subjectId: String
  let updatedAt: Date
}
```

Keychain 속성:

| 속성 | 값 |
|---|---|
| class | `kSecClassGenericPassword` |
| service | `com.canieatthis.symptom-response.shared-auth` |
| account | `current-session-v1` |
| access group | flavor의 `SYMPTOM_KEYCHAIN_ACCESS_GROUP` |
| accessible | `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly` |
| synchronizable | false |

`SharedAccessTokenStore` API:

```swift
protocol SharedAccessTokenStoring {
  func readSession() throws -> SharedAuthSession?
  func syncSession(accessToken: String, subjectId: String) throws
  func updateAccessTokenIfSessionExists(_ accessToken: String) throws
  func clear() throws
}
```

Extension은 payload에 `subjectId`를 요구하지 않는다. 공유 Keychain session을 읽을 수 있으면 그 사용자 ID를 내부 `ownerSubjectId`로 저장하고 직접 업로드한다. Keychain을 읽지 못하면 `ownerSubjectId = null`로 enqueue만 허용하며 native upload는 하지 않는다. 소유자 없는 record는 다음 ready/resume의 현재 사용자로 재전송될 수 있다.

Extension은 Keychain 조회 결과를 다음처럼 구분한다.

| 조회 결과 | 기록 완료 |
|---|---|
| session 존재 + subject 일치 | enqueue 후 native upload 시도 |
| `errSecInteractionNotAllowed` 등 잠금 상태 | enqueue 허용, native upload 생략 |
| `errSecItemNotFound` | enqueue 금지, 앱에서 자세히 안내 |
| session 존재 + subject 불일치 | enqueue 금지, 앱에서 자세히 안내 |
| 그 외 Keychain 오류 | enqueue 허용, native upload 생략, 고정 error class만 기록 |

확정적으로 로그아웃 상태이거나 다른 계정인 경우 새 건강정보 파일을 만들지 않는다. 기기 잠금처럼 일시적으로 session을 읽을 수 없는 경우에는 payload의 subject binding으로 pending을 만들고 앱 resume에서 다시 검증한다.

### 9.2 Flutter token mirror

`TokenStore` 구현은 primary store를 정본으로 유지하는 decorator로 바꾼다.

```dart
final class MirroringTokenStore implements TokenStore {
  MirroringTokenStore(this.primary, this.bridge);

  final TokenStore primary;
  final SymptomOutboxBridge bridge;
}
```

동작:

- `readAccessToken`, `readRefreshToken`, consent API는 primary에 위임
- `writeTokens`: primary 성공 후 `bridge.updateSharedAccessToken(access)` best-effort
- `clear`: primary clear 후 `bridge.clearSharedSession()` best-effort
- `updateSharedAccessToken`은 native session이 이미 있을 때만 token을 교체하고 새 session을 만들지 않음

로그인·복구·bootstrap에서는 `AuthSession.userId`를 확보한 뒤 다음을 호출한다.

```dart
final token = await ref.read(tokenStoreProvider).readAccessToken();
if (token != null) {
  await ref.read(symptomOutboxBridgeProvider).syncSharedSession(
    accessToken: token,
    subjectId: session.userId,
  );
}
```

현재 코드의 배선 위치는 다음으로 고정한다.

| 기존 경로 | 추가 호출 |
|---|---|
| `AuthController.build()`의 `currentSession()` 성공 | session/token이 있으면 `syncSharedSession` |
| `signInWithKakao()`의 `Authenticated` 처리 | `_applyOutcomeToState` 후 `syncSharedSession` |
| `signInWithApple()`의 `Authenticated` 처리 | `_applyOutcomeToState` 후 `syncSharedSession` |
| `signInWithGoogle()`의 `Authenticated` 처리 | `_applyOutcomeToState` 후 `syncSharedSession` |
| `recoverAccount()` 성공 | state 설정 후 `syncSharedSession` |
| `AuthInterceptor._performRefresh()`의 `writeTokens` | `MirroringTokenStore`가 기존 shared session token만 갱신 |
| 다음 `ready`/resume | migration 실패를 보완하기 위해 다시 `syncSharedSession` |

공유 sync 실패는 로그인 성공을 rollback하지 않는다. 다음 bootstrap/ready/resume에서 다시 시도한다. token, subjectId, Keychain status detail은 로그에 남기지 않는다.

### 9.3 auth exit 순서

`AuthController`의 네 경로는 다음 순서를 지킨다.

| 경로 | 순서 |
|---|---|
| logout | FCM token delete → native purge/block + delivered rich 알림 제거 → 서버 logout와 primary clear → profile clear → state null |
| withdraw | FCM token delete → native purge/block + delivered rich 알림 제거 → 서버 withdraw와 primary clear → profile/guide clear → state null |
| offline signOut | FCM subscription cancel → native purge/block + delivered rich 알림 제거 → primary clear → profile clear → state null |
| session expiry | shared token clear → native purge/block + delivered rich 알림 제거 → state null |

`AuthInterceptor.onSessionExpired`를 `Future<void> Function()?`으로 바꾸고 refresh 실패 시 await한다. cleanup 실패는 `cleanup-required` marker를 남기며 다음 로그인, token sync, upload보다 cleanup을 먼저 수행한다.

기존 `_auth_retried == true` 요청이 다시 401을 받는 분기도 단순 `handler.next`로 끝내지 않는다. primary/shared token clear와 async `onSessionExpired`를 실행한 뒤 `SessionExpiredFailure`로 reject한다. 따라서 Flutter pending upload의 “refresh 후 두 번째 401”도 같은 purge 경로를 탄다.

`purgeAndCancelForLogout`은 시작할 때 lock 안에서 `cleanup-required`를 만들고 이후 모든 enqueue/claim/upload를 차단한다. 해당 flavor background session의 task 조회·cancel, Outbox purge, shared Keychain clear, `post_meal`/`post_meal_delayed_single` delivered notification 제거가 끝난 뒤에만 marker를 제거한다. 중간에 앱이 종료되면 다음 bridge 초기화가 cleanup을 재개한다. Extension이 marker를 발견하면 기록 버튼을 비활성화하고 `앱에서 자세히`만 제공한다. task cancel callback이 purge 뒤 도착해 record를 찾지 못하는 경우는 정상 no-op이다.

로그아웃·탈퇴·offline signOut·session expiry에서는 `UNUserNotificationCenter.getDeliveredNotifications` 결과에서 category가 `post_meal` 또는 `post_meal_delayed_single`인 request identifier만 제거한다. 다른 종류의 알림은 삭제하지 않는다. 반면 Extension의 `기록 완료`는 Outbox enqueue 성공 직후 현재 `UNNotification.request.identifier` 하나만 제거한다. native upload 성공·실패·timeout과 무관하게 pending이 안전하게 보관되었으면 알림은 재응답할 수 없어야 하며, enqueue 실패 때만 알림을 유지한다.

AuthController는 native purge 오류를 기록 데이터 없이 보고하고 서버 logout/withdraw와 primary token clear를 계속한다. marker가 남아 있으므로 cleanup이 끝나기 전에는 다음 로그인 session sync가 `cleanupRequired`로 실패하고 native upload도 시작되지 않는다.

## 10. Native upload

### 10.1 request

```swift
var request = URLRequest(url: apiBaseURL.appendingPathComponent("symptoms"))
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
request.timeoutInterval = 30
```

`URLSessionConfiguration.background(withIdentifier:)`:

```swift
configuration.sharedContainerIdentifier = config.appGroupIdentifier
configuration.sessionSendsLaunchEvents = true
configuration.waitsForConnectivity = true
configuration.isDiscretionary = false
```

`uploadTask(with:fromFile:)`만 사용한다. `uploadTask(with:from:)`와 data task는 사용하지 않는다.

### 10.2 response 분류

| 결과 | 분류 | Outbox |
|---|---|---|
| 200/201 + JSON `isSuccess == true` | success | ack |
| 401 | unauthorized | pending 유지, Flutter refresh 경로 대기 |
| 408/429/5xx | retryable | pending |
| timeout/offline/연결 오류 | retryable | pending |
| 400/403/404/409/422 | permanent | quarantine |
| 2xx지만 envelope 없음/실패 | invalid envelope | quarantine |
| 그 외 status | unknown retryable | pending |
| response 없음 | result unknown | pending |

응답 body는 `isSuccess`, `code`, `traceId`만 관대하게 읽는다. 분석 문구와 음식명은 저장하거나 로그에 남기지 않는다.

### 10.3 delegate와 callback

`BackgroundSymptomUploader`는 `URLSessionDelegate`, `URLSessionTaskDelegate`, `URLSessionDataDelegate`를 구현한다.

- task별 응답 data는 최대 64KB까지만 메모리에 수집
- 초과하면 `invalidEnvelope`로 분류
- `didCompleteWithError`에서 exactly once로 store mutation
- `urlSessionDidFinishEvents`에서 registry의 completion handler를 main queue에서 한 번 호출
- task lookup은 `taskDescription`과 manifest의 session/task identifier를 함께 검증

`AppDelegate.application(_:handleEventsForBackgroundURLSession:completionHandler:)`는 identifier가 현재 flavor의 값과 정확히 같을 때만 registry에 넘긴다. 다른 identifier는 `super` 구현과 기존 plugin 경로를 유지한다.

## 11. MethodChannel wire contract

### 11.1 공통

- channel: `canieatit/symptom_outbox`
- codec: `StandardMethodCodec`
- handler 등록 위치: `AppDelegate.didInitializeImplicitFlutterEngine`
- 파일·Keychain 작업: 전용 serial dispatch queue
- Flutter result callback: main queue
- channel argument와 결과를 로그로 출력하지 않음

### 11.2 methods

| method | arguments | result |
|---|---|---|
| `claimPending` | `{limit}` | record map 배열 |
| `acknowledge` | `{clientRecordId, claimToken}` | `null` |
| `release` | `{clientRecordId, claimToken, errorClass?}` | `null` |
| `quarantine` | `{clientRecordId, claimToken, reasonCode, httpStatus?, serverCode?}` | `null` |
| `pendingCount` | 없음 | int |
| `syncSharedSession` | `{accessToken, subjectId}` | `null` |
| `updateSharedAccessToken` | `{accessToken}` | `null` |
| `clearSharedSession` | 없음 | `null` |
| `purgeAndCancelForLogout` | 없음 | `null` |

`claimPending` result 예시:

```json
[
  {
    "schemaVersion": 1,
    "clientRecordId": "9A489D3E-5CB5-4F53-B6BB-ED8A2BB385E2",
    "claimToken": "F5085B5A-4C1F-46FB-AB39-9EE70D71EC25",
    "subjectId": "server-user-id",
    "symptomState": "normal",
    "symptomTypes": ["acid_reflux"],
    "occurredAt": "2026-08-13T21:10:03+09:00",
    "mealRecordId": "c4e90e6a-2b3c-4d5e-8f90-1a2b3c4d5e6f"
  }
]
```

### 11.3 PlatformException code

- `invalidArguments`
- `configurationInvalid`
- `storeUnavailable`
- `claimMismatch`
- `cleanupRequired`
- `keychainUnavailable`
- `internal`

메시지는 사용자 데이터 없이 고정 문구를 사용한다. Flutter는 `claimMismatch`를 이미 다른 owner가 처리한 것으로 간주하고 재시도하지 않는다. 나머지는 record 삭제 없이 다음 lifecycle trigger에서 다시 시도한다.

### 11.4 Dart interface

```dart
abstract interface class SymptomOutboxBridge {
  Future<List<PendingSymptomRecord>> claimPending({
    required String subjectId,
    int limit = 10,
  });

  Future<void> acknowledge({
    required String clientRecordId,
    required String claimToken,
  });

  Future<void> release({
    required String clientRecordId,
    required String claimToken,
    String? errorClass,
  });

  Future<void> quarantine({
    required String clientRecordId,
    required String claimToken,
    required String reasonCode,
    int? httpStatus,
    String? serverCode,
  });

  Future<int> pendingCount();
  Future<void> syncSharedSession({
    required String accessToken,
    required String subjectId,
  });
  Future<void> updateSharedAccessToken(String accessToken);
  Future<void> clearSharedSession();
  Future<void> purgeAndCancelForLogout();
}
```

Android 기본 구현은 빈 list, count 0, 나머지 no-op인 `UnsupportedSymptomOutboxBridge`를 제공한다. iOS가 아닌 플랫폼에서 MethodChannel 예외를 발생시키지 않는다.

## 12. Flutter retry

### 12.1 coordinator lifecycle

`symptomOutboxRetryCoordinatorProvider`는 `App.build`에서 watch해 앱 수명 동안 유지한다.

Trigger:

1. provider 최초 build 후 bootstrap
2. `sessionStatusProvider`가 처음 `ready`가 됨
3. `AppLifecycleState.resumed`

네트워크 상태 package는 V1에 추가하지 않는다. 위 trigger와 background URLSession의 connectivity 대기로 충분하다.

동시 trigger는 하나의 `_drainFuture`를 공유한다. debounce는 500ms, 한 drain에서 최대 10건을 순차 전송한다. 병렬 업로드하지 않는다.

### 12.2 upload service

```dart
sealed class PendingUploadResult {
  const PendingUploadResult();
}

final class PendingUploadSuccess extends PendingUploadResult {
  const PendingUploadSuccess();
}

final class PendingUploadRetryable extends PendingUploadResult {
  const PendingUploadRetryable(this.errorClass);
  final String errorClass;
}

final class PendingUploadPermanent extends PendingUploadResult {
  const PendingUploadPermanent({
    required this.reasonCode,
    this.httpStatus,
    this.serverCode,
  });
  final String reasonCode;
  final int? httpStatus;
  final String? serverCode;
}
```

`SymptomPendingUploadService`는 `dioProvider`와 `ApiEndpoints.symptoms`를 사용하고 record의 네 API 필드를 그대로 보낸다. `SymptomCreateRequestDto`와 `symptom-request-v1.json` fixture로 body 동등성을 검증한다.

- 200/201 + `isSuccess == true`: success
- 400/403/404/409/422: permanent
- 408/429/5xx, Dio transport error, malformed response: retryable
- refresh 실패 `SessionExpiredFailure`: retryable을 반환하지 않고 rethrow하여 auth expiry cleanup을 우선

### 12.3 drain algorithm

```text
if sessionStatus != ready: return
session = authController state
shared session best-effort sync
records = bridge.claimPending(limit: 10)
for record in records:
  result = uploadService.upload(record)
  success   -> acknowledge(claim token) -> cache invalidation
  retryable -> release(claim token, error class)
  permanent -> quarantine(claim token, sanitized reason)
  session expired -> stop drain; auth cleanup owns purge
```

하나의 record 실패가 다음 record를 막지 않지만 session expiry와 `cleanupRequired`는 drain 전체를 중단한다.

### 12.4 cache invalidation

기존 앱 직접 저장과 pending 재전송 성공이 같은 helper를 호출하도록 `invalidateSymptomMutationCaches`를 만든다.

```dart
void invalidateSymptomMutationCaches(
  void Function(ProviderOrFamily) invalidate,
) {
  invalidate(timelineControllerProvider);
  invalidate(monthlyControllerProvider);
  invalidate(unrecordedMealCountProvider);
  invalidate(mealRecordDetailControllerProvider);
  invalidate(myStreakProvider);
  invalidate(weeklyReportProvider);
  invalidateDictionaryCaches(invalidate);
}
```

기존 `SymptomWriteController.submit`의 inline invalidate를 `invalidateSymptomMutationCaches(ref.invalidate)`로 교체해 두 저장 경로가 drift하지 않게 한다.

## 13. Content Extension UI

### 13.1 view model

```swift
@MainActor
final class SymptomCheckInViewModel {
  private(set) var state: SymptomStateCode = .normal
  private(set) var selectedTypes: Set<SymptomTypeCode> = []
  private(set) var selectedNone = false
  private(set) var submissionState: SubmissionState = .idle

  func setSliderIndex(_ index: Int)
  func toggleType(_ type: SymptomTypeCode)
  func selectNone()
  func submit() async
}
```

`SubmissionState`:

- `idle`
- `submitting`
- `queued(clientRecordId)`
- `failed(DisplayError)`

버튼 활성 조건은 payload valid, shared session이 확정적으로 absent/mismatch가 아님, `submissionState == idle`, 그리고 `selectedNone || !selectedTypes.isEmpty`다.

### 13.2 화면 구조

```text
Root vertical stack
├── title: 지금 속은 어때요?
├── meal context: notification body
├── divider
├── label: 증상 강도
├── UISlider (0...4, default 2)
├── tick labels: 0 1 2 3 4
├── selected state label: 보통 (3 / 5)
├── label: 증상 종류 (선택)
├── wrapping chips: 없음 / 목 이물감 / 신물 / 기침 / 가슴 답답함
├── inline error label
└── primary button: 기록 완료
```

- `preferredContentSize.height`는 Auto Layout 결과에 맞춰 갱신하고 고정 높이를 강제하지 않는다.
- notification title/body는 payload에서 표시만 하며 Outbox에 저장하지 않는다.
- 음식명이 길면 2줄 뒤 말줄임한다.
- Dynamic Type 접근성 크기에서 chip은 다음 줄로 wrap한다.
- VoiceOver slider increment/decrement는 index를 정확히 1씩 바꾼다.
- 색상 외에 selected trait와 테두리/텍스트 변화로 선택을 표시한다.

### 13.3 submit UX

1. 첫 탭 즉시 button과 입력 control을 비활성화한다.
2. tap 시각으로 `occurredAt`을 만든다.
3. Outbox enqueue를 수행한다.
4. 공유 세션이 일치하면 native upload를 시작하고, record별 완료 callback을 최대 3초 기다린다.
5. `2xx`와 `isSuccess: true` 응답이면 즉시 `dismissNotificationContentExtension()`으로 닫는다. 세션 부재·시작 실패·재시도 가능 오류·timeout이면 pending을 보존하고 `기기에 저장했어요. 앱을 열면 자동 전송합니다.`를 약 1초 표시한 뒤 닫는다. 영구 `4xx` 오류면 `기록을 확인할 수 없어요. 앱에서 다시 시도해 주세요.`를 같은 방식으로 표시한다. timeout 후 observer는 제거하며 background task는 취소하지 않는다.
6. enqueue 실패면 control을 다시 활성화하고 `기록을 보관하지 못했어요. 앱에서 다시 시도해 주세요.`를 표시한다.

offline과 Keychain 잠금·일시 오류는 enqueue 실패가 아니다. record를 보존하고 앱 resume fallback을 기다린다. Keychain item이 확정적으로 없거나 subject가 다른 경우에는 enqueue하지 않고 `앱에서 자세히`를 안내한다.

시스템 action은 다음처럼 containing app으로 전달한다.

```swift
func didReceive(
  _ response: UNNotificationResponse,
  completionHandler: @escaping (UNNotificationContentExtensionResponseOption) -> Void
) {
  switch response.actionIdentifier {
  case "SYMPTOM_OPEN_APP_ACTION":
    completionHandler(.dismissAndForwardAction)
  default:
    completionHandler(.dismissAndForwardAction)
  }
}
```

completion handler는 모든 분기에서 정확히 한 번 호출한다.

## 14. 테스트 구현표

### 14.1 Swift 단위 테스트

| 테스트 | 핵심 assertion |
|---|---|
| payload decode | type/category 일치, targetId→mealRecordId |
| enum fixture | Swift raw value가 Dart fixture와 일치 |
| date formatter | 머신 timezone과 무관하게 `+09:00`, 초 단위 |
| enqueue | 두 파일 생성 후 pending atomic rename |
| duplicate request | 같은 notificationRequestId는 한 record만 존재 |
| staging recovery | 완전한 staging은 pending 복구, 불완전 파일은 quarantine |
| lock concurrency | 병렬 enqueue/claim/ack에서 JSON 손상 없음 |
| native claim | task resume 전 task ID가 manifest에 저장됨 |
| Flutter lease | 유효 lease 재claim 금지, 5분 뒤 재claim 가능 |
| reconciliation | active 유지, orphan 10분 뒤 pending 복구 |
| claim mismatch | 다른 token으로 ack/release 불가 |
| classifier | 모든 status/error 표가 기대 결과와 일치 |
| completion | handler exactly once, main queue 호출 |
| Keychain | sync/update/clear, subject mismatch, ThisDeviceOnly accessibility |
| purge | task cancel, directories 삭제, marker recovery |
| view model | 기본 normal, 없음 상호 배타, 중복 submit 차단 |

테스트 Outbox는 실제 App Group 대신 `FileManager.temporaryDirectory` 아래 매 테스트별 UUID directory를 주입한다. 파일 lock과 clock도 protocol로 주입한다.

### 14.2 Dart 단위 테스트

| 테스트 | 핵심 assertion |
|---|---|
| bridge codec | 모든 method/argument/result key와 PlatformException mapping |
| pending DTO | 미지 enum/중복 type/잘못된 ISO 거부 |
| upload body | 기존 SymptomCreateRequestDto fixture와 byte-semantic 동등 |
| response class | 2xx, 4xx, 401, 429, 5xx, transport 분류 |
| single flight | bootstrap+ready+resume 동시 발생 시 drain 1회 |
| claim lifecycle | success ack, retry release, permanent quarantine |
| session gate | ready가 아니면 claim하지 않음 |
| subject gate | 현재 userId만 channel에 전달 |
| session expiry | drain 중단 후 purge 호출 |
| auth lifecycle | login sync와 네 exit path purge 순서 |
| retry 401 | refresh 후 두 번째 401이 session expiry와 purge를 호출 |
| cache | 직접 저장과 retry 성공이 같은 provider set invalidate |
| non-iOS | no-op bridge가 예외 없이 동작 |

### 14.3 실기기 시나리오

1. dev 로그인 후 정상 알림 → 확장 → 기록 → 해당 delivered 알림 제거 → 서버 생성 → Outbox 제거
2. airplane mode에서 기록 → 해당 delivered 알림 제거·확장 닫힘 → 앱 resume 전 pending 유지 → 네트워크 복구 후 전송
3. Extension 전송 중 프로세스 종료 → Runner background callback → ack
4. 서버 성공 직후 ack 전 종료 → 재전송 중복 가능성과 record 보존 확인
5. access token 만료 → Extension 401 보존 → 앱 resume refresh → 성공
6. refresh 실패 → session expiry → task/Outbox/shared token purge
7. upload 중 logout/withdraw/offline signOut → 이전 계정 데이터 즉시 제거
8. 이전 계정 알림을 계정 교체 후 확장 → subject mismatch로 enqueue·직접 전송 모두 차단
9. dev record가 prod 앱/Extension에서 보이지 않음
10. Content Extension load 실패 → 기본 알림과 `앱에서 자세히` 정상
11. 기기 재부팅 후 첫 unlock 전에 확장 가능하면 Outbox 접근 실패를 표시하고 알림을 닫지 않음 → 첫 unlock 후 다시 기록하면 정상 enqueue·재전송
12. Dynamic Type 최대, VoiceOver, 미리보기 숨김에서 민감정보와 control 동작 확인

## 15. 검증 명령

### 15.1 코드 생성과 Flutter

```bash
dart run build_runner build --delete-conflicting-outputs
dart format lib test
flutter analyze
flutter test
```

### 15.2 simulator build

```bash
xcodebuild \
  -workspace ios/Runner.xcworkspace \
  -scheme dev \
  -configuration Debug-dev \
  -sdk iphonesimulator \
  CODE_SIGNING_ALLOWED=NO \
  build

xcodebuild \
  -workspace ios/Runner.xcworkspace \
  -scheme prod \
  -configuration Release-prod \
  -sdk iphonesimulator \
  CODE_SIGNING_ALLOWED=NO \
  build
```

### 15.3 signed archive

각 flavor archive 후 Runner와 `.appex`를 검사한다.

```bash
codesign -d --entitlements :- <Runner.app>
codesign -d --entitlements :- <Runner.app/PlugIns/SymptomNotificationContent.appex>
```

검사 항목:

- 같은 flavor의 App Group과 Keychain group이 두 target에 동일
- dev archive에 prod group/API/session ID 없음
- prod archive에 dev group/API/session ID 없음
- `.appex`가 `PlugIns`에 한 번만 embed
- Extension bundle ID와 provisioning profile 일치
- Extension에 Flutter/CocoaPods framework가 불필요하게 link되지 않음

## 16. 구현 완료 체크리스트

### Slice 1 — Xcode

- [ ] Extension target과 네 configuration 생성
- [ ] Runner dependency와 Embed App Extensions 추가
- [ ] dev/prod native xcconfig 연결
- [ ] Runner/Extension Info.plist config 연결
- [ ] Runner/Extension App Group·Keychain entitlement 연결
- [ ] 두 식후 category와 open-app action 등록
- [ ] 두 flavor simulator build 통과

### Slice 2 — Shared storage/auth

- [ ] shared fixture와 Codable contract 구현
- [ ] atomic Outbox와 cross-process lock 구현
- [ ] claim/lease/reconciliation 구현
- [ ] quarantine/tombstone/staging recovery 구현
- [ ] shared Keychain session 구현
- [ ] Swift 단위 테스트 통과

### Slice 3 — Native UI/upload

- [ ] payload validation과 view model 구현
- [ ] 5단계 slider와 앱 동일 chip 구현
- [ ] enqueue 성공 기준 dismiss 구현
- [ ] background file upload와 response classifier 구현
- [ ] AppDelegate background completion 연결
- [ ] 오프라인과 401 native 테스트 통과

### Slice 4 — Flutter fallback

- [ ] MethodChannel codec 구현
- [ ] iOS/no-op bridge provider 구현
- [ ] retry coordinator와 lifecycle trigger 구현
- [ ] pending upload service 구현
- [ ] token mirror와 auth exit purge 배선
- [ ] 공통 cache invalidation helper 적용
- [ ] Dio body/FCM data 평문 로그 제거
- [ ] Flutter analyze/test 통과

### Slice 5 — 배포

- [ ] signed dev/prod entitlement 검사
- [ ] 실제 APNs payload E2E
- [ ] background callback 실기기 검증
- [ ] logout/account switch privacy 검증
- [ ] accessibility 검증
- [ ] remote flag/kill switch 검증
- [ ] TestFlight 내부 사용자 검증

## 17. 구현 중 변경 규칙

다음 변경은 문서 수정과 리뷰 없이 구현하지 않는다.

- Outbox state 또는 schema version 변경
- 서버 request 필드 추가
- shared Keychain에 refresh token이나 다른 사용자 정보를 추가
- pending 만료·자동 삭제 도입
- response status 분류 변경
- background session identifier 변경
- App Group/Keychain group 변경
- snooze 재도입
- Flutter가 App Group 파일을 직접 읽는 우회 구현

schema가 호환되지 않게 바뀌면 기존 v1을 제자리 수정하지 않고 v2 decoder/migration과 `SYMPTOM_CHECKIN_V2` 도입 여부를 함께 검토한다.
