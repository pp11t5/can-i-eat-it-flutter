import 'package:freezed_annotation/freezed_annotation.dart';

part 'verdict_history_summary.freezed.dart';

/// VerdictCard Section 3 — 이 음식 섭취 후 기록 요약 (ADR-0003 §4).
///
/// [count] 가 0이면 빈 섹션으로 간주한다.
/// [averageSeverity] 는 서버 문자열 그대로 표시 (예: '보통').
@freezed
abstract class VerdictHistorySummary with _$VerdictHistorySummary {
  const factory VerdictHistorySummary({
    /// 과거 섭취 기록 건수.
    @Default(0) int count,

    /// 평균 심각도 레이블. 서버 문자열 그대로. 없으면 null.
    String? averageSeverity,
  }) = _VerdictHistorySummary;

  /// 기록이 없는 빈 요약.
  factory VerdictHistorySummary.empty() =>
      const VerdictHistorySummary(count: 0);
}
