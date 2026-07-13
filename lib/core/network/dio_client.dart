import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/flavor_config.dart';
import '../security/token_store.dart';
import 'auth_interceptor.dart';

part 'dio_client.g.dart';

// ---------------------------------------------------------------------------
// 마스킹 헬퍼 (테스트 접근 가능)
// ---------------------------------------------------------------------------

/// 로그 텍스트에서 토큰 값을 마스킹한다.
///
/// [LogInterceptor] 의 `logPrint` 콜백(_maskedLogPrint) 이 내부적으로 위임한다.
/// 테스트에서 직접 호출해 마스킹 정규식을 검증한다.
///
/// @visibleForTesting — 프로덕션 코드에서 직접 호출하지 않는다.
@visibleForTesting
String maskTokensForLog(String text) {
  var result = text;
  // JSON 필드 값 마스킹: "accessToken":"<값>" / "refreshToken":"<값>" / "idToken":"<값>"
  result = result.replaceAllMapped(
    RegExp(r'"(accessToken|refreshToken|idToken)"\s*:\s*"[^"]*"'),
    (m) => '"${m.group(1)}":"***"',
  );
  // Dart Map toString 마스킹: {idToken: eyJ...} 또는 {idToken: eyJ..., ...}
  // 값은 쉼표 또는 닫힌 중괄호 전까지 캡처한다.
  result = result.replaceAllMapped(
    RegExp(r'\b(accessToken|refreshToken|idToken)\s*:\s*([^,}\s][^,}]*)'),
    (m) => '${m.group(1)}: ***',
  );
  // Authorization 헤더 마스킹: Bearer <토큰>
  result = result.replaceAllMapped(
    RegExp(r'(Authorization\s*:\s*Bearer\s+)\S+'),
    (m) => '${m.group(1)}***',
  );
  return result;
}

/// 앱 전역에서 공유하는 Dio 인스턴스 (ADR-0007 §3-1 (1)).
///
/// ## validateStatus 정책 (CRITICAL 2)
/// 메인 instance 에만 적용:
/// - 401 → throw (AuthInterceptor.onError 가 refresh 큐잉 처리)
/// - 400/403 → **정상 Response 로 datasource 에 전달** → `unwrap()` 이 봉투
///   code 를 읽어 [TermsRequiredFailure]/[RecoverableAccountFailure] 로 매핑.
/// - 5xx → throw → [NetworkFailure] 폴백.
///
/// refreshDio 의 validateStatus 는 **건드리지 않는다** — refresh 의 401/4xx 는
/// throw 돼야 [_performRefresh] catch 가 [SessionExpiredFailure] 로 전이.
///
/// ## 인터셉터 구성
/// - [AuthInterceptor]: 요청에 Bearer 토큰 주입, 401 단일 refresh 큐잉.
/// - [LogInterceptor]: kDebugMode 에서만 로깅. 토큰 평문 노출 방지를 위해
///   `requestHeader: false`, 응답 바디는 accessToken/refreshToken 마스킹.
@riverpod
Dio dio(Ref ref) {
  final config = FlavorConfig.current;

  // refresh 전용 bare Dio — 인터셉터 없음, validateStatus 기본값 유지 (재귀 방지)
  final refreshDio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
    ),
  );

  final tokenStore = ref.watch(tokenStoreProvider);

  final instance = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      responseType: ResponseType.json,
      // CRITICAL 2: 400/403 은 정상 Response 로 datasource 에 전달해
      // unwrap() 이 봉투 code 를 읽도록 한다.
      // 401 만 throw 해 AuthInterceptor.onError(refresh) 가 작동하게 한다.
      // 5xx 는 throw → NetworkFailure 폴백.
      validateStatus: (status) =>
          status != null && status != 401 && status < 500,
    ),
  );

  // AuthInterceptor: Bearer 토큰 주입 + 401 refresh 큐잉
  instance.interceptors.add(
    AuthInterceptor(
      tokenStore: tokenStore,
      refreshDio: refreshDio,
      // onSessionExpired seam — 기본 no-op, 티켓 3 에서 AuthController 배선
      onSessionExpired: null,
    ),
  );

  // 로깅 인터셉터 — dev only
  // HIGH 1: requestHeader:false 로 Authorization 헤더 평문 노출 방지.
  // 응답 바디의 accessToken/refreshToken 은 _MaskedLogPrint 가 마스킹.
  if (kDebugMode) {
    instance.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        logPrint: _maskedLogPrint,
      ),
    );
  }

  return instance;
}

/// [LogInterceptor] 출력에서 토큰 값을 마스킹한다 (HIGH 1).
///
/// 실제 마스킹 로직은 [maskTokensForLog] 에 위임한다.
void _maskedLogPrint(Object object) {
  debugPrint('[Dio] ${maskTokensForLog(object.toString())}');
}
