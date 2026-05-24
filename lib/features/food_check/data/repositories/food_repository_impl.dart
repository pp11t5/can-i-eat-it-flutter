import '../../../condition_profile/domain/entities/health_condition.dart';
import '../../domain/entities/eat_verdict.dart';
import '../../domain/repositories/food_repository.dart';
import '../dtos/eat_verdict_dto.dart';

/// 서버 API 확정 전 임시 목 구현. 간단한 트리거 성분 휴리스틱으로 판별 흉내.
/// API 확정 시 retrofit datasource 호출 + [EatVerdictDto.toEntity] 매핑으로 교체.
class FoodRepositoryImpl implements FoodRepository {
  const FoodRepositoryImpl();

  /// 위산 역류/위 자극을 유발하기 쉬운 대표 트리거(데모용).
  static const _triggers = ['커피', '탄산', '튀김', '매운', '술', '초콜릿', '기름'];

  @override
  Future<EatVerdict> checkFood({
    required String foodQuery,
    required List<HealthCondition> conditions,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final hasTrigger = _triggers.any(foodQuery.contains);
    final hasCondition = conditions.isNotEmpty;

    final dto = switch ((hasTrigger, hasCondition)) {
      (true, true) => EatVerdictDto(
          level: VerdictLevel.avoid.name,
          reason: '$foodQuery 은(는) 위산 역류·위 자극을 유발할 수 있어 '
              '선택한 질환에는 권장되지 않아요.',
          sources: const ['데모 규칙 기반(서버 판별 로직 연동 예정)'],
        ),
      (false, true) => EatVerdictDto(
          level: VerdictLevel.caution.name,
          reason: '$foodQuery 은(는) 일반적으로 큰 문제는 없지만 양과 컨디션에 따라 주의하세요.',
          sources: const ['데모 규칙 기반(서버 판별 로직 연동 예정)'],
        ),
      _ => EatVerdictDto(
          level: VerdictLevel.safe.name,
          reason: '$foodQuery 은(는) 특별한 위험 요인이 확인되지 않았어요.',
          sources: const ['데모 규칙 기반(서버 판별 로직 연동 예정)'],
        ),
    };

    return dto.toEntity();
  }
}
