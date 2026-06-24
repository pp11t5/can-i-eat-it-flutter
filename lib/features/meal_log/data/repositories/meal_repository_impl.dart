import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/meal_log/data/dtos/meal_dtos.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';

/// [MealRepository] 실 서버 구현 (신 계약: /meal-records + /timeline).
///
/// - Dio 직접 + unwrap + FailureMapper (food_check_impl 패턴 동일).
/// - date: KST 'YYYY-MM-DD', eatenAt: ISO-8601 +09:00 오프셋 (kst_time 헬퍼).
/// - 봉투 형태 분기(F-9): timeline=result.items[](객체 래핑) → unwrap<Map> 후 ['items'].
///   weekly/candidates=result[](직접 배열) → unwrap<List>.
class MealRepositoryImpl implements MealRepository {
  MealRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  // ---------------------------------------------------------------------------
  // 타임라인
  // ---------------------------------------------------------------------------

  @override
  Future<List<TimelineItem>> timeline(DateTime date) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.timeline,
        queryParameters: {'date': toServerDate(date)},
      );
      // result 는 {items:[...]} 객체 → unwrap<Map> 후 ['items'].
      final result = unwrap<Map<String, dynamic>>(
        response,
        (json) => json as Map<String, dynamic>,
      );
      final rawList = (result['items'] as List?) ?? const [];
      return rawList
          .map((e) => TimelineItemDto.fromJson(e as Map<String, dynamic>))
          .whereType<TimelineItem>()
          .toList();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<List<WeeklyDay>> weekly(DateTime date) async {
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.timelineWeekly,
        queryParameters: {'date': toServerDate(date)},
      );
      // result 는 직접 배열 → unwrap<List>.
      final items = unwrap<List<dynamic>>(
        response,
        (json) => json as List<dynamic>,
      );
      return items
          .map((e) => WeeklyDayDto.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // 음식 추가
  // ---------------------------------------------------------------------------

  @override
  Future<MealFood> appendFood({
    required String foodExternalId,
    DateTime? eatenAt,
    String? mealRecordId,
  }) async {
    try {
      final body = CreateMealRecordRequestDto(
        foodExternalId: foodExternalId,
        eatenAt: eatenAt != null ? toServerOffset(eatenAt) : null,
        mealRecordId: mealRecordId,
      ).toJson()
        ..removeWhere((_, v) => v == null);
      final response = await _dio.post<dynamic>(
        ApiEndpoints.mealRecords,
        data: body,
      );
      final dto = unwrap<MealFoodRecordDetailDto>(
        response,
        (j) => MealFoodRecordDetailDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<MealFood> appendFoodByText({
    required String foodTextInput,
    DateTime? eatenAt,
    String? mealRecordId,
  }) async {
    // 서버 미지원 seam. 호출부(meal_recording.dart)는 by-text 분기에서 이 메서드를
    // 호출하지 않고 "준비중" 토스트로 단락한다. 이 throw는 다른 호출자가 생기면
    // 즉시 터지게 하는 안전망이다.
    throw UnimplementedError('텍스트 음식 추가는 서버 준비중입니다');
  }

  // ---------------------------------------------------------------------------
  // 상세
  // ---------------------------------------------------------------------------

  @override
  Future<MealRecord> mealDetail(String mealRecordId) async {
    try {
      final response =
          await _dio.get<dynamic>(ApiEndpoints.mealRecordItem(mealRecordId));
      final dto = unwrap<MealRecordDetailDto>(
        response,
        (j) => MealRecordDetailDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<MealFood> foodDetail(String mealFoodId) async {
    try {
      final response =
          await _dio.get<dynamic>(ApiEndpoints.mealRecordFood(mealFoodId));
      final dto = unwrap<MealFoodRecordDetailDto>(
        response,
        (j) => MealFoodRecordDetailDto.fromJson(j as Map<String, dynamic>),
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
  Future<void> deleteMeal(String mealRecordId) async {
    try {
      final response =
          await _dio.delete<dynamic>(ApiEndpoints.mealRecordItem(mealRecordId));
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<void> deleteFood(String mealFoodId) async {
    try {
      final response =
          await _dio.delete<dynamic>(ApiEndpoints.mealRecordFood(mealFoodId));
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // 증상 연결 후보 (증상레이어 공유)
  // ---------------------------------------------------------------------------

  @override
  Future<List<MealCandidatesDay>> candidates() async {
    try {
      final response =
          await _dio.get<dynamic>(ApiEndpoints.mealRecordCandidates);
      // result 는 직접 배열 → unwrap<List>.
      final items = unwrap<List<dynamic>>(
        response,
        (json) => json as List<dynamic>,
      );
      return items
          .map(
            (e) => MealCandidatesDayDto.fromJson(e as Map<String, dynamic>)
                .toEntity(),
          )
          .toList();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
