# 데이터 모델 — 도메인 엔티티 · 서버 테이블 매핑

> 근거: PRD v1 §담당별 산출(데이터 모델) · 계획 "핵심 확정 사실"

## 도메인 엔티티 개요

```
사용자 프로필 (health_profile)
  ├── 질환 (UserCondition)
  ├── 복용약 (UserMedication)
  └── 트리거 음식 (UserTrigger)

음식 (Food)
  ├── 대체 음식 (FoodAlternative)
  ├── 사용자 추가 대기 (UserFoodSubmission)
  └── 분석 로그 (AnalysisLog)

식사 기록 (Meal)
  └── 증상 기록 (Symptom)

리포트
  ├── 주간 리포트 (WeeklyReport)
  └── 트리거 후보 (TriggerCandidate)
```

---

## 서버 테이블명 매핑

### 사용자 · 프로필

| 서버 테이블 | Flutter 엔티티 | 주요 필드 |
|---|---|---|
| `users` | `User` | user_id, kakao_id, name, created_at |
| `user_conditions` | `UserCondition` | user_id, condition_code (GERD 고정, 확장 가능) |
| `user_medications` | `UserMedication` | user_id, medication_name |
| `user_triggers` | `UserTrigger` | user_id, trigger_food, custom_text |

> `health_profile` 피처(`lib/features/health_profile/domain/`) 소유. onboarding·mypage·food_check이 repository 임포트.

### 음식 · 판정

| 서버 테이블 | Flutter 엔티티 | 주요 필드 |
|---|---|---|
| `foods` | `Food` | food_id, name, category, kcal |
| `food_alternatives` | `FoodAlternative` | food_id, alternative_food_id |
| `user_food_submissions` | `UserFoodSubmission` | submission_id, user_id, name, status(pending/approved/rejected) |
| `analysis_logs` | `AnalysisLog` | log_id, user_id, food_id, signal, confidence, created_at |

### 식사 · 증상

| 서버 테이블 | Flutter 엔티티 | 주요 필드 |
|---|---|---|
| `meals` | `Meal` | meal_id, user_id, photo_url, foods[], eaten_at |
| `symptoms` | `Symptom` | symptom_id, meal_id, severity(0~5), types[], memo, occurred_at, recorded_at |

severity 매핑: 편안(0) / 괜찮(1) / 보통(2) / 불편(3) / 심함(4~5)
types: `heartburn` / `acid_reflux` / `cough` / `throat_lump` / `chest_tightness`

### 리포트

| 서버 테이블 | Flutter 엔티티 | 주요 필드 |
|---|---|---|
| `weekly_reports` | `WeeklyReport` | report_id, user_id, week(ISO 주차), signal_distribution{}, symptom_timeline[] |
| `trigger_candidates` | `TriggerCandidate` | candidate_id, user_id, food_id, occurrence_rate |

---

## EatVerdict — 신호등 4상태

```dart
enum EatVerdict { safe, caution, danger, unknown }
```

| 값 | 서버 signal | 의미 |
|---|---|---|
| `safe` | `"safe"` | 권장 |
| `caution` | `"caution"` | 주의 |
| `danger` | `"danger"` | 위험 |
| `unknown` | `"unknown"` | 확인어려움 (신뢰도 임계 미만 폴백) |

> 샘플 피처의 3값 모델을 이어받지 않는다. W1 클린 초기세팅에서 신규 설계. (ADR-0003)

---

## Repository 인터페이스 우선 전략

1. 서버 API 확정 전: `domain/` 레이어에 repository **인터페이스**만 정의
2. `data/` 레이어에 **Mock 구현** 주입 (Riverpod provider override)
3. API 확정 후: retrofit 구현만 교체 — 인터페이스 불변

```
lib/features/<feature>/
  domain/
    repositories/
      <feature>_repository.dart        ← 인터페이스
  data/
    repositories/
      mock_<feature>_repository.dart   ← Mock 구현 (선개발)
      <feature>_repository_impl.dart   ← retrofit 구현 (API 확정 후)
```

코드 생성(`build_runner`) 대상: freezed DTO, Riverpod provider, (retrofit datasource — API 확정 시).

---

## 모델 코드 생성 워크플로우

freezed 애너테이션 추가·수정 후:

```
dart run build_runner build --delete-conflicting-outputs
```

생성물(`*.freezed.dart`, `*.g.dart`)은 커밋한다. 손으로 수정 금지.
