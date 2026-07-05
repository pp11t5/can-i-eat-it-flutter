import 'package:dio/dio.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';
import 'package:can_i_eat_it/features/mypage/data/dtos/my_page_summary_dto.dart';
import 'package:can_i_eat_it/features/mypage/domain/entities/my_page_summary.dart';
import 'package:can_i_eat_it/features/mypage/domain/repositories/my_page_repository.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';

/// [MyPageRepository] 실 서버 구현 (Dio 직접 + unwrap + FailureMapper,
/// weekly_report_repository_impl / dictionary_repository_impl 패턴 동일).
class MyPageRepositoryImpl implements MyPageRepository {
  MyPageRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<MyPageSummary> getSummary() async {
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.myPageSummary);
      // result:null 관용 처리 — 백엔드가 항상 zero-fill 하지 않으므로 빈 요약으로
      // 폴백해 에러 화면 대신 빈 상태를 보여준다(W7, weekly_report와 동일 원칙).
      final dto = unwrapOrNull<MyPageSummaryDto>(
        response,
        (j) => MyPageSummaryDto.fromJson(j as Map<String, dynamic>),
      );
      return dto?.toEntity() ?? _emptyMyPageSummary;
    } on DioException catch (e) {
      throw FailureMapper.fromDioException(e);
    }
  }
}

/// result:null(요약 데이터가 아직 없음) 폴백 빈 요약.
const _emptyMyPageSummary = MyPageSummary(
  profile: MyPageProfileSummary(nickName: '', disease: MyPageDisease.unknown),
  foodHistory: FoodHistorySummary(safeCount: 0, cautionCount: 0),
  weeklySummary: WeeklySummary(
    mealRecordCount: 0,
    recentSymptomCount: 0,
    streakCount: 0,
    mealCount: MealCount(
      recommendCount: 0,
      cautionCount: 0,
      riskCount: 0,
      unknownCount: 0,
    ),
  ),
);
