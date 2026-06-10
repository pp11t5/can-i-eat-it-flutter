import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// 서버 공통 응답 봉투.
///
/// 모든 API 응답이 `{isSuccess, code, message, traceId, result}` 형태로 온다.
/// [result] 는 `isSuccess==true` 일 때 실제 데이터를 담고, 그 외에는 null.
///
/// 봉투는 core 에 두고, 각 피처의 DTO 는 feature/data/dtos/ 에 분리한다 (ADR-0007).
@Freezed(genericArgumentFactories: true)
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool isSuccess,
    required String code,
    required String message,
    String? traceId,
    T? result,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}
