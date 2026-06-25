import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/notification/data/dtos/notification_dtos.dart';
import 'package:can_i_eat_it/features/notification/domain/entities/notification_settings.dart';
import 'package:can_i_eat_it/features/notification/domain/repositories/notification_repository.dart';

/// [NotificationRepository] 실 서버 구현.
///
/// - Dio 직접 + unwrap/unwrapVoid + FailureMapper (symptom_repository_impl 패턴 동일).
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  // ---------------------------------------------------------------------------
  // fetch — GET /notifications/settings
  // ---------------------------------------------------------------------------

  @override
  Future<NotificationSettings> fetch() async {
    try {
      final response =
          await _dio.get<dynamic>(ApiEndpoints.notificationSettings);
      final dto = unwrap<NotificationSettingResponseDto>(
        response,
        (j) => NotificationSettingResponseDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // toggle — PATCH /notifications/settings/toggle
  // ---------------------------------------------------------------------------

  @override
  Future<void> toggle(NotificationToggleType type) async {
    try {
      final body = NotificationToggleRequestDto(type: type.toServer()).toJson();
      final response = await _dio.patch<dynamic>(
        ApiEndpoints.notificationSettingsToggle,
        data: body,
      );
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }

  // ---------------------------------------------------------------------------
  // updateDailyTime — PATCH /notifications/settings/daily-time
  // ---------------------------------------------------------------------------

  @override
  Future<void> updateDailyTime(DailyNotificationTime time) async {
    try {
      final body =
          NotificationDailyTimeRequestDto(time: time.toServer()).toJson();
      final response = await _dio.patch<dynamic>(
        ApiEndpoints.notificationSettingsDailyTime,
        data: body,
      );
      unwrapVoid(response);
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
