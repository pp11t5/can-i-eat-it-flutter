// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_me_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthMeResponseDto _$AuthMeResponseDtoFromJson(Map<String, dynamic> json) =>
    _AuthMeResponseDto(
      userId: json['userId'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$AuthMeResponseDtoToJson(_AuthMeResponseDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'email': instance.email,
      'profileImage': instance.profileImage,
    };
