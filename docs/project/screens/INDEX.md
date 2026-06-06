# 화면 상태 트래커

> 상태: 미착수 / 진행중 / 완료
> 화면별 세부 노트(`screens/<id>.md`)는 구현 직전 Figma Description Note에서 생성. 사전 생성 금지.
> 갱신: 구현 시작 시 "진행중", 완료 시 "완료"로 변경.

---

## F0. 인증 · 계정

| ID | 화면명 | 라우트 | 우선순위 | 상태 | Figma node |
|---|---|---|---|---|---|
| 01 | 스플래시 | `/splash` | P0 | 미착수 | — |
| 02 | 로그인 (카카오) | `/login` | P0 | 완료 | — |
| 02a | 삭제 유예 안내 | `/login?mode=deleted` | P0 | 미착수 | — |
| 03 | 약관 동의 | `/terms` | P0 | 완료 | — |

---

## F1. 온보딩

| ID | 화면명 | 라우트 | 우선순위 | 상태 | Figma node |
|---|---|---|---|---|---|
| 04 | 온보딩 인트로 | `/onboarding/intro` | P0 | 완료 | — |
| 05 | 질환 선택 (1/4) | `/onboarding/condition` | P0 | 완료 | — |
| 06 | 증상 빈도 + 심각도 (2/4) | `/onboarding/frequency` | P0 | 완료 | — |
| 07 | 트리거 음식 (3/4) | `/onboarding/triggers` | P0 | 완료 | — |
| 08 | 알레르기·복용약 (4/4) | `/onboarding/medications` | P0 | 완료 | — |
| 09 | 온보딩 완료 | `/onboarding/done` | P0 | 완료 | — |

---

## 홈

| ID | 화면명 | 라우트 | 우선순위 | 상태 | Figma node |
|---|---|---|---|---|---|
| 10 | 홈 대시보드 | `/` | P0 | 완료 | — |

---

## F2. 신호등 판정 (food_check)

| ID | 화면명 | 라우트 | 우선순위 | 상태 | Figma node |
|---|---|---|---|---|---|
| 13a | 검색 입력전 | `/check` | P0 | 미착수 | — |
| 13b | 검색 입력후 (자동완성·결과 리스트) | `/check` | P0 | 미착수 | — |
| 13c | 음식 직접 추가 | `/check/add` | P0 | 미착수 | — |
| 14 | 로딩중 | `/check/loading` | P0 | 미착수 | — |
| 15 | 결과 — 권장 | `/check/result` | P0 | 미착수 | — |
| 16 | 결과 — 주의 | `/check/result` | P0 | 미착수 | — |
| 17 | 결과 — 위험 | `/check/result` | P0 | 미착수 | — |
| 18 | 결과 — 확인어려움 | `/check/result` | P0 | 미착수 | — |

---

## F3. 식사·증상 기록 (meal_log)

| ID | 화면명 | 라우트 | 우선순위 | 상태 | Figma node |
|---|---|---|---|---|---|
| 20 | 증상 작성 | `/log/symptom/new` | P0 | 미착수 | — |
| 21 | 타임라인 | `/timeline` | P0 | 미착수 | — |
| 21a | 타임라인 상세 | `/timeline/detail` | P0 | 미착수 | — |
| 22 | 식사 상세 | `/log/meal/:id` | P0 | 미착수 | — |
| 23 | 리치 푸시 응답 (iOS) | — (in-notification) | P0 | 미착수 | — |
| 24 | 리치 푸시 응답 (Android) | — (in-notification) | P0 | 미착수 | — |
| 26b | 상태 기록 (식사 후) | `/log/status` | P0 | 미착수 | — |
| 27 | 증상 수정 | `/log/symptom/:id/edit` | P0 | 미착수 | — |
| 28 | 발생 시간 수정 | `/log/symptom/:id/time` | P0 | 미착수 | — |
| 29 | 연결 식사 수정 | `/log/symptom/:id/meal` | P0 | 미착수 | — |

---

## F4. 마이페이지 (mypage)

| ID | 화면명 | 라우트 | 우선순위 | 상태 | Figma node |
|---|---|---|---|---|---|
| 30 | 마이페이지 | `/mypage` | P0 | 미착수 | — |
| 31 | 프로필·건강정보 편집 | `/mypage/profile/edit` | P0 | 미착수 | — |
| 31a | 로그아웃 확인 | `/mypage/logout` | P0 | 미착수 | — |
| 32 | 계정 삭제 | `/mypage/account/delete` | P0 | 미착수 | — |
| 32a | 계정 삭제 확인 | `/mypage/account/delete/confirm` | P0 | 미착수 | — |
| 34 | 개인정보·약관 | `/mypage/terms` | P0 | 미착수 | — |
| 35 | 알레르기·복용약 편집 | `/mypage/medications/edit` | P0 | 미착수 | — |

---

## F4. 주간 리포트 (report)

| ID | 화면명 | 라우트 | 우선순위 | 상태 | Figma node |
|---|---|---|---|---|---|
| 36 | 주간 리포트 (차트 3종) | `/report` | P0 | 미착수 | — |
| 37 | OS 공유시트 (iOS) | — (share_plus) | P0 | 미착수 | — |
| 38 | OS 공유시트 (Android) | — (share_plus) | P0 | 미착수 | — |

---

## 알림 설정 (notification)

| ID | 화면명 | 라우트 | 우선순위 | 상태 | Figma node |
|---|---|---|---|---|---|
| 37 | 알림 설정 | `/settings/notification` | P0 | 미착수 | — |
| 37b | OS 알림 차단 안내 | `/settings/notification?blocked=true` | P0 | 미착수 | — |

---

## 베타 이후 (Backlog)

| ID | 화면명 | 라우트 | 우선순위 | 상태 |
|---|---|---|---|---|
| — | 인앱결제 | — | P1 | 미착수 |
| — | PDF 공유 결과 | — | P1 | 미착수 |

---

## 통계

- 전체 화면: 35개 (베타후 제외)
- 미착수: 26 / 진행중: 0 / 완료: 9
- 마지막 갱신: 2026-06-06
