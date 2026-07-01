import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/dtos/dictionary_dtos.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/entities/dictionary_food.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/repositories/dictionary_repository.dart';

/// [DictionaryRepository] 실 서버 구현 (Dio 직접 + unwrap + FailureMapper,
/// meal_repository_impl 패턴 동일).
class DictionaryRepositoryImpl implements DictionaryRepository {
  DictionaryRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<DictionaryPage> getSafe({int? cursor, int size = 20}) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.dictionarySafe,
        queryParameters: {'cursor': cursor, 'size': size}
          ..removeWhere((_, v) => v == null),
      );
      final dto = unwrap<SafeDictionaryPageDto>(
        response,
        (j) => SafeDictionaryPageDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<DictionaryPage> getCautionRisk({int? cursor, int size = 20}) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.dictionaryCautionRisk,
        queryParameters: {'cursor': cursor, 'size': size}
          ..removeWhere((_, v) => v == null),
      );
      final dto = unwrap<CautionRiskDictionaryPageDto>(
        response,
        (j) =>
            CautionRiskDictionaryPageDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<DictionaryCount> getCount() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.dictionaryCount);
      final dto = unwrap<DictionaryCountDto>(
        response,
        (j) => DictionaryCountDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
