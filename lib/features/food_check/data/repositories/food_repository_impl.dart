import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/food_check/data/dtos/food_summary_dto.dart';
import 'package:can_i_eat_it/features/food_check/data/dtos/judgment_response_dto.dart';
import 'package:can_i_eat_it/features/food_check/data/dtos/recent_food_dto.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/recent_food.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/food_repository.dart';

/// [FoodRepository] 실 서버 구현 (ADR-0007 §3-1 (5), 수기 dio).
///
/// - search / recent CRUD: 실 `/foods/*` 엔드포인트.
/// - judgeByText: GET /foods/judgment?foodTextInput= (W3-3 충실 정합).
/// - judgeById: GET /foods/{foodExternalId}/judgment (W3-3 충실 정합).
///
/// Mock 위임(W3 이전) 완전 제거. FOOD 에러코드는 FailureMapper로 매핑.
class FoodRepositoryImpl implements FoodRepository {
  FoodRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  // ---------------------------------------------------------------------------
  // 판정 — 실 서버 연동 (W3-3)
  // ---------------------------------------------------------------------------

  /// 자유 텍스트 음식명을 판정한다.
  ///
  /// GET /foods/judgment?foodTextInput=<text>
  /// substitutes 없음, category 없음 (by-text 규약).
  /// FOOD400_1 → [InvalidFoodQueryFailure], 통신오류 → [NetworkFailure].
  @override
  Future<EatVerdict> judgeByText(String foodTextInput) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.foodsJudgmentByText,
        queryParameters: {'foodTextInput': foodTextInput},
      );
      final dto = unwrap<TextJudgmentResponseDto>(
        response,
        (j) => TextJudgmentResponseDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  /// 등록 음식(externalId)을 판정한다.
  ///
  /// GET /foods/{foodExternalId}/judgment
  /// substitutes·category 포함 완전 응답 (by-id 규약).
  /// FOOD404_1 → [FoodNotFoundFailure], 통신오류 → [NetworkFailure].
  @override
  Future<EatVerdict> judgeById(String foodExternalId) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.foodsJudgmentById(foodExternalId),
      );
      final dto = unwrap<JudgmentResponseDto>(
        response,
        (j) => JudgmentResponseDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

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
