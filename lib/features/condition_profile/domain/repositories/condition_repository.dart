import '../entities/health_condition.dart';

/// 기저질환 목록 조회 계약. 구현은 data 레이어(서버 API 확정 시 retrofit).
abstract interface class ConditionRepository {
  Future<List<HealthCondition>> fetchAvailableConditions();
}
