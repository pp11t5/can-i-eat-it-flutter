import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/eat_verdict.dart';

part 'eat_verdict_dto.freezed.dart';
part 'eat_verdict_dto.g.dart';

/// 서버 응답 ↔ 도메인 엔티티 매핑용 DTO.
/// json 직렬화는 data 레이어에 가둔다(domain 엔티티는 순수 유지).
@freezed
abstract class EatVerdictDto with _$EatVerdictDto {
  const EatVerdictDto._();

  const factory EatVerdictDto({
    required String level,
    required String reason,
    @Default(<String>[]) List<String> sources,
  }) = _EatVerdictDto;

  factory EatVerdictDto.fromJson(Map<String, dynamic> json) =>
      _$EatVerdictDtoFromJson(json);

  EatVerdict toEntity() => EatVerdict(
        level: VerdictLevel.values.firstWhere(
          (e) => e.name == level,
          orElse: () => VerdictLevel.caution,
        ),
        reason: reason,
        sources: sources,
      );
}
