import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/food_check/data/dtos/food_symptom_dto.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_symptom.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_symptom_repository.dart';

/// [FoodSymptomRepository] 실 서버 구현 (Dio 직접 + unwrap + FailureMapper,
/// weekly_report_repository_impl / dictionary_repository_impl 패턴 동일).
class FoodSymptomRepositoryImpl implements FoodSymptomRepository {
  FoodSymptomRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<FoodSymptom>> getSymptoms(String foodExternalId) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.foodSymptoms(foodExternalId),
      );
      final items = unwrap<List<dynamic>>(
        response,
        (json) => json as List<dynamic>,
      );
      return items
          .map((e) => FoodSymptomDto.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
