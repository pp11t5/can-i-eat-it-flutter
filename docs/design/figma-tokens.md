# Figma 디자인 토큰 (실측 — 단일 진실 원천)

출처: Figma `DEFNKWPwiIBFDqJv423n39` "먹어도돼?" → Design Tokens 플러그인(Lukas Oppermann) Export.
폰트는 **Pretendard** 확정(디자이너 한희, 2026-05-27 — 자간 조정 이슈로 Noto Sans KR 폐기).
이 표가 `lib/app/theme/tokens/` primitive의 단일 출처. 값 변경 시 이 문서 → primitive → (semantic/theme 자동 연동) 순.

## 색 (hex, alpha ff 제거)

### Green 스케일 (`color` 그룹)
| 토큰 | hex | 비고 |
|---|---|---|
| green10 | `#F0FFF4` | 최연한 |
| green50 | `#D9F5EA` | |
| green80 | `#B1EBD3` | |
| green100 | `#00BF72` | **Primary / semantic_green / 권장(recommend)** |
| green200 | `#02995B` | |
| green300 | `#027344` | 최진한 |

### Semantic (`foundation/sementic color`)
| 토큰 | hex | 용도 |
|---|---|---|
| semanticRed | `#FF383C` | **위험(danger)** |
| semanticOrange | `#FF8D28` | **주의(caution)** |
| (semanticGreen) | `#00BF72` | 권장 = green100과 동일 |
> unknown(확인어려움) 전용 semantic 없음 → `gray80(line) #8C8C8C`로 매핑(설계 선택).

### Foundation
| 토큰 | hex |
|---|---|
| white | `#FEFEFE` |
| black | `#222222` |

### Font color (`foundation/font color`)
| 토큰 | hex | 용도 |
|---|---|---|
| fontColor20 | `#8C8C99` | tertiary/placeholder |
| fontColor50 | `#737380` | secondary |
| fontColor80 | `#10111A` | strong |
| fontColor100 | `#1A1A1F` | primary 텍스트 |

### Gray (`foundation/gray`)
| 토큰 | hex | 용도(Figma 라벨) |
|---|---|---|
| gray10 | `#FDFDFD` | |
| gray20 | `#FCFCFC` | background |
| gray30 | `#F5F5F5` | disable |
| gray40 | `#EAEAEA` | stroke/border |
| gray50 | `#D3D3D3` | |
| gray60 | `#BBBBBB` | navi |
| gray70 | `#B0B0B0` | |
| gray80 | `#8C8C8C` | line |
| gray90 | `#696969` | |
| gray100 | `#525252` | check |

### 브랜드 (Figma foundation 외 — 고정 브랜드값)
| 토큰 | hex |
|---|---|
| kakaoYellow | `#FEE500` |

## 타이포그래피 (전부 Pretendard)
Flutter `height` = lineHeight(px) ÷ fontSize. letterSpacing은 px.

| Figma 스타일 | size | weight | lineHeight(px / 배율) | letterSpacing(px) |
|---|---|---|---|---|
| Title_2(B) | 32 | 700 | 32 / 1.0 | 0 |
| Header_1(B) | 24 | 700 | 36 / 1.5 | 0 |
| Header_2(B) | 20 | 700 | 24 / 1.2 | 1.2 |
| Header_1(M) | 20 | 400 | 24 / 1.2 | 0 |
| Body_1(B) | 16 | 700 | 22.4 / 1.4 | 0.32 |
| Body_1(M) | 16 | 500 | 25.6 / 1.6 | 0 |
| Body_2(B) | 14 | 700 | 19.6 / 1.4 | 0 |
| Body_2(M) | 14 | 500 | 22.4 / 1.6 | 0 |
| Caption_1(B) | 12 | 700 | 18 / 1.5 | 0 |
| Caption_1(M) | 12 | 500 | 20.4 / 1.7 | 0.36 |

> 패널 캡처엔 Title_1(48)/Title_3(28)/Caption_2(10)도 보였으나 이번 플러그인 export엔 없음(디자이너 정리 중일 가능성). 현 export 10종을 정본으로 구현.

## Grid (layout guide)
columns 3, gutter 8, margin(offset) 16, alignment stretch → 8pt 그리드 + 16 마진 확정.
