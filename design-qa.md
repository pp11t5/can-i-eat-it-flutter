# 약관 동의 화면 Design QA

- source visual truth path: `/var/folders/v8/bkjb_6316532k6_nmxpskbsh0000gn/T/TemporaryItems/NSIRD_screencaptureui_sateYh/Screenshot 2026-08-05 at 5.36.09 AM.png`
- implementation screenshot path: `test/features/auth/presentation/goldens/terms_screen_375x812.png`
- combined comparison evidence: `docs/design/terms-consent-comparison.png` (왼쪽 기준, 오른쪽 구현)
- viewport / CSS size: 375×812
- source pixels: 1060×2248. 바깥 캔버스 여백을 제외한 1020×2208 앱 화면을 375×812로 Lanczos 정규화했다(약 2.72× → 1×).
- implementation pixels: 375×812, devicePixelRatio 1.0
- state: 서버 약관 로드 완료, 필수 3개 선택, 선택 약관 미선택, CTA 활성

## Findings

- 최종 비교에서 조치가 필요한 P0/P1/P2 차이는 없다.
- 기준 이미지에만 보이는 시각적 상태바 아이콘은 OS 소유 device chrome이다. 구현 골든은 앱 viewport 렌더이므로 아이콘을 복제하지 않았으며, 동일한 44px 상단 inset으로 앱 소유 레이아웃을 정규화했다.

## Required Fidelity Surfaces

- Fonts and typography: Pretendard Bold/Medium을 사용한다. 제목의 24px 계층, 2줄 줄바꿈, 약관 행의 14px 계층과 가중치가 기준과 일치한다. 1× 래스터의 안티앨리어싱 차이만 남는다.
- Spacing and layout rhythm: 앱바 경계, 제목 시작점, 전체 동의 카드, 구분선, 40px 약관 행 리듬을 기준에 맞췄다. CTA는 후속 요구에 따라 기준 시안보다 32px 위인 온보딩 화면의 위치와 동일하게 맞췄다. 목록은 약관 증가와 작은 화면을 위해 스크롤된다.
- Colors and visual tokens: 흰 배경, 본문/보조 텍스트, 회색 경계·구분선, 활성 초록색을 기존 앱 토큰으로 매핑했다. 활성/비활성 상태 대비가 기준과 일치한다.
- Image quality and asset fidelity: 별도 래스터 이미지가 필요한 화면이 아니다. 뒤로가기·상세 화살표·체크는 기존 앱의 벡터 아이콘 자산을 사용하며 크기와 정렬이 기준과 일치한다.
- Copy and content: 고정 제목과 전체 동의/CTA 문구가 기준과 일치한다. 개별 행 제목·필수 여부는 서버 응답이 유일한 진실 원천이며 골든 fixture는 기준 문구를 사용한다.
- Accessibility and behavior: 행과 전체 동의는 탭 가능하고, 상세 아이콘에는 semantics label이 있으며, 모든 필수 약관 선택 전까지 CTA가 비활성이다. 로딩·오류·긴 목록에서도 CTA 구조를 유지한다.

## Full-view Comparison Evidence

`docs/design/terms-consent-comparison.png`에서 동일 375×812 크기로 좌우 비교했다. 앱바/본문/CTA의 주요 경계, 텍스트 줄바꿈, 체크 상태, 행 리듬과 색상을 한 화면에서 확인했다.

## Focused Region Comparison

별도 확대 비교는 필요하지 않았다. 750×812 결합 이미지가 양쪽을 각각 원본 1× 크기로 유지해 제목, 14px 행 텍스트, 20px 체크, 24px 화살표까지 명확히 읽고 판단할 수 있었다.

## Comparison History

1. 첫 캡처에서 앱바·본문이 기준보다 위로 붙고, 전체 동의 카드와 48px 약관 행이 기준보다 높았으며, CTA가 하단 safe area와 추가 패딩 때문에 약 34px 위에 놓인 P2 차이를 확인했다.
2. `TermsScreen`의 앱바 높이, 본문 시작 간격, 전체 동의 카드 세로 패딩, 약관 행 높이, CTA 하단 패딩을 조정했다.
3. 같은 375×812·필수 3개 선택 상태로 다시 캡처했다. `docs/design/terms-consent-comparison.png`에서 이전 P2 차이가 해소되고 조치 가능한 P0/P1/P2 차이가 없음을 확인했다.
4. 후속 요구로 약관 CTA의 하단 패딩을 온보딩과 동일한 32px로 변경했다. 기준 시안의 CTA 위치와 다른 점은 사용자 지정 일관성 요구에 따른 의도된 차이이며, 갱신된 골든과 비교 이미지를 반영했다.

## Implementation Checklist

- [x] 375×812 레이아웃 및 고정 CTA
- [x] 서버 제목·필수 여부 기반 행
- [x] 필수 3개 선택/선택 약관 미선택 시각 상태
- [x] 기존 Pretendard·색상·벡터 아이콘 토큰 재사용
- [x] 로딩·오류·스크롤 상태에서 레이아웃 안정성

## Follow-up Polish

- 없음.

final result: passed
