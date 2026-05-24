# 주간 개발 워크플로우 — 초안 기획 대응

기획(Notion)·디자인(Figma)·서버 API가 **매주 갱신**되는 초안 단계 제품이다. 이 문서는 매주 반복하는 클라이언트 개발 루프를 정의한다. 단일 진실의 원천은 항상 Notion(기획)과 Figma(디자인)이며, 코드/문서는 그 파생물이다.

## 매주 반복 루프

1. **기획 조회 (Notion MCP)**
   - Claude Code 세션에서 Notion MCP로 이번 주 기획 페이지/DB를 조회한다. 복사-붙여넣기로 옮기지 말고 매번 실시간 조회해 드리프트를 막는다.
   - 변경된 요구사항을 이슈 단위로 분해한다. 각 이슈에 검증 라벨 `[TDD] / [Review] / [None]` 부여 (`.claude/skills/test-strategy-routing/SKILL.md`).

2. **디자인 컨텍스트 추출 (Figma Framelink MCP)**
   - 대상 화면의 Figma 링크로 레이아웃/디자인 토큰(색·간격·타이포)을 추출한다.
   - Framelink는 **코드가 아니라 디자인 컨텍스트**를 준다. React 코드 생성을 기대하지 말고, 토큰·계층을 Flutter 위젯(`Column/Row/Padding/ThemeData`)으로 옮긴다.
   - 반복되는 토큰은 `lib/app/theme/app_theme.dart`에 흡수한다.

3. **구조 영향 판단 (필요 시 architect + ADR)**
   - 비가역적/구조적 결정(새 레이어, 라우팅 구조 변경, API 계약 변경)이면 `architect`에 위임하고 `docs/adr/`에 ADR을 남긴다.
   - 단순 기능 추가면 이 단계를 건너뛴다.

4. **피처별 구현 (implementer)**
   - 변경을 해당 `features/<feature>/` 내부로 격리한다. 서버 API 변경은 `core/network` + 그 피처의 `data` 레이어에만 반영한다.
   - 위임 시 4요소(의도/제약/완료 기준/관련 파일)를 항상 명시한다.

5. **테스트 (test-writer)**
   - `[TDD]`/`[Review]` 라벨이 붙은 이슈는 테스트를 작성/갱신한다. 판별 로직(EatVerdict 계산)은 우선 단위 테스트 대상.

6. **리뷰 (pr-reviewer)**
   - 보안·핵심·아키텍처 영향이 있는 변경만 `pr-reviewer`로 보낸다. 스타일/린트는 `flutter analyze` + `riverpod_lint`가 담당.

## 서버 API가 아직 안 나온 주

- 피처 `data` 레이어의 repository 인터페이스만 먼저 정의하고, Riverpod provider override로 **목(mock) 데이터소스**를 주입해 UI를 선개발한다.
- 실제 API 확정 시 retrofit 데이터소스 구현만 교체한다(인터페이스 불변).

## 의료성 제품 주의

- 모든 판별 결과 화면에는 **면책 고지**와 **근거 출처**를 함께 노출한다(도메인·UI 설계의 기본 요건). 자가 진단 대체가 아님을 명시.
