# API 계약 — 엔드포인트 목록 · 요청/응답 스키마

> 근거: PRD v1 §담당별 산출(Backend) · 계획 "핵심 확정 사실"
> 상태: 1차 계약. 세부 필드는 Figma Description Note + Notion 회의록 확정 후 갱신.

---

## 기본 규칙

- Base URL: `https://api.can-i-eat-it.com/v1` (서버 미확정 시 Mock)
- 인증: `Authorization: Bearer <JWT>` 헤더
- 클라이언트는 서버 API 확정 전 **Mock 구현**으로 선개발. API 확정 시 retrofit datasource만 교체.
- 변경 격리: 서버 API 변경은 `core/network/` + 해당 피처 `data/` 레이어에만 반영.

---

## F0. 인증

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | `/auth/kakao` | 카카오 인가코드 → JWT 발급 |
| POST | `/auth/logout` | 세션 종료 |
| DELETE | `/auth/account` | 계정 삭제 (유예 처리) |

카카오 소셜 로그인 단독 (D2). 클라이언트 Mock 선개발.

---

## F1. 사용자 프로필 · 온보딩

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | `/users/profile` | 온보딩 완료 후 일괄 전송 |
| PUT | `/users/profile` | 프로필·건강정보 수정 |
| GET | `/users/me/summary` | 마이페이지 요약 카드 (관리 N일째, 이번 주 요약) |

### POST /users/profile 요청 스키마 (온보딩 일괄)

```json
{
  "conditions": ["GERD"],
  "symptom_frequency": ["weekly_heartburn", "post_meal_cough"],
  "diagnosed": true,
  "trigger_foods": ["spicy", "caffeine"],
  "custom_triggers": "탄산음료",
  "medications": ["omeprazole"],
  "allergies": ["shellfish"]
}
```

---

## F2. 신호등 판정 (텍스트 검색 단독, D4)

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | `/foods/analyze` | 음식명 텍스트 → 신호등 판정 |
| POST | `/foods` | 사용자 음식 직접 추가 (승인 큐) |
| GET | `/foods/search?q=` | 자동완성·검색 결과 리스트 |

### POST /foods/analyze 요청

```json
{ "text": "된장찌개" }
```

### POST /foods/analyze 응답

```json
{
  "label": "된장찌개",
  "confidence": 0.92,
  "signal": "caution",
  "reason_general": "나트륨 함량이 높아 위산 역류를 악화할 수 있습니다.",
  "reason_personal": "트리거 음식 매치: 없음. 알레르기 해당: 없음.",
  "kcal": 480,
  "category": "한식",
  "alternatives": ["저염 된장찌개", "두부국"],
  "history_summary": {
    "count": 3,
    "average_severity": "보통",
    "records": []
  }
}
```

`signal` 값: `"safe"` / `"caution"` / `"danger"` / `"unknown"`
`confidence` 임계 미만 → `signal: "unknown"` (확인어려움, 18화면)

**비기능**: P95 응답 ≤ 3초 / 검색 자동완성 캐시 활용 (LRU + Redis)

---

## F3. 식사 · 증상 기록

| 메서드 | 경로 | 설명 |
|---|---|---|
| POST | `/meals` | 식사 기록 생성 |
| GET | `/meals?from=&to=` | 타임라인 조회 (무한 스크롤) |
| POST | `/symptoms` | 증상 기록 생성 |
| PATCH | `/symptoms/{id}` | 증상 기록 수정 |

### POST /meals 요청

```json
{
  "foods": ["food_id_1", "food_id_2"],
  "photo_url": "https://s3.../...",
  "eaten_at": "2026-05-24T12:30:00+09:00"
}
```

### POST /symptoms 요청

```json
{
  "meal_id": "meal_uuid",
  "severity": 2,
  "types": ["heartburn", "acid_reflux"],
  "memo": "점심 먹고 30분 뒤부터 불편",
  "occurred_at": "2026-05-24T13:00:00+09:00"
}
```

severity: 0(편안) ~ 5(심함)

---

## F4. 주간 리포트 · 마이페이지

| 메서드 | 경로 | 설명 |
|---|---|---|
| GET | `/reports/weekly?week=YYYY-Www` | 주간 리포트 (차트 3종 데이터) |
| GET | `/users/me/summary` | 마이페이지 요약 카드 |

### GET /reports/weekly 응답 (요약)

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

**베타 이후**: 서버사이드 PDF 생성 엔드포인트 별도 추가.

---

## Mock 교체 전략

```
현재 (Mock 선개발)
  data/repositories/mock_<feature>_repository.dart
  ← Riverpod provider override

API 확정 후 교체
  data/datasources/<feature>_datasource.dart  (retrofit)
  data/repositories/<feature>_repository_impl.dart
  ← 인터페이스(domain) 불변
```

retrofit 재도입 시점: retrofit 4.9.x ↔ retrofit_generator 9.7.x 비호환 해소 확인 후. (ADR-0001 후속 액션)
