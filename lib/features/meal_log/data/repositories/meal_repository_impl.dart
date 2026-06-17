import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/data/dtos/meal_dtos.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';

/// [MealRepository] 실 서버 구현.
///
/// - Dio 직접 + unwrap + FailureMapper (food_check_impl 패턴 동일).
/// - date: KST 'YYYY-MM-DD', eatenAt: ISO-8601 +09:00 오프셋 (kst_time 헬퍼).
/// - judgedGrade: 도메인→서버는 [VerdictLevel.toServerGrade()] 사용.
class MealRepositoryImpl implements MealRepository {
  MealRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  // ---------------------------------------------------------------------------
  // 타임라인 조회
  // ---------------------------------------------------------------------------

  @override
  Future<List<MealGroup>> timeline(DateTime date) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.meals,
        queryParameters: {'date': toServerDate(date)},
      );
      final items = unwrap<List<dynamic>>(
        response,
        (json) => json as List<dynamic>,
      );
      return items
          .map(
            (e) => MealGroupDto.fromJson(e as Map<String, dynamic>).toEntity(),
          )
          .toList();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // 식사 기록 생성
  // ---------------------------------------------------------------------------

  @override
  Future<MealRecord> create({
    required String foodExternalId,
    DateTime? eatenAt,
    String? mealGroupId,
    VerdictLevel? grade,
  }) async {
    try {
      final body = CreateMealRecordRequestDto(
        foodExternalId: foodExternalId,
        eatenAt: eatenAt != null ? toServerOffset(eatenAt) : null,
        mealGroupId: mealGroupId,
        judgedGrade: grade?.toServerGrade(),
      );
      final response = await _dio.post<dynamic>(
        ApiEndpoints.meals,
        data: body.toJson(),
      );
      final dto = unwrap<MealRecordSummaryDto>(
        response,
        (j) => MealRecordSummaryDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<MealRecord> createByText({
    required String foodTextInput,
    DateTime? eatenAt,
    String? mealGroupId,
    VerdictLevel? grade,
  }) async {
    try {
      final body = CreateMealByTextRequestDto(
        foodTextInput: foodTextInput,
        eatenAt: eatenAt != null ? toServerOffset(eatenAt) : null,
        mealGroupId: mealGroupId,
        judgedGrade: grade?.toServerGrade(),
      );
      final response = await _dio.post<dynamic>(
        ApiEndpoints.mealsText,
        data: body.toJson(),
      );
      final dto = unwrap<MealRecordSummaryDto>(
        response,
        (j) => MealRecordSummaryDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // 식사 기록 상세
  // ---------------------------------------------------------------------------

  @override
  Future<MealDetail> detail(String mealId) async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.mealItem(mealId));
      final dto = unwrap<MealRecordDetailDto>(
        response,
        (j) => MealRecordDetailDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // 메모 수정
  // ---------------------------------------------------------------------------

  @override
  Future<MealDetail> updateMemo(String mealId, String? memo) async {
    try {
      final body = UpdateMealMemoRequestDto(memo: memo);
      final response = await _dio.patch<dynamic>(
        ApiEndpoints.mealItem(mealId),
        data: body.toJson(),
      );
      final dto = unwrap<MealRecordDetailDto>(
        response,
        (j) => MealRecordDetailDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // 삭제
  // ---------------------------------------------------------------------------

  @override
  Future<void> delete(String mealId) async {
    try {
      final response =
          await _dio.delete<dynamic>(ApiEndpoints.mealItem(mealId));
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
