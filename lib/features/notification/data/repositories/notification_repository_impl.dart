import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/notification/domain/repositories/notification_repository.dart';

/// [NotificationRepository] 실 서버 구현.
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<bool> fetchMarketingEnabled() async {
    try {
      final response =
          await _dio.get<dynamic>(ApiEndpoints.notificationSettings);
      // BE 기본값과 동일하게 값이 없으면 미동의로 본다.
      return unwrap<bool>(
        response,
        (j) =>
            (j as Map<String, dynamic>)['marketingEnabled'] as bool? ?? false,
      );
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  @override
  Future<bool> toggleMarketingConsent() async {
    try {
      final response =
          await _dio.patch<dynamic>(ApiEndpoints.consentMarketingToggle);
      return unwrap<bool>(response, (j) => j as bool);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
