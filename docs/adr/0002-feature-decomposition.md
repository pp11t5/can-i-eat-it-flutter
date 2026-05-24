# ADR-0002: 피처 경계 분해 — MVP 피처 지도 · health_profile 공유 도메인 · 앱 셸 라우팅

- **Status**: Accepted
- **Date**: 2026-05-24
- **Decider(s)**: 프로젝트 팀

## 1. 의사결정 요약

"먹어도 돼?" MVP를 **8개 피처 폴더**(auth / onboarding / food_check / meal_log / home / mypage / notification / report)로 분해하고, 질환·증상·트리거·복용약 프로필을 여러 피처가 공유하는 **health_profile 공유 도메인**(presentation 없음)으로 별도 추출한다. 앱 셸은 go_router `StatefulShellRoute` + 인증·온보딩 완료 여부 기반 `redirect` 가드로 구성한다.

## 2. 옵션 비교 (최소 2개)

### Option A: 8피처 + health_profile 공유 도메인 분리 (채택)

- 장점:
  - 피처별 변경이 해당 폴더 내부로 격리된다(ADR-0001 원칙 유지).
  - health_profile entity/repository를 onboarding·mypage·food_check가 임포트해 중복 정의를 없앤다.
  - presentation 레이어가 없으므로 UI 결합 없이 도메인 계약만 공유한다.
  - report·notification을 별도 피처로 두면 F4 베타후 확장(서버 PDF·자동 푸시)이 해당 피처 `data` 교체만으로 완결된다.
- 단점: 피처 수가 많아 초기 스캐폴딩 비용이 증가한다.
- 비용·복잡도: 중. W1 클린 초기세팅 시 한 번에 생성.

### Option B: 단일 `features/` 평탄 구조 (도메인별 미분리)

- 장점: 폴더 수가 적고 초기 설정이 빠르다.
- 단점: 질환 프로필처럼 여러 화면에서 쓰는 도메인이 특정 피처에 종속되어, 다른 피처가 그 피처를 직접 임포트하는 의존성 역전이 발생한다. MVP 이후 확장 시 경계 재정의 비용이 크다.
- 비용·복잡도: 초기 낮음, 장기 높음.

### Option C: 레이어 우선(layer-first) 구조

- 장점: `data/` `domain/` `presentation/` 최상위 분리로 레이어 경계가 명확하다.
- 단점: 한 피처의 변경이 세 폴더에 걸쳐 발생해 PR 범위가 넓어진다. 주간 반복 변경이 많은 초안 단계에 비적합(ADR-0001 근거와 충돌).
- 비용·복잡도: 중. 대규모 팀 규약 강제에 유리하나 1인 Flutter 체제에서 과도.

## 3. 선택 근거

선택: **Option A (8피처 + health_profile 공유 도메인)**

근거:
- ADR-0001 피처 우선 원칙의 직접 구체화다. 피처 폴더별 변경 격리가 주간 기획·디자인 변경을 흡수하는 핵심 수단이다.
- 질환·증상 프로필은 onboarding(수집), mypage(편집), food_check(판정 입력) 세 피처가 동시에 참조하므로, 어느 한 피처에 귀속시키면 의존성 역전이 필연적으로 발생한다. 별도 공유 도메인이 유일한 의존성 비역전 해법이다.
- `StatefulShellRoute`는 바텀 내비(홈·타임라인·마이페이지 + 중앙 체크)의 탭 상태를 유지하면서 화면 전환을 처리하는 go_router 표준 패턴이다. `redirect` 가드를 한 곳에 두면 인증·온보딩 완료 여부에 따른 라우팅 제어가 단일 진실 원천으로 유지된다.

## 4. 위험·전제

**위험**:
- health_profile entity가 비대해지면 다른 피처 컴파일 단위 전체에 영향을 준다 → entity를 작게 유지하고 피처별 DTO는 각 피처 `data`에 둔다.
- 피처 수 증가로 초기 스캐폴딩 누락 가능성 → W1 클린 초기세팅 이슈에서 디렉토리 체크리스트 운영.
- `redirect` 가드 로직이 복잡해지면 라우터 파일이 비대해진다 → 가드 함수를 별도 파일로 분리(`app/router/guards/`).

**전제**:
- meal_log는 단일 피처로 충분하다(타임라인·식사 상세·증상 기록이 모두 F3 범위). 타임라인과 증상이 독립 피처로 분리될 만큼 화면·데이터가 복잡해지면 이 ADR을 재검토한다.
- payment·다중 질환은 베타후 범위이므로 이번 ADR 경계에서 제외한다. Backlog 마일스톤 이슈로 별도 추적.

**전제 깨짐 신호**: meal_log 또는 report 변경이 3개 이상 다른 피처를 동시에 건드리거나, health_profile entity 수정이 빌드 전체에 영향을 주기 시작하면 경계 재설계가 필요하다.

## 5. 피처 경계 상세

### MVP 피처 목록

| 피처 폴더 | 화면 ID | 라우트(안) | MVP 범위 |
|---|---|---|---|
| auth | 01 스플래시·02 로그인·02a·03 약관동의 | `/splash` `/login` `/terms` | MVP (Mock 선개발) |
| onboarding | 04 인트로·05~08 입력 4스텝·09 완료 | `/onboarding/*` | P0 |
| food_check | 13a·13b 검색·14 로딩·15~18 결과 4종·직접추가 | `/check` `/check/result` | P0 핵심 |
| meal_log | 26b 상태기록·20 증상작성·21·21a 타임라인·22 식사상세·23·24 리치푸시 응답·27~29 수정 | `/timeline` `/log/*` | P0 |
| home | 10 홈 | `/` | MVP |
| mypage | 30 마이페이지·31·31a 프로필편집·35 알레르기복용약·32·32a 계정삭제·34 약관 | `/mypage/*` | MVP |
| notification | 37 알림설정·37b OS 차단 | `/settings/notification` | P0 |
| report | 36 주간리포트·OS 공유시트 | `/report` | P0 (서버 PDF·배치는 베타후) |

### health_profile 공유 도메인

```
lib/features/health_profile/
  domain/
    entities/health_profile.dart      # 질환·증상빈도·트리거·복용약·알레르기
    repositories/health_profile_repository.dart  # 인터페이스만
  data/
    dtos/health_profile_dto.dart       # freezed DTO
    datasources/health_profile_datasource.dart
    repositories/health_profile_repository_impl.dart
  # presentation/ 없음 — UI는 onboarding·mypage가 각자 소유
```

임포트 방향: onboarding → health_profile domain, mypage → health_profile domain, food_check → health_profile domain. health_profile → 다른 피처 임포트 금지.

### 앱 셸 · 라우팅 구조

- **바텀 내비 탭**: 홈(`/`) · 타임라인(`/timeline`) · 마이페이지(`/mypage`) + 중앙 플로팅 체크(`/check`)
- **StatefulShellRoute**: 탭 전환 시 각 탭의 Navigator 상태를 유지한다.
- **redirect 가드**: 세션 토큰 없음 → `/login`, 온보딩 미완료 → `/onboarding/intro`, 완료 → `/`
- 가드 판단 근거: auth + health_profile repository의 상태를 읽는 Riverpod provider를 구독해 redirect 반환값을 계산한다.

### 베타후 범위 (이 ADR 제외)

- payment 피처 (인앱결제 월 9,900원)
- 다중 질환 확장
- 서버 PDF 생성·트리거 추론 배치·주간 자동 푸시 (report/notification `data` 교체로 대응 예정)

## 6. 후속 액션

- [ ] W1: 8개 피처 폴더 + health_profile 스캐폴드 생성 (샘플 피처 condition_profile·food_check 제거 후)
- [ ] W1: go_router StatefulShellRoute + redirect 가드 골격 구현 (Figma 10_홈 기준)
- [ ] W2: health_profile domain entity + repository 인터페이스 + Mock impl 완성
- [ ] W4: report `data` 레이어에 서버 PDF·배치 stub 추가 (베타후 교체 대비)

---

> 이 ADR 형식은 architect 에이전트의 표준 출력 구조(핸드북 §6.2)를 따른다.
> ① 의사결정 요약 ② 옵션 비교 ③ 선택 근거 ④ 위험·전제 ⑤ 후속 액션.
