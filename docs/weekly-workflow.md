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

4. **피처별 구현 — 이슈 라벨에 따라 RGR 흐름 분기**

   이슈 분해 시 각 이슈에 `[TDD]` / `[Review]` / `[None]` 라벨을 부여한다(`.claude/skills/test-strategy-routing/SKILL.md`).

   #### `[TDD]` 이슈 — Red-Green-Refactor 전체 흐름
   로직 레이어(domain 판정 룰·repository 계약·Riverpod 컨트롤러 상태)에 기본 적용한다.

   1. **test-writer → Red**: 아직 통과하지 않는 실패 스펙 테스트를 작성한다. 테스트 이름은 한국어 행위서술(`given-when-then` 본문). PR을 먼저 머지한 뒤 다음 단계를 연다.
   2. **implementer → Green**: 테스트를 통과하는 최소 구현을 작성한다. 변경을 해당 `features/<feature>/` 내부로 격리하고, 서버 API 변경은 `core/network` + 그 피처의 `data` 레이어에만 반영한다. 위임 시 4요소(의도/제약/완료 기준/관련 파일)를 항상 명시한다.
   3. **refactorer → Refactor**: 모든 테스트가 green인 상태를 유지하면서 코드를 정리한다. 행위 변경 없이 구조·가독성만 개선한다.

   #### `[Review]` 이슈 — Red 없이 implementer 직접 구현
   UI 레이어(위젯·화면 레이아웃)처럼 test-first가 비효율적인 영역에 적용한다. implementer가 직접 구현한 뒤, 행위 테스트·골든 테스트를 추가하고 pr-reviewer(핵심·보안 영향 시)로 보낸다.

   #### `[None]` 이슈 — implementer 직접 구현, 테스트 없음
   설정 파일·문서·린트 규칙 등 테스트 대상이 아닌 변경에 한정한다. 남용하지 않는다.

5. **리뷰 (pr-reviewer)**
   - 보안·핵심·아키텍처 영향이 있는 변경만 `pr-reviewer`로 보낸다. 스타일/린트는 `flutter analyze` + `riverpod_lint`가 담당.

## 서버 API가 아직 안 나온 주

- 피처 `data` 레이어의 repository 인터페이스만 먼저 정의하고, Riverpod provider override로 **목(mock) 데이터소스**를 주입해 UI를 선개발한다.
- 실제 API 확정 시 retrofit 데이터소스 구현만 교체한다(인터페이스 불변).

## 의료성 제품 주의

- 모든 판별 결과 화면에는 **면책 고지**와 **근거 출처**를 함께 노출한다(도메인·UI 설계의 기본 요건). 자가 진단 대체가 아님을 명시.
