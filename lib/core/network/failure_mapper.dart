import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../error/failure.dart';
import 'api_response.dart';

/// 서버 `code` 문자열 → [Failure] 매핑 테이블.
///
/// **이 파일 한 곳에만** 매핑 테이블이 존재한다 (ADR-0007 §3-1 (2)).
/// 새 에러 코드 추가 시 [_codeToFailure] 맵만 수정한다.
///
/// 미매핑 code 는 dev 경고 로그 + [NetworkFailure] 폴백.
class FailureMapper {
  FailureMapper._();

  // ---------------------------------------------------------------------------
  // 매핑 테이블
  // ---------------------------------------------------------------------------

  static final Map<String, Failure> _codeToFailure = {
    // ── 약관 필요 (HTTP 400) ──────────────────────────────────────────────────
    'AUTH400_1': const TermsRequiredFailure(
      requirements: {TermsRequirement.email},
    ),
    'AUTH400_3': const TermsRequiredFailure(
      requirements: {TermsRequirement.nickname},
    ),

    // ── 복구 가능 계정 (HTTP 403) ─────────────────────────────────────────────
    'AUTH403_2': const RecoverableAccountFailure(reason: RecoverReason.inactive),
    'AUTH403_5': const RecoverableAccountFailure(
      reason: RecoverReason.deletionInProgress,
    ),

    // ── 토큰 무효 (HTTP 401) ──────────────────────────────────────────────────
    'AUTH401': const InvalidTokenFailure(),

    // ── 음식 판정 에러 (F2 judgment — W3-3) ──────────────────────────────────
    // FOOD400_1: 잘못된 검색어 (by-text 빈 문자열·특수문자 등)
    'FOOD400_1': const InvalidFoodQueryFailure(),
    // FOOD404_1: 음식 없음 (by-id 에서 externalId 미존재·삭제된 음식)
    'FOOD404_1': const FoodNotFoundFailure(),
    // FOOD404_2: 최근검색 단건 삭제 시 항목 없음 — judgment 무관, NetworkFailure 폴백
  };

  // ---------------------------------------------------------------------------
  // 공개 API
  // ---------------------------------------------------------------------------

  /// 서버 [code] 문자열을 [Failure] 로 변환한다.
  ///
  /// 매핑 테이블에 없는 code 는 dev 경고 로그를 출력하고
  /// [NetworkFailure] 를 반환한다.
  static Failure fromCode(String code, {String? message}) {
    final mapped = _codeToFailure[code];
    if (mapped != null) return mapped;

    // 미매핑 코드 — dev 경고
    if (kDebugMode) {
      debugPrint(
        '[FailureMapper] WARNING: unmapped server code "$code". '
        'message=$message. Falling back to NetworkFailure.',
      );
    }
    return NetworkFailure(message ?? '네트워크 오류가 발생했어요.');
  }

  /// [DioException] → [Failure] 변환.
  ///
  /// 연결 오류·타임아웃 등 HTTP 응답이 없는 케이스.
  static Failure fromDioException(DioException e) {
    if (kDebugMode) {
      debugPrint('[FailureMapper] DioException: ${e.type} — ${e.message}');
    }
    return NetworkFailure(e.message ?? '네트워크 오류가 발생했어요.');
  }
}

// ---------------------------------------------------------------------------
// unwrap 헬퍼
// ---------------------------------------------------------------------------

/// 서버 응답 [response] 에서 봉투를 벗기고 [T] 를 반환한다.
///
/// - `isSuccess == true` → [result] 를 [fromJson] 으로 역직렬화해 반환.
/// - `isSuccess == false` → [code] → [Failure] 로 변환 후 throw.
///
/// 사용 예:
/// ```dart
/// final data = unwrap<UserDto>(response, UserDto.fromJson);
/// ```
T unwrap<T>(Response<dynamic> response, T Function(Object?) fromJson) {
  final Map<String, dynamic> body;
  if (response.data is Map<String, dynamic>) {
    body = response.data as Map<String, dynamic>;
  } else {
    throw const UnexpectedFailure('응답 형식이 올바르지 않아요.');
  }

  final envelope = ApiResponse.fromJson(body, (json) => json);

  if (envelope.isSuccess) {
    if (envelope.result == null) {
      throw const UnexpectedFailure('응답에 데이터가 없어요.');
    }
    return fromJson(envelope.result);
  } else {
    throw FailureMapper.fromCode(envelope.code, message: envelope.message);
  }
}

/// 응답 데이터 없이 성공 여부만 확인하는 언랩.
///
/// 서버가 `result: null` 인 성공 응답을 보내는 엔드포인트에 사용.
void unwrapVoid(Response<dynamic> response) {
  final Map<String, dynamic> body;
  if (response.data is Map<String, dynamic>) {
    body = response.data as Map<String, dynamic>;
  } else {
    throw const UnexpectedFailure('응답 형식이 올바르지 않아요.');
  }

  final envelope = ApiResponse.fromJson(body, (json) => json);

  if (!envelope.isSuccess) {
    throw FailureMapper.fromCode(envelope.code, message: envelope.message);
  }
}
