import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/auth/data/dtos/onboarding_status_dto.dart';
import 'package:can_i_eat_it/features/health_profile/data/dtos/medical_info_dto.dart';
import 'package:can_i_eat_it/features/health_profile/data/dtos/onboarding_request_dto.dart';
import 'package:can_i_eat_it/features/health_profile/data/dtos/profile_detail_dto.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/health_profile/domain/repositories/health_profile_repository.dart';

/// [HealthProfileRepository] 실 구현 (ADR-0007 §3-1 (6-D), W7 프로필/건강정보 서버 마이그레이션).
///
/// - [onboardedStatus]: `GET /onboarding/status` → boolean.
/// - [submitProfile]: `POST /onboarding` → 서버 성공 후 [ProfileCache] 에 저장(온보딩 최초 제출 전용, 불변).
/// - [currentProfile]: **표시 전용(cosmetic)**. `GET /my-page/health-info` + `GET /my-page/profile`을
///   각각 독립적으로 조회해 성공분만 병합. 네트워크 오류·파싱 실패 시 [ProfileCache](오프라인
///   폴백)로 대체 — 크래시 금지. **편집 화면 초기화에는 사용하지 말 것** — [fetchMedicalInfoStrict] 사용.
/// - [fetchMedicalInfoStrict]: 편집 화면 전용. 캐시 폴백 없이 실패를 그대로 throw.
/// - [updateHealthInfo]: `PATCH /my-page/health-info` → 서버 성공 후 캐시 갱신(기존 캐시 필드 보존).
class HealthProfileRepositoryImpl implements HealthProfileRepository {
  HealthProfileRepositoryImpl({
    required Dio dio,
    required ProfileCache cache,
  })  : _dio = dio,
        _cache = cache;

  final Dio _dio;
  final ProfileCache _cache;

  /// `GET /my-page/health-info` + `GET /my-page/profile`을 **독립적으로** 조회해 병합한다.
  ///
  /// 표시 전용(cosmetic) — 한쪽이 실패해도 다른 쪽 성공분은 버리지 않는다(pr-review
  /// 의료안전 플래그#2 — health-info 같은 안전필수 데이터를 profile 같은 cosmetic 실패로
  /// 폐기하지 않음). 두 응답 모두 `result:null`이면 온보딩 미완료로 간주해 null을 반환한다.
  ///
  /// 캐시 병합은 기존 캐시(symptomFrequency/triggerFoods/customTriggers/diagnosed 등)를
  /// 베이스로 conditions/allergies/medications만 교체한다 — 신규 3필드 엔티티로 캐시를
  /// 통째로 덮어써 다른 필드를 소실시키지 않는다.
  ///
  /// [DioException]·[FormatException] 등 조회/파싱 오류는 throw 하지 않고 [ProfileCache]
  /// (직전 성공 시 저장된 오프라인 폴백)로 대체한다 — 크래시 금지. 그 외 예외(프로그래밍 오류)는
  /// 표면화하도록 좁게만 잡는다.
  @override
  Future<HealthProfile?> currentProfile() async {
    MedicalInfoDto? healthInfo;
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.myPageHealthInfo);
      healthInfo = unwrapOrNull<MedicalInfoDto>(
        response,
        (json) => MedicalInfoDto.fromJson(json as Map<String, dynamic>),
      );
    } on DioException {
      healthInfo = null;
    } on FormatException {
      healthInfo = null;
    }

    ProfileDetailDto? profileDetail;
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.myPageProfile);
      profileDetail = unwrapOrNull<ProfileDetailDto>(
        response,
        (json) => ProfileDetailDto.fromJson(json as Map<String, dynamic>),
      );
    } on DioException {
      profileDetail = null;
    } on FormatException {
      profileDetail = null;
    }

    if (healthInfo == null && profileDetail == null) {
      // 둘 다 실패/미존재 — 오프라인 캐시로 폴백(온보딩 미완료 포함, 크래시 금지).
      return _cache.read();
    }

    final base = await _cache.read() ?? const HealthProfile();
    final merged = base.copyWith(
      conditions: profileDetail != null
          ? [profileDetail.disease.toConditionCode()]
          : base.conditions,
      allergies: healthInfo?.allergies ?? base.allergies,
      medications: healthInfo?.medications ?? base.medications,
    );

    // 다음 오프라인 폴백을 위해 최신 값을 캐시에 반영.
    await _cache.write(merged);
    return merged;
  }

  /// 편집 화면 전용 — 캐시 폴백 없이 서버 최신 allergies/medications를 조회한다.
  ///
  /// [currentProfile]과 달리 실패를 그대로 throw한다(unwrap 사용, unwrapOrNull 금지) —
  /// 편집 화면이 stale 캐시를 진실로 오인해 PATCH로 알레르기 정보를 덮어써 소실시키는
  /// 것을 방지한다(pr-review 의료안전 ②-1). conditions 등 다른 필드는 기본값으로 채운다
  /// (이 메서드는 allergies/medications 전용).
  @override
  Future<HealthProfile> fetchMedicalInfoStrict() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.myPageHealthInfo);
      final dto = unwrap<MedicalInfoDto>(
        response,
        (json) => MedicalInfoDto.fromJson(json as Map<String, dynamic>),
      );
      return HealthProfile(allergies: dto.allergies, medications: dto.medications);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

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

  /// 서버 PATCH 성공 후에만 캐시를 갱신한다 (낙관적 갱신 금지, [submitProfile]과 동일 원칙).
  ///
  /// [submitProfile]과 달리 allergens/medications 두 필드만 전송한다
  /// (allergy_med_edit_screen의 전체 프로필 재제출 워크어라운드 대체, W7).
  @override
  Future<void> updateHealthInfo({
    required List<String> allergies,
    required List<String> medications,
  }) async {
    try {
      final dto = MedicalInfoUpdateRequestDto(
        allergens: allergies,
        medications: medications,
      );
      // TODO(be-confirm): PATCH가 allergens/medications 배열을 전량 교체함을
      // 서버 계약으로 확인(부분 병합 semantics일 경우 이 클라이언트 가정이 깨짐).
      final response = await _dio.patch<dynamic>(
        ApiEndpoints.myPageHealthInfo,
        data: dto.toJson(),
      );
      unwrapVoid(response);
      // 캐시에 반영된 이전 프로필이 있으면 allergies/medications만 교체, 없으면 최소 필드만 구성.
      final cached = await _cache.read();
      final next = (cached ?? const HealthProfile()).copyWith(
        allergies: allergies,
        medications: medications,
      );
      await _cache.write(next);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
