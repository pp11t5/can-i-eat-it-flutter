import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';

part 'food_summary_dto.freezed.dart';
part 'food_summary_dto.g.dart';

/// GET /foods/search 응답 항목 DTO (ADR-0007 §3-1 (5)).
///
/// 서버 JSON 필드: camelCase.
/// - 검색(search): 키 이름이 'externalId' → 필드명을 externalId로 선언.
/// - 최근 조회(recent)는 [RecentFoodDto] 참조 (키 이름 'foodExternalId', 변경 금지).
/// entity 변환: [toEntity].
@freezed
abstract class FoodSummaryDto with _$FoodSummaryDto {
  const factory FoodSummaryDto({
    required String externalId,
    required String name,
    String? category,
  }) = _FoodSummaryDto;

  factory FoodSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$FoodSummaryDtoFromJson(json);
}

extension FoodSummaryDtoMapper on FoodSummaryDto {
  FoodSummary toEntity() => FoodSummary(
        externalId: externalId,
        name: name,
        category: category,
      );
}
