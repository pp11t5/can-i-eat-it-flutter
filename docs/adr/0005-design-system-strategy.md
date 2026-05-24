# ADR-0005: 디자인 시스템 선구축 전략 — 3층 토큰 + 골든 검수 + 하드코딩 금지

- **Status**: Accepted
- **Date**: 2026-05-24
- **Decider(s)**: 프로젝트 팀

## 1. 의사결정 요약

디자이너의 완성 GUI 확정 전이라도 **3층 토큰 구조**(primitive → semantic → ThemeData)를 W1에 먼저 구축하고, 와이어프레임 Figma에서 추출한 **provisional(임시) 값**으로 seed한다. 디자이너 완성 시 **primitive 파일만 교체**하면 semantic·ThemeData가 자동으로 반영되도록 설계한다. 원시값 하드코딩을 금지하는 가드레일과 VerdictCard 등 핵심 컴포넌트의 골든 테스트로 토큰 교체 diff를 검수한다.

## 2. 옵션 비교 (최소 2개)

### Option A: 3층 토큰 선구축 + provisional seed (채택)

- 구조:
  - Layer 1 (Primitive): `app_colors.dart`, `app_typography.dart`, `app_spacing.dart` — 원시값 정의. 와이어프레임 추출 provisional 값으로 초기화.
  - Layer 2 (Semantic): `app_semantic_colors.dart` — primitive를 의미 단위로 매핑 (`colorVerdictRecommend = AppColors.green500` 등).
  - Layer 3 (ThemeData): `app_theme.dart` — semantic을 `ThemeData`·`ColorScheme`·`TextTheme`으로 조립.
- 장점:
  - 디자이너 완성본 도착 시 primitive 파일 값만 교체하면 전체 앱에 즉시 반영된다. 교체 범위가 파일 1개로 제한돼 회귀 위험이 낮다.
  - semantic 레이어가 "이 색이 어디에 쓰이는가"를 코드로 표현하므로, 개발자가 올바른 토큰을 선택하기 쉽다.
  - W1부터 토큰을 쓰면 이후 모든 피처가 처음부터 하드코딩 없이 개발된다. 나중에 일괄 교체하는 리팩토링 비용이 없다.
  - provisional 값이 있으므로 UI 선개발 시 빈 화면을 방지한다.
- 단점: W1에 토큰 구조 설계 시간이 필요하다. 와이어프레임 추출 값이 완성 GUI와 다를 수 있다.
- 비용·복잡도: 중. 초기 설계 비용이 있지만 이후 피처마다 절약된다.

### Option B: 디자이너 완성 후 토큰 구축

- 방식: UI 구현 시 `Color(0xFFXXXXXX)` 등 원시값을 직접 사용하다가, 완성 GUI 도착 시 일괄 교체.
- 장점: 초기 설계 비용 없음.
- 단점:
  - 하드코딩된 원시값이 전체 코드베이스에 분산된다. 교체 시 누락이 발생하고, 완성 GUI 색상이 미묘하게 다를 경우 수십 곳을 찾아 바꿔야 한다.
  - 디자이너 완성본 도착이 늦으면 피처 구현이 멈추거나 값 두 벌이 공존한다.
  - 클라이언트 −1주 로드맵(디자이너 W1 = 2026-05-18, 클라이언트 W1 = 2026-05-25)에서 디자이너 완성본은 클라이언트보다 1주 앞서므로 대기 없이 교체 가능하다고 보이나, 실제로는 화면별로 완성 순서가 다르다.
- 비용·복잡도: 초기 낮음, 교체 시 높음.

### Option C: Flutter MaterialDesign 기본 ThemeData만 사용

- 방식: 커스텀 토큰 없이 `Theme.of(context).colorScheme` 기본값 사용.
- 장점: 설계 비용 없음.
- 단점: 신호등(EatVerdict) 색상, VerdictCard 배경색 등 도메인 고유 색상을 표현할 방법이 없다. 결국 Extension이나 하드코딩이 필연적으로 발생한다.
- 비용·복잡도: 낮음. 단, "먹어도 돼?" 도메인 요건을 충족 불가.

## 3. 선택 근거

선택: **Option A (3층 토큰 선구축 + provisional seed)**

근거:
- 클라이언트 −1주 로드맵에서 디자이너 완성본이 화면별로 순차 도착한다. provisional seed로 선구축해두면 도착 즉시 primitive만 교체하고 개발을 계속할 수 있다.
- EatVerdict 신호등 4색(권장·주의·위험·확인어려움), VerdictCard 배경, MedicalDisclaimer 강조색 등 도메인 고유 semantic 색상이 다수 존재한다. semantic 레이어 없이는 이를 일관되게 관리할 수 없다.
- Figma Framelink MCP로 와이어프레임 토큰을 추출하면 provisional seed의 정확도가 충분히 높다(CLAUDE.md MCP 사용 규약).
- W1에 선구축하면 이후 W2~W4 피처 구현이 처음부터 토큰을 사용하게 되어, 나중의 일괄 교체 리팩토링 이슈가 발생하지 않는다.

## 4. 토큰 구조 상세

### 파일 레이아웃

```
lib/app/theme/
  tokens/
    app_colors.dart          # Layer 1: 원시 색상 팔레트 (provisional → 완성본 교체 대상)
    app_typography.dart      # Layer 1: 폰트 패밀리·사이즈·웨이트
    app_spacing.dart         # Layer 1: 여백·반경 스케일
  app_semantic_colors.dart   # Layer 2: 의미 단위 매핑
  app_theme.dart             # Layer 3: ThemeData + ColorScheme + TextTheme 조립
```

### Semantic 색상 예시 (도메인 고유)

```dart
// app_semantic_colors.dart
abstract class AppSemanticColors {
  // 신호등 EatVerdict
  static const verdictRecommend = AppColors.green500;    // 권장
  static const verdictCaution   = AppColors.yellow400;   // 주의
  static const verdictDanger    = AppColors.red500;      // 위험
  static const verdictUnknown   = AppColors.gray400;     // 확인어려움

  // 공통 UI
  static const surfacePrimary   = AppColors.white;
  static const textPrimary      = AppColors.gray900;
  static const disclaimerBg     = AppColors.yellow50;    // MedicalDisclaimer 배경
}
```

### 컴포넌트 레이어

도메인 고유 컴포넌트는 semantic 토큰을 직접 참조한다:

```
lib/app/widgets/
  verdict_card.dart          # EatVerdict 4상태 × 3섹션
  medical_disclaimer.dart    # 면책 고지 (전 결과화면 공통)
  verdict_badge.dart         # 신호등 배지 (색상·텍스트)
```

## 5. 하드코딩 금지 가드레일

**규칙**: `Color(0xFFXXXXXX)`, `FontSize(14)` 등 원시값을 위젯 코드에 직접 쓰지 않는다. 반드시 `AppSemanticColors.*` 또는 `AppSpacing.*`을 경유한다.

**강제 수단**:
1. PR 체크리스트 항목 — "원시 색상값 직접 사용 없음" 체크 (pr-reviewer 리뷰 시 확인).
2. `custom_lint` 규칙 추가 가능 — `avoid_hardcoded_colors` (riverpod_lint와 동일 체인). W1 infra epic에서 검토.
3. CI `flutter analyze` — custom_lint 규칙이 추가되면 빌드 게이트에서 차단.

## 6. 골든 테스트 검수

디자인 토큰 교체(primitive 파일 교체) 시 VerdictCard 등 핵심 컴포넌트의 시각적 변경을 의도치 않은 회귀와 구별하기 위해 골든 테스트를 운영한다.

- VerdictCard 4종(recommend·caution·danger·unknown) 골든 이미지 유지.
- primitive 교체 PR에서 골든 diff를 PR 코멘트에 첨부해 디자이너 확인 후 업데이트.
- `flutter test --update-goldens`는 의도적 교체 시에만 실행. 실수 실행을 방지하기 위해 Makefile 타깃 또는 GitHub Action input으로 분리.

## 7. Figma → primitive 교체 절차

1. Figma Framelink MCP로 완성 GUI 섹션(node `82:178` "온보딩(완료)" 기준) 토큰 추출.
2. `app_colors.dart` · `app_typography.dart` · `app_spacing.dart`의 provisional 값을 완성값으로 교체.
3. `flutter test`로 골든 diff 확인 → 의도된 변경이면 `--update-goldens` 실행.
4. `flutter analyze` 통과 확인 후 PR.

## 8. 위험·전제

**위험**:
- provisional 값이 완성 GUI와 크게 달라 semantic 매핑 구조 자체를 바꿔야 할 수 있다 → semantic 이름을 색상 원시값이 아닌 **의미**로 짓는다(`verdictRecommend`, `surfacePrimary` 등). 값이 바뀌어도 이름은 유지.
- 골든 이미지를 CI 환경에서 생성하지 않으면 로컬 환경 차이로 허위 실패가 발생한다 → CI에서 최초 골든 생성 및 비교를 동일 runner로 고정.
- `custom_lint` 하드코딩 금지 규칙이 없으면 PR 체크리스트만으로 강제가 약하다 → W1 infra epic에서 구현 가능성 평가 후 결정.

**전제**:
- Figma Framelink MCP가 와이어프레임(node `13:2`)과 완성 GUI(node `82:178`)를 모두 접근 가능하다.
- 디자이너 완성본은 화면별로 순차 도착하고, 클라이언트는 provisional 값으로 선개발 후 교체한다.
- 모든 신규 위젯은 AppSemanticColors를 임포트해서 작성한다.

**전제 깨짐 신호**: primitive 파일 교체 후 앱 전체가 아닌 특정 위젯만 색이 바뀌지 않으면 하드코딩 누락이 있다는 신호다 → `Grep`으로 `Color(0xFF` 패턴 전수 검사.

## 9. 후속 액션

- [ ] W1: `lib/app/theme/tokens/` 디렉토리 + provisional 값으로 3층 토큰 파일 생성 (Figma 와이어프레임 추출)
- [ ] W1: `AppSemanticColors` — EatVerdict 4색 포함 semantic 매핑 정의
- [ ] W1: `VerdictCard` · `MedicalDisclaimer` · `VerdictBadge` 컴포넌트 골격 작성
- [ ] W1: VerdictCard 4종 골든 이미지 초기 생성 + CI 등록
- [ ] W1: PR 체크리스트에 "원시 색상값 직접 사용 없음" 항목 추가
- [ ] W1 infra epic: `custom_lint` `avoid_hardcoded_colors` 규칙 구현 가능성 평가
- [ ] 디자이너 완성 GUI 도착 시: primitive 교체 → 골든 diff 확인 → PR

---

> 이 ADR 형식은 architect 에이전트의 표준 출력 구조(핸드북 §6.2)를 따른다.
> ① 의사결정 요약 ② 옵션 비교 ③ 선택 근거 ④ 위험·전제 ⑤ 후속 액션.
