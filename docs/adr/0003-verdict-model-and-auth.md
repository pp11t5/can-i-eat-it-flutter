# ADR-0003: 판정 모델(EatVerdict 4상태) · 인증 전략(카카오 단독 + JWT Mock-우선)

- **Status**: Accepted
- **Date**: 2026-05-24
- **Decider(s)**: 프로젝트 팀

## 1. 의사결정 요약

신호등 판정 모델을 **EatVerdict 4상태**(recommend / caution / danger / unknown)로 신규 설계한다. `unknown`은 LLM 신뢰도가 임계값 미만이거나 매칭에 실패했을 때의 폴백 상태로, 단정을 금지하고 면책 고지를 노출한다. 인증은 **카카오 소셜 로그인 단독 + JWT** 방식을 채택하며, 서버 API 완성 전까지 **Mock 인증**으로 UI를 선개발한다.

## 2. 옵션 비교

### 판정 모델: Option A — 4상태 EatVerdict (채택)

- 상태: `recommend`(권장) / `caution`(주의) / `danger`(위험) / `unknown`(확인어려움)
- 장점:
  - `unknown`이 명시적 폴백 상태로 존재해 LLM 신뢰도 미달·DB 미매칭 시 "단정하지 않음"을 타입 시스템으로 강제한다.
  - PRD v1 Figma 화면이 4종(15 권장·16 주의·17 위험·18 확인어려움)으로 이미 설계되어 있어, 4상태가 UI 계약과 1:1 대응한다.
  - 의료성 제품 요건상 "확인 불가" 상태를 UI에서 별도 처리해야 하므로, `unknown` 없는 3상태는 구현 시 null 처리나 예외 분기가 남발된다.
  - 서버 응답 `signal` 필드 값이 4종으로 오도록 API 계약(api-contract.md)을 고정할 수 있다.
- 단점: 3상태 대비 VerdictCard UI 분기가 하나 더 필요하다.
- 비용·복잡도: 낮음. enum 정의 + switch 분기 추가.

### 판정 모델: Option B — 3상태 (safe / caution / danger)

- 장점: 단순, 기존 샘플 피처 코드와 유사.
- 단점:
  - LLM 신뢰도 미달 시 `caution`으로 강제 분류하면 사용자에게 잘못된 정보를 준다. 의료성 제품에서 허용 불가.
  - Figma 18_확인어려움 화면 처리를 별도 플래그로 관리해야 해 코드가 지저분해진다.
  - PRD v1 D 결정사항과 어긋난다.
- 비용·복잡도: 낮음. 단, 의료성 리스크 높음.

---

### 인증: Option A — 카카오 단독 + JWT + Mock-우선 (채택)

- 장점:
  - 국내 20~30대 타깃 커버리지와 가입 전환율이 카카오가 가장 높다(PRD v1 D2 근거).
  - 소셜 로그인 1종만 유지하면 약관·동의이력·계정삭제 플로우가 단순해진다.
  - Mock 인증 provider를 Riverpod override로 주입하면 서버 API 미완성 주간에도 UI 전체를 선개발·테스트할 수 있다(ADR-0001 Mock-우선 전략의 직접 적용).
  - JWT를 앱 로컬(secure storage)에 보관하고 refresh 로직만 구현하면 서버 인증과 연결이 최소 작업으로 완성된다.
- 단점: 카카오 SDK 의존성 추가, iOS App Store 심사 시 카카오 로그인 단독은 Apple 정책(자체 계정 생성 경로 필요) 위반 소지. → 계정 삭제 + 개인정보 약관 진입점으로 Apple 심사 요건 충족 확인 필요.
- 비용·복잡도: 중. 카카오 SDK 초기 셋업 비용 있음.

### 인증: Option B — 카카오 + 애플 로그인 동시 지원

- 장점: Apple 심사 정책 대응이 명확해진다.
- 단점:
  - 개발 공수 2배(Apple Sign-In 추가), Flutter 1인 체제에서 W1 과부하.
  - PRD v1 D2에서 애플 제외가 명시적으로 확정됐다.
  - 베타 50명 국내 클로즈드 단계에서 Apple 로그인 필요성이 낮다.
- 비용·복잡도: 높음.

### 인증: Option C — 자체 이메일/비밀번호 인증

- 장점: 서드파티 SDK 불필요.
- 단점: 회원 관리·비밀번호 찾기·보안 책임 전부를 자체 백엔드가 져야 한다. 5주 MVP 공수 내 완성 불가.
- 비용·복잡도: 매우 높음.

## 3. 선택 근거

선택: **판정 모델 Option A(4상태) + 인증 Option A(카카오 단독 + JWT + Mock-우선)**

근거:
- PRD v1 D2(카카오 단독), D3(F4 in-app MVP) 확정 결정을 그대로 반영한다.
- `unknown` 상태는 의료성 제품의 "단정 금지" 요건을 타입 시스템 레벨에서 보장한다. Dart `sealed class` 또는 `enum`으로 exhaustive switch를 강제하면 UI가 `unknown` 처리를 누락할 수 없다.
- Mock-우선 인증은 ADR-0001의 provider override 전략을 인증 도메인에 적용한 것이다. 서버 JWT API 완성 전에도 온보딩·판정·기록 화면을 독립적으로 개발할 수 있다.

## 4. VerdictCard 3섹션 구조

PRD v1 §3 F2 결과 카드 구조를 ADR 수준에서 확정한다.

```
VerdictCard
├── Section 1: 일반 분석 (공통 정보)
│     음식 특성·GERD 영향 설명 (reason_general)
├── Section 2: 개인화 맞춤 분석 (회원님 기반)
│     트리거·알레르기 매치 결과 (reason_personal)
│     health_profile repository 데이터 참조
└── Section 3: 이 음식 섭취 후 기록 (N건)
      과거 섭취 후 증상 히스토리 + 평균 (history_summary)
      모두 보기 → meal_log 피처 연결
```

- `caution` · `danger` 상태에만 대체 음식 1~3개(`alternatives[]`) 추가 노출.
- 모든 verdict 화면에 `MedicalDisclaimer` 위젯 노출 (app-level 공통 컴포넌트).
- `unknown` 상태: Section 1·2 대신 "확인이 어려워요" 메시지 + 면책 고지만 표시.

## 5. 위험·전제

**위험**:
- Apple App Store 심사 시 카카오 단독 로그인이 Apple의 "자체 계정 생성 경로 제공" 정책과 충돌할 수 있다. 베타는 TestFlight(심사 불필요)이므로 출시 전 결정.
- LLM 신뢰도 임계값이 서버 로직에 의존한다. 클라이언트는 서버 응답의 `signal` 필드 값을 신뢰하고 `unknown`을 폴백으로 처리한다. 임계값 조정은 서버측 결정.
- `unknown` 상태 카피(UX라이팅)는 PRD v1 요건에 따라 PO 출시 전 검수 필수.

**전제**:
- 서버 `POST /v1/foods/analyze` 응답에 `signal` 필드가 `recommend | caution | danger | unknown` 4값 중 하나로 반환된다.
- 카카오 SDK는 Flutter용 `kakao_flutter_sdk_user` 패키지로 통합 가능하다.
- Mock 인증은 Riverpod `AuthRepository` 인터페이스 override로 구현되며, 실 카카오 JWT 구현 시 인터페이스 불변.

**전제 깨짐 신호**: 서버가 `signal`에 4값 외 다른 값을 반환하기 시작하면 API 계약 재합의 필요. Apple 심사 리젝션 시 Apple Sign-In 추가 검토.

## 6. 후속 액션

- [ ] `lib/features/food_check/domain/entities/eat_verdict.dart` — `EatVerdict` sealed class 또는 enum(4상태) 정의
- [ ] `VerdictCard` 위젯 — 3섹션 구조 + `unknown` 분기 + `MedicalDisclaimer` 포함
- [x] `AuthRepository` 인터페이스 정의 + Mock impl (W1 #4, Riverpod override) — 완료
- [ ] 실 카카오 JWT AuthRepository 구현 (서버 인증 API 확정 시, W1 말 또는 W2)
- [ ] Apple App Store 심사 대응 (출시 직전) — 부록 §7
- [ ] 로그인 버튼 실 SDK + 공식 Apple 위젯 교체 (출시 전, 디자이너 재디자인 반영) — 부록 §7

## 7. 부록 (2026-05-30): 로그인 버튼 컴플라이언스 + 플랫폼 분기

W1 #4 구현 중 확정. 상세 출처: `docs/compliance/login-button-compliance.md`.
- **플랫폼 분기**: iOS = 카카오 + Apple(4.8 충족), Android = 카카오 단독(Apple 숨김). 구현은 `defaultTargetPlatform` 분기.
- **Apple 4.8**: 제3자 소셜 로그인(카카오)만 제공 시 App Store 리젝 위험 → 정식 출시 전 Sign in with Apple 동반 필수. **TestFlight 비공개 베타는 허용**(W1은 베타 단계).
- **버튼 출시 블로커**: Apple 버튼은 공식 위젯(`ASAuthorizationAppleIDButton` / `sign_in_with_apple`) + 승인 문구("Apple로 계속하기")로 교체, 카카오 공식 심볼 확인. W1은 디자인 토큰 기반 placeholder(디자이너 재디자인 진행 중, Figma 코멘트 전달 완료).
- **계정 삭제(5.1.1(v))**: 02a 삭제유예 복구 + 계정삭제 화면으로 충족 예정.

---

> 이 ADR 형식은 architect 에이전트의 표준 출력 구조(핸드북 §6.2)를 따른다.
> ① 의사결정 요약 ② 옵션 비교 ③ 선택 근거 ④ 위험·전제 ⑤ 후속 액션.
