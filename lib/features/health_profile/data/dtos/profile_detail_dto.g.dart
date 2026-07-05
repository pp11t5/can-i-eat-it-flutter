// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileDetailDto _$ProfileDetailDtoFromJson(Map<String, dynamic> json) =>
    _ProfileDetailDto(
      nickName: json['nickName'] as String? ?? '',
      profileImage: json['profileImage'] as String?,
      email: json['email'] as String? ?? '',
      provider: json['provider'] as String? ?? 'LOCAL',
      diseaseType: json['diseaseType'] as String? ?? 'gerd',
      representativeInfo: json['representativeInfo'] as String?,
      etcCount: (json['etcCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProfileDetailDtoToJson(_ProfileDetailDto instance) =>
    <String, dynamic>{
      'nickName': instance.nickName,
      'profileImage': instance.profileImage,
      'email': instance.email,
      'provider': instance.provider,
      'diseaseType': instance.diseaseType,
      'representativeInfo': instance.representativeInfo,
      'etcCount': instance.etcCount,
    };
