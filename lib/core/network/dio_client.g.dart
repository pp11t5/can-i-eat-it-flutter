// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioHash() => r'b5e9d66f61a55c492a93719fdf9553882dfa6c64';

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
///
/// Copied from [dio].
@ProviderFor(dio)
final dioProvider = AutoDisposeProvider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioRef = AutoDisposeProviderRef<Dio>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
