import '../../../condition_profile/domain/entities/health_condition.dart';
import '../entities/eat_verdict.dart';

/// 음식 판별 계약. 사용자 질환 목록 기준으로 음식 섭취 가부를 판별한다.
/// 구현은 data 레이어(서버 API 확정 시 retrofit).
abstract interface class FoodRepository {
  Future<EatVerdict> checkFood({
    required String foodQuery,
    required List<HealthCondition> conditions,
  });
}
