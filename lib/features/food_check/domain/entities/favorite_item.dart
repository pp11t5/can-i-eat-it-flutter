import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

part 'favorite_item.freezed.dart';

/// 즐겨찾기 항목.
///
/// [foodName] 기준으로 중복 여부를 판단한다.
@freezed
abstract class FavoriteItem with _$FavoriteItem {
  const factory FavoriteItem({
    required String foodName,
    required VerdictLevel level,
    required DateTime savedAt,
    String? foodExternalId,
  }) = _FavoriteItem;
}
