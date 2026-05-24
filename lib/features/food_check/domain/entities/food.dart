import 'package:freezed_annotation/freezed_annotation.dart';

part 'food.freezed.dart';

/// 판별 대상 음식/성분. 순수 도메인 엔티티.
@freezed
abstract class Food with _$Food {
  const factory Food({
    required String id,
    required String name,
    @Default(<String>[]) List<String> ingredients,
  }) = _Food;
}
