import 'package:freezed_annotation/freezed_annotation.dart';

part 'verdict_history_item.freezed.dart';
part 'verdict_history_item.g.dart';

/// 판정 이력 단건.
///
/// [verdict]: 'safe' | 'caution' | 'avoid' | 'unknown'
/// [checkedAt]: 판정 시각 (DateTime, UTC 저장)
@freezed
abstract class VerdictHistoryItem with _$VerdictHistoryItem {
  const factory VerdictHistoryItem({
    required String foodName,
    required String verdict,
    required DateTime checkedAt,
  }) = _VerdictHistoryItem;

  factory VerdictHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$VerdictHistoryItemFromJson(json);
}
