// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SafeFoodItemDto _$SafeFoodItemDtoFromJson(Map<String, dynamic> json) =>
    _SafeFoodItemDto(
      foodId: json['foodId'] as String,
      name: json['name'] as String,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$SafeFoodItemDtoToJson(_SafeFoodItemDto instance) =>
    <String, dynamic>{
      'foodId': instance.foodId,
      'name': instance.name,
      'code': instance.code,
    };

_CautionRiskFoodItemDto _$CautionRiskFoodItemDtoFromJson(
        Map<String, dynamic> json) =>
    _CautionRiskFoodItemDto(
      foodId: json['foodId'] as String,
      name: json['name'] as String,
      code: json['code'] as String?,
      type: json['type'] as String,
    );

Map<String, dynamic> _$CautionRiskFoodItemDtoToJson(
        _CautionRiskFoodItemDto instance) =>
    <String, dynamic>{
      'foodId': instance.foodId,
      'name': instance.name,
      'code': instance.code,
      'type': instance.type,
    };

_SafeDictionaryPageDto _$SafeDictionaryPageDtoFromJson(
        Map<String, dynamic> json) =>
    _SafeDictionaryPageDto(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => SafeFoodItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <SafeFoodItemDto>[],
      nextCursor: (json['nextCursor'] as num?)?.toInt(),
      hasNext: json['hasNext'] as bool? ?? false,
    );

Map<String, dynamic> _$SafeDictionaryPageDtoToJson(
        _SafeDictionaryPageDto instance) =>
    <String, dynamic>{
      'items': instance.items,
      'nextCursor': instance.nextCursor,
      'hasNext': instance.hasNext,
    };

_CautionRiskDictionaryPageDto _$CautionRiskDictionaryPageDtoFromJson(
        Map<String, dynamic> json) =>
    _CautionRiskDictionaryPageDto(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) =>
                  CautionRiskFoodItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CautionRiskFoodItemDto>[],
      nextCursor: (json['nextCursor'] as num?)?.toInt(),
      hasNext: json['hasNext'] as bool? ?? false,
    );

Map<String, dynamic> _$CautionRiskDictionaryPageDtoToJson(
        _CautionRiskDictionaryPageDto instance) =>
    <String, dynamic>{
      'items': instance.items,
      'nextCursor': instance.nextCursor,
      'hasNext': instance.hasNext,
    };

_DictionaryCountDto _$DictionaryCountDtoFromJson(Map<String, dynamic> json) =>
    _DictionaryCountDto(
      safeCount: (json['safeCount'] as num?)?.toInt() ?? 0,
      cautionRiskCount: (json['cautionRiskCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$DictionaryCountDtoToJson(_DictionaryCountDto instance) =>
    <String, dynamic>{
      'safeCount': instance.safeCount,
      'cautionRiskCount': instance.cautionRiskCount,
    };
