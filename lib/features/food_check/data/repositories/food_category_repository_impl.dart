import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/food_check/data/dtos/food_category_dto.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_category.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_category_repository.dart';

/// [FoodCategoryRepository] 실 서버 구현 (Dio 직접 + unwrap + FailureMapper,
/// weekly_report_repository_impl / dictionary_repository_impl 패턴 동일).
class FoodCategoryRepositoryImpl implements FoodCategoryRepository {
  FoodCategoryRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<FoodCategory>> getCategories() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.foodCategories);
      final items = unwrap<List<dynamic>>(
        response,
        (json) => json as List<dynamic>,
      );
      return items
          .map((e) => FoodCategoryDto.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
