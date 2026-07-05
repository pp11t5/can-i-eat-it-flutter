import 'package:can_i_eat_it/features/food_check/domain/entities/food_category.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_category_repository.dart';

/// [FoodCategoryRepository] 인메모리 Mock 구현. UI 선개발·테스트용.
class MockFoodCategoryRepository implements FoodCategoryRepository {
  MockFoodCategoryRepository({List<FoodCategory>? initial})
      : _categories = initial ?? _seededCategories;

  /// 빈 상태.
  factory MockFoodCategoryRepository.empty() =>
      MockFoodCategoryRepository(initial: const []);

  /// 샘플 데이터.
  factory MockFoodCategoryRepository.seeded() => MockFoodCategoryRepository();

  final List<FoodCategory> _categories;

  @override
  Future<List<FoodCategory>> getCategories() async => _categories;
}

// ---------------------------------------------------------------------------
// 시드 데이터 — category_icon.dart 토큰 맵과 코드 일치.
// ---------------------------------------------------------------------------

const _seededCategories = [
  FoodCategory(code: 'rice_porridge', displayName: '밥·죽'),
  FoodCategory(code: 'noodles', displayName: '면'),
  FoodCategory(code: 'soup_stew', displayName: '국·찌개'),
  FoodCategory(code: 'beverage', displayName: '음료'),
];
