# 디자인 시스템 — 3층 토큰 구조 · 컴포넌트 인벤토리

> 근거: ADR-0005 (design-system-strategy) · PRD v1 §공통 인프라

## 목적

Figma 완성 GUI가 도착하기 전 **Provisional(잠정) 값**으로 개발을 진행한 뒤, 완성 시 primitive 파일만 교체해 전체 UI에 반영하는 구조다. 원시값 하드코딩을 방지해 토큰 교체 비용을 최소화한다.

---

## 3층 토큰 구조

```
Primitive (원시값)          lib/app/theme/tokens/primitives.dart
    ↓ 의미 부여
Semantic (의미 토큰)        lib/app/theme/tokens/semantic.dart
    ↓ Flutter 바인딩
ThemeData / AppTheme        lib/app/theme/app_theme.dart
```

### Primitive 레이어

색·크기·간격·타이포의 원시값만 보유. Figma 완성 시 **이 파일만 교체**하면 전체 적용.

```
예시 키:
  ColorPrimitives.green500
  ColorPrimitives.yellow400
  ColorPrimitives.red500
  SpacingPrimitives.s4, s8, s12, s16, s24
  TypographyPrimitives.bodyMd, titleLg
```

### Semantic 레이어

의미 기반 별칭. primitive를 참조하며 절대값 직접 기재 금지.

```
예시 키:
  AppColors.verdictSafe      → ColorPrimitives.green500
  AppColors.verdictCaution   → ColorPrimitives.yellow400
  AppColors.verdictDanger    → ColorPrimitives.red500
  AppColors.verdictUnknown   → ColorPrimitives.grey400
  AppColors.surface          → ColorPrimitives.white
  AppSpacing.cardPadding     → SpacingPrimitives.s16
```

### ThemeData / AppTheme 레이어

Flutter `MaterialApp` 에 주입하는 최종 바인딩. semantic 토큰 참조.

---

## 컴포넌트 인벤토리

| 컴포넌트 | 위치 | 설명 |
|---|---|---|
| `MedicalDisclaimer` | `lib/app/widgets/medical_disclaimer.dart` | 전 결과 화면 노출 필수. "본 앱은 진단·치료 서비스가 아닙니다" |
| `VerdictBadge` | `lib/app/widgets/verdict_badge.dart` | 신호등 4상태 뱃지 (색·아이콘·라벨) |
| `VerdictCard` | `lib/features/food_check/presentation/widgets/` | 결과 카드 3섹션(일반분석/개인화맞춤/이 음식 섭취후 기록) |
| `SignalLightDot` | `lib/app/widgets/signal_light_dot.dart` | 🟢🟡🔴 인라인 표시용 |
| `AppBottomNav` | `lib/app/widgets/app_bottom_nav.dart` | 바텀 네비 셸 |
| `ProgressStepper` | `lib/app/widgets/progress_stepper.dart` | 온보딩 N/4 인디케이터 |

> 추가 컴포넌트는 2회 이상 반복될 때 `lib/app/widgets/`로 승격. 1회 사용은 해당 피처 폴더 내 유지.

---

## Figma 토큰 추출 절차

1. Figma Framelink MCP로 대상 화면 레이아웃·토큰 조회
2. 색·간격·타이포 값을 `primitives.dart`에 기록
3. `semantic.dart`에서 의미 별칭 연결
4. `app_theme.dart` ThemeData 갱신
5. 컴포넌트 골든 테스트로 변경 diff 검수

완성 GUI 도착 시: **`primitives.dart`만 교체** → semantic/theme는 자동 연동.

---

## 하드코딩 금지 규약

- `Color(0xFF...)`, `EdgeInsets.all(16)` 등 원시값을 위젯 코드에 직접 쓰지 않는다.
- 모든 색은 `AppColors.*`, 간격은 `AppSpacing.*`, 타이포는 `AppTextStyles.*` 경유.
- PR 리뷰 체크리스트 항목으로 포함. (custom_lint 규칙 추가 시 ADR-0005 갱신)

---

## Provisional(잠정) 값 운영

와이어프레임 Figma(`DEFNKWPwiIBFDqJv423n39`, node `13:2`) 기반 seed 값으로 개발을 진행한다. 완성 GUI (`node 82:178` "온보딩(완료)" 섹션 기준)가 도착하면 primitive 레이어만 교체한다.

잠정 값에는 코드 주석 `// provisional` 을 달아 추후 교체 대상임을 명시한다.

---

## W1 선행 작업

PRD v1 §공통 인프라에서 디자인 시스템을 P0·W1 선행으로 지정. W1 구현 대상:
- 컬러·타이포·아이콘·신호등 컴포넌트를 토큰으로 제공
- 골든 테스트로 토큰 교체 diff 검수 체계 확보
