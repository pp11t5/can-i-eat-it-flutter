/// 온보딩 선택지 코드↔한국어 라벨 단일 소스.
///
/// 출처: PRD §3 F1 / api-contract.
/// code 값은 서버 DTO snake_case 계약과 일치한다.
/// UI 라벨(한국어)은 이 카탈로그가 매핑하며 화면·컨트롤러가 공유한다.
///
/// TODO(figma): 알레르기/트리거 칩 라벨은 Figma 82:197/82:358 collapsed —
///   디자이너 확정 시 정합.
library;

// ---------------------------------------------------------------------------
// 타입 별칭
// ---------------------------------------------------------------------------

/// 코드-라벨 쌍.
typedef OptionEntry = ({String code, String label});

// ---------------------------------------------------------------------------
// 질환 (conditions)
// ---------------------------------------------------------------------------

/// 지원 질환 목록. 현재 GERD 단일, 다중 확장 대비 리스트 구조.
const List<OptionEntry> conditionOptions = [
  (code: 'GERD', label: '역류성 식도염'),
];

// ---------------------------------------------------------------------------
// 증상 빈도 (symptomFrequency) — 복수 선택
// ---------------------------------------------------------------------------

/// PRD §3 F1 카피 verbatim.
const List<OptionEntry> symptomFrequencyOptions = [
  (code: 'weekly_heartburn', label: '주에 1번 이상 속이 쓰리거나 신물이 올라와요'),
  (code: 'post_meal_cough', label: '밥을 먹고 나면 기침이 나요'),
  (code: 'sour_taste', label: '입에서 신맛·악취가 느껴져요'),
  (code: 'lying_chest_tightness', label: '누우면 가슴이 답답해져요'),
  (code: 'throat_lump', label: '목에 이물감이 있어요'),
];

// ---------------------------------------------------------------------------
// 진단 여부 (diagnosed) — 단일 선택 bool
// ---------------------------------------------------------------------------

/// 체크 시 diagnosed = true 로 설정한다.
const String diagnosedLabel = '예전에 진단받았지만 지금은 관리만 하고 있어요';

// ---------------------------------------------------------------------------
// 트리거 음식 (triggerFoods) — 복수 선택
// ---------------------------------------------------------------------------

/// PRD "매운 음식·카페인·튀김 등" 기반 8개 항목.
const List<OptionEntry> triggerFoodOptions = [
  (code: 'spicy', label: '매운 음식'),
  (code: 'caffeine', label: '카페인'),
  (code: 'fried', label: '튀김'),
  (code: 'carbonated', label: '탄산음료'),
  (code: 'alcohol', label: '음주'),
  (code: 'citrus', label: '신 과일·주스'),
  (code: 'chocolate', label: '초콜릿'),
  (code: 'fatty', label: '기름진 음식'),
];

// ---------------------------------------------------------------------------
// 알레르기 (allergies) — 복수 선택 칩
// ---------------------------------------------------------------------------

/// 일반적 한국 알레르기 항목 6개.
const List<OptionEntry> allergyOptions = [
  (code: 'egg', label: '계란'),
  (code: 'milk', label: '우유'),
  (code: 'shellfish', label: '갑각류'),
  (code: 'nuts', label: '견과류'),
  (code: 'peach', label: '복숭아'),
  (code: 'soy', label: '대두'),
];

// ---------------------------------------------------------------------------
// 조회 헬퍼
// ---------------------------------------------------------------------------

/// 주어진 카탈로그에서 [code]에 해당하는 라벨을 반환한다.
/// 존재하지 않으면 null 반환.
String? labelForCode(List<OptionEntry> catalog, String code) {
  for (final entry in catalog) {
    if (entry.code == code) return entry.label;
  }
  return null;
}

/// 주어진 카탈로그에서 [label]에 해당하는 코드를 반환한다.
/// 존재하지 않으면 null 반환.
String? codeForLabel(List<OptionEntry> catalog, String label) {
  for (final entry in catalog) {
    if (entry.label == label) return entry.code;
  }
  return null;
}
