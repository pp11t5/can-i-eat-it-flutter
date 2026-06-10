# ADR-0007: 통신계층 확정 — 수기 dio + 응답봉투 언랩 + 인증 Failure 계층 + 401 단일 refresh

- **Status**: Accepted
- **Date**: 2026-06-09
- **Decider(s)**: 프로젝트 팀

## 1. 의사결정 요약

W3 실서버(`https://can-i-eat-it.com` + `/api/v1`, 공통 봉투 `{isSuccess, code, message, traceId, result}`) 연동을 위해 통신계층을 확정한다. (1) **retrofit을 보류하고 수기 dio**로 datasource를 작성한다(스파이크상 호환은 되나, 공통 봉투 언랩·인증 에러 분기·401 큐잉이 retrofit의 선언형 모델과 충돌). (2) 봉투를 단일 지점에서 언랩하고 `code` 기반으로 **인증 의미를 가진 Failure 서브타입**(약관필요·복구가능·토큰무효·세션만료)으로 끌어올린다. (3) 토큰은 **secure storage 인터페이스 추상화**로 보관한다. (4) 401에는 **단일 refresh 큐잉**을 적용한다. (5) DTO는 freezed+json_serializable로 `data/dtos/`에 두고 봉투와 분리한다. (6) 로그인 4분기는 실서버에서 HTTP 200/400/403 출처이고 400/403은 토큰 미발급이므로, `signIn`이 **`SignInOutcome` sealed 결과를 한 번의 await로 반환**하도록 바꿔 현재의 세션-프로퍼티 분기를 대체한다. 단, **게이트(`sessionStatusFrom`/`resolveRedirect`) 순수 함수 모델은 그대로 보존**한다(ADR-0006 불변). 판정(`/foods/analyze`)·전체 프로필 GET은 서버에 없으므로 W3에서 Mock을 유지한다.

## 2. 옵션 비교

### 2-1. datasource 작성 방식

#### Option A: retrofit 재도입 (기각)
- 장점: 스파이크(`docs/spikes/retrofit-compat.md`)상 `retrofit 4.9.2` + `retrofit_generator 10.2.6`이 스택과 충돌 없이 resolve. 보일러플레이트 감소.
- 단점:
  - 모든 응답이 `{isSuccess, code, message, result}` **봉투로 감싸여** 온다. retrofit은 `result`만 직접 역직렬화하기 어렵고, 봉투 언랩을 위해 결국 인터셉터나 래퍼를 덧대야 해 retrofit 이점이 상쇄된다.
  - 핵심 요구인 **`code` 기반 인증 분기**(AUTH400_1 등)와 **401 단일 refresh 큐잉**은 dio 인터셉터/QueuedInterceptor 레벨 로직이다. retrofit은 이 위에 얇게 얹히는 선언형 레이어일 뿐, 본질 작업을 줄여주지 못한다.
  - 코드 생성 의존성·빌드 시간이 추가되지만, 현재 엔드포인트 수(auth 7 + gate 3 + food 5)가 적어 회수되지 않는다.
- 비용·복잡도: 중. 생성기 도입 + 봉투 우회 설계가 이중 비용.

#### Option B: 수기 dio datasource (채택)
- 장점:
  - 봉투 언랩·인증 분기·401 큐잉이 모두 **dio 인터셉터 + 단일 언랩 헬퍼**에 자연히 모인다. 통신계층의 본질 로직과 코드 구조가 일치.
  - 생성 의존성 0. 엔드포인트가 적어 수기 비용이 낮다.
  - ADR-0001 후속 "retrofit 재도입"은 엔드포인트가 많아지고 봉투 처리가 안정화된 뒤로 미룰 수 있다(인터페이스 불변이므로 후일 교체 가능).
- 단점: 엔드포인트가 수십 개로 늘면 수기 직렬화 보일러플레이트가 누적된다.
- 비용·복잡도: 낮음. 단일 언랩 헬퍼 + 피처별 datasource.

### 2-2. 인증 에러 표현

#### Option A: 기존 `NetworkFailure` 메시지에 사유 문자열만 담음 (기각)
- 장점: `Failure` 변경 없음.
- 단점: UI가 "약관 화면으로 보낼지/복구 팝업을 띄울지/로그아웃할지"를 **문자열 파싱**으로 결정해야 한다. 의료성 인증 플로우에서 취약하고 exhaustive switch 불가.
- 비용·복잡도: 낮지만 위험.

#### Option B: 인증 의미 Failure 서브타입 신설 (채택)
- 장점: `Failure` sealed 트리에 인증 분기를 타입으로 올려 UI가 exhaustive switch로 분기. `code`→타입 매핑을 언랩 지점 1곳에 격리.
- 단점: `Failure` 트리 확장 + 매핑 테이블 유지.
- 비용·복잡도: 낮음.

### 2-3. 로그인 결과 표현 (핵심)

#### Option A: 현행 세션-프로퍼티 분기 유지 (기각)
- 장점: `login_screen` 변경 최소.
- 단점: 실서버는 분기 출처가 **HTTP 200/400/403**이고 400/403은 **토큰 미발급(세션 없음)**이다. 현재는 `session.hasAgreedTerms`/`accountStatus`(세션 프로퍼티)로 분기하므로, 세션이 없는 400/403을 표현할 수 없다 — **임피던스 불일치**. 세션을 인위적으로 합성해야 하는 결합이 생긴다.
- 비용·복잡도: 표면상 낮으나 실연동에서 깨진다.

#### Option B: `SignInOutcome` sealed 결과 반환 (채택)
- 장점: 로그인 결과(인증완료/약관필요/복구가능)를 HTTP 상태와 1:1로 sealed 타입에 담아 한 번의 await로 반환. `login_screen`이 이걸로 분기 → 세션 합성 불필요. 게이트 순수 함수 모델은 손대지 않음.
- 단점: `AuthRepository.signIn` 시그니처·`login_screen` 분기 코드 변경.
- 비용·복잡도: 중. 단, 실연동 정합성 확보의 핵심.

## 3. 선택 근거

선택: **2-1 Option B(수기 dio) + 2-2 Option B(인증 Failure 서브타입) + 2-3 Option B(SignInOutcome)**

근거:
- 통신계층의 진짜 작업은 "선언형 API 바인딩"이 아니라 **봉투 언랩 + code 기반 인증 분기 + 401 큐잉**이다. 이 셋은 모두 dio 인터셉터 레벨이며, retrofit은 그 위의 장식일 뿐이다. 따라서 수기 dio가 작업의 본질과 일치하고 비용도 낮다(엔드포인트 15개).
- 인증 에러를 타입으로 올리면 `login_screen`/복구 팝업/세션만료 처리가 exhaustive switch로 강제된다. 의료성·보안 영역에서 문자열 분기는 허용하지 않는다(ADR-0003 "단정 금지"의 타입-강제 원칙과 동일 철학).
- `SignInOutcome`은 실서버의 HTTP 200/400/403 분기를 그대로 타입에 반영해, 세션 합성 결합 없이 게이트 모델(ADR-0006)을 보존한다.

### 3-1. 결정 상세 (티켓 구현 규약)

#### (1) 수기 dio
- `AppConfig.dev.apiBaseUrl`을 `https://can-i-eat-it.com/api/v1`로 교체(현재 `https://api.example.com`). prefix `/api/v1` 포함.
- `dioProvider`에 인터셉터 2종 추가: **AuthInterceptor**(요청에 `Authorization: Bearer`, 응답 401 → refresh 큐잉) + **로깅 인터셉터**(dev only). 현재 `dioProvider`는 인터셉터 0개.
- `api-contract.md`는 STALE(구 `/auth/kakao`·`/foods/analyze`·`/users/profile`, base `api.can-i-eat-it.com/v1`). 본 ADR의 "확정 서버 계약"이 정본이며, **api-contract.md 전면 갱신을 후속 액션으로 명시**한다.

#### (2) `ApiResponse<T>` 봉투 언랩 + Failure 매핑
- `core/network/api_response.dart`: `ApiResponse<T>` freezed(`isSuccess, code, message, traceId, result`). **봉투는 DTO와 분리**(봉투는 core, DTO는 feature data/dtos).
- 단일 언랩 헬퍼 `unwrap<T>(Response, T Function(Object?) fromJson)`: `isSuccess==true` → `result`를 `fromJson`으로 역직렬화, 아니면 `code`→Failure 매핑 후 throw.
- `Failure` sealed 트리 확장(현재 `NetworkFailure`/`UnexpectedFailure`만 존재):
  - `AuthFailure`(추상, `Failure` 하위) — 인증 의미 공통 부모.
    - `TermsRequiredFailure(Set<TermsRequirement> requirements)` ← **400 AUTH400_1(이메일)·AUTH400_3(닉네임)**. `requirements`로 어떤 동의가 필요한지 전달.
    - `RecoverableAccountFailure(RecoverReason reason)` ← **403 AUTH403_5(탈퇴처리중)·AUTH403_2(비활성)**. UI 복구 팝업 분기.
    - `InvalidTokenFailure` ← **401 토큰무효**(refresh 불가/refresh 자체 실패 시).
    - `SessionExpiredFailure` ← refresh 실패로 세션 만료 전이(자동 로그아웃 트리거).
  - `code` 미상/매핑 불가 → `NetworkFailure`/`UnexpectedFailure` 폴백.
  - **매핑 테이블은 언랩 지점 1곳에만** 둔다(`core/network/failure_mapper.dart`). 새 에러 코드 추가 시 이 한 곳만 수정.

#### (3) 토큰 저장 — secure storage 추상화
- 인터페이스 `TokenStore`(domain-agnostic, `core/security/token_store.dart`):
  - `Future<String?> readAccessToken()` / `readRefreshToken()`
  - `Future<void> writeTokens({required String access, required String refresh})`
  - `Future<void> clear()`
- 구현 `FlutterSecureStorageTokenStore`(`core/security/`)는 `flutter_secure_storage`로 분리. 테스트는 인메모리 fake로 계약 검증.
- **토큰 응답에 만료필드 없음** → 클라이언트는 만료를 선제 계산하지 않고 **401 반응형 refresh만** 수행. `TokenStore`는 만료 타임스탬프를 저장하지 않는다.

#### (4) 401 단일 refresh 큐잉 (알고리즘 규약)
- dio `QueuedInterceptor`(또는 동급 락) 기반. 규약:
  1. 응답 401 수신 시, 진행 중 refresh가 **없으면** 단일 refresh Future를 시작(`POST /auth/refresh {refreshToken}`)하고 `_refreshing` 플래그/Completer를 세운다.
  2. refresh 진행 중 도착한 다른 401 요청은 **새 refresh를 시작하지 않고** 그 Completer를 await(큐잉).
  3. refresh 성공 → 새 accessToken을 `TokenStore`에 저장, 큐잉된 요청 전부 새 토큰으로 **재시도(1회)**.
  4. refresh 실패(401/만료) → `TokenStore.clear()` + 큐잉 요청 전부 `SessionExpiredFailure`로 실패시키고, **세션만료 전이**(AuthController가 세션 null로). 무한 refresh 루프 방지를 위해 refresh 요청 자체는 인터셉터 대상에서 제외.
- 원칙: **refresh는 동시 다발 401에서 정확히 1회만** 실행. 재시도는 요청당 1회로 제한(재시도 결과가 또 401이면 그대로 실패 전파).

#### (5) DTO 정합 규약
- DTO는 freezed + json_serializable로 각 피처 `data/dtos/`에 둔다. **봉투(core)와 DTO(feature)를 분리**.
- 서버 JSON은 camelCase(`accessToken`, `foodExternalId`, `searchedAt`)이므로 DTO 필드도 camelCase, `@JsonKey`는 불필요할 때 생략. snake_case 응답 필드가 섞이면 해당 필드에만 `@JsonKey(name:)`.
- DTO ↔ domain entity 매핑은 DTO에 `toEntity()`/`fromEntity()` 확장으로 둔다(entity는 freezed 비종속 유지, ADR-0001 domain 프레임워크 비종속 원칙).

#### (6) `SignInOutcome` + 게이트 보존

**(A) SignInOutcome 형태** — 결론: sealed 결과 + repo 내부에서 onboarded 채움.
- `AuthRepository.signInWithKakao()`/`signInWithApple()` 반환 타입을 `Future<SignInOutcome>`로 변경:
  ```
  sealed SignInOutcome
    Authenticated(AuthSession session, bool onboarded)   // 200
    NeedsTerms(Set<TermsRequirement> requirements)        // 400
    Recoverable(RecoverReason reason)                     // 403
  ```
- 200 성공 시 repo가 토큰 저장 후 **`GET /onboarding/status`를 이어 호출해 `onboarded`를 채운다**(repo 내부). 근거: `onboarded`는 데이터소스 호출 결과이지 UI 상태가 아니므로, 컨트롤러가 두 번째 await를 오케스트레이션하는 것보다 repo가 하나의 일관된 결과를 반환하는 편이 `login_screen` 분기를 단순화한다. (`GET /auth/me`는 표시용 프로필 필요 시점에 별도 호출.)
- `login_screen._handlePostSignIn`은 세션 프로퍼티 대신 이 `SignInOutcome`을 switch: `Authenticated`→`context.go('/')`(게이트가 onboarded로 재평가), `NeedsTerms`→`context.push('/terms')`, `Recoverable`→복구 다이얼로그. 현재 `AuthController.signInWithKakao`가 세션을 갱신하고 화면이 세션을 다시 읽는 흐름은, 컨트롤러가 `SignInOutcome`을 반환·노출하는 흐름으로 대체한다.

**(B) post-login `hasAgreedTerms` 의미 + 게이트 보존** — 결론: 게이트 모델 보존, 세션 필드는 실연동에서 항상 true로 채움(당장 deprecate 안 함).
- 실서버에선 **토큰 보유 = 약관 동의 완료**(미동의면 400으로 토큰 없음). 따라서 200 후 만들어지는 `AuthSession`은 `hasAgreedTerms=true`로 채운다. `needsTerms`는 가드 redirect가 아니라 LoginScreen imperative push로만 도달(ADR-0006 보존) → **`sessionStatusFrom`/`resolveRedirect` 순수 함수 모델을 그대로 둔다**. 즉 게이트의 `needsTerms`는 가드 redirect가 아님을 본 ADR에서 재확인한다.
- `accountStatus`: 200 성공은 항상 `active`(403 복구가능은 토큰 없이 `SignInOutcome.Recoverable`로 빠지므로 세션이 만들어지지 않음). 따라서 세션의 `deletionGrace` 분기는 실연동에서 도달하지 않으나, **Mock 호환·게이트 순수 함수 시그니처 안정성을 위해 필드는 유지**한다(deprecate는 Mock 제거 시 재검토).

**(C) `FoodRepository` 통합 vs `SearchHistoryRepository` 소유권** — 결론: 단일 `FoodRepository`로 통합, 최근검색 엔티티화.
- 서버가 `/foods/search`·`/foods/recent`를 모두 `/foods/*`로 제공 → search + recent(+ 추후 analyze)를 **단일 `FoodRepository`**로 통합 권장:
  ```
  Future<List<FoodSummary>> search(String q, {int size});    // GET /foods/search
  Future<List<RecentFood>> recentSearches({int size});        // GET /foods/recent
  Future<void> addRecent(String foodExternalId);              // POST /foods/recent
  Future<void> removeRecent(String foodExternalId);           // DELETE /foods/recent/{id}
  Future<void> clearRecent();                                 // DELETE /foods/recent
  ```
- 기존 String 기반 `SearchHistoryRepository`(`Future<List<String>>`)는 **흡수·대체**한다. 마이그레이션 영향:
  - 삭제/대체 대상: `search_history_repository.dart`(인터페이스), `mock_search_history_repository.dart`, `search_history_providers.dart`, `search_history_repository_test.dart`. 계약 테스트는 새 `FoodRepository` 계약으로 이관(기존 계약 테스트 패턴 `void healthProfileRepositoryContract(... Function() create)`와 동일한 주입형 함수 패턴 재사용).
  - 최근검색 항목을 **`{foodExternalId, name, category?, searchedAt}` 엔티티**(`RecentFood`)로 승격. 근거: 분석 진입·`POST /foods/recent`에 `foodExternalId`가 필요하므로 String만으로는 부족하다. `FoodSummary`(`externalId, name, category?`)는 검색 결과용 별도 엔티티.
  - 영향 범위가 UI(최근검색 칩 렌더링이 String→엔티티)에 닿으므로, 해당 위젯의 표시 필드를 `.name`으로 교체. 정렬은 서버 `searchedAt` 순서 신뢰(클라이언트 재정렬 불필요).

**(D) `currentProfile()` boolean 양보** — 결론: 게이트 전용 `onboardedStatus()` 메서드 추가(마커 반환 방식 기각).
- 서버에 전체 프로필 GET 부재 → 게이트는 `GET /onboarding/status {onboarded}` boolean만 사용.
- `HealthProfileRepository`에 `Future<bool> onboardedStatus()`를 추가하고, **게이트(`sessionStatus` provider)는 `currentProfile()` 대신 `onboardedStatus()`를 watch**한다. `currentProfile()`은 실서버 GET 부재로 W3에서 **항상 null 또는 Mock 유지**(전체 프로필 표시는 엔드포인트 부재로 후속).
- 마커 반환(`onboarded ? <빈 마커 프로필> : null`) 방식을 기각한 근거: 가짜 마커 프로필은 `currentProfile()`의 계약("프로필 없으면 null, 있으면 그 프로필")을 오염시키고, `repository_contract.dart`의 "submitProfile 후 동일 프로필 반환" 계약과 충돌한다. boolean 의미는 boolean 메서드로 표현하는 편이 계약이 깨끗하다.
- ADR-0006 게이트는 `hasProfile`(bool?)을 받는 순수 함수이므로, 공급 소스를 `currentProfile()!=null`에서 `onboardedStatus()`로 바꿔도 **`sessionStatusFrom` 시그니처는 불변**(ADR-0006 보존). 단 게이트는 onboarded를 모르는 동안 `bool? hasProfile=null`(로딩)을 전달해 `SessionStatus.loading`을 유지하는 현 합성 규약을 따른다.

#### (7) "신규=400" 가정의 백엔드 확인 대기
- "신규 사용자 = 로그인 400(약관필요)" 가정은 **백엔드 확인 대기** 상태다(Swagger상 400 사유가 약관 동의 누락으로 보이나, 신규 가입 분기와 동일한지 미검증).
- 규약: 이 가정에 의존하는 코드(SignInOutcome 매핑, `NeedsTerms` 분기)에 `// ASSUMPTION(be-confirm): 신규=로그인400. 백엔드 확인 후 제거.` 주석 표식을 남긴다. 확인 완료 시 표식 일괄 grep 제거.

## 4. 위험·전제

**위험**:
- 봉투 `code` 체계가 추가/변경되면 `failure_mapper.dart` 매핑 테이블이 누락 매핑을 폴백(`NetworkFailure`)으로 삼켜, 약관/복구 분기가 일반 에러로 떨어질 수 있다. 미매핑 `code`는 dev 로그에 경고로 남긴다.
- 401 큐잉 구현 오류 시 동시 다발 401이 다중 refresh를 유발하거나 데드락. **단위 테스트로 "동시 N개 401 → refresh 정확히 1회 + N개 재시도"를 검증**(보안·비가역 영역).
- "신규=400" 가정이 틀리면 신규 사용자가 약관 화면 대신 일반 에러를 본다(위 (7) 표식으로 추적).
- `SearchHistoryRepository` 흡수가 W2 산출 코드(String 기반 위젯·테스트)를 건드린다. 동작 보존 마이그레이션 필요.

**전제**:
- 공통 봉투 `{isSuccess, code, message, traceId, result}`가 **모든** 응답에 일관 적용된다(에러 응답 포함).
- 토큰 응답에 만료필드가 끝까지 없다 → 반응형 401 refresh만으로 충분하다.
- 200 성공은 항상 약관 동의 완료 + active 계정이다(미동의·복구대상은 토큰 없이 400/403).
- `GET /onboarding/status`가 200 직후 호출 가능한 인증 상태다(방금 받은 accessToken으로).

**전제 깨짐 신호**:
- 일부 엔드포인트가 봉투 없이 raw JSON을 반환하기 시작 → 언랩 헬퍼 분기 필요.
- 토큰 응답에 `expiresIn`이 추가됨 → 선제 refresh 전략 재검토(본 ADR (3)·(4) 수정).
- 200 응답인데 `hasAgreedTerms=false` 상태가 존재 → (B) 보존 결정 재검토.
- 신규 가입이 400이 아닌 별도 상태(예: 201/202)로 옴 → (A) SignInOutcome 매핑·(7) 가정 수정.

## 5. 후속 액션

- [ ] `AppConfig.dev.apiBaseUrl` → `https://can-i-eat-it.com/api/v1` 교체, `dioProvider`에 AuthInterceptor + 로깅 인터셉터 추가
- [ ] `core/network/api_response.dart`(봉투 freezed) + `core/network/failure_mapper.dart`(code→Failure) + `unwrap<T>` 헬퍼
- [ ] `Failure` 트리 확장: `AuthFailure` 추상 + `TermsRequiredFailure`/`RecoverableAccountFailure`/`InvalidTokenFailure`/`SessionExpiredFailure`
- [ ] `core/security/token_store.dart`(인터페이스) + `FlutterSecureStorageTokenStore` 구현 + 인메모리 fake
- [ ] 401 단일 refresh 큐잉(QueuedInterceptor) + refresh 실패 → 세션만료 전이 + 동시성 단위 테스트
- [ ] `AuthRepository` 실 구현(카카오 OIDC idToken → `POST /auth/{provider}/login`) + `signIn` 반환을 `SignInOutcome`으로 변경 + `recover`/`signOut`/`refresh`/`me`/`logout`/`withdraw` 메서드 정합
- [ ] `login_screen._handlePostSignIn` 세션-프로퍼티 분기 → `SignInOutcome` switch 분기로 교체
- [ ] `HealthProfileRepository.onboardedStatus()` 추가 + `sessionStatus` provider가 이를 watch (게이트 순수 함수 불변 확인)
- [ ] `FoodRepository` 통합(search+recent) + `RecentFood`/`FoodSummary` 엔티티화 + 기존 `SearchHistoryRepository` 4파일 흡수·마이그레이션 + UI 칩 String→엔티티
- [ ] 피처별 DTO를 `data/dtos/`에 freezed로 작성 + `toEntity()` 매핑
- [ ] **api-contract.md 전면 갱신**(STALE): base/prefix, 공통 봉투, 실 엔드포인트(auth 7·gate 3·food 5), 서버 부재 항목(`/foods/analyze`·`POST /foods`·프로필 GET) 명기
- [ ] "신규=400" 가정에 `// ASSUMPTION(be-confirm)` 표식 삽입, 백엔드 확인 후 제거
- [ ] 판정(`/foods/analyze`)·전체 프로필 표시는 엔드포인트 부재로 W3 Mock 유지(후속 이슈로 추적)

---

> 이 ADR 형식은 architect 에이전트의 표준 출력 구조(핸드북 §6.2)를 따른다.
> ① 의사결정 요약 ② 옵션 비교 ③ 선택 근거 ④ 위험·전제 ⑤ 후속 액션.
> 선행 결정 정합: ADR-0001(수기 dio는 후속 retrofit 재도입과 인터페이스 불변으로 양립) · ADR-0003(카카오+JWT, 타입-강제 분기) · ADR-0006(게이트 순수 함수·SessionStatus 모델 보존).
