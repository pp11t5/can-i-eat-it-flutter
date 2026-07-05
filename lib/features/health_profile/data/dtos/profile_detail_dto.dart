import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_detail_dto.freezed.dart';
part 'profile_detail_dto.g.dart';

// ---------------------------------------------------------------------------
// 계정 제공자
// ---------------------------------------------------------------------------

/// 계정 제공자. 서버 `provider` 필드(LOCAL|KAKAO)와 매핑.
///
/// 현재 화면 표시는 [AuthSession.provider](auth 피처)를 그대로 쓰므로 이 값은
/// 아직 UI에 연결하지 않는다 — 계약 보존을 위해 DTO 레벨에만 우선 반영.
enum ProfileProvider { local, kakao, unknown }

/// [ProfileProvider] 서버 변환 확장.
extension ProfileProviderMapper on ProfileProvider {
  /// 서버 [v] 문자열을 [ProfileProvider] 로 변환한다. 미지 값은 [ProfileProvider.unknown].
  static ProfileProvider fromServer(String v) => switch (v) {
        'LOCAL' => ProfileProvider.local,
        'KAKAO' => ProfileProvider.kakao,
        _ => ProfileProvider.unknown,
      };
}

// ---------------------------------------------------------------------------
// 질환 코드
// ---------------------------------------------------------------------------

/// 질환 코드. 서버 `diseaseType`(gerd|gastritis_ulcer|ibs|functional_dyspepsia)과 매핑.
enum ProfileDiseaseType { gerd, gastritisUlcer, ibs, functionalDyspepsia, unknown }

/// [ProfileDiseaseType] 서버 변환 확장.
extension ProfileDiseaseTypeMapper on ProfileDiseaseType {
  /// 서버 [v] 문자열을 [ProfileDiseaseType] 으로 변환한다. 미지 값은 [ProfileDiseaseType.unknown].
  static ProfileDiseaseType fromServer(String v) => switch (v) {
        'gerd' => ProfileDiseaseType.gerd,
        'gastritis_ulcer' => ProfileDiseaseType.gastritisUlcer,
        'ibs' => ProfileDiseaseType.ibs,
        'functional_dyspepsia' => ProfileDiseaseType.functionalDyspepsia,
        _ => ProfileDiseaseType.unknown,
      };

  /// [conditionOptions](onboarding_options.dart) 카탈로그 코드로 변환한다.
  ///
  /// `HealthProfile.conditions` 표시 병합용 — GERD 만 대문자('GERD')이고 나머지는
  /// 서버 값과 카탈로그 코드가 다르다(예: gastritis_ulcer → 'gastritis').
  String toConditionCode() => switch (this) {
        ProfileDiseaseType.gerd => 'GERD',
        ProfileDiseaseType.gastritisUlcer => 'gastritis',
        ProfileDiseaseType.ibs => 'ibs',
        ProfileDiseaseType.functionalDyspepsia => 'functional_dyspepsia',
        ProfileDiseaseType.unknown => 'unknown',
      };
}

// ---------------------------------------------------------------------------
// ProfileDetailDto — GET /my-page/profile
// ---------------------------------------------------------------------------

/// `GET /my-page/profile` 응답 DTO (ProfileDetailResponseDTO).
///
/// [representativeInfo]/[etcCount]는 계약상 보존하되, 확정된 표시 슬롯이 없어
/// 아직 화면에 연결하지 않는다(TODO: 디자인 확정 시 연결).
@freezed
abstract class ProfileDetailDto with _$ProfileDetailDto {
  const factory ProfileDetailDto({
    @Default('') String nickName,
    String? profileImage,
    @Default('') String email,
    @Default('LOCAL') String provider,
    @Default('gerd') String diseaseType,
    String? representativeInfo,
    @Default(0) int etcCount,
  }) = _ProfileDetailDto;

  const ProfileDetailDto._();

  factory ProfileDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDetailDtoFromJson(json);

  /// [provider] 문자열을 [ProfileProvider] 로 변환한다.
  ProfileProvider get providerType => ProfileProviderMapper.fromServer(provider);

  /// [diseaseType] 문자열을 [ProfileDiseaseType] 으로 변환한다.
  ProfileDiseaseType get disease => ProfileDiseaseTypeMapper.fromServer(diseaseType);
}
