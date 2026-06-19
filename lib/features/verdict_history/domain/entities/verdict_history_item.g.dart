// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verdict_history_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerdictHistoryItem _$VerdictHistoryItemFromJson(Map<String, dynamic> json) =>
    _VerdictHistoryItem(
      foodName: json['foodName'] as String,
      verdict: json['verdict'] as String,
      checkedAt: DateTime.parse(json['checkedAt'] as String),
    );

Map<String, dynamic> _$VerdictHistoryItemToJson(_VerdictHistoryItem instance) =>
    <String, dynamic>{
      'foodName': instance.foodName,
      'verdict': instance.verdict,
      'checkedAt': instance.checkedAt.toIso8601String(),
    };
