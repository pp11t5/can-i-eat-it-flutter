// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_login_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthLoginResponseDto _$AuthLoginResponseDtoFromJson(
        Map<String, dynamic> json) =>
    _AuthLoginResponseDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      userId: json['userId'] as String,
      email: json['email'] as String?,
      role: json['role'] as String,
    );

Map<String, dynamic> _$AuthLoginResponseDtoToJson(
        _AuthLoginResponseDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'userId': instance.userId,
      'email': instance.email,
      'role': instance.role,
    };
