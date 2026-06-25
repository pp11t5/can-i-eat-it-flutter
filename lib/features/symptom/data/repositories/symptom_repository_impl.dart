import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/data/dtos/symptom_dtos.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';
import 'package:can_i_eat_it/features/symptom/domain/repositories/symptom_repository.dart';

/// [SymptomRepository] 실 서버 구현.
///
/// - Dio 직접 + unwrap/unwrapVoid + FailureMapper (meal_repository_impl 패턴 동일).
/// - occurredAt: toServerOffset(dt) 직렬화 직전 1회만. 시간 연산 금지.
/// - null 필드: body..removeWhere((_,v)=>v==null) 로 누락 (appendFood 패턴).
class SymptomRepositoryImpl implements SymptomRepository {
  SymptomRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  // ---------------------------------------------------------------------------
  // create — POST /symptoms
  // ---------------------------------------------------------------------------

  @override
  Future<Symptom> create(SymptomDraft draft) async {
    try {
      final body = SymptomCreateRequestDto(
        symptomState: draft.symptomState.toServer(),
        symptomTypes: draft.symptomTypes.map((t) => t.toServer()).toList(),
        occurredAt:
            draft.occurredAt != null ? toServerOffset(draft.occurredAt!) : null,
        mealRecordId: draft.mealRecordId,
        memo: draft.memo,
      ).toJson()
        ..removeWhere((_, v) => v == null);

      final response = await _dio.post<dynamic>(
        ApiEndpoints.symptoms,
        data: body,
      );
      final dto = unwrap<SymptomResponseDto>(
        response,
        (j) => SymptomResponseDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // detail — GET /symptoms/{symptomId}
  // ---------------------------------------------------------------------------

  @override
  Future<Symptom> detail(String symptomId) async {
    try {
      final response =
          await _dio.get<dynamic>(ApiEndpoints.symptomItem(symptomId));
      final dto = unwrap<SymptomResponseDto>(
        response,
        (j) => SymptomResponseDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // update — PUT /symptoms/{symptomId}
  // ---------------------------------------------------------------------------

  @override
  Future<void> update(String symptomId, SymptomDraft draft) async {
    try {
      // update 시 occurredAt 필수 (서버 계약) — 호출자가 보장.
      final body = SymptomUpdateRequestDto(
        symptomState: draft.symptomState.toServer(),
        symptomTypes: draft.symptomTypes.map((t) => t.toServer()).toList(),
        occurredAt: toServerOffset(draft.occurredAt!),
        mealRecordId: draft.mealRecordId,
        memo: draft.memo,
      ).toJson()
        ..removeWhere((_, v) => v == null);

      final response = await _dio.put<dynamic>(
        ApiEndpoints.symptomItem(symptomId),
        data: body,
      );
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // updateMemo — PATCH /symptoms/{symptomId}/memo
  // ---------------------------------------------------------------------------

  @override
  Future<void> updateMemo(String symptomId, String? memo) async {
    try {
      final body = SymptomMemoUpdateRequestDto(memo: memo).toJson();
      final response = await _dio.patch<dynamic>(
        ApiEndpoints.symptomMemo(symptomId),
        data: body,
      );
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // delete — DELETE /symptoms/{symptomId}
  // ---------------------------------------------------------------------------

  @override
  Future<void> delete(String symptomId) async {
    try {
      final response =
          await _dio.delete<dynamic>(ApiEndpoints.symptomItem(symptomId));
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
