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
    // ── 공통 400 (요청 형식 오류) ─────────────────────────────────────────────
    // COMMON400_1: 필수 파라미터 누락
    'COMMON400_1': const NetworkFailure('요청 파라미터가 누락됐어요.'),
    // COMMON400_2: 요청 형식이 올바르지 않음 (페이로드 스키마 불일치 등)
    'COMMON400_2': const NetworkFailure('요청 형식이 올바르지 않아요.'),

    // ── 공통 401 (인증) ───────────────────────────────────────────────────────
    'COMMON401_1': const InvalidTokenFailure(),

    // ── 공통 403 (권한) ───────────────────────────────────────────────────────
    'COMMON403_1': const UnexpectedFailure('접근 권한이 없어요.'),

    // ── 공통 404 (리소스 없음) ────────────────────────────────────────────────
    'COMMON404_1': const NetworkFailure('요청한 리소스를 찾을 수 없어요.'),

    // ── 공통 500 (서버 오류) ──────────────────────────────────────────────────
    'COMMON500_1': const UnexpectedFailure('서버 오류가 발생했어요. 잠시 후 다시 시도해 주세요.'),

    // ── 약관 필요 (HTTP 400) ──────────────────────────────────────────────────
    'AUTH400_1': const TermsRequiredFailure(
      requirements: {TermsRequirement.email},
    ),
    'AUTH400_3': const TermsRequiredFailure(
      requirements: {TermsRequirement.nickname},
    ),

    // ── 약관 신 계약 (POST /consent, 약관 마이그레이션) ─────────────────────────
    // ONBOARD400_1: 필수 약관 미동의(서버 측 최종 검증 거부).
    // AuthRepositoryImpl.recordTermsAgreement 의 로컬 requiredButNotAgreed
    // 검증과 동일한 사용자 메시지로 통일한다.
    'ONBOARD400_1': const NetworkFailure('필수 약관에 모두 동의해야 계속할 수 있어요.'),

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
  /// - 연결 계열(`connectionError`, `connectionTimeout`, `sendTimeout`,
  ///   `receiveTimeout`) → [NetworkFailure] (진짜 오프라인/타임아웃).
  /// - 그 외(`badResponse` 5xx 등 HTTP 응답이 있는 케이스) → [UnexpectedFailure].
  ///
  /// 이렇게 분리해야 5xx를 오프라인으로 오분류하지 않는다 (ADR-0007, H1 수정).
  static Failure fromDioException(DioException e) {
    if (kDebugMode) {
      debugPrint('[FailureMapper] DioException: ${e.type} — ${e.message}');
    }
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(e.message ?? '네트워크 오류가 발생했어요.');
      default:
        return UnexpectedFailure(e.message ?? '알 수 없는 오류가 발생했어요.');
    }
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

/// 서버 응답 [response] 에서 봉투를 벗기고 [T] 를 반환한다. [unwrap] 과 달리
/// `result` 가 `null` 이면 예외 없이 `null` 을 반환한다.
///
/// 백엔드가 항상 zero-fill 된 객체를 보낸다고 가정할 수 없는 엔드포인트
/// (예: 이번 주 리포트가 아직 없는 경우)에서 호출부가 빈 상태 엔티티로
/// 폴백할 때 사용한다 (W7). 실패 응답(`isSuccess==false`)은 [unwrap] 과
/// 동일하게 [Failure] 를 throw 한다 — null 관용은 "성공 + result:null" 케이스에만
/// 적용된다.
T? unwrapOrNull<T>(Response<dynamic> response, T Function(Object?) fromJson) {
  final Map<String, dynamic> body;
  if (response.data is Map<String, dynamic>) {
    body = response.data as Map<String, dynamic>;
  } else {
    throw const UnexpectedFailure('응답 형식이 올바르지 않아요.');
  }

  final envelope = ApiResponse.fromJson(body, (json) => json);

  if (envelope.isSuccess) {
    if (envelope.result == null) return null;
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
