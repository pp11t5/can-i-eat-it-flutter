# ADR-0008: 딥링크(유니버설/앱링크 + 푸시 탭) 라우팅 아키텍처

- **Status**: Proposed (월요일 기획·서버 논의용 초안)
- **Date**: 2026-07-11
- **Decider(s)**: 프로젝트 팀 (기획·서버·앱)
- **작성 근거**: 실측 `app_router.dart`·`auth_guard.dart`·`fcm_messaging_handler.dart`·`Runner.entitlements`·`AndroidManifest.xml`·`pubspec.yaml`

---

## 1. 의사결정 요약

외부(이메일·웹·타 앱)에서 오는 **유니버설링크/앱링크**와 앱 내부의 **FCM 푸시 탭**이라는 두 유입 경로를 **단일 `DeepLinkResolver` 진입점**으로 수렴시킨다. 링크 URL 문법은 API·웹과 충돌 없는 전용 접두사 **`https://can-i-eat-it.com/app/*`** 로 고정하고, 이 URL을 내부 go_router 경로로 번역한다. 외부 링크 수신은 **`app_links` 패키지**로 처리하며(cold/warm 통일), 기존의 **순수 redirect 가드(ADR-0002)는 절대 오염시키지 않고** pending-link 복원 로직은 리졸버에 격리한다.

핵심 사실 3가지가 설계를 좌우한다:
1. 내부 라우트 상당수가 `state.extra`로 **타입 객체**(`VerdictArgs`·`MealRecordContext`·`Symptom`·`SymptomWriteArgs`·`int afterMealMinutes`)를 받는다 → URL로 재현 불가. **딥링크 노출 가능 집합은 "id-only 또는 무인자로 화면이 스스로 GET 조회하는 라우트"로 한정**된다.
2. **푸시 탭 라우팅은 서버 파일(AASA/assetlinks) 없이도 오늘 당장 가능**하다. FCM이 `message.data`를 직접 배달하므로 유니버설링크 검증이 불필요하다. 유니버설링크는 오직 *외부(브라우저/메일)* 오픈에만 필요 → **순차 출시가 가능**하다(푸시 딥링크 먼저, 유니버설링크 나중).
3. 콜드스타트 시 링크가 세션 재수화(splash) *이전*에 도착 → 리졸버가 세션 확정을 기다렸다가 replay 해야 한다.

---

## 2. 옵션 비교

두 개의 독립된 비가역 결정이 있다. 각각 옵션을 비교한다.

### 결정 A — URL 문법/접두사

- **Option A1 — 전용 접두사 `/app/*` (권고)**
  - 장점: AASA/assetlinks가 `/app/*` **한 구획만** 클레임 → API(`/v3/api-docs`, `/api/*`)·마케팅 웹·`/.well-known/*`이 브라우저에 남는다. 링크 URL과 내부 go_router 경로가 **디커플링**되어 내부 라우트 리팩터가 외부 계약을 깨지 않는다.
  - 단점: URL↔내부경로 번역 테이블을 1개 유지해야 함(경미).
  - 비용: 낮음. 번역 맵 + AASA 1구획.

- **Option A2 — 내부 경로 그대로 클레임(`/meal/:id` 등)**
  - 장점: 번역 불필요.
  - 단점: 내부 홈 경로가 `/` 라 **도메인 전체**(API·웹 포함)를 앱이 삼켜 브라우저 접근이 깨진다. 내부 라우트 이름이 곧 공개 URL 계약이 되어 리팩터가 곧바로 외부 파괴. **채택 불가**.

- **Option A3 — 초단축 `/l/*`**
  - 장점: 짧다(문자 절약, 푸시 페이로드/문자 공유).
  - 단점: 가독성↓, 의미 불명. `/app`이 사용자·기획에 더 명확.

### 결정 B — 리졸버 아키텍처 (본 ADR의 핵심 비가역 결정)

- **Option B1 — `app_links` + 명시적 단일 리졸버 (권고)**
  - 구조: 외부 링크 = `app_links` 스트림(cold: `getInitialAppLink()`, warm: `uriLinkStream`) / 푸시 = `fcm_messaging_handler`의 `_handleOpened`에서 `message.data['link']` 추출 → **둘 다 하나의 `DeepLinkResolver.handle(Uri)` 로 수렴**.
  - 장점: (1) 두 유입 경로가 한 곳으로 모여 매핑·pending 로직 **단일화**. (2) pending-link 스태시·세션대기·replay를 리졸버에 격리 → **`auth_guard.resolveRedirect`의 순수성(ADR-0002 §4) 보존**. (3) cold vs warm, 세션 미확정 타이밍을 명시 제어.
  - 단점: 의존성 1개 추가(`app_links`), go_router 네이티브 딥링크 처리와의 **이중 처리 회피 배선** 필요(리스크 R4).
  - 비용: 중. 리졸버 클래스 + 배선.

- **Option B2 — go_router 네이티브 `/app/*` redirect 라우트**
  - 구조: go_router에 `/app/meals/:id` 등을 추가하고 `redirect`가 내부 `/meal/:id`로 반환. 플랫폼 링크를 go_router가 자동 소비.
  - 장점: 단일 라우터가 진실원천, cold/warm을 Flutter Router가 자동 처리, 기존 redirect 체인과 자연 합성.
  - 단점: (1) 미인증 시 목적지 복원을 하려면 **pending 위치를 redirect 안에서 write** 해야 함 → 현재 명시적으로 순수 함수로 설계된 `resolveRedirect`에 부작용 유입, ADR-0002 위반. (2) 푸시(`message.data`)는 이 경로를 안 타므로 **결국 별도 배선이 또 필요** → 유입 경로 이원화. (3) 병렬 라우트 트리로 라우터 비대.
  - 비용: 중. 라우트 미러 트리 + 순수성 훼손.

---

## 3. 선택 근거

- **결정 A → A1(`/app/*`)**: A2는 도메인 전체 클레임으로 API/웹을 깨므로 배제. `/app`은 `/l`보다 기획·QA·서버에 의미가 명확하고 문자 절감 이득은 푸시가 data payload라 무의미(사용자에게 URL 안 보임).
- **결정 B → B1(`app_links` + 리졸버)**: 결정적 이유는 **유입 경로가 실제로 둘(외부링크·푸시)이라는 점**이다. B2는 외부링크만 우아하게 처리하고 푸시는 어차피 별도 배선이 남아 **매핑 로직이 두 벌**이 된다. B1은 두 경로를 한 `Uri`로 정규화해 매핑·pending·세션대기를 **한 곳**에 둔다. 더불어 이 저장소는 `resolveRedirect`를 "BuildContext 비의존 순수 함수"로 명시 설계(ADR-0002 §4, 테스트 가능성)했는데, B2는 pending-link 부작용을 그 순수 함수에 밀어넣어 그 자산을 파괴한다. B1은 부작용을 리졸버에 격리해 가드의 순수성을 지킨다.

즉 **가드(순수·리다이렉트 정책) / 리졸버(부작용·링크 번역·pending) 관심사 분리**가 선택의 축이다.

### 내부 라우팅 설계 (권고 흐름)

```
[외부 유니버설/앱링크]  app_links: getInitialAppLink()(cold) / uriLinkStream(warm)
                              \
                               → DeepLinkResolver.handle(Uri) → 내부 location? ─┐
                              /                                                  │
[FCM 푸시 탭] getInitialMessage()(cold) / onMessageOpenedApp(warm)              │
             _handleOpened: Uri.parse(message.data['link'])                     │
                                                                                 ▼
                                              세션 상태 분기 (sessionStatusProvider)
                                              ├ ready              → router.go(내부 location)
                                              ├ loading/미확정      → pendingDeepLinkProvider = location (스태시)
                                              ├ unauthenticated    → 스태시 후 /login (가드가 처리)
                                              └ needsOnboarding    → 스태시 보류(온보딩 완료 후 replay)
                        로그인/온보딩 완료로 SessionStatus.ready 전이 시
                        → pendingDeepLinkProvider 소비 → router.go(pending) → 클리어
```

- **단일 진입점**: `DeepLinkResolver.handle(Uri)` 하나. FCM `_handleOpened`의 현재 TODO(라인 122)와 신규 `app_links` 구독이 **모두 이 메서드를 호출**.
- **번역 규칙**: `uri.path`가 `/app/`로 시작하지 않으면 무시(방어). `/app/` 제거 후 세그먼트 매핑 테이블로 내부 location 생성. 매칭 실패 시 안전 폴백 = 홈(`/`) + 선택적 토스트(잘못된 링크). **절대 에러 화면으로 튕기지 않음**.
- **auth 게이트 결합**: 리졸버는 목적지 문자열만 만들고, 실제 접근 통제는 **기존 `resolveRedirect`에 위임**한다(중복 정책 금지). 미인증이면 리졸버가 pending 스태시 → `router.go(목적지)` 호출 → 가드가 `/login`으로 replace. 로그인 성공 리스너가 pending을 replay. 온보딩 미완(`needsOnboarding`)이면 목적지를 pending에 두고 온보딩 완료(`ready` 전이)까지 보류.
- **cold vs warm**: cold는 세션이 `loading`이라 무조건 스태시→`ready` 전이 시 replay(splash가 자연스러운 대기실). warm은 대개 이미 `ready`라 즉시 `router.go`. **cold 경로에서 go_router 네이티브 자동 딥링크가 같은 링크를 중복 소비하지 않도록 차단**(R4) 필요.

---

## 4. 정규 경로 리스트 (실측 기반)

접두사 `https://can-i-eat-it.com/app/…`. "화면이 스스로 GET 조회하는 id-only/무인자" 라우트만 1차 노출. 인증은 전부 `ready` 필요(로그인+온보딩 완료).

| 화면 | 내부 go_router 경로 | 제안 유니버설링크 URL | 파라미터 | 딥링크 가능 | 비고 |
|---|---|---|---|---|---|
| 홈 | `/` | `/app/home` | — | ✅ | 폴백 기본 목적지 |
| 타임라인 | `/timeline` | `/app/timeline` | — | ✅ | Shell 브랜치 |
| 식사 상세 | `/meal/:mealRecordId` | `/app/meals/{mealRecordId}` | path `mealRecordId` | ✅ | 화면이 GET 조회(무 extra) |
| 음식 상세 | `/meal/food/:mealFoodId` | `/app/meal-foods/{mealFoodId}` | path `mealFoodId` | ✅ | 화면이 GET 조회 |
| 증상 상세 | `/symptom/:symptomId` | `/app/symptoms/{symptomId}` | path `symptomId` | ✅ | `afterMealMinutes`는 extra→링크 진입 시 null(허용) |
| 주간 리포트 | `/weekly-report` | `/app/weekly-report` | (확장) `?week=YYYY-Www` | ✅ | 현재 무인자. 특정 주 지정은 화면 파라미터 확장 필요 |
| 음식 히스토리(도감) | `/food-history` | `/app/food-history` | — | ✅ | 무인자 |
| 마이페이지 | `/mypage` | `/app/mypage` | — | ✅ | Shell 브랜치 |
| 알림 설정 | `/mypage/notification-settings` | `/app/settings/notifications` | — | ⚪ 2차 | "알림 다시 켜기" 안내용 |
| 미기록 식단 | `/unrecorded-meals` | `/app/unrecorded-meals` | — | ⚪ 2차 | 무인자, "증상 기록 유도" 푸시 후보 |

**1차 최소 세트(푸시 주용도 = 식후 증상·리포트 유도)**: `/app/symptoms/{id}`, `/app/meals/{id}`, `/app/weekly-report`, `/app/home`. (W6/W7 리포트·증상 흐름과 정합)

**노출하지 않음(타입 extra 필수 = URL 재현 불가)**:
- `/verdict` (`VerdictArgs`: text/externalId) — 확장하려면 `/app/verdict?foodId={externalId}&text={name}` + VerdictScreen이 query 파싱하도록 **라우트 수정 필요**. 현재는 `state.extra as VerdictArgs`라 불가. → **확장 후보(별도 티켓)**.
- `/check`(`MealRecordContext`), `/symptom/record`(`Symptom`/`SymptomWriteArgs`), `/meal/record`(extra `String?`) — **생성 플로우**. 링크로 "기록 작성 화면"을 여는 건 UX·데이터 정합상 부적절 → 비노출 권고.
- `/splash`·`/login`·`/terms`·`/onboarding/*` — pre-auth 전용, 딥링크 대상 아님.
- `/mypage/profile`·`/…/allergy-med`·`/mypage/withdraw` — 딥 설정, 필요 시 3차.

---

## 5. 서버 핸드오프 계약 (얇게)

**1. iOS — `https://can-i-eat-it.com/.well-known/apple-app-site-association`**
- Content-Type `application/json`, **확장자 없음**, HTTPS, **리다이렉트 금지**, 인증 없이 200.
```json
{
  "applinks": {
    "details": [
      {
        "appIDs": ["RKG4N9K9YM.com.canieatthis.canIEatThis"],
        "components": [
          { "/": "/app/*", "comment": "먹어도돼 앱 딥링크" }
        ]
      }
    ]
  }
}
```

**2. Android — `https://can-i-eat-it.com/.well-known/assetlinks.json`**
- Content-Type `application/json`, HTTPS, 200.
```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.canieatthis.can_i_eat_this",
    "sha256_cert_fingerprints": ["<앱팀 제공: Play 앱 서명(App Signing) 인증서 SHA256 + 업로드 키 SHA256>"]
  }
}]
```
> ⚠️ 지문은 **앱팀이 Play Console → 앱 무결성 → 앱 서명에서 제공**해야 한다(서버가 만들 수 없음). Play App Signing이 배포 서명을 재작성하므로 **로컬 keystore 지문만 넣으면 검증 실패**하는 흔한 함정. release + upload 둘 다 등록 권고.

**3. FCM 페이로드 — 링크 필드**
- **data 메시지**에 `link` 필드(전체 https URL). 유니버설링크와 **동일 URL 문법**을 써서 리졸버 한 벌이 양쪽 처리(DRY).
```json
{
  "notification": { "title": "속쓰림 어떠세요?", "body": "점심 식사 후 증상을 기록해 주세요" },
  "data": { "link": "https://can-i-eat-it.com/app/symptoms/12345" },
  "apns": { "payload": { "aps": { "content-available": 1 } } }
}
```
- 필드명 **`link`** 고정(대안 `url`·구조화 `{screen,id}` 대비, 전체 URL이 유니버설링크와 통일되어 유리). iOS는 `content-available:1`이 있어야 백그라운드 data 전달이 안정적. **notification+data 하이브리드** 권고(표시는 notification, 라우팅은 data.link).

---

## 6. 네이티브 셋업 체크리스트 (앱팀 몫, 본 ADR은 구현 아님)

- [ ] **iOS entitlements**: `Runner.entitlements`에 `com.apple.developer.associated-domains = ["applinks:can-i-eat-it.com"]` 추가 + Xcode Signing & Capabilities에 Associated Domains 추가 + 프로비저닝 프로파일 갱신. (현재 `aps-environment=development` → 릴리스 빌드는 `production` 필요.)
- [ ] **Android manifest**: `MainActivity`에 intent-filter 추가(`android:autoVerify="true"`, `VIEW`+`DEFAULT`+`BROWSABLE`, `scheme=https`, `host=can-i-eat-it.com`, `pathPrefix=/app`). 기존 MAIN/LAUNCHER 유지. `launchMode="singleTop"` 이미 설정됨 → `onNewIntent`로 warm 링크 정상 수신(양호).
- [ ] **패키지 추가**: **`app_links`**(권고, uni_links 후속·유지보수 활발·cold+warm 스트림). 대안 go_router 네이티브 단독은 푸시 유입과 통일 안 되고 pending 처리 복잡(§2-B 참조).
- [ ] **go_router 이중 처리 차단**(R4): cold 링크를 go_router가 자동 소비하지 않고 `app_links`+리졸버가 replay하도록 배선(`initialLocation:'/splash'` 유지, 플랫폼 기본 경로 무시 설정).
- [ ] **FCM seam 연결**: `fcm_messaging_handler.dart` `_handleOpened`(라인 120-124 TODO)를 `DeepLinkResolver.handle(Uri.parse(message.data['link']))`로 교체.
- [ ] iOS `aps-environment` 릴리스 시 `production` 전환(APNs 서버개발자 Firebase 콘솔 조율).

---

## 7. 위험·전제

- **R1 유니버설링크 미검증 폴백**: AASA 미배포/캐시 오류/지문 불일치 시 링크가 앱이 아닌 **브라우저로 열림**. 전제: 서버가 `/app/*`에 **웹 폴백 페이지**("앱에서 열기 / 스토어로") 호스팅. iOS는 AASA를 Apple CDN이 최대 24h 캐시 → 개발 중 `applinks:can-i-eat-it.com?mode=developer` 사용.
- **R2 콜드스타트 타이밍**: 링크가 세션 재수화 전 도착. 전제: 리졸버가 `sessionStatusProvider` 확정까지 pending 보류 후 replay. 신호: cold 진입 시 홈으로 튕기거나 목적지 유실 로그.
- **R3 Android 지문 함정**: Play App Signing 재서명으로 로컬 지문만 등록 시 자동 검증 실패 → 링크가 "브라우저로 열까요" 선택지로 강등. 신호: `adb shell pm get-app-links com.canieatthis.can_i_eat_this`가 `verified` 아님.
- **R4 go_router 이중 소비**: cold 시 go_router 네이티브 딥링크 + app_links가 같은 URI를 둘 다 처리 → 이중 네비/깜빡임. 전제: 유입은 app_links 단일 채널로 통제.
- **R5 서버 파일 배포 의존성**: AASA/assetlinks/폴백페이지 배포 전까지 **외부 유니버설링크 불가**. 단, **푸시 탭 딥링크는 서버 파일 없이 동작**(FCM data 직접 배달) → **선출시 가능**. 신호 없음(설계상 분리).
- **전제(공통)**: 딥링크 대상 화면은 **id만으로 자기 데이터를 GET 조회**한다(현재 `/meal/:id`·`/symptom/:id`·`/meal/food/:id` 충족). 이 전제가 깨지면(화면이 타입 extra 필수로 변경) 해당 URL은 딥링크 불가로 강등.
- **전제 깨짐 신호**: 새 화면을 딥링크에 추가하려는데 라우트가 `state.extra as <Type>`를 필수로 읽음 → 그 화면은 리팩터(id로 자체 조회) 없이는 노출 불가.

---

## 8. 후속 액션

- [ ] (기획) 정규 경로 리스트에서 **1차 푸시 대상 화면 확정**(권고: 증상상세·식사상세·주간리포트·홈) — 월요일.
- [ ] (기획+개발) `/verdict` 딥링크 노출 여부 결정 → 노출 시 VerdictScreen query 파싱 확장 별도 티켓.
- [ ] (서버) AASA·assetlinks·`/app/*` 웹 폴백 페이지 3종 배포 티켓 생성. 지문은 **앱팀 대기**로 블록 표시.
- [ ] (앱팀) Play Console에서 SHA256 지문(App Signing+upload) 추출해 서버 전달.
- [ ] (앱팀 구현 티켓, 본 ADR 승인 후) `app_links` 도입 + `DeepLinkResolver` + `pendingDeepLinkProvider` + FCM seam 연결 + 네이티브 entitlement/manifest. **auth_guard.resolveRedirect 순수성 유지 필수**.
- [ ] (선행 분리 출시) 서버 파일과 무관한 **푸시 탭 in-app 라우팅**(FCM data.link→리졸버)을 먼저 배선해 유니버설링크 배포 전 푸시 딥링크 확보.

---

## 9. 월요일 논의용 2블록 요약

**▶ 기획에게 줄 것 — "어떤 화면이 어떤 URL로 열리나"**
- 링크 문법: `https://can-i-eat-it.com/app/<대상>`. 예) 증상 `…/app/symptoms/{id}`, 식사 `…/app/meals/{id}`, 주간리포트 `…/app/weekly-report`, 홈 `…/app/home`.
- 지금 열 수 있는 화면: 홈·타임라인·식사상세·음식상세·증상상세·주간리포트·도감·마이. (위 표)
- **못 여는 것**: "기록 작성"류(음식판정 입력/증상 작성/식사 작성)는 타입 데이터가 필요해 링크로 못 엶 → 링크는 "조회/상세"에만.
- 결정 요청: 1차 푸시로 어디를 여는가(권고: 증상상세·식사상세·주간리포트). 주간리포트를 "특정 주"로 열려면 화면 확장 필요.

**▶ 서버에게 줄 것 — "도메인에 올릴 파일 + 페이로드 문법"**
- 파일 3종: `/.well-known/apple-app-site-association`(iOS, appID `RKG4N9K9YM.com.canieatthis.canIEatThis`, path `/app/*`), `/.well-known/assetlinks.json`(Android, package `com.canieatthis.can_i_eat_this`, **지문은 앱팀이 전달**), 그리고 `/app/*` **웹 폴백 페이지**(앱 미설치·미검증 시).
- 조건: HTTPS·리다이렉트 없음·`application/json`·확장자 없음(AASA)·인증 없이 200.
- FCM 페이로드: `data.link`에 **전체 https URL**(유니버설링크와 동일 문법) + notification 블록 + iOS `aps.content-available:1`. 필드명 `link` 고정.
- **선출시 가능**: 위 파일 배포 전에도 **푸시 탭 딥링크는 동작**(FCM가 data 직접 배달). 유니버설링크(메일/웹 오픈)만 파일 배포에 의존.

---

## 참고 (실측 근거 파일)

`lib/app/router/app_router.dart`, `lib/app/router/guards/auth_guard.dart`, `lib/core/push/fcm_messaging_handler.dart`(seam: 라인 120-124), `lib/features/food_check/presentation/models/verdict_args.dart`, `ios/Runner/Runner.entitlements`, `android/app/src/main/AndroidManifest.xml`.
