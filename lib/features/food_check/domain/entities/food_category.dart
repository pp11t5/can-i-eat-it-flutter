import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_category.freezed.dart';

/// 음식 카테고리 코드-표시명 엔티티 (GET /foods/categories 대응).
///
/// `app/widgets/category_icon.dart`의 하드코딩 매핑을 대체할 예정 —
/// 현재는 데이터레이어만 구현한다(W7 Phase 5, 우선순위 낮음, UI 배선 defer).
@freezed
abstract class FoodCategory with _$FoodCategory {
  const factory FoodCategory({
    required String code,
    required String displayName,
  }) = _FoodCategory;
}
