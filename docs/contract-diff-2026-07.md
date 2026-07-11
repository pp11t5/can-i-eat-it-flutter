# 서버 계약 diff — 라이브 Swagger ↔ 클라이언트 (2026-07)

출처: `https://can-i-eat-it.com/v3/api-docs` (라이브 OpenAPI). 기준 코드: main(#142 정합 이후).
목적: 최종 주 계약 재확인. 확정 drift는 코드 정합, 서버측 잔존 갭은 후속 추적.

## 1. 해소된 이전 갭 (#122)

| 이전 갭 | 라이브 Swagger 현재 | 상태 |
|---|---|---|
| 타임라인 symptom에 symptomId 없음 | Symptom 변형에 `symptomId` 제공 | ✅ 해소 (#121 언블록) |
| symptom mealRecordId 필수(minLen1) vs "선택 안 할래요" | Create/Update `mealRecordId` **nullable** | ✅ 해소 → **코드 정합**(§3) |
| 텍스트 분석 음식 기록 추가 API 부재 | `POST /meal-records/{id}/foods`(text)·`POST /meal-records`(text) 제공 | ✅ 서버 제공 + **코드 이미 구현**(`appendFoodByText`) |
| 리포트 엔드포인트 | `GET /my-page/reports` | ✅ 코드 이미 정합(`api_endpoints.myPageReports`) |
| SymptomResponse에 analysis | `analysis{items[{emphasis,body}]}` 제공 | ✅ 코드 반영됨 |

## 2. 서버측 잔존 갭 (코드로 못 고침 — 백엔드 요청)

| 갭 | 영향 | 추적 |
|---|---|---|
| SymptomResponse에 `memo`·`afterMealMinutes` 미포함 | 증상 상세 직접진입 시 메모/식후N분 표시·수정 프리필 불가 | 백엔드 요청 |
| `linkedMeal`에 식사 시각(eatenAt) 미제공 | 상세에서 음식명만 표시 | 백엔드 요청 |
| 리포트 응답에 **증상 집계 부재** | Figma "기록된 증상" 카드 데이터 없음 | UI 선개발(seam+빈상태), 백엔드 필드 추가 요청 |
| 증상 기간 목록 조회 EP 부재 | 증상 모두보기(읽기전용 리스트) 데이터원 없음 | 백엔드 요청 |
| daily-time enum ↔ 표시 시각 의미 불일치 | 알림 시간 매핑 모호 | 서버/기획 확인 |

## 3. 확정 drift — 코드 정합 (이번 작업 반영)

### A. 타임라인 음식 category 키
- **서버**: timeline Single/Group이 `mealFoodCategory`(code) 제공 (원본 스키마 확인).
- **코드(이전)**: `meal_dtos.dart`가 `j['category']`를 읽어 미제공 취급 → 아이콘 regular 폴백.
- **정합**: `j['category']` → `j['mealFoodCategory']`. W7 타임라인 아이콘 category 갭 해소.

### B. 증상 mealRecordId nullable
- **서버**: `SymptomCreateRequestDTO`/`SymptomUpdateRequestDTO`의 `mealRecordId` nullable.
- **코드(이전)**: DTO `required String mealRecordId` + 작성화면 "선택 안 할래요" 저장 게이팅.
- **정합**: DTO `String?`, null이면 요청 키 누락, 식사 미연결 증상 저장 언블록.

## 4. 문서 주석 stale (마이너, 코드/서버는 일치)

| 항목 | 내용 | 조치 |
|---|---|---|
| `/auth/logout` | 코드·서버 모두 DELETE, 일부 주석만 POST 표기 | 주석 갱신(선택) |
| `/foods/recent` | POST·DELETE도 실사용, 주석은 GET만 | 주석 보완(선택) |
| `/health` | 상수만 존재, 미호출 dead endpoint | 정리(선택) |
| 키 비대칭 | 검색 `externalId` vs 최근 `foodExternalId`; health-info 응답 `allergies` vs 요청 `allergens`; 주간 `judgementList`(서버 오탈자) | 서버 그대로 미러 — **유지** |

## 5. 신규 엔드포인트 (코드 미연동, 기획 대기)
- `GET /foods/{foodExternalId}/symptoms` — 음식별 연결 증상(FoodSymptomDto 존재, 화면 기획 대기)
- `GET /users/me/streak` — 연속일(현재 my-page/summary의 streakCount로 충당)
