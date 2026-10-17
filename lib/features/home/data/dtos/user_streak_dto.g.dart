// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_streak_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStreakDto _$UserStreakDtoFromJson(Map<String, dynamic> json) =>
    _UserStreakDto(
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      characterStatus: $enumDecodeNullable(
              _$CharacterStatusEnumMap, json['characterStatus'],
              unknownValue: CharacterStatus.statisfied) ??
          CharacterStatus.statisfied,
    );

Map<String, dynamic> _$UserStreakDtoToJson(_UserStreakDto instance) =>
    <String, dynamic>{
      'streak': instance.streak,
      'characterStatus': _$CharacterStatusEnumMap[instance.characterStatus]!,
    };

const _$CharacterStatusEnumMap = {
  CharacterStatus.greeting: 'greeting',
  CharacterStatus.terrible: 'terrible',
  CharacterStatus.statisfied: 'statisfied',
  CharacterStatus.grateful: 'grateful',
};
