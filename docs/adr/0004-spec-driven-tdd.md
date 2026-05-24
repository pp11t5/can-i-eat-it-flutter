# ADR-0004: 스펙 주도 TDD — Red-Green-Refactor 방법론

- **Status**: Accepted
- **Date**: 2026-05-24
- **Decider(s)**: 프로젝트 팀

## 1. 의사결정 요약

"먹어도 돼?" Flutter 클라이언트의 개발 방법론으로 **스펙 주도 TDD(Red-Green-Refactor)** 를 채택한다. Figma Description Note·기능명세서·API 계약을 **한국어 행위서술 Dart 테스트**로 번역해 스펙을 실행 가능한 형태로 고정하고, 레이어별로 검증 강도를 달리 적용한다. 8-에이전트 흐름에서는 test-writer(Red) → implementer(Green) → refactorer(Refactor) 순서로 역할을 분담한다.

## 2. 옵션 비교 (최소 2개)

### Option A: 스펙 주도 TDD — 한국어 행위서술 Dart 테스트 (채택)

- 방식: Figma Description Note·PRD·API 계약을 `group` / `test` + given-when-then 본문으로 번역. 추가 BDD 프레임워크 미도입.
- 장점:
  - 테스트 이름이 곧 실행 가능한 명세가 되어 별도 스펙 문서와 코드 간 드리프트가 없다.
  - 한국어로 작성하면 PO·디자이너도 테스트 이름만 보고 의도를 검증할 수 있다.
  - 추가 도구 없이 Flutter SDK 기본 `test` 패키지만으로 완결된다.
  - repository 계약 스위트 패턴을 적용하면 Mock impl과 retrofit impl이 동일 테스트를 통과해야 하므로, 서버 지연 중에도 계약이 고정된다.
- 단점: 한국어 테스트 이름 컨벤션을 팀이 일관되게 유지해야 한다(초기 규칙 합의 비용).
- 비용·복잡도: 낮음. 기존 `test/food_repository_impl_test.dart` 스타일을 확장.

### Option B: Gherkin / flutter_gherkin BDD 도구 도입

- 방식: `.feature` 파일에 Given-When-Then을 Gherkin 문법으로 작성, 코드 생성으로 step 연결.
- 장점: 비개발자가 직접 시나리오를 작성할 수 있다.
- 단점:
  - `flutter_gherkin` 패키지가 Flutter 통합 테스트에 특화돼 단위·위젯 레벨 적용이 어색하다.
  - step 파일 + feature 파일 + 구현 코드를 세 곳에서 동기화해야 해 오히려 드리프트가 생긴다.
  - 5주 MVP 공수에서 도구 학습 비용이 과도하다.
- 비용·복잡도: 높음.

### Option C: 테스트 없이 구현 후 QA

- 방식: 기능 구현 완료 후 수동 QA·버그픽스.
- 장점: 초기 개발 속도가 빠르다.
- 단점:
  - 의료성 판정 로직(EatVerdict 계산·GERD 룰셋)의 회귀를 잡을 안전망이 없다. 잦은 기획 변경이 있는 5주 MVP에서 회귀 비용이 더 크다.
  - repository 계약이 코드로 고정되지 않아 서버 API 변경 시 사이드이펙트 파악이 어렵다.
- 비용·복잡도: 초기 낮음, 장기 매우 높음.

## 3. 선택 근거

선택: **Option A (스펙 주도 TDD, 한국어 행위서술 Dart 테스트)**

근거:
- "먹어도 돼?"는 판정 결과가 의료성 정보이므로 판정 로직의 정확도·회귀 방지가 제품 요건이다(PRD v1 §2 규제 가드레일). 테스트가 없으면 매주 기획 변경 시 판정 룰셋이 조용히 깨질 수 있다.
- 서버 API가 매주 갱신되는 초안 단계에서 repository 계약 스위트는 Mock impl과 실 impl을 같은 테스트로 묶어 "서버가 늦어도 계약은 고정"되게 한다.
- 추가 BDD 프레임워크를 도입하지 않음으로써 Flutter 1인 체제의 공수 부담을 최소화한다.

## 4. 레이어별 검증 강도

### 로직 레이어 — 엄격 RGR (기본값 `[TDD]`)

대상: domain 판정 룰(EatVerdict 계산·GERD 룰셋), repository 계약, Riverpod 컨트롤러 상태 전이.

적용 순서:
1. **Red**: test-writer가 실패하는 스펙 테스트 작성 (한국어 행위서술, given-when-then)
2. **Green**: implementer가 테스트를 통과하는 최소 구현
3. **Refactor**: refactorer가 테스트 green을 유지하면서 코드를 정리

```dart
// 예: EatVerdict 계산 테스트 (한국어 행위서술)
group('EatVerdict — GERD 룰셋', () {
  test('카페인이 포함된 음식은 트리거 매치 시 danger를 반환한다', () {
    // given
    final profile = HealthProfile(triggers: [Trigger.caffeine]);
    final food = Food(category: FoodCategory.caffeinated);
    // when
    final verdict = VerdictCalculator.calculate(food, profile);
    // then
    expect(verdict, EatVerdict.danger);
  });

  test('신뢰도가 임계값 미만이면 unknown을 반환한다', () {
    // given
    final response = AnalyzeResponse(confidence: 0.4, signal: 'unknown');
    // when
    final verdict = EatVerdict.fromSignal(response.signal);
    // then
    expect(verdict, EatVerdict.unknown);
  });
});
```

### UI 레이어 — 행위·골든 테스트 (`[Review]`)

대상: 위젯/화면 상태 전이, 면책 고지 노출 여부, VerdictCard verdict별 렌더링.

- 상태 전이 테스트: `WidgetTester`로 탭/입력 → 예상 위젯 노출 확인.
- 골든 테스트: VerdictCard 4종(recommend·caution·danger·unknown)을 골든 이미지로 고정해 디자인 토큰 교체 시 의도치 않은 시각 변경을 검출.
- test-first를 강제하지 않음(레이아웃 소스는 Figma). 구현 후 행위 테스트·골든 생성.

## 5. Repository 계약 스위트 패턴

핵심 패턴: repository 인터페이스를 대상으로 작성된 테스트를 Mock impl과 retrofit impl이 **동일하게 통과**해야 한다.

```dart
// 계약 스위트 — FoodRepository 인터페이스 기준
void runFoodRepositoryContractTests(FoodRepository repo) {
  group('FoodRepository 계약', () {
    test('음식 분석 결과는 EatVerdict 4상태 중 하나를 반환한다', () async {
      final result = await repo.analyze('된장찌개');
      expect(EatVerdict.values, contains(result.verdict));
    });

    test('신뢰도 미달 시 unknown verdict를 반환한다', () async {
      // Mock impl은 저신뢰도 시나리오를 주입해 검증
    });
  });
}

// Mock impl 검증
void main() => runFoodRepositoryContractTests(MockFoodRepository());

// 미래 retrofit impl 검증 (서버 API 확정 시)
// void main() => runFoodRepositoryContractTests(RetrofitFoodRepository(...));
```

## 6. 위험·전제

**위험**:
- 골든 테스트 이미지가 CI 환경(렌더링 엔진)과 로컬 환경에서 픽셀 차이로 불일치할 수 있다 → CI에서 골든 생성·비교를 동일 Docker 이미지로 고정.
- 테스트 이름을 한국어로 쓰면 터미널 출력 깨짐 가능 → UTF-8 환경 설정 확인.
- test-writer·implementer·refactorer가 순서를 지키지 않고 구현을 먼저 하면 Red 단계가 의미를 잃는다 → 이슈 라벨 `[TDD]`가 붙은 이슈는 반드시 Red 테스트 PR이 먼저 머지되어야 Green PR이 열리도록 GitHub issue 체크리스트로 관리.

**전제**:
- 판정 로직이 클라이언트에서 일부 계산 가능하다(GERD 룰셋 후처리 로직 포함). 서버가 `signal`을 완전히 결정하면 클라이언트 로직 테스트 범위가 줄고, repository 계약 스위트가 주된 단위 테스트 대상이 된다.
- `flutter test`가 CI 게이트에서 실행된다(ADR-0001 후속 액션, W1 infra epic).

**전제 깨짐 신호**: CI 테스트 실행 시간이 5분을 초과하기 시작하면 테스트 분리(unit/integration 레이어 분리)를 검토한다.

## 7. 후속 액션

- [ ] W1: `test/` 디렉토리 구조 정의 — `unit/` (domain·repository) / `widget/` / `golden/`
- [ ] W1: `runFoodRepositoryContractTests` 계약 스위트 템플릿 작성
- [ ] W1: CI에 `flutter test` 게이트 추가 (infra epic)
- [ ] W2~W3: EatVerdict 계산·GERD 룰셋 Red 테스트 작성 (test-writer), Green 구현 (implementer)
- [ ] W3: VerdictCard 4종 골든 이미지 생성 및 CI 등록
- [ ] 이슈 라벨 `tdd`·`review`·`none` 운영 규칙 README 기록

---

> 이 ADR 형식은 architect 에이전트의 표준 출력 구조(핸드북 §6.2)를 따른다.
> ① 의사결정 요약 ② 옵션 비교 ③ 선택 근거 ④ 위험·전제 ⑤ 후속 액션.
