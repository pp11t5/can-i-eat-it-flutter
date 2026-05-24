# 컨텍스트 소스 — Notion · Figma · PRD 접근법

> 이 파일은 기획·디자인·API 정보의 **원본 위치와 접근 방법**을 정의한다.
> 실시간 조회 방법을 따르지 않으면 스냅샷 드리프트가 발생한다.

---

## 1. PRD v1 (최우선 스펙)

| 항목 | 값 |
|---|---|
| 로컬 경로 | `docs/project/prd-v1.md` |
| Notion 원본 ID | `36212597ad8781a8ba22efd3fb80383b` |
| 작성자/날짜 | PO · 2026-05-23 |
| 역할 | 화면·유저스토리·API·결정로그(D1~D4)의 **단일 스펙** |

PRD v1은 repo에 스냅샷으로 보존(`prd-v1.md`). 버전 변경 시 PO가 새 파일로 제공하며, 이전 버전은 파일명에 날짜를 붙여 보존.

---

## 2. Figma

| 항목 | 값 |
|---|---|
| 파일 ID | `DEFNKWPwiIBFDqJv423n39` |
| 와이어프레임 섹션 node | `13:2` |
| 완성 GUI 섹션 node | `82:178` ("온보딩(완료)") |
| 회의록 참조 API 상세 node | `Tjy6BNJLydYbqCaO57bLJJ` |

### 접근 방법

**Figma Framelink MCP** 사용. 토큰·레이아웃 추출 목적.

```
// 예시: 특정 node 레이아웃 조회
mcp_figma.get_node(file_id: "DEFNKWPwiIBFDqJv423n39", node_id: "82:178")
```

- React 코드 생성을 기대하지 않는다. 토큰·계층을 Flutter 위젯으로 옮긴다.
- 완성 GUI 구현 시 **`82:178` 섹션 우선 참조**. 와이어프레임(`13:2`)은 보조.
- `FIGMA_API_KEY`는 `.env`(비커밋)로 주입.

### 화면별 세부 노트 생성 시점

`docs/project/screens/<id>.md`는 구현 직전 해당 화면 Figma Description Note에서 생성. 사전 생성 금지.

---

## 3. Notion 회의록

| 항목 | 값 |
|---|---|
| 상태 | 공개 페이지 (Notion OAuth 인증 필요 — 게스트 차단 가능성) |
| 접근 방법 | **Notion MCP** (OAuth 1회 인증 후 `/mcp`로 갱신) |
| 폴백 | Playwright (MCP 차단 시) |

### Notion MCP 접근 절차

1. 세션 시작 시 `/mcp` 명령으로 Notion OAuth 상태 확인
2. 미인증 시 브라우저 인증 후 재시도
3. 이번 주 기획 페이지를 실시간 조회 — 복붙 금지

### Playwright 폴백

MCP가 게스트 차단으로 접근 불가한 경우 Playwright로 공개 URL을 직접 읽는다.

---

## 4. 갱신 방법 요약

| 소스 | 갱신 방법 | 주기 |
|---|---|---|
| PRD v1 | PO 제공 파일 → `prd-v1.md` 교체 | 버전 변경 시 |
| Figma 토큰 | Framelink MCP → `primitives.dart` 갱신 | 디자인 변경 시 |
| Notion 회의록 | Notion MCP 실시간 조회 | 주간 루프 시작 시 |
| `screens/INDEX.md` | 구현 시작·완료 시 상태 갱신 | 화면 작업 시 |
| `api-contract.md` | 서버 API 확정·변경 시 반영 | API 변경 시 |

---

## 5. 접근 불가 시 처리

- Figma 접근 불가: `docs/project/design-system.md`의 provisional 값으로 진행, `// provisional` 주석 추가
- Notion 접근 불가: `prd-v1.md` + `open-issues.md`로 대체. PO에 명확화 요청 후 `open-issues.md`에 기록
- 정보 불명확: `open-issues.md`에 항목 추가 후 PO·architect에 에스컬레이션
