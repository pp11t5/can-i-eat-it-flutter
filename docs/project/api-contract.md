# API 계약 — 엔드포인트 목록 · 요청/응답 스키마

> **정본**: ADR-0007 + Swagger 실측(2026-06). 이전 초안 엔드포인트(`/auth/kakao`, `/foods/analyze`, `/users/profile`, base `api.can-i-eat-it.com/v1`)는 모두 교체됨.
> 근거: PRD v1 §담당별 산출(Backend) · ADR-0007 §3-1

---

## 기본 규칙

- **Base URL**: `https://can-i-eat-it.com` + prefix `/api/v1`
  - 전체 예시: `https://can-i-eat-it.com/api/v1/auth/kakao/login`
- **인증**: `Authorization: Bearer <accessToken>` 헤더 (게이트 이후 모든 요청)
- **공통 응답 봉투**: 모든 응답(성공·실패 공통)은 아래 봉투로 감싸인다.

```json
{
  "isSuccess": true,
  "code":      "AUTH200_0",
  "message":   "요청 성공",
  "traceId":   "abc-123",
  "result":    { ... }
}
```

  - `isSuccess`: 성공 여부 boolean
  - `code`: 서버 정의 의미 코드 (에러 분기의 기준. 예: `AUTH400_1`, `AUTH403_5`)
  - `traceId`: 서버 추적용 ID (에러 신고 시 첨부)
  - `result`: 성공 시 실제 페이로드. 실패 시 null 또는 생략
  - 클라이언트 언랩 지점: `core/network/failure_mapper.dart` 단일 위치에서 `code` → `Failure` 매핑

- **토큰 만료 전략**: 토큰 응답에 만료 필드 없음 → **401 반응형 refresh**만 수행 (선제 계산 없음)
- **클라이언트 선개발 규칙**: 서버 미확정 엔드포인트는 Mock 구현으로 선개발. API 확정 시 datasource만 교체(인터페이스 불변).
- **변경 격리**: 서버 API 변경은 `core/network/` + 해당 피처 `data/` 레이어에만 반영.
- **의료성 면책**: 판정 결과는 의학적 진단을 대체하지 않는다. 화면에 면책 문구 표기 의무.

---

## F0. 인증

### 엔드포인트 목록

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | `/auth/{provider}/login` | 소셜 OIDC idToken → 토큰 발급 |
| POST | `/auth/refresh` | 액세스 토큰 갱신 |
| GET | `/auth/me` | 현재 사용자 기본 정보 |
| DELETE | `/auth/logout` | 세션 종료 (서버 refreshToken 무효화) |
| DELETE | `/auth/withdraw` | 계정 탈퇴 (유예 처리) |
| POST | `/auth/{provider}/recover` | 탈퇴처리중·비활성 계정 복구 |

`{provider}` 값: 현재 `kakao` (카카오 OIDC 단독, ADR-0003).

### POST /auth/{provider}/login

**요청**

```json
{ "idToken": "<카카오 OIDC idToken>" }
```

**응답 분기 (로그인 4분기)**

| HTTP | `code` | 의미 | result |
|---|---|---|---|
| 200 | — | 인증 완료 | `{ accessToken, refreshToken, userId, email, role }` |
| 400 | `AUTH400_1` | 이메일 동의 누락 (약관필요) | — |
| 400 | `AUTH400_3` | 닉네임 동의 누락 (약관필요) | — |
| 403 | `AUTH403_5` | 탈퇴 처리중 계정 (복구가능) | — |
| 403 | `AUTH403_2` | 비활성 계정 (복구가능) | — |
| 401 | — | idToken 무효 | — |

> 200 성공 시 `hasAgreedTerms=true`·`accountStatus=active` 보장 (미동의·복구대상은 토큰 없이 400/403으로 빠짐).
>
> 토큰 응답에 만료 필드(`expiresIn` 등) 없음 — 클라이언트는 만료를 선제 계산하지 않는다.

**클라이언트 `SignInOutcome` 매핑** (ADR-0007 §3-1 (6)):

```
sealed SignInOutcome
  Authenticated(AuthSession session, bool onboarded)   // 200
  NeedsTerms(Set<TermsRequirement> requirements)        // 400 AUTH400_1·AUTH400_3
  Recoverable(RecoverReason reason)                     // 403 AUTH403_5·AUTH403_2
```

> `// ASSUMPTION(be-confirm): 신규=로그인400. 백엔드 확인 후 제거.`

### POST /auth/refresh

**요청**

```json
{ "refreshToken": "<refreshToken>" }
```

**응답** (200): `{ accessToken, refreshToken }`

401 응답 시 → `SessionExpiredFailure` 전이, 자동 로그아웃.

### GET /auth/me

**응답** (200): `{ userId, nickname, email, profileImage }`

### DELETE /auth/logout

**요청 바디**: `{ "refreshToken": "<refreshToken>" }`

### DELETE /auth/withdraw

요청 바디 없음. 계정 탈퇴(유예 처리).

### POST /auth/{provider}/recover

**요청**

```json
{ "idToken": "<카카오 OIDC idToken>" }
```

복구 대상 계정 재식별. 로그인과 동일하게 새 idToken을 전송.

---

## F1. 사용자 프로필 · 온보딩

### 엔드포인트 목록

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | `/consent` | 약관 동의 일괄 전송 |
| POST | `/onboarding` | 온보딩 건강 정보 일괄 전송 |
| GET | `/onboarding/status` | 온보딩 완료 여부 조회 (게이트 소스) |

> 전체 프로필 GET 엔드포인트(`GET /users/profile` 등)는 **서버에 없음** — W3에서 `currentProfile()` Mock 유지. 전체 프로필 표시는 엔드포인트 확정 후 후속 이슈로 추적.

### POST /consent

**요청**

```json
{
  "tos":             true,
  "privacy":         true,
  "healthSensitive": true,
  "marketing":       false
}
```

### POST /onboarding

**요청** (모든 필드 예시)

```json
{
  "conditions":    ["GERD"],
  "symptoms":      ["weekly_heartburn", "post_meal_cough"],
  "triggers":      ["spicy", "caffeine"],
  "allergens":     ["shellfish"],
  "medications":   ["omeprazole"]
}
```

필드명·허용 값은 Swagger 확인 후 갱신. 현재 camelCase 기준(서버 JSON 규칙).

### GET /onboarding/status

**응답** (200): `{ "onboarded": true }`

`onboarded` boolean — 게이트(`sessionStatus` provider)가 이 값으로 온보딩 완료 여부를 판단한다 (ADR-0007 §3-1 (6-D)). 로그인 200 직후 repo 내부에서 자동 호출.

---

## F2. 신호등 판정

### 실 엔드포인트 (W3-3 충실 정합 — 판정 + 검색 · 최근 검색)

> W3-3 이후 `POST /foods/analyze` Mock은 제거됨. 판정은 아래 두 엔드포인트(실 dio)로 연결.

| 메서드 | 경로 | 설명 |
|---|---|---|
| GET | `/foods/judgment?foodTextInput=` | 텍스트 직접 입력 판정 |
| GET | `/foods/{foodExternalId}/judgment` | 검색 결과 ID 기반 판정 |

### GET /foods/judgment (by-text)

**쿼리**: `foodTextInput` (필수 — 판정할 음식 텍스트)

**응답** (200): `result` 객체

```json
{
  "foodName":     "두부",
  "grade":        "RECOMMEND",
  "personalTitle":"두부, 안심하고 드세요",
  "items": [
    { "emphasis": "트리거/증상 분석",    "body": "역류 트리거에 해당하지 않아요." },
    { "emphasis": "알레르기/복용약 분석", "body": "알레르기·복용약 충돌이 없어요." }
  ],
  "stateRecords": {
    "total":   0,
    "records": []
  }
}
```

- `foodExternalId`·`category`·`substitutes` 없음 (by-text 규약).
- 클라이언트는 `substitutes`를 항상 빈배열로 처리한다.

**에러**:

| HTTP | code | Failure 클래스 |
|---|---|---|
| 400 | `FOOD400_1` | `InvalidFoodQueryFailure` |

### GET /foods/{foodExternalId}/judgment (by-id)

**경로 파라미터**: `foodExternalId` (검색 결과 `FoodSummary.externalId`)

**응답** (200): `result` 객체

```json
{
  "foodExternalId": "food-001",
  "foodName":       "커피",
  "category":       "음료",
  "grade":          "RISK",
  "personalTitle":  "커피, 지금은 피하는 게 좋아요",
  "items": [
    { "emphasis": "트리거/증상 분석",    "body": "카페인이 위산 분비를 촉진해요." },
    { "emphasis": "알레르기/복용약 분석", "body": "복용약과의 직접 충돌은 없어요." }
  ],
  "stateRecords": {
    "total":   2,
    "records": [
      { "label": "속쓰림", "date": "2026-06-10", "timing": "식후 30분" }
    ]
  },
  "substitutes": [
    { "foodExternalId": "sub-1", "name": "디카페인 커피" }
  ]
}
```

- `category` nullable.
- `substitutes` 빈배열 가능 (grade=RECOMMEND·UNKNOWN 시 서버가 빈배열 반환).

**에러**:

| HTTP | code | Failure 클래스 |
|---|---|---|
| 404 | `FOOD404_1` | `FoodNotFoundFailure` |

### grade 값 정의

| grade | VerdictLevel | 처리 방침 |
|---|---|---|
| `RECOMMEND` | `recommend` | AsyncData → VerdictResultScreen |
| `CAUTION` | `caution` | AsyncData → VerdictResultScreen |
| `RISK` | `risk` | AsyncData → VerdictResultScreen |
| `UNKNOWN` | `unknown` | AsyncData → VerdictUnknownScreen (성공 응답 — D1, R3) |
| 미지값 | `unknown` | 안전 폴백 (AsyncData) |

> `UNKNOWN`은 성공 응답이다. 절대 AsyncError로 흘리지 않는다 (D1, R3).

### 실 엔드포인트 (검색 · 최근 검색)

| 메서드 | 경로 | 설명 |
|---|---|---|
| GET | `/foods/search?q=&size=` | 텍스트 검색 · 자동완성 결과 |
| GET | `/foods/recent?size=` | 최근 검색 목록 |
| POST | `/foods/recent` | 최근 검색 항목 추가 |
| DELETE | `/foods/recent` | 최근 검색 전체 삭제 |
| DELETE | `/foods/recent/{foodExternalId}` | 최근 검색 단건 삭제 |

### GET /foods/search

**쿼리**: `q` (검색어), `size` (결과 수, 선택)

**응답** (200): `result` 배열

```json
[
  { "externalId": "food-001", "name": "된장찌개", "category": "한식" }
]
```

`category` 필드는 선택적(nullable).

### GET /foods/recent

**쿼리**: `size` (결과 수, 선택)

**응답** (200): `result` 배열

```json
[
  {
    "foodExternalId": "food-001",
    "name":           "된장찌개",
    "category":       "한식",
    "searchedAt":     "2026-06-09T10:30:00+09:00"
  }
]
```

`category` 선택적. 정렬은 서버 `searchedAt` 순(클라이언트 재정렬 불필요).

### POST /foods/recent

**요청**: `{ "foodExternalId": "food-001" }`

### DELETE /foods/recent/{foodExternalId}

경로 파라미터로 단건 삭제.

### DELETE /foods/recent

바디 없음. 전체 삭제.

**도메인 엔티티** (ADR-0007 §3-1 (6-C)):
- `FoodSummary`: `{ externalId, name, category? }` — 검색 결과용
- `RecentFood`: `{ foodExternalId, name, category?, searchedAt }` — 최근 검색용

**비기능**: 검색 자동완성 캐시 활용 (LRU + Redis, 서버측). P95 응답 목표는 엔드포인트 출시 시 확정.

---

## F3. 식사 · 증상 기록

> **미확정/후속 (Swagger 미확인)**: 아래 엔드포인트는 현재 서버에서 확인되지 않았다. 계약 초안을 보존하되, 실 구현 전 Swagger 재확인 필수.

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | `/meals` | 식사 기록 생성 |
| GET | `/meals?from=&to=` | 타임라인 조회 (무한 스크롤) |
| POST | `/symptoms` | 증상 기록 생성 |
| PATCH | `/symptoms/{id}` | 증상 기록 수정 |

### POST /meals 요청 (초안 — Swagger 미확인)

```json
{
  "foods":     ["food_id_1", "food_id_2"],
  "photo_url": "https://s3.../...",
  "eaten_at":  "2026-05-24T12:30:00+09:00"
}
```

### POST /symptoms 요청 (초안 — Swagger 미확인)

```json
{
  "meal_id":    "meal_uuid",
  "severity":   2,
  "types":      ["heartburn", "acid_reflux"],
  "memo":       "점심 먹고 30분 뒤부터 불편",
  "occurred_at":"2026-05-24T13:00:00+09:00"
}
```

`severity`: 0(편안) ~ 5(심함)

---

## F4. 주간 리포트 · 마이페이지

> **미확정/후속 (Swagger 미확인)**: 아래 엔드포인트는 현재 서버에서 확인되지 않았다. 계약 초안을 보존하되, 실 구현 전 Swagger 재확인 필수.

| 메서드 | 경로 | 설명 |
|---|---|---|
| GET | `/reports/weekly?week=YYYY-Www` | 주간 리포트 (차트 3종 데이터) |
| GET | `/users/me/summary` | 마이페이지 요약 카드 |

### GET /reports/weekly 응답 (초안 — Swagger 미확인)

```json
{
  "week": "2026-W21",
  "signal_distribution": { "safe": 10, "caution": 5, "danger": 2 },
  "symptom_timeline": [
    { "hour": 12, "count": 3 },
    { "hour": 18, "count": 5 }
  ],
  "trigger_candidates": [
    { "food": "커피", "occurrence_rate": 0.80, "count": 4 }
  ]
}
```

**베타 이후**: 서버사이드 PDF 생성 엔드포인트 별도 추가 예정.

---

## 기타

| 메서드 | 경로 | 설명 |
|---|---|---|
| GET | `/health` | 서버 헬스 체크 |

---

## Mock 교체 전략

```
현재 (Mock 선개발)
  data/repositories/mock_<feature>_repository.dart
  ← Riverpod provider override

API 확정 후 교체
  data/datasources/<feature>_datasource.dart  (수기 dio, ADR-0007)
  data/repositories/<feature>_repository_impl.dart
  ← 인터페이스(domain) 불변
```

**우선순위**:
1. auth (F0) · gate (F1 consent·onboarding) — W3 실 연동 대상
2. food search · recent (F2 실 엔드포인트) — W3 실 연동 대상
3. `/foods/analyze` · 전체 프로필 GET — **엔드포인트 부재, Mock 유지** (출시 시 datasource 교체)
4. F3 (식사·증상) · F4 (리포트) — Swagger 확인 후 착수

수기 dio datasource 재도입 시점: ADR-0007 §2-1 채택(retrofit 보류, 봉투 언랩·인증 분기·401 큐잉이 dio 인터셉터에 자연히 모임). retrofit 재도입은 엔드포인트가 충분히 늘고 봉투 처리 안정화 후 재검토(ADR-0001 후속).
