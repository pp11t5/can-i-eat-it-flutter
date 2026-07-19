# 빌드 플레이버 (dev / prod)

스테이징 서버 없이 **dev 서버 + 운영(prod) 서버 2종**만 운영한다. 코어 모듈은 공유하고,
진입점·설정·번들 식별자만 플레이버로 분리한다. (설계: ADR-0009 요지)

## 번들 ID / 패키지명 (확정)

| 플랫폼 | 운영(prod) | 개발(dev) | 방식 |
|---|---|---|---|
| **iOS 번들 ID** | `com.canieatthis.canIEatThis` | `com.canieatthis.canIEatThis.dev` | 접미사 `.dev` (Xcode 컨피그 `*-prod`/`*-dev` 빌드세팅, 구현됨) |
| **Android 패키지** | `com.canieatthis.can_i_eat_this` | `com.canieatthis.can_i_eat_this.dev` | `applicationIdSuffix = ".dev"` (구현됨) |
| **앱 표시명** | `먹어도돼?` | `먹어도돼? Dev` | Android resValue / iOS `APP_DISPLAY_NAME` 빌드세팅 |

> ⚠️ **기존 표기 불일치(주의)**: iOS 번들은 camelCase(`canIEatThis`), Android 패키지는
> snake_case(`can_i_eat_this`)로 **원래부터 다르다**. `.dev` 접미사는 각 표기에 그대로 붙인다.
> dev용 **카카오 앱·Firebase 앱을 생성할 때 위 `.dev` ID를 대소문자까지 정확히 등록**해야 한다.

접미사 방식이라 dev·prod가 한 기기에 **동시 설치**된다(별개 앱).

## 진입점 / 설정

- `lib/core/config/flavor.dart` — `enum Flavor { dev, prod }`.
- `lib/core/config/flavor_config.dart` — `FlavorConfig`(apiBaseUrl·appDisplayName·kakaoNativeAppKey…).
  `FlavorConfig.current` 기본값 `prod`(테스트 안전), `bootstrap`이 진입점에서 교체.
- `lib/bootstrap.dart` — 공통 초기화(Firebase·FCM·Kakao) + 실 repository override.
- `lib/main_prod.dart` / `lib/main_dev.dart` — 플레이버 진입점.
- `lib/main.dart` — 플레이버 미지정 `flutter run` 편의용 → prod 위임 shim.

## 빌드 커맨드

```bash
# 운영(prod)
flutter build ios --flavor prod -t lib/main_prod.dart \
  --dart-define=KAKAO_NATIVE_APP_KEY=2d007771e0083b600999053b9b1d4e83
flutter build apk --flavor prod -t lib/main_prod.dart \
  --dart-define=KAKAO_NATIVE_APP_KEY=2d007771e0083b600999053b9b1d4e83

# 개발(dev)
flutter run --flavor dev -t lib/main_dev.dart \
  --dart-define=KAKAO_NATIVE_APP_KEY=cd24aa08a740a475401f84390c8219df
```

카카오 네이티브 앱키의 **SDK init 값**은 리터럴을 커밋하지 않고 빌드 시 주입한다
(`FlavorConfig.kakaoNativeAppKey` = `--dart-define=KAKAO_NATIVE_APP_KEY`). 반면
**URL scheme(`kakao<key>`)** 은 네이티브 설정에 반드시 들어가므로 iOS 빌드세팅
`KAKAO_URL_SCHEME`(컨피그별) · Android `manifestPlaceholders[kakaoScheme]`(플레이버별)로
커밋된다(클라 식별자로 노출 정상, 기존 prod 패턴과 동일). 빌드 시 dart-define 키와
네이티브 scheme 키가 **같은 플레이버 값**이어야 한다.

| | 운영(prod) | 개발(dev) |
|---|---|---|
| 카카오 네이티브 앱키 | `2d007771e0083b600999053b9b1d4e83` | `cd24aa08a740a475401f84390c8219df` |

## Firebase (네이티브 설정, 커밋됨)

플레이버별 Firebase 앱(같은 프로젝트 `canieatthis-38b4e`, 번들ID로 구분):

| | Android (`google-services.json`) | iOS (`GoogleService-Info.plist`) |
|---|---|---|
| **prod** | `android/app/src/prod/` | `ios/config/prod/` |
| **dev** | `android/app/src/dev/` | `ios/config/dev/` |

- Android: google-services 플러그인이 `src/<flavor>` 를 자동 인식(루트 파일 없음).
- iOS: 정적 번들 대신 **Run Script build phase** 가 `GOOGLE_SERVICE_FLAVOR` 빌드세팅을 읽어
  `ios/config/<flavor>/GoogleService-Info.plist` 를 앱 번들로 복사한다.

## 앱 아이콘

- 소스: `assets/app_icon/app_icon_prod.png`, `app_icon_dev.png` (1024×1024, Figma `2045:5086`, Stg 제외).
- 설정: `flutter_launcher_icons-{prod,dev}.yaml`. 적용: `dart run flutter_launcher_icons -f flutter_launcher_icons-prod.yaml`.
- dev 아이콘엔 "Dev" 배지. iOS는 플레이버 AppIcon set 준비 후 적용.

## 남은 작업 (TODO)

- [ ] iOS 네이티브 플레이버(스킴 `prod`/`dev` + xcconfig 빌드 컨피그 + 번들ID/표시명/AppIcon/Kakao scheme/GoogleService-Info 분리) — Xcode 필요.
- [ ] dev 서버 도메인 확정 → `FlavorConfig.dev.apiBaseUrl` 기본값 교체(현재 `https://dev.can-i-eat-it.com/api/v1` placeholder).
- [ ] dev 카카오 앱 생성 → dev 네이티브 앱키·URL scheme.
- [ ] dev Firebase 앱 생성 → `android/app/src/dev/google-services.json`, iOS dev `GoogleService-Info.plist`.
- [ ] 아이콘 적용(`flutter_launcher_icons`) — iOS 플레이버 타겟 준비 후.

## dev-login (미커밋 로컬 도구)

라이브 UI 검증용 dev-login(`POST /auth/dev-login`)은 **절대 커밋하지 않는다**.
현재 로컬 관례: **카카오 버튼 = 실제 카카오 로그인**(테스트용), **애플 버튼 = dev-login 우회**
(애플 로그인 미구현이므로 재활용). `auth_repository_impl.dart` / `api_endpoints.dart` 변경분과
`main.dart`의 목 override, Kakao 자격증명은 커밋 금지 대상.
