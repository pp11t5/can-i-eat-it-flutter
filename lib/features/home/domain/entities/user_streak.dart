import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_streak.freezed.dart';

/// 서버 characterStatus 코드. statisfied는 API 계약의 철자를 유지한다.
enum CharacterStatus { greeting, terrible, statisfied, grateful }

/// 현재 사용자의 연속 편안 일수와 홈 캐릭터 상태.
@freezed
abstract class UserStreak with _$UserStreak {
  const factory UserStreak({
    @Default(0) int streak,
    @Default(CharacterStatus.statisfied) CharacterStatus characterStatus,
  }) = _UserStreak;
}
