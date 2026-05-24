# ADR-0001: Flutter 클라이언트 아키텍처 — Riverpod + 피처 우선

- **Status**: Accepted
- **Date**: 2026-05-24
- **Decider(s)**: 프로젝트 팀

## 1. 의사결정 요약

"먹어도 돼?" Flutter 클라이언트의 기반 아키텍처로 **Riverpod 상태관리 + 피처 우선(feature-first) 폴더 구조**를 채택한다. 네트워킹은 dio + retrofit, 라우팅은 go_router, 모델 직렬화/불변성은 freezed + json_serializable, 코드 생성은 build_runner로 통일한다. 기획·디자인·서버 API가 매주 갱신되는 초안 단계 제품이므로, 변경을 피처 단위로 격리할 수 있는 구조를 우선한다.

## 2. 옵션 비교 (최소 2개)

### Option A: Riverpod + 피처 우선 (채택)
- 장점: 컴파일 타임 안전한 의존성 주입, 위젯 트리와 분리된 테스트 용이성, 피처 단위 격리로 주간 변경 흡수 용이. riverpod_lint로 정적 검증.
- 단점: 코드 생성(build_runner) 워크플로우 학습 비용, 보일러플레이트.
- 비용·복잡도: 중. 팀 친숙도 높음.

### Option B: BLoC + 피처 우선
- 장점: 이벤트/상태 분리가 엄격, 대규모 팀에서 규약 강제에 유리.
- 단점: 이벤트·상태 클래스 보일러플레이트가 더 많고, 초안 단계의 잦은 변경에 다소 무거움.
- 비용·복잡도: 중상.

## 3. 선택 근거

선택: **Option A (Riverpod + 피처 우선)**

근거:
- 상세 기획이 미확정이고 매주 변경 → 피처별 `data/domain/presentation` 격리로 변경 폭을 한 피처에 가둘 수 있다.
- 서버 API 변경은 `core/network` + 해당 피처 `data` 레이어에 국한된다.
- Riverpod의 provider override로 목 데이터 ↔ 실 API 전환이 쉬워, API가 늦게 나오는 주간 흐름에 적합.

## 4. 위험·전제

**위험**:
- 피처 경계 설계가 미흡하면 `core`가 비대해질 수 있다 → 공통화는 2회 이상 반복될 때만.
- 코드 생성 누락 시 빌드 실패 → CI/사전 커밋 단계에서 `build_runner` 강제.

**전제**:
- 도메인이 "사용자 질환 ↔ 음식/성분 ↔ 판별 결과" 매핑으로 표현 가능하다.
- 팀이 Riverpod/코드 생성 워크플로우에 익숙하다.

**전제 깨짐 신호**: 한 화면의 변경이 3개 이상 피처를 동시에 건드리기 시작하면 경계 재설계 필요.

## 5. 후속 액션

- [x] feature-first 스캐폴드 + 샘플 피처(condition_profile, food_check) 생성
- [ ] 서버 API 확정 시 `core/network/api_endpoints.dart` + 각 피처 `data` DTO 채우기
- [ ] retrofit 재도입(현재 retrofit 4.9.x ↔ retrofit_generator 9.7.x 비호환으로 보류). 호환 버전 확인 후 datasource 작성
- [ ] 의료성 면책 고지 컴포넌트 공통화
- [ ] CI에 `build_runner` + `flutter analyze` + `flutter test` 게이트 추가

---

> 이 ADR 형식은 architect 에이전트의 표준 출력 구조(핸드북 §6.2)를 따른다.
