import '../../domain/entities/health_condition.dart';
import '../../domain/repositories/condition_repository.dart';

/// 서버 API 확정 전 임시 목 구현.
/// API 확정 시 retrofit datasource 기반 구현으로 교체(인터페이스 불변).
class ConditionRepositoryImpl implements ConditionRepository {
  const ConditionRepositoryImpl();

  @override
  Future<List<HealthCondition>> fetchAvailableConditions() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return const [
      HealthCondition(id: 'gerd', name: '역류성 식도염'),
      HealthCondition(id: 'gastritis', name: '위염'),
      HealthCondition(id: 'dyspepsia', name: '기능성 소화불량'),
      HealthCondition(id: 'ulcer', name: '위궤양'),
    ];
  }
}
