/// 온보딩 선택지 코드↔한국어 라벨 단일 소스.
///
/// 라벨은 Figma 디자인(365:1555 / 365:1554 / 365:1553 / 1064:12268) verbatim.
/// code 값은 서버 DTO snake_case 계약 대상.
/// TODO(enum): 트리거/증상/알레르기 코드값을 Notion MVP enum·서버 Swagger와 정합.
///   (Notion 미인증으로 미확인 — 현재는 Figma 라벨에서 도출한 코드. 인터페이스 불변이라 추후 교체 가능.)
library;

// ---------------------------------------------------------------------------
// 타입
// ---------------------------------------------------------------------------

/// 코드-라벨 쌍 (증상·트리거·알레르기 공용).
/// code 값은 서버 OnboardingRequestDTO enum과 1:1 일치해야 한다.
typedef OptionEntry = ({String code, String label});

/// 질환 선택지. 캡션·활성화 여부 포함(현재 GERD만 활성, 나머지는 비활성 표시).
typedef ConditionOption = ({
  String code,
  String label,
  String? caption,
  bool enabled,
});

// ---------------------------------------------------------------------------
// 질환 (conditions) — 단일 선택 (Figma 365:1555)
// ---------------------------------------------------------------------------

/// 현재 GERD만 지원. 나머지 3종은 비활성 셀로 노출(향후 확장 예고).
const List<ConditionOption> conditionOptions = [
  (
    code: 'GERD',
    label: '역류성 식도염',
    caption: '소화가 잘 안 되고 더부룩해요',
    enabled: true,
  ),
  (code: 'gastritis', label: '위염 / 위궤양', caption: null, enabled: false),
  (
    code: 'ibs',
    label: '과민성 대장 증후군',
    caption: null,
    enabled: false,
  ),
  (
    code: 'functional_dyspepsia',
    label: '기능성 소화불량',
    caption: null,
    enabled: false,
  ),
];

// ---------------------------------------------------------------------------
// 증상 빈도 (symptomFrequency) — 복수 선택 (Figma 365:1554, 순서 verbatim)
// ---------------------------------------------------------------------------

const List<OptionEntry> symptomFrequencyOptions = [
  (code: 'heartburn_reflux', label: '주에 1번 이상 속이 쓰리거나 신물이 올라와요'),
  (code: 'post_meal_cough', label: '밥을 먹고 나면 기침이 나요'),
  (code: 'throat_globus', label: '목에 이물감이 있어요'),
  (code: 'sour_mouth_odor', label: '입에서 신맛과 악취가 느껴져요'),
  (code: 'supine_chest_tight', label: '누우면 가슴이 답답해져요'),
  (code: 'none_but_manage', label: '불편함은 딱히 없지만 관리하고 싶어요'),
];

// ---------------------------------------------------------------------------
// 트리거 음식 (triggerFoods) — 복수 선택 칩 (Figma 365:1553, 순서 verbatim)
// ---------------------------------------------------------------------------

const List<OptionEntry> triggerFoodOptions = [
  (code: 'caffeine', label: '커피·카페인'),
  (code: 'carbonated', label: '탄산음료'),
  (code: 'alcohol', label: '술'),
  (code: 'fried_fatty', label: '튀김·기름진 음식'),
  (code: 'chocolate', label: '초콜릿'),
  (code: 'spicy', label: '매운 음식'),
  (code: 'citrus', label: '감귤류'),
  (code: 'tomato', label: '토마토'),
  (code: 'mint', label: '민트'),
  (code: 'onion_garlic_raw', label: '양파·마늘'),
  (code: 'cheese_dairy', label: '(생)치즈·유제품'),
  (code: 'refined_flour', label: '빵·정제 밀가루'),
];

// ---------------------------------------------------------------------------
// 알레르기 (allergies) — 복수 선택 칩 (Figma 1064:12268, 2행 순서 verbatim)
// ---------------------------------------------------------------------------

const List<OptionEntry> allergyOptions = [
  (code: 'milk', label: '우유·유제품'),
  (code: 'egg', label: '계란'),
  (code: 'wheat', label: '밀'),
  (code: 'soy', label: '콩(대두)'),
  (code: 'peanut', label: '땅콩'),
  (code: 'crustacean', label: '갑각류'),
  (code: 'tree_nut', label: '견과류'),
  (code: 'fish_shellfish', label: '생선·조개류'),
];

// ---------------------------------------------------------------------------
// 조회 헬퍼 (OptionEntry 카탈로그 전용)
// ---------------------------------------------------------------------------

/// 주어진 카탈로그에서 [code]에 해당하는 라벨을 반환한다. 없으면 null.
String? labelForCode(List<OptionEntry> catalog, String code) {
  for (final entry in catalog) {
    if (entry.code == code) return entry.label;
  }
  return null;
}

/// 주어진 카탈로그에서 [label]에 해당하는 코드를 반환한다. 없으면 null.
String? codeForLabel(List<OptionEntry> catalog, String label) {
  for (final entry in catalog) {
    if (entry.label == label) return entry.code;
  }
  return null;
}
