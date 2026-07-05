import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/home/data/dtos/recent_meal_dto.dart';
import 'package:can_i_eat_it/features/home/domain/entities/recent_meal.dart';
import 'package:can_i_eat_it/features/home/domain/repositories/home_repository.dart';

/// [HomeRepository] 실 서버 구현 (Dio 직접 + unwrap + FailureMapper,
/// weekly_report_repository_impl / dictionary_repository_impl 패턴 동일).
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<int> unrecordedMealCount() async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.mealRecordsUnrecordedCount,
      );
      return unwrap<int>(
        response,
        (j) => (j as Map<String, dynamic>)['count'] as int? ?? 0,
      );
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<List<RecentMeal>> recentFoods() async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.mealRecordsRecentFoods,
      );
      final items = unwrap<List<dynamic>>(
        response,
        (json) => json as List<dynamic>,
      );
      return items
          .map((e) => RecentMealDto.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
