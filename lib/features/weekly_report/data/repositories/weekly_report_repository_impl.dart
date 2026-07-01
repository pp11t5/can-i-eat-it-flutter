import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/weekly_report/data/dtos/weekly_report_dto.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/repositories/weekly_report_repository.dart';

/// [WeeklyReportRepository] 실 서버 구현 (Dio 직접 + unwrap + FailureMapper,
/// meal_repository_impl / dictionary_repository_impl 패턴 동일).
class WeeklyReportRepositoryImpl implements WeeklyReportRepository {
  WeeklyReportRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<WeeklyReport> getWeeklyReport() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.myPageReports);
      final dto = unwrap<WeeklyReportDto>(
        response,
        (j) => WeeklyReportDto.fromJson(j as Map<String, dynamic>),
      );
      return dto.toEntity();
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}
