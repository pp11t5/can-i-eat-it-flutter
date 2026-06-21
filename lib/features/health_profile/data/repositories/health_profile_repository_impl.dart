import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/auth/data/dtos/onboarding_status_dto.dart';
import 'package:can_i_eat_it/features/health_profile/data/dtos/onboarding_request_dto.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/health_profile/domain/repositories/health_profile_repository.dart';

/// [HealthProfileRepository] 실 구현 (ADR-0007 §3-1 (6-D)).
///
/// - [onboardedStatus]: `GET /onboarding/status` → boolean.
/// - [submitProfile]: `POST /onboarding` → 서버 성공 후 [ProfileCache] 에 저장.
/// - [currentProfile]: 서버 GET 엔드포인트 부재 → [ProfileCache] 우선, 없으면 null.
class HealthProfileRepositoryImpl implements HealthProfileRepository {
  HealthProfileRepositoryImpl({
    required Dio dio,
    required ProfileCache cache,
  })  : _dio = dio,
        _cache = cache;

  final Dio _dio;
  final ProfileCache _cache;

  /// 캐시 우선 반환. 캐시 미존재 시 null (서버 GET 엔드포인트 부재).
  @override
  Future<HealthProfile?> currentProfile() async => _cache.read();

  @override
  Future<bool> onboardedStatus() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.onboardingStatus);
      final dto = unwrap<OnboardingStatusDto>(
        response,
        (json) => OnboardingStatusDto.fromJson(json as Map<String, dynamic>),
      );
      return dto.onboarded;
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  /// 서버 POST 성공 후에만 캐시에 저장한다 (낙관적 갱신 금지).
  @override
  Future<void> submitProfile(HealthProfile profile) async {
    try {
      final dto = OnboardingRequestDto.fromEntity(profile);
      final response = await _dio.post<dynamic>(
        ApiEndpoints.onboarding,
        data: dto.toJson(),
      );
      unwrapVoid(response);
      // 서버 성공 확인 후 캐시 저장 — 서버 실패 시 캐시 불변
      await _cache.write(profile);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
