# ADR-0006: 온보딩 완료 게이트 — health_profile 소유 + 합성 로딩 게이트

- **Status**: Accepted
- **Date**: 2026-06-06
- **Decider(s)**: 프로젝트 팀

## 1. 의사결정 요약

`needsOnboarding` 판정의 진실 원천을 `AuthSession.hasCompletedOnboarding`(auth 소유, W1 mock 플래그)에서 `healthProfileControllerProvider`(health_profile 소유)로 이관한다. `SessionStatus`에 `loading` 멤버를 추가하고, `sessionStatus` provider가 auth + health_profile 두 async 소스를 합성하되 어느 하나라도 로딩 중이면 `loading`을 반환한다. `resolveRedirect`는 `loading`에서 항상 null(현 위치 유지=splash 잔류)을 반환해 부팅 시 깜빡임을 차단한다. ADR-0002 §5("가드는 auth + health_profile 상태를 읽는다")의 직접 실현이다.

## 2. 옵션 비교

### Option A: `AuthSession.hasCompletedOnboarding` 유지 (auth 소유, 기각)

- 장점: 코드 변경 없음. W1 구현을 그대로 유지한다.
- 단점:
  - 진실 원천 이중화. 온보딩 완료 여부를 auth와 health_profile 양쪽이 각자 관리하게 된다.
  - ADR-0002 §5 위반. 가드가 health_profile 상태를 읽어야 한다고 명시했으나, auth 플래그로 대체하면 이 원칙이 무효화된다.
  - 온보딩 완료는 물리적으로 `POST /v1/users/profile`(health_profile 소유) 후 발생한다. 이 시점에 게이트를 뒤집으려면 auth 세션을 인위적으로 갱신해야 하는 쓰기 결합이 생긴다.
  - `auth_session.dart`의 "W2에서 health_profile이 소유 예정" 주석과 직접 충돌한다.
- 비용·복잡도: 단기 낮음, 장기 높음(결합 누적).

### Option B: `healthProfileControllerProvider`에서 파생 (profile == null → needsOnboarding) [채택]

- 장점:
  - 진실 원천 단일화. 온보딩 완료 = `POST profile` 후 provider 갱신으로 게이트가 자연히 ready 전환.
  - import 방향이 보존된다. onboarding/auth → health_profile domain(ADR-0002 허용 방향). health_profile이 다른 피처를 역방향 임포트하지 않는다.
  - `SessionStatus.loading` 추가로 async 소스 2개 합성 복잡도를 한 곳(`sessionStatus` provider)에 격리하고, `resolveRedirect` · `sessionStatusFrom`은 순수 함수로 보존해 테스트 가능성을 유지한다.
- 단점: async 소스 2개 합성 로직 구현 필요. `hasCompletedOnboarding` 제거로 기존 테스트 마이그레이션이 수반된다.
- 비용·복잡도: 중. W2에서 일괄 처리.

### Option C: 하이브리드 (auth 플래그 + health_profile이 채움, 기각)

- 장점: 기존 auth 플래그를 재활용할 수 있다.
- 단점:
  - health_profile이 auth를 역방향 임포트해야 하므로 ADR-0002의 임포트 금지 원칙을 직접 위반한다.
  - 두 소스 간 동기화 실패 시나리오(auth=완료, health_profile=미저장)를 별도로 처리해야 해 결합이 최악이다.
- 비용·복잡도: 높음. 기각.

---

### 로딩 처리 하위 결정: `SessionStatus.loading` 추가 + redirect null 반환

현행 "로딩 → unauthenticated 평탄화" 방식은 부팅 시 `/login` 깜빡임(이슈 #20 S1)을 유발한다. async 소스가 2개(auth + health_profile)가 되면 `/login → /onboarding → /` 다단 점프로 악화된다. `loading` 멤버를 추가하고 `resolveRedirect`가 `loading`에서 null을 반환하면, go_router의 "redirect null = 현 위치 유지" 표준 패턴에 따라 초기 위치인 `/splash`에 머물다 합성 완료 후 단 한 번 최종 라우트로 이동한다.

## 3. 선택 근거

선택: **Option B (healthProfileControllerProvider 파생) + SessionStatus.loading 추가**

근거:
- 온보딩 완료의 물리적 정의는 "프로필 레코드 존재"(`POST /v1/users/profile` 일괄 전송, data-model.md)다. 데이터를 소유한 피처가 완료를 판정하는 것이 결합 최소 원칙에 부합한다.
- 합성 복잡도는 전부 `sessionStatus` provider(불순)에 격리한다. `resolveRedirect` · `sessionStatusFrom`은 순수 함수로 보존되어 단위 테스트가 상태 의존성 없이 가능하다.
- 게이트 플립은 온보딩 `submit` 후 provider 상태 갱신 한 줄로 완결된다. auth 세션에 쓰는 결합이 없다.
- `loading → null`은 go_router의 표준 패턴(redirect null = 현 위치 유지)이며, 초기 위치가 `/splash`이므로 로딩 동안 스플래시를 유지하고 완료 후 한 번만 최종 라우트로 이동한다. 깜빡임 0(이슈 #20 S1·S3 흡수).
- ADR-0002 §5 가드 계약("auth + health_profile 상태를 읽는다")을 실현하며, ADR-0003 §7 AuthSession 설계(W2 이관 예정 주석)와 충돌하지 않는다.

## 4. 위험·전제

**위험**:
- `profile == null`이 "온보딩 미완료"와 "fetch 에러"를 함께 삼킬 수 있다. W2는 `AsyncError` 상태를 별도 분기로 유지하고, `needsOnboarding` 폴백 처리 + TODO를 명시한다. 에러 UX는 본 ADR 범위 밖이며 별도 이슈로 추적한다.
- 약관 동의 직후 한 프레임 health_profile 로딩이 발생할 수 있다. `sessionStatus`가 `loading`을 반환하고 splash/현 위치를 유지하므로 사용자에게 노출되지 않는다.
- `hasCompletedOnboarding` 제거 시 이를 참조하는 기존 테스트가 컴파일 에러를 낸다. W2 구현 시 일괄 마이그레이션 필수.

**전제**:
- 온보딩 완료 = "프로필 레코드 1개 존재"로 단순 매핑한다. data-model.md의 "일괄 POST" 설계가 근거이며, 부분저장(draft) 시나리오는 없다.
- go_router redirect는 동일 `SessionStatus` 반복 평가에 멱등(순수 함수)이다. 이슈 #20 S3(refreshListenable 중복 발화) 완화의 근거.
- `refreshListenable`은 `sessionStatusProvider` 단일 listen으로 교체되어, auth + health_profile 변경 모두 하나의 notifier를 통해 라우터에 전달된다.

**전제 깨짐 신호**: 온보딩 스텝별 부분저장(draft) 도입 시 `profile != null`이 더 이상 "완료"를 뜻하지 않는다. 이 경우 별도 완료 플래그(예: `onboarding_draft` 엔티티)가 필요하며 본 ADR을 재검토한다.

## 5. 후속 액션

- [x] `SessionStatus.loading` 추가 + `sessionStatusFrom` 합성 순수 함수 + `sessionStatus` provider 합성 구현 (W2)
- [x] `resolveRedirect` — `loading → null`, `app_router` refreshListenable을 `sessionStatusProvider` 단일 listen으로 교체 (W2)
- [x] `AuthSession.hasCompletedOnboarding` 제거 → 온보딩 완료 판정을 health_profile 소유로 이관 (W2)
- [x] 이슈 #20 S1(부팅 깜빡임) · S3(refreshListenable 중복 발화) 흡수
- [ ] 온보딩 부분저장(draft) 도입 시 본 ADR 재검토

---

> 이 ADR 형식은 architect 에이전트의 표준 출력 구조(핸드북 §6.2)를 따른다.
> ① 의사결정 요약 ② 옵션 비교 ③ 선택 근거 ④ 위험·전제 ⑤ 후속 액션.
