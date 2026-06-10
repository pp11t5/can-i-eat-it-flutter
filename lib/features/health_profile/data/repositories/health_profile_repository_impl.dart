import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/auth/data/dtos/onboarding_status_dto.dart';
import 'package:can_i_eat_it/features/health_profile/data/dtos/onboarding_request_dto.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/health_profile/domain/repositories/health_profile_repository.dart';

/// [HealthProfileRepository] 실 구현 (ADR-0007 §3-1 (6-D)).
///
/// - [onboardedStatus]: `GET /onboarding/status` → boolean.
/// - [submitProfile]: `POST /onboarding` → void.
/// - [currentProfile]: 실서버에 전체 프로필 GET 엔드포인트 부재로 W3에서 항상 null 반환.
///   게이트 판정에는 [onboardedStatus]를 사용한다 (ADR-0007 §3-1 (6-D)).
class HealthProfileRepositoryImpl implements HealthProfileRepository {
  HealthProfileRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// W3에서 전체 프로필 GET 엔드포인트 부재 — null 반환.
  ///
  /// 게이트는 [onboardedStatus]를 사용하므로 이 메서드가 null을 반환해도
  /// 세션 상태 판정에 영향 없다 (ADR-0007 §3-1 (6-D)).
  @override
  Future<HealthProfile?> currentProfile() async => null;

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

  @override
  Future<void> submitProfile(HealthProfile profile) async {
    try {
      final dto = OnboardingRequestDto.fromEntity(profile);
      final response = await _dio.post<dynamic>(
        ApiEndpoints.onboarding,
        data: dto.toJson(),
      );
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
