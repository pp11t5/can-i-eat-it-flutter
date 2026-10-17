// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/home/domain/entities/user_streak.dart';

part 'user_streak_dto.freezed.dart';
part 'user_streak_dto.g.dart';

/// GET /users/me/streak의 result.
@freezed
abstract class UserStreakDto with _$UserStreakDto {
  const factory UserStreakDto({
    @Default(0) int streak,
    @JsonKey(unknownEnumValue: CharacterStatus.statisfied)
    @Default(CharacterStatus.statisfied)
    CharacterStatus characterStatus,
  }) = _UserStreakDto;

  factory UserStreakDto.fromJson(Map<String, dynamic> json) =>
      _$UserStreakDtoFromJson(json);
}

extension UserStreakDtoMapper on UserStreakDto {
  UserStreak toEntity() => UserStreak(
        streak: streak,
        characterStatus: characterStatus,
      );
}
