# 먹어도 돼? (can_i_eat_it) — Flutter 클라이언트

역류성 식도염·위염 등 **기저질환 보유자**를 대상으로, 사용자의 질환 프로필 기준 특정 음식/성분의 섭취 가부를 판별하는 앱의 Flutter 클라이언트다. 핵심 매핑은 **사용자 질환 ↔ 음식/성분 ↔ 판별 결과(safe/caution/avoid + 근거)**. 의료성 정보를 다루므로 정확도·면책 고지·근거 표기가 제품 요건이다.

이 문서는 저장소를 처음 받는 Flutter 개발자가 **클론 → 셋업 → 빌드/실행 → 테스트 → 핵심 통합 파악**까지 혼자 진행할 수 있게 하는 것을 목표로 한다.

---

## 1. 기술 스택

| 영역 | 선택 | 버전(pubspec.yaml 기준) |
|---|---|---|
| 언어/프레임워크 | Flutter (CI 고정) / Dart | Flutter `3.44.0`(stable), Dart SDK `^3.5.4` |
| 상태관리 | Riverpod (+codegen) | `flutter_riverpod ^2.6.1`, `riverpod_annotation ^2.6.1`, `riverpod_generator ^2.6.5` |
| 라우팅 | go_router | `^15.1.2` |
| 네트워킹 | dio (직접 사용) | `^5.9.2` |
| 모델 | freezed + json_serializable | `freezed(_annotation) ^3.1.0`, `json_serializable ^6.9.5` |
| 코드 생성 | build_runner | `^2.5.4` |
| 소셜 로그인 | 카카오 / 애플 | `kakao_flutter_sdk_user ^1.9.7`, `sign_in_with_apple ^8.1.0` |
| 푸시 | Firebase Cloud Messaging | `firebase_core ^4.11.0`, `firebase_messaging ^16.4.1`, `flutter_local_notifications ^22.0.1` |
| 기타 주요 패키지 | | `flutter_secure_storage ^9.2.4`(토큰 저장), `webview_flutter ^4.10.0`(약관), `fl_chart ^1.2.0`(리포트 차트), `share_plus ^10.1.4` |
| 린트 | flutter_lints + custom_lint | `flutter_lints ^4.0.0`, `custom_lint ^0.7.6`, `riverpod_lint ^2.6.5` |

**retrofit은 아직 미도입**이다. `pubspec.yaml`에 의존성이 없고, `data/repositories/*_impl.dart`는 dio를 직접 호출한다. `docs/spikes/retrofit-compat.md`(2026-05-29)는 `retrofit 4.9.2 + retrofit_generator 10.2.6` 조합이 현재 스택과 호환됨을 확인했지만, 아직 실제 도입(마이그레이션)은 이루어지지 않았다 — 필요 시 이 스파이크 문서를 출발점으로 삼는다.

---

## 2. 아키텍처 (디렉토리 맵)

Feature-first 구조. 상세 규칙은 저장소 루트 `CLAUDE.md` 참조.

```
lib/
  app/            # 진입 위젯(MaterialApp.router), go_router 라우터, 테마 토큰, 공통 위젯
    router/         app_router.dart(@riverpod GoRouter) + guards/auth_guard.dart
    theme/          app_colors/app_spacing/app_text_styles + tokens/
    widgets/        app_button, app_card, app_shell(바텀내비 셸) 등 공통 위젯
  core/           # 횡단 관심사 (2회 이상 반복될 때만 공통화)
    network/        dio_client, api_endpoints(엔드포인트 상수), api_response(공통 응답 봉투),
                     auth_interceptor, failure_mapper
    config/         flavor.dart(enum Flavor{dev,prod}), flavor_config.dart(FlavorConfig)
    security/       token_store(flutter_secure_storage 래핑)
    push/           fcm_messaging_handler / fcm_repository / fcm_providers / fcm_token_service
    analytics/       analytics_event / analytics_service
    error/          failure.dart (Failure 계층)
    utils/, util/   kst_time.dart(KST 직렬화 헬퍼) 등
  features/<feature>/
    domain/         entity + repository 인터페이스 (프레임워크 비종속)
    data/           DTO(freezed) + repository 구현(dio 직접 호출) + mock repository
    presentation/    screen + widget + controller(Riverpod provider)
  bootstrap.dart  # 플레이버 공통 초기화(Firebase/FCM/Kakao) + 실 repository override
  main.dart       # 플레이버 미지정 실행 시 prod로 위임하는 shim
  main_dev.dart   # 개발 플레이버 진입점
  main_prod.dart  # 운영 플레이버 진입점
```

현재 `lib/features/` 하위 피처: `auth`, `onboarding`, `health_profile`, `home`, `food_check`, `food_dictionary`, `meal_log`, `symptom`, `mypage`, `weekly_report`, `notification`.

변경 격리 원칙: 기능 변경은 해당 feature 내부에, **서버 API 변경은 `core/network` + 그 feature의 `data`에만** 반영한다. 서버 계약이 미정인 부분은 domain 인터페이스만 먼저 정의하고 Riverpod provider override로 mock 데이터소스를 주입해 UI를 선개발한다(예: `mock_food_repository.dart`, `mock_auth_repository.dart` 등 각 feature `data/repositories/`에 존재).

---

## 3. 사전 요구사항

- Flutter **3.44.0**(stable 채널) — CI(`​.github/workflows/ci.yml`)가 이 버전에 고정되어 있다. 로컬도 동일 버전 사용을 권장(다른 버전에서는 codegen/analyze 결과가 달라질 수 있음).
- Dart SDK `^3.5.4`(Flutter 3.44 번들 Dart, 대략 3.12대).
- iOS: Xcode, CocoaPods(`sudo gem install cocoapods`). iOS 최소 배포 타깃 **15.0**.
- Android: Android 스튜디오/SDK. (⚠️ 로컬 Android 빌드가 JDK 25 환경에서 실패한 이력이 있다 — 정확한 요구 JDK 버전은 확인 필요. CI에는 Android 빌드 스텝 자체가 없다.)
- 카카오 로그인 실기기 검증 시 카카오톡 앱(또는 웹 로그인 폴백) 필요.

---

## 4. 셋업 (클론 직후 1회)

```bash
./scripts/bootstrap.sh
```

이 스크립트가 하는 일(`scripts/bootstrap.sh` 기준):

1. `flutter config --no-enable-swift-package-manager` — **SwiftPM을 끈다.**
2. `flutter pub get`
3. CocoaPods가 설치돼 있으면 `cd ios && pod install` (미설치 시 경고만 출력하고 건너뜀)

> ⚠️ **`flutter config --enable-swift-package-manager` 절대 실행 금지.** Firebase iOS SDK(iOS 15 요구)와 Flutter가 생성하는 SwiftPM umbrella(`FlutterGeneratedPluginSwiftPackage`, iOS 13.0 하한)가 충돌해 iOS 빌드가 `requires minimum platform version 15.0 ... but this target supports 13.0`로 깨진다(PR #147 배경). `flutter config`는 머신 전역 설정이라 저장소에 담기지 않으므로, 클론할 때마다 반드시 `bootstrap.sh`를 다시 실행해야 한다.

셋업 후 코드 생성물을 생성한다(3rd-party 코드 생성 대상이 하나도 없어도 최초 1회 필요):

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 5. 빌드/실행 (dev / prod)

플레이버(dev/prod) 상세 설계·근거는 **`docs/build-flavors.md`가 SSOT**다. 아래는 실행에 필요한 핵심만 요약한다.

> ⚠️ `docs/build-flavors.md` 하단의 **"남은 작업(TODO)" 및 "dev-login" 섹션은 낡은 정보**다. PR #176이 iOS 네이티브 플레이버(스킴/xcconfig/번들ID/Kakao scheme/GoogleService-Info 분리)를 완성했고, PR #177이 **실제 Apple Sign-In을 도입하며 dev-login을 완전히 제거**했다. 현재는 **카카오·애플 로그인 둘 다 실제 소셜 로그인**이며, dev-login이라는 우회 경로는 코드에 존재하지 않는다. 아래 절(§5, §9)이 최신 상태다.

### 번들 ID / 표시명

| | 운영(prod) | 개발(dev) |
|---|---|---|
| iOS 번들 ID | `com.canieatthis.canIEatThis` | `com.canieatthis.canIEatThis.dev` |
| Android 패키지 | `com.canieatthis.can_i_eat_this` | `com.canieatthis.can_i_eat_this.dev` |
| 앱 표시명 | 먹어도돼? | 먹어도돼? Dev |

⚠️ iOS는 camelCase(`canIEatThis`), Android는 snake_case(`can_i_eat_this`)로 **원래부터 표기가 다르다**(오타 아님). `.dev` 접미사 방식이라 dev·prod가 한 기기에 **동시 설치**된다.

### 실행/빌드 커맨드

카카오 네이티브 앱키를 `--dart-define`으로 주입한다(리터럴은 소스에 커밋하지 않음, `FlavorConfig.kakaoNativeAppKey`).

```bash
# 개발(dev) 실행
flutter run --flavor dev -t lib/main_dev.dart \
  --dart-define=KAKAO_NATIVE_APP_KEY=cd24aa08a740a475401f84390c8219df

# 운영(prod) 빌드 — iOS
flutter build ios --flavor prod -t lib/main_prod.dart \
  --dart-define=KAKAO_NATIVE_APP_KEY=2d007771e0083b600999053b9b1d4e83

# 운영(prod) 빌드 — Android
flutter build apk --flavor prod -t lib/main_prod.dart \
  --dart-define=KAKAO_NATIVE_APP_KEY=2d007771e0083b600999053b9b1d4e83
```

- `lib/main.dart`는 플레이버 미지정 `flutter run` 편의용 shim으로, 내부적으로 `main_prod.dart`에 위임한다(운영 서버 대상 실행이 됨에 유의).
- dev 카카오 네이티브 앱키(`cd24aa08a740a475401f84390c8219df`)와 prod 앱키(`2d007771e0083b600999053b9b1d4e83`)는 클라이언트 식별자이며 `docs/build-flavors.md`에 이미 커밋되어 있다.
- dev 서버 = 현재 라이브 서버(`can-i-eat-it.com`)와 동일하다(운영 서버는 추후 별도 제공 예정, `lib/core/config/flavor_config.dart`의 TODO 참조). `API_BASE_URL`은 `--dart-define`으로 override 가능(기본값은 dev/prod 모두 `https://can-i-eat-it.com/api/v1`).
- `FlavorConfig.kakaoNativeAppKey`가 빈 문자열이면(`--dart-define` 누락 시) `bootstrap.dart`가 카카오 SDK init을 건너뛴다 — 앱은 뜨지만 카카오 로그인만 비활성.

---

## 6. 코드 생성 워크플로우

`@freezed` / `@riverpod` / provider 함수 등 코드 생성 애너테이션을 추가·수정했으면 반드시:

```bash
dart run build_runner build --delete-conflicting-outputs
```

생성물(`*.freezed.dart`, `*.g.dart`)은 **커밋한다**(빌드 재현성). 손으로 수정하지 않는다. CI가 build_runner 실행 후 `git diff --exit-code`로 생성물 최신성을 검증하므로, 커밋 누락 시 CI가 실패한다.

---

## 7. 테스트 & CI

`.github/workflows/ci.yml` — 단일 잡(`build`, `ubuntu-latest`, Flutter `3.44.0` stable), PR/`main` push 시 실행:

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs`
3. 생성물 최신성 검증(`git diff --exit-code`, 어긋나면 실패 + 안내 메시지)
4. `flutter analyze`
5. `dart run custom_lint`
6. `flutter test --exclude-tags golden`

병합 방식은 **squash**(`"...(#NNN)"` 형태 커밋 메시지).

### 골든 테스트

`@Tags(['golden'])`로 태그된 위젯 골든 테스트가 `test/` 하위 11개 파일에 있다(예: `test/features/mypage/presentation/mypage_golden_test.dart`). **CI는 `--exclude-tags golden`으로 골든을 아예 실행하지 않는다.** 로컬 폰트 환경 차이로 일부 골든이 로컬에서 상시 실패하는 이력이 있으므로, 로컬에서 `--update-goldens`로 임의 갱신하지 않는다.

### 시간대(KST) 관련 주의

`lib/core/utils/kst_time.dart`의 헬퍼(`parseKst`/`nowKst`/`toServerOffset` 등)는 명시적으로 **`.toLocal()`을 쓰지 않고** UTC instant에 +9h를 더해 KST 컴포넌트를 만드는 방식으로 머신 타임존에 무관하게 동작한다. 과거 `.toLocal()` 사용으로 인한 KST 이중변환 버그 이력이 있으므로, 프로덕션 코드에서 `.toLocal()`을 사용하지 않는다. 시간 관련 테스트를 로컬에서 검증할 때는 `TZ=UTC flutter test ...`처럼 타임존을 명시해 CI(우분투 러너, 기본 UTC) 환경과 동일하게 재현하는 것을 권장한다.

---

## 8. 로그인 (카카오 / 애플)

**카카오·애플 둘 다 실제 소셜 로그인**이다(우회용 dev-login 없음, PR #177로 완전 제거). 흐름은 `AuthRepositoryImpl._signIn`(`lib/features/auth/data/repositories/auth_repository_impl.dart`) 기준:

1. `KakaoAuthService`/`AppleAuthService`로 provider의 idToken 획득
2. `POST /auth/{provider}/login` (`{idToken}`)
3. 토큰 저장(`TokenStore`, `flutter_secure_storage`) 후 `GET /onboarding/status` 조회 → `Authenticated(onboarded: ...)`
4. 서버가 약관 동의를 요구하면 `TermsRequiredFailure` → `NeedsTerms`, 탈퇴 유예 등 복구 가능 계정이면 `RecoverableAccountFailure` → `Recoverable`(idToken 재사용해 `POST /auth/{provider}/recover`)

### 카카오

- `bootstrap.dart`가 `config.kakaoNativeAppKey`가 비어있지 않을 때만 `KakaoSdk.init`을 호출한다.
- 카카오 로그인이 성립하려면 **클라이언트 네이티브 앱키 = 백엔드가 idToken을 검증하는 키 = 같은 카카오 앱**이어야 하며, 그 카카오 콘솔 앱에 iOS 번들ID·Android 패키지명+키해시·OIDC·로그인 활성화가 등록돼 있어야 한다.
- iOS는 UIScene 라이프사이클에서 OAuth 콜백을 받기 위해 `ios/Runner/AppDelegate.swift`의 `SceneDelegate`가 `scene(_:openURLContexts:)`로 받은 URL을 레거시 `FlutterAppDelegate.application(_:open:options:)`로 되넘긴다. `kakao_flutter_sdk_common` 플러그인이 레거시 콜백 경로만 지원하기 때문이다(파일 내 주석 참조).

### 애플

- `sign_in_with_apple ^8.1.0` 사용, idToken을 `POST /auth/apple/login`으로 전달.
- `ios/Runner/Runner.entitlements`에 `com.apple.developer.applesignin`(Default) capability가 이미 설정돼 있다.
- 실기기/TestFlight 배포 시 Apple Developer 포털에서 두 App ID(운영/개발) 모두 Sign in with Apple capability를 활성화해야 한다.

---

## 9. 서버 API

- **권위 있는 원본은 라이브 Swagger**: `https://can-i-eat-it.com/v3/api-docs` (WebFetch로 조회 가능). `docs/project/api-contract.md`는 2026-06 Swagger 실측 스냅샷이라 최신 변경분과 어긋날 수 있다 — 확정 근거가 필요하면 라이브 Swagger를 우선한다.
- Base URL: `https://can-i-eat-it.com` + prefix `/api/v1`.
- 공통 응답 봉투: `{ isSuccess, code, message, traceId, result }`. 클라이언트 언랩 지점은 `lib/core/network/failure_mapper.dart` 한 곳(`code` → `Failure` 매핑).
- 인증 전략: 토큰 만료 필드가 없어 **401 반응형 refresh**만 수행(선제 계산 없음).
- 엔드포인트 상수는 `lib/core/network/api_endpoints.dart` 한 파일에 모여 있다(Auth/Gate·Onboarding/Food·판정/Meal-records·Timeline/Dictionary/Symptoms/Health/FCM/Notifications/My Page/Weekly Report 카테고리별). 새 엔드포인트 추가 시 이 파일에 상수+주석(HTTP 메서드)을 남기는 관례를 따른다.
- 서버 API가 아직 안 나온 기능은 `features/<feature>/data/repositories/mock_*.dart`로 선개발하고, `domain/repositories/*.dart` 인터페이스는 그대로 둔 채 실 구현으로 provider override만 교체한다.

---

## 10. Firebase / 푸시

- Firebase 프로젝트: `canieatthis-38b4e`, 플레이버별로 별도 앱(번들ID로 구분).
- Android: `android/app/src/{prod,dev}/google-services.json` — google-services 플러그인이 `src/<flavor>`를 자동 인식.
- iOS: `ios/config/{prod,dev}/GoogleService-Info.plist` — Run Script build phase가 `GOOGLE_SERVICE_FLAVOR` 빌드세팅을 읽어 앱 번들로 복사.
- `bootstrap.dart`가 `Firebase.initializeApp()`을 시도하되 실패해도 앱은 계속 뜨도록 try/catch로 감싸져 있다(설정 누락 시 푸시만 비활성). 이어서 `FirebaseMessaging.onBackgroundMessage` 등록, `initForegroundMessaging()`, `wireOpenedApp()` 순으로 초기화한다(`lib/core/push/`).
- AI(LLM) 분석 응답용 `receiveTimeout`은 제거되어 있다(`FlavorConfig.receiveTimeout = Duration.zero`) — 응답이 10초 이상 걸릴 수 있는 판정 API에서 timeout으로 인한 오탐 에러("분석 중 오류…")를 없애기 위함. `connectTimeout`(10초)은 유지되어 진짜 오프라인은 계속 감지한다.

---

## 11. 디자인 · 기획 워크플로우 (MCP)

- **Figma Framelink MCP**: 디자인 **토큰/레이아웃 추출** 전용. React 코드 생성이 아니라 토큰·계층을 Flutter 위젯으로 옮기는 데 쓴다. `FIGMA_API_KEY`는 `.env`가 아니라 **셸 환경변수**로 export해야 Claude Code의 `.mcp.json`이 확장한다(`.env.example` 참조).
- **Notion MCP**: 주간 기획 조회 전용, OAuth 인증(`/mcp` → notion → Authenticate, 1회).
- 주간 반복 루프(기획 조회 → 디자인 추출 → 구조 영향 판단 → 이슈별 TDD/Review/None 구현 → 리뷰) 전체는 `docs/weekly-workflow.md` 참조.

---

## 12. 시크릿 관리

| 파일/값 | 커밋 여부 | 비고 |
|---|---|---|
| 카카오 네이티브 앱키(dev/prod) | **커밋됨** | 클라이언트 식별자(앱 인식용), 시크릿 아님. `docs/build-flavors.md`에 이미 기재. |
| `android/app/src/{prod,dev}/google-services.json`, `ios/config/{prod,dev}/GoogleService-Info.plist` | **커밋됨** | `.gitignore`에서 제외되지 않으며 저장소에 실제로 커밋되어 있다(`docs/build-flavors.md`도 "커밋됨"으로 명시). Firebase 클라이언트 설정 파일로, 앱 식별자 성격이라 커밋되는 것이 이 저장소의 현재 관례다. |
| `.env` (`FIGMA_API_KEY` 등) | **비커밋** | `.gitignore`에 명시. `.env.example`을 복사해 로컬에서만 채운다. |
| Apple/APNs `.p8` 키 | **이 저장소에 없음** | 서버(백엔드) 개발자가 별도 관리. 클라이언트 레포에 추가하지 않는다. |

---

## 13. 주요 함정 / 주의

- **iOS SwiftPM은 항상 OFF 유지.** `flutter config --enable-swift-package-manager` 절대 실행 금지(§4 참조). 클론마다 `bootstrap.sh` 재실행 필요(머신 전역 설정이라 레포에 저장 안 됨).
- iOS 최소 배포 타깃 **15.0**.
- 새 CocoaPods 의존성 추가 시 **플레이버별 Flutter xcconfig 배선**을 함께 확인한다(PR #177에서 발견된 함정 — per-flavor Pods xcconfig 누락 시 빌드가 깨질 수 있음).
- Android 로컬 빌드가 JDK 25 환경에서 실패한 이력이 있다(정확한 요구 JDK 버전은 확인 필요). CI에는 Android 빌드 스텝이 없어(analyze/test/codegen만) 이 문제가 CI에서는 드러나지 않는다.
- 골든 테스트는 로컬 폰트 환경에 따라 상시 실패할 수 있다 — 로컬 `--update-goldens` 금지, CI는 골든을 아예 제외한다(§7).
- `@freezed`/`@riverpod`/provider 변경 후 생성물(`.g.dart`/`.freezed.dart`) 커밋 누락 시 CI가 "Verify generated files are up-to-date" 스텝에서 실패한다(§6).
- 프로덕션 코드에서 `.toLocal()` 금지 — KST 이중변환 버그 이력(§7).
- AI(LLM) 판정 API는 `receiveTimeout`이 의도적으로 무제한이다(§10) — 임의로 timeout을 다시 넣지 않는다.
- `docs/build-flavors.md` 하단 "남은 작업(TODO)"·"dev-login" 섹션은 PR #176/#177 이전 작성분이라 신뢰하지 않는다(§5 경고 참조).

---

## 14. 참고 문서 & 미해결(후속)

- `docs/build-flavors.md` — 빌드 플레이버 SSOT (하단 TODO/dev-login 섹션 제외, §5 참조)
- `docs/weekly-workflow.md` — 주간 개발 루프
- `docs/adr/` — 아키텍처 결정 기록(0001 아키텍처 ~ 0008 딥링크 라우팅)
- `docs/project/` — 기획 컨텍스트 허브(PRD, 기능 지도, 디자인 시스템, 데이터 모델, API 계약, 로드맵, 오픈 이슈 등). 목록·갱신 규칙은 `docs/project/README.md` 참조.
- `docs/project/open-issues.md` — 미결정 사항. 현재 미해결 1건: **OI-01 강제 업데이트 vs API 버전 분기**(비차단, 출시 근처 결정 예정).
- `docs/spikes/retrofit-compat.md` — retrofit 도입 가능성 스파이크(호환 확인됨, 미도입 상태, §1 참조).
- `CLAUDE.md` — 도메인 요약, 레이어 규칙, 코드 생성 워크플로우, MCP 사용 규약, 이 팀의 Claude Code 멀티에이전트 운영 관례(오케스트레이션 마스터 + 8개 서브에이전트).

---

## 15. (참고) Claude Code 서브에이전트 관례

이 저장소는 Claude Code를 쓸 때 `architect`·`implementer`·`refactorer`·`test-writer`·`doc-writer`·`explorer`·`deep-debugger`·`pr-reviewer` 8개 서브에이전트로 작업을 분담하는 관례를 따른다(정의는 `.claude/agents/`, 라우팅 규칙과 SSOT는 저장소 루트 `CLAUDE.md`). Claude Code를 쓰지 않는 개발자에게는 무관하며, 강제 사항은 아니다.
