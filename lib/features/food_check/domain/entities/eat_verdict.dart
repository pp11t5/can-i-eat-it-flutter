import 'package:freezed_annotation/freezed_annotation.dart';

part 'eat_verdict.freezed.dart';

/// 판별 수위. safe(괜찮음) / caution(주의) / avoid(피하기).
enum VerdictLevel { safe, caution, avoid }

/// "이 음식, 먹어도 돼?"에 대한 판별 결과.
///
/// 의료성 정보이므로 [reason]과 [sources](근거 출처) 노출이 제품 요건이다.
@freezed
abstract class EatVerdict with _$EatVerdict {
  const factory EatVerdict({
    required VerdictLevel level,
    required String reason,
    @Default(<String>[]) List<String> sources,
  }) = _EatVerdict;
}
