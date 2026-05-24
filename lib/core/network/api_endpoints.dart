/// 서버 API 엔드포인트 경로 모음.
///
/// 서버 API는 매주 갱신되는 초안 단계다. 경로가 확정되면 여기에 추가하고,
/// 각 피처의 retrofit datasource(`features/<feature>/data/`)에서 참조한다.
class ApiEndpoints {
  const ApiEndpoints._();

  // 예시(초안) — 실제 계약 확정 시 교체.
  static const String healthConditions = '/health-conditions';
  static const String foodCheck = '/foods/check';
}
