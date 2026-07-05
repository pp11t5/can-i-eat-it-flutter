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
      // result:null 관용 처리 — 백엔드가 항상 zero-fill 하지 않으므로 빈 리포트로
      // 폴백해 에러 화면 대신 빈 상태를 보여준다(W7).
      final dto = unwrapOrNull<WeeklyReportDto>(
        response,
        (j) => WeeklyReportDto.fromJson(j as Map<String, dynamic>),
      );
      return dto?.toEntity() ?? _emptyWeeklyReport;
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}

/// result:null(이번 주 리포트가 아직 없음) 폴백 빈 리포트.
///
/// startDate/endDate/weekLabel은 서버 원문이 없어 빈 문자열이다 — 화면의
/// 날짜·주차 라벨은 빈 값을 그대로 통과시켜 크래시 없이 렌더한다.
const _emptyWeeklyReport = WeeklyReport(
  startDate: '',
  endDate: '',
  weekLabel: '',
  comfortableState: ComfortableState(
    streakCount: 0,
    recommendedMealCount: 0,
    percentage: 0,
  ),
  mealCount: MealCount(
    recommendCount: 0,
    cautionCount: 0,
    riskCount: 0,
    unknownCount: 0,
  ),
);
