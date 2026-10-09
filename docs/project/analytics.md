# Analytics — GA 이벤트 키

Flutter 클라이언트가 Firebase Analytics로 보내는 이벤트 키다. `eventName` 문자열은 대시보드 키이므로 바꾸지 않는다.

코드의 열거형은 `lib/core/analytics/analytics_event.dart`다. 1회 기록은 `funnel_once_store.dart`, 오류 보고는 `lib/core/monitoring/error_reporter.dart`(설정은 `lib/bootstrap.dart`)에 있다.

## 키

| GA 키 | 언제 | GA에 남는 파라미터 |
|---|---|---|
| `sign_up` | 카카오·애플·구글 로그인 성공. 재로그인 포함. 복구 필요(Recoverable)와 예외는 제외 | `provider`: `kakao`, `apple`, `google` |
| `onboarding_completed` | 온보딩 제출 성공 | 없음 |
| `first_verdict_checked` | 판정 성공마다 | `level`: `recommend`, `caution`, `risk`, `unknown` |
| `account_first_verdict_checked` | 그 계정의 첫 판정 성공 | 위와 같음 |
| `first_meal_recorded` | 신규 식사 저장 성공마다 | 없음 |
| `account_first_meal_recorded` | 그 계정의 첫 신규 식사 | 없음 |
| `symptom_response` | 식후 알림으로 연 화면에서 증상을 새로 저장 | 없음 |
| `report_viewed` | 주간 리포트 화면이 로드에 성공한 뒤, 그 화면 인스턴스마다 한 번. 로딩·실패 중에는 보내지 않음 | 없음 |
| `search_screen_viewed` | 검색 화면(`/check`) 인스턴스마다 한 번 | `from_meal_record`: 식사 기록 흐름이면 `1`, 아니면 `0` |
| `meal_record_failed` | 빈 이름으로 저장을 시작하지 못함(`empty_name`) 또는 저장 요청 실패(`request_failed`) | `reason`, `is_new_meal` (`1` 또는 `0`) |

판정 이벤트는 호출부에서 `food_name`도 넘기지만, 전송 전에 빠진다. `food_name`, `foodName`, `memo`, `email`과 `firebase_` / `google_` / `ga_` 접두 키는 보내지 않는다. 사용자 연결은 이벤트 파라미터가 아니라 `FirebaseAnalytics.setUserId`(`AuthSession.userId`)다.

## 식사 기록과 판정

`first_meal_recorded`(`FunnelEvent.firstMealRecorded`)는 **식사 기록 이벤트**다. 신규 식사 저장이 성공할 때마다 보낸다. 기존 식사에 음식만 추가하는 append, 빈 이름, 저장 실패는 보내지 않는다. 이름의 `first_`는 PRD US-SYS-2 퍼널 단계 "첫 기록"에서 왔고, 운영 키의 의미는 식사 기록 횟수다.

계정의 첫 신규 식사는 그 이벤트와 함께 `account_first_meal_recorded`를 한 번 더 보낸다.

`first_verdict_checked`는 **판정 이벤트**다. 텍스트 판정과 등록 음식 판정이 성공하면 매번 보낸다. `unknown`도 성공 응답이면 포함한다. 요청 실패는 보내지 않는다.

계정의 첫 성공 판정은 그 이벤트와 함께 `account_first_verdict_checked`를 한 번 더 보낸다.

1회 기록은 기기 로컬이다. 키는 `analytics.funnel_once_v1.<event>.<userId>`이고, 토큰 저장소와 다른 기본 Secure Storage를 쓴다. 세션이 없거나 저장에 실패하면 1회 이벤트만 건너뛴다(저장 실패는 [오류 보고](#오류-보고)로 남는다). 매번 나가는 `first_meal_recorded`와 `first_verdict_checked`는 그대로 보낸다. 탈퇴가 끝나면 그 계정의 1회 기록을 지운다. 로그아웃과 로컬 로그아웃은 지우지 않는다. 재설치나 다른 기기에서는 1회 이벤트가 다시 나갈 수 있다.

"처음인지 확인하고 기록"은 `FunnelOnceStore.claim`이 한 번에 처리한다. 같은 계정·이벤트로 동시에 호출돼도 `true`는 한 번만 나온다. 먼저 들어온 호출이 끝나기 전에 온 호출은 `false`를 받는다. 먼저 들어온 호출이 저장에 실패하면 그 1회 이벤트는 나가지 않는다.

## 호출 위치

| 키 | 파일 |
|---|---|
| `sign_up` | `lib/features/auth/presentation/providers/auth_providers.dart` |
| `onboarding_completed` | `lib/features/onboarding/presentation/providers/onboarding_controller.dart` |
| `first_verdict_checked`, `account_first_verdict_checked` | `lib/features/food_check/data/food_check_providers.dart` |
| `first_meal_recorded`, `account_first_meal_recorded`, `meal_record_failed` | `lib/features/meal_log/presentation/meal_recording.dart` |
| `symptom_response` | `lib/features/symptom/presentation/providers/symptom_write_controller.dart` |
| `report_viewed` | `lib/features/weekly_report/presentation/screens/weekly_report_screen.dart` |
| `search_screen_viewed` | `lib/features/food_check/presentation/screens/food_check_screen.dart` |
| 1회 기록 확인·저장(`claim`) | `lib/core/analytics/funnel_once_store.dart` |

## 오류 보고

분석 호출은 앱 흐름을 막지 않으려고 오류를 삼킨다. 삼킨 오류는 `ErrorReporter`로 Crashlytics에 non-fatal로 남는다(디버그 빌드는 콘솔만). `reason`에는 식별 정보를 넣지 않는다. 이 절은 분석에서 삼킨 오류만 다룬다.

| reason | 언제 |
|---|---|
| `analytics.logEvent(<이벤트명>)` | GA 이벤트 전송 실패 |
| `analytics.setUserId` | GA 사용자 ID 설정 실패 |
| `analytics.claim(<이벤트명>)` | 1회 기록 확인·저장 실패 |
| `analytics.setup` | GA 수집·동의 설정 실패 |
