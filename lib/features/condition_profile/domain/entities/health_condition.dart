import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_condition.freezed.dart';

/// 사용자의 기저질환(역류성 식도염·위염 등). 순수 도메인 엔티티.
@freezed
abstract class HealthCondition with _$HealthCondition {
  const factory HealthCondition({
    required String id,
    required String name,
  }) = _HealthCondition;
}
