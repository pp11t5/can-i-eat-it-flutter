import 'package:can_i_eat_it/features/food_check/domain/entities/food_category.dart';

/// 음식 카테고리 저장소 인터페이스 — read 전용 (W7 minor EP, UI 배선 defer).
///
/// - 도메인 레이어 — 프레임워크 비종속.
/// - 실 구현: [FoodCategoryRepositoryImpl], 테스트·오프라인: [MockFoodCategoryRepository].
abstract interface class FoodCategoryRepository {
  /// 음식 카테고리 전체 목록을 조회한다.
  ///
  /// 대응 API: GET /foods/categories (result[]).
  Future<List<FoodCategory>> getCategories();
}
