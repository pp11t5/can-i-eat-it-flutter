# iOS 리치 푸시 증상 기록 운영 계약

> 코드 정본: `ios/SymptomNotificationContent/`, `ios/SymptomResponseShared/`, `ios/Runner/SymptomOutboxMethodChannel.swift`, `lib/core/symptom_outbox/`
> 관련 외부 계약: [API 계약](./api-contract.md#ios-식후-증상-리치-푸시-fcmapns), [데이터 모델](./data-model.md#ios-로컬-증상-outbox)

## 범위

- iOS 15+의 `SymptomNotificationContent` Notification Content Extension이 `post_meal`, `post_meal_delayed_single` 알림에서 같은 증상 기록 UI를 제공한다.
- 사용자는 5단계 상태와 4개 증상을 선택하고 `기록 완료`로 `POST /api/v1/symptoms` 요청을 만든다.
- Snooze, 메모 입력, 별도 Notification Service Extension, 서버 idempotency key, pending 만료 정책은 제공하지 않는다.

## 서버 푸시 계약

알림은 **data-only가 아닌 APNs alert push**여야 한다. `aps.category`와 `data.type`은 반드시 같은 지원 category여야 하며, `targetId`는 비어 있지 않은 `mealRecordId`다.

```json
{
  "message": {
    "token": "<fcm-token>",
    "apns": {
      "headers": {
        "apns-push-type": "alert",
        "apns-priority": "10"
      },
      "payload": {
        "aps": {
          "alert": {
            "title": "속은 좀 어떠세요?",
            "body": "방금 드신 식사 후 증상을 기록해 보세요."
          },
          "category": "post_meal"
        }
      }
    },
    "data": {
      "type": "post_meal",
      "targetId": "c4e90e6a-2b3c-4d5e-8f90-1a2b3c4d5e6f"
    }
  }
}
```

- 필수 data: 문자열 `type`, 문자열 `targetId`.
- 선택 data: `title`, `body`, `mealOccurredAt`, `hoursElapsed`, `foodNames`. Extension은 `title`과 식사 문맥을 자체 카드에 표시한다. 이 값이 없어도 기록 기능은 동작한다.
- `aps.alert`은 기본 알림 및 Extension 로딩 실패 시의 fallback을 위해 서버가 제공한다. Extension은 기본 콘텐츠를 숨기고 자체 헤더·제목·본문을 렌더링한다.
- `schemaVersion`, `notificationEventId`, `subjectId`는 payload에 넣지 않는다. 토큰, 사용자 ID, 요청 body 전체는 로그에 남기지 않는다.

푸시 탭은 Flutter에서도 두 type을 기존 증상 작성 화면으로 해석한다. `앱에서 자세히` action은 foreground로 앱을 연다.

## 입력과 전송

| 항목 | 값 |
|---|---|
| 상태 | `comfortable`, `good`, `normal`, `uncomfortable`, `severe` |
| 증상 | `throat_foreign_body`, `acid_reflux`, `cough`, `chest_tightness` |
| 없음 | 별도 코드 없이 `symptomTypes: []` |
| `occurredAt` | `기록 완료`를 누른 시각(KST ISO-8601) |
| `mealRecordId` | FCM `data.targetId` |

Extension 요청은 메모를 포함하지 않고 아래 네 필드만 전송한다.

```json
{
  "symptomState": "normal",
  "symptomTypes": [],
  "occurredAt": "2026-08-26T17:00:00+09:00",
  "mealRecordId": "c4e90e6a-2b3c-4d5e-8f90-1a2b3c4d5e6f"
}
```

`기록 완료`는 먼저 App Group Outbox에 원자적으로 저장하고, 그 성공 직후 해당 delivered notification을 제거한다. 저장 실패 때만 폼을 유지한다.

공유 Keychain에 현재 세션이 있고 record 소유자와 일치하면 native background upload를 시작하고 최대 3초 동안 응답을 기다린다.

- HTTP 2xx와 응답 envelope `isSuccess: true`: Outbox를 삭제하고 Extension을 닫는다.
- 세션 부재, 네트워크 오류, 401, 5xx, 2xx이지만 `isSuccess: false`, 3초 timeout: pending을 보존하고 보관 안내 후 닫는다.
- 그 외 4xx: `quarantine`으로 보존하고 앱 확인 안내 후 닫는다.

서버가 저장한 뒤 응답이 유실되면 이후 재전송으로 중복 기록이 생길 수 있다. 서버 idempotency가 없으므로 이 위험은 현재 수용한다.

## Outbox와 재전송

Outbox는 App Group의 `symptom-outbox/<clientRecordId>/` 아래 `request.json`과 `manifest.json`을 보관하며, Swift store가 유일하게 파일을 직접 다룬다. Flutter는 MethodChannel로만 claim·ack·release·quarantine 한다.

상태는 `pending → nativeUploading` 또는 `pending → flutterClaimed`이고, 영구 오류는 `quarantine`이다. Flutter claim은 5분 lease를 가지며, native task가 10분 이상 발견되지 않으면 Flutter fallback 대상으로 회수한다. ready/resume에서 Runner가 Extension background session을 임의로 열지 않는다. 이는 다른 프로세스가 session을 소유했을 때 발생하는 `NSURLErrorBackgroundSessionInUseByAnotherProcess (-996)`를 피하기 위함이다.

Flutter는 세션 ready 전환과 앱 resume에서 최대 10건을 claim하고, 기존 Dio 인증·refresh 흐름으로 재전송한다. 성공은 acknowledge, 재시도 가능 오류는 release, 영구 4xx는 quarantine으로 처리한다.

## 인증 및 계정 종료

- 공유 Keychain에는 access token, `AuthSession.userId` 기반 `subjectId`, 갱신 시각만 저장한다. refresh token은 앱 전용 저장소에 남긴다.
- Keychain item은 `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`, `synchronizable=false`를 사용한다.
- bootstrap, Kakao·Apple·Google 로그인, 계정 복구 후 공유 세션을 동기화한다. access token refresh 성공 시에는 기존 shared session의 token만 갱신한다.
- Keychain을 읽을 수 없는 상태에서 Extension이 기록하면 owner 없는 pending만 저장한다. 다음 ready/resume에서 로그인한 현재 사용자가 재전송할 수 있다.
- 로그아웃, 탈퇴, offline sign-out, 최종 session expiry에서는 background task 취소, 모든 Outbox record와 shared Keychain 삭제, 두 category의 delivered notification 제거를 수행한다. purge 도중 종료되면 App Group cleanup marker가 남아 다음 lifecycle에서 정리를 이어 간다.

## flavor·서명 확인

dev/prod는 bundle ID, App Group, Keychain access group, API base URL, background session identifier를 완전히 분리한다. Runner와 Extension entitlement에는 같은 flavor의 App Group 및 Keychain group이 있어야 한다.

- Extension build configuration: `Debug-dev`, `Profile-dev`, `Release-dev`, `Debug-prod`, `Profile-prod`, `Release-prod`.
- Automatic Signing을 사용한다. App Group과 Extension App ID 연결이 완료된 경우 Developer Portal에서 추가 profile을 수동 생성하지 않는다.
- 배포 전 signed archive에서 Runner와 `.appex`의 bundle ID, provisioning profile, App Group, Keychain group을 확인한다.

## 운영 점검

1. 서버는 alert push와 일치하는 `aps.category`/`data.type`, 비어 있지 않은 `targetId`를 전송한다.
2. 잠금 화면에서 알림을 길게 눌러 Extension UI를 펼친다. 축약 카드에서 전체 입력 UI가 바로 보이지 않는 것은 iOS 시스템 동작이다.
3. Console은 Extension 프로세스를 별도로 선택하고 `SymptomPush` 또는 `SymptomNativeUpload`로 검색한다. debug 로그는 record ID 앞 8자리, category, type, HTTP 상태와 결과만 남긴다.
4. 실기기에서 온라인 성공, 오프라인/timeout 후 앱 resume 재전송, Google 로그인, 네 가지 인증 종료 경로를 확인한다.

