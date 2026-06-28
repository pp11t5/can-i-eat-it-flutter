import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';

/// FCM 토큰 서버 등록/삭제 인터페이스.
abstract interface class FcmRepository {
  /// 서버에 FCM 토큰 등록. [platform]: "ios" | "android".
  Future<void> register({required String token, required String platform});

  /// 서버에서 현재 기기 FCM 토큰 삭제.
  Future<void> delete();
}

/// [FcmRepository] 구현체 — Dio + 봉투 언랩(unwrapVoid) 패턴.
class FcmRepositoryImpl implements FcmRepository {
  FcmRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<void> register({
    required String token,
    required String platform,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        ApiEndpoints.fcmTokens,
        data: {'token': token, 'platform': platform},
      );
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<void> delete() async {
    try {
      final response = await _dio.delete<dynamic>(ApiEndpoints.fcmTokens);
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
