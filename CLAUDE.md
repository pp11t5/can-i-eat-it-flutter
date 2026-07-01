# CLAUDE.md — Standard Profile

이 프로젝트는 **8-에이전트 표준 서브에이전트 시스템**으로 운영된다. 마스터 세션은 오케스트레이션 전용이다.

## 마스터 세션의 절대 원칙

- **`/model` 교체 금지**. 마스터는 한 모델(Opus 4.8 권장, 2026-05 기준)을 유지한다. 모델 다양성은 서브에이전트의 `model` 필드로 표현한다.
- **마스터는 코드를 거의 짜지 않는다**. 마스터의 본업은 작업 분해·라우팅·결과 종합이다.
- **이 CLAUDE.md를 자주 수정하지 않는다**. 캐시 친화 유지가 비용 절감의 핵심.

## 8개 서브에이전트 요약

| 에이전트 | 모델 | effort | 쓰기 권한 | 핵심 용도 |
|---|---|---|---|---|
| architect | opus | high | × | 아키텍처·ADR·API 설계 (비가역 결정) |
| deep-debugger | opus | high | ✓ | race·메모리·heisenbug |
| pr-reviewer | opus | xhigh | × | 보안·핵심 PR 리뷰 |
| implementer | sonnet | — | ✓ | 명세 명확한 기능 구현 |
| refactorer | sonnet | — | ✓ | 동작 보존 리팩토링 |
| test-writer | sonnet | — | ✓ | 테스트 작성 |
| doc-writer | sonnet | — | ✓ | 사람이 읽을 문서 |
| explorer | haiku | — | × | 코드베이스 탐색 (거의 모든 첫 호출) |

## 라우팅 핵심 규칙

**마스터 직접 처리**:
- 한두 줄 답변, 빠른 사실 확인.
- 결과를 즉시 종합해야 하는 짧은 흐름.
- 위임 대상이 마땅치 않은 모호한 작업 (단, 명확화 후 위임이 원칙).

**위임**:
- 다단계 도구 호출이 필요한 작업.
- 결과가 길어 마스터 컨텍스트를 더럽힐 가능성.
- Opus급 깊은 추론이 필요한 단일 분야 작업.
- 같은 패턴을 반복할 가능성이 있는 작업.

세부 라우팅은 `.claude/skills/sub-agent-routing/SKILL.md`를 참조.

## 위임 명세 4요소 (이 템플릿을 항상 사용)

```
의도: [무엇을 왜]
제약: [지켜야 할 것 / 건드리면 안 될 것]
완료 기준: [무엇이 되면 끝인가]
관련 파일: [경로 목록 또는 "explorer로 먼저 확인"]
```

이 4요소가 빠지면 결과 품질이 즉각 떨어진다. Opus 4.8은 명령을 문자 그대로 따르므로 모호한 명세 = 좁은 결과.

## 검증 강도 라우팅 (이슈 분해 시)

이슈를 분해할 때 각 이슈에 `[TDD]` / `[Review]` / `[None]` 라벨을 부여한다. 세부는 `.claude/skills/test-strategy-routing/SKILL.md` 참조. sub-agent-routing과는 별개의 결정.

## 비용 함정 주의

- **`model: inherit` 사용 금지**. 새 에이전트를 추가할 때마다 `model` 필드를 명시했는지 확인. inherit은 마스터 모델을 그대로 상속해 비용 폭주의 주범.
- **모든 PR을 pr-reviewer로 보내지 않는다**. 스타일·린트는 도구 영역. pr-reviewer는 보안·핵심·아키텍처 영향에만.
- **서브에이전트끼리 협업을 기대하지 않는다**. 서브에이전트는 자식 서브에이전트를 만들 수 없다. 협업 흐름은 항상 마스터가 지휘.
- **단순 스택트레이스 버그를 deep-debugger로 보내지 않는다**. 그건 implementer의 일이다.

## 모델·effort 기준 (2026-07, Opus 4.8 + Sonnet 5)

- 기본 effort는 **high**. 비가역·보안 영역만 한 단계 올린다(pr-reviewer=xhigh). Opus 4.8 high ≈ Opus 4.7 xhigh 수준이라 대부분 high로 충분하고, max는 xhigh 대비 이득이 거의 없다(토큰 낭비).
- 신규 레버(필요 시에만, 기본 흐름은 8-에이전트 라우팅 유지):
  - **fast mode**($10/$50, 출력 2.5×): 비용이 아닌 *지연* 레버. 인터랙티브 멀티에이전트 루프용.
  - **dynamic workflows / ultracode**(리서치 프리뷰): 100s~1000s 서브에이전트 병렬. *대량 구조 변환* 보조용이며 architect/pr-reviewer의 비가역 설계·핵심 리뷰를 **대체하지 않는다**.
  - Opus 4.8 캐시 최소치 1,024토큰 — 짧은 프롬프트도 캐시된다.
- **Sonnet 5 반영(2026-06-30 출시)**: `model: sonnet` alias가 자동으로 Sonnet 5를 가리켜 에이전트 파일 무수정 승격. 가격 표준 $3/$15(2026-08-31까지 인트로 $2/$10). 새 토크나이저로 Sonnet 4.6 대비 ~30% 토큰↑ → 표시가 동일해도 Sonnet 작업 실비용이 오르니 토큰 예산·`max_tokens` 절단 위험 재점검. xhigh effort·적응형 추론 기본 ON을 새로 지원하지만, 정책상 Sonnet 에이전트엔 effort 필드 미부여(기본값 유지) — 어려운 작업만 호출 시점에 `effort: xhigh` 지정.
- 토큰 절감 운영 습관 (v0.3.0 §11.7·§11.8):
  - **도구 출력 컴팩션**: `flutter test`·`dart run build_runner`·`dart analyze`·`flutter build`·git 출력은 원시로 마스터에 붓지 않는다. 명령 단계에서 좁히고(`| tail -n 30`, `grep -E '(FAIL|Error|✗|warning)'`, `--reporter=compact` 등), 긴 로그는 explorer(Haiku)에 "실패 원인+위치만" 추출 위임. 같은 파일 통째 재독 회피.
  - **컨텍스트 위생**: 이 CLAUDE.md는 얇게 유지(매 세션 자동 로드). 무거운 산출물(대용량 로그·생성물)은 파일로 남기고 경로만 참조. 완료 작업 메모는 작업 컨텍스트에서 비운다.
  - 자동화가 필요할 만큼 코드베이스가 커지면 §14.3 MCP 후보 검토 — 단 내장 LSP·ast_grep로 충분한지 먼저 확인(본 저장소엔 둘 다 마운트됨).
- 불변: 8-에이전트 로스터, 3원칙(비가역→Opus / 일상→Sonnet / 대량→Haiku), 마스터 `/model` 교체 금지.

## 한국어 키워드 → 에이전트 매핑

| 한국어 표현 | 매핑 에이전트 |
|---|---|
| "설계해줘", "ADR 써줘", "트레이드오프" | architect |
| "race", "동시성", "메모리 누수", "이상한 버그" | deep-debugger |
| "리뷰해줘" + 보안/핵심 맥락 | pr-reviewer |
| "구현해줘", "기능 추가", "만들어줘", "고쳐줘" + 단순 맥락 | implementer |
| "리팩토링", "정리", "구조 개선" | refactorer |
| "테스트 작성", "테스트 추가", "단위 테스트" | test-writer |
| "문서 정리", "README 갱신", "주석 추가" | doc-writer |
| "어디 있어?", "찾아줘", "탐색", "구조 알려줘" | explorer |

## 호출 방법

- **자동 라우팅**: 사용자가 자연어로 요청하면 마스터가 description 키워드를 매칭해 서브에이전트 호출.
- **명시적 호출**: `@architect`, `@implementer` 형식으로 강제.
- **라우팅 스킬 강제**: "라우팅 스킬을 적용해 결정해라" 한 줄.

## 핸드북 참조

이 시스템의 단일 진실의 원천은 `HANDBOOK.md` (또는 템플릿 저장소의 동일 파일). 운영 중 의문이 들면 핸드북의 해당 절을 인용해 결정.

---

> 템플릿 v0.4.0 기반 (Opus 4.8 + Sonnet 5, 2026-07 Sonnet 5 반영: family alias 자동 승격 · 토크나이저 ~30% 주의).

---

# 프로젝트: 먹어도 돼? (Flutter 클라이언트)

## 도메인 한 줄 요약

역류성 식도염·위염 등 **기저질환 보유자**를 대상으로, 사용자의 질환 프로필 기준으로 특정 음식/성분이 악영향을 주는지 판별한다. 핵심 매핑: **사용자 질환 ↔ 음식/성분 ↔ 판별 결과(safe/caution/avoid + 근거)**. 의료성 정보이므로 정확도·면책 고지·근거 표기가 제품 요건.

## 기술 스택 (확정)

- 상태관리: **Riverpod** (riverpod_generator 코드 생성)
- 구조: **피처 우선(feature-first)** — `lib/features/<feature>/{data,domain,presentation}`
- 라우팅: **go_router** (`lib/app/router/app_router.dart`)
- 네트워킹: **dio** (`lib/core/network/`). retrofit은 서버 API 계약 확정 시 추가(현재 retrofit 4.9.x ↔ generator 9.7.x 비호환으로 보류, 목 repository 사용 중).
- 모델: **freezed + json_serializable**
- 코드 생성: **build_runner**
- 린트: **flutter_lints + custom_lint(riverpod_lint)**

## 레이어 규칙

- `lib/app/` — 앱 진입, MaterialApp.router, 라우터, 테마(디자인 토큰).
- `lib/core/` — 횡단 관심사(네트워크 클라이언트, 에러/Failure, 환경 설정). 공통화는 **2회 이상 반복될 때만**.
- `lib/features/<feature>/`
  - `domain/` — entity + repository **인터페이스** (프레임워크 비종속)
  - `data/` — DTO(freezed) + datasource(retrofit) + repository 구현
  - `presentation/` — screen + widget + controller(Riverpod provider)
- 변경 격리 원칙: 기능 변경은 해당 feature 내부에, **서버 API 변경은 `core/network` + 그 feature의 `data`** 에만 반영.

## 코드 생성 워크플로우

- freezed/riverpod/retrofit 애너테이션 추가·수정 후 반드시:
  `dart run build_runner build --delete-conflicting-outputs`
- 생성물(`*.freezed.dart`, `*.g.dart`)은 커밋한다(빌드 재현성). 손으로 수정 금지.

## MCP 사용 규약

- **Notion MCP**: 이번 주 기획 조회는 항상 Notion MCP로 실시간 조회. 복붙 금지(드리프트 방지). OAuth는 `/mcp`로 1회 인증.
- **Figma Framelink MCP**: 디자인 **토큰/레이아웃 추출** 용도. 코드(React) 생성을 기대하지 말고 토큰·계층을 Flutter 위젯으로 옮긴다. 반복 토큰은 `app/theme`로 흡수. `FIGMA_API_KEY`는 `.env`(비커밋)로 주입.
- 상세 주간 루프: `docs/weekly-workflow.md`.

## OMC 공존 메모

- 이 저장소에서는 **이 프로젝트 CLAUDE.md와 `.claude/agents/`(8개)가 1차 기준**이다.
- 전역 oh-my-claudecode(OMC)의 스킬(autopilot 등)·도구는 보조로 활용하되, 에이전트 라우팅 충돌 시 위 8-에이전트 표를 우선한다.

## 서버 API 미정 시

- repository **인터페이스**만 먼저 정의하고, Riverpod provider override로 **목 데이터소스**를 주입해 UI 선개발. API 확정 시 retrofit 구현만 교체(인터페이스 불변).
