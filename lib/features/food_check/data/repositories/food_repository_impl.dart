import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/food_check/data/dtos/food_summary_dto.dart';
import 'package:can_i_eat_it/features/food_check/data/dtos/recent_food_dto.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_food_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/recent_food.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_repository.dart';

/// [FoodRepository] 실 서버 구현 (ADR-0007 §3-1 (5), 수기 dio).
///
/// search / recent CRUD 는 실 서버 `/foods/*` 엔드포인트를 호출한다.
///
/// [analyze] 는 서버 미출시(W3)이므로 [MockFoodRepository]에 위임한다.
/// 서버 `/foods/analyze` 출시 시 이 메서드만 교체한다.
/// // TODO(server): analyze 서버 출시 시 교체. MockFoodRepository 위임 제거.
class FoodRepositoryImpl implements FoodRepository {
  FoodRepositoryImpl({
    required Dio dio,
    MockFoodRepository? analyzeDelegate,
  })  : _dio = dio,
        // analyze 위임: 인자로 주입받거나 기본 MockFoodRepository.empty() 사용.
        _analyzeDelegate = analyzeDelegate ?? MockFoodRepository.empty();

  final Dio _dio;

  /// analyze 위임 대상 (W3 Mock 유지).
  /// 서버 출시 시 이 필드를 제거하고 실 API 호출로 대체한다.
  final MockFoodRepository _analyzeDelegate;

  // ---------------------------------------------------------------------------
  // 판정 — Mock 위임 (서버 미출시, W3)
  // ---------------------------------------------------------------------------

  /// 자유 텍스트 음식명을 분석해 판정 결과를 반환한다.
  ///
  /// // TODO(server): analyze 서버 출시 시 교체.
  /// 현재는 [MockFoodRepository]에 위임해 결정론적 결과를 반환한다.
  @override
  Future<EatVerdict> analyze(String text) => _analyzeDelegate.analyze(text);

  // ---------------------------------------------------------------------------
  // 검색
  // ---------------------------------------------------------------------------

  @override
  Future<List<FoodSummary>> search(String q, {int size = 20}) async {
    if (q.trim().isEmpty) return [];
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.foodsSearch,
        queryParameters: {'q': q, 'size': size},
      );
      final items = unwrap<List<dynamic>>(
        response,
        (json) => json as List<dynamic>,
      );
      return items
          .map((e) => FoodSummaryDto.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // 최근 검색
  // ---------------------------------------------------------------------------

  @override
  Future<List<RecentFood>> recentSearches({
    int size = kRecentFoodMaxCount,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.foodsRecent,
        queryParameters: {'size': size},
      );
      final items = unwrap<List<dynamic>>(
        response,
        (json) => json as List<dynamic>,
      );
      return items
          .map((e) => RecentFoodDto.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<void> addRecent(String foodExternalId) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.foodsRecent,
        data: {'foodExternalId': foodExternalId},
      );
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<void> removeRecent(String foodExternalId) async {
    try {
      final response = await _dio.delete<dynamic>(
        ApiEndpoints.foodsRecentItem(foodExternalId),
      );
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<void> clearRecent() async {
    try {
      final response = await _dio.delete<dynamic>(ApiEndpoints.foodsRecent);
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
