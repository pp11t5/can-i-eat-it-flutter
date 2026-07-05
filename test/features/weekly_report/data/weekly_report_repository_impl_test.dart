import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/features/weekly_report/data/repositories/weekly_report_repository_impl.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

const _baseUrl = 'https://test.example.com';
const _urlMatcher = UrlRequestMatcher(matchMethod: true);

Map<String, dynamic> _envelope(dynamic result) => {
      'isSuccess': true,
      'code': 'SUCCESS',
      'message': 'ok',
      'traceId': null,
      'result': result,
    };

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late WeeklyReportRepositoryImpl repo;

  setUp(() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );
    adapter = DioAdapter(dio: dio, matcher: _urlMatcher);
    repo = WeeklyReportRepositoryImpl(dio: dio);
  });

  // -------------------------------------------------------------------------
  group('getWeeklyReport — GET /my-page/reports (result 객체 래핑, 실서버 봉투 1:1)', () {
    test('startDate·endDate·weekLabel·comfortableState·mealCount를 WeeklyReport로 정확히 파싱한다',
        () async {
      adapter.onGet(
        ApiEndpoints.myPageReports,
        (server) => server.reply(
          200,
          _envelope({
            'startDate': '2026-05-10',
            'endDate': '2026-05-16',
            'weekLabel': '2026년 5월 둘째주',
            'comfortableState': {
              'streakCount': 3,
              'recommendedMealCount': 6,
              'percentage': 84.3,
            },
            'mealCount': {
              'recommendCount': 6,
              'cautionCount': 3,
              'riskCount': 2,
            },
          }),
        ),
      );
      final result = await repo.getWeeklyReport();
      expect(result, isA<WeeklyReport>());
      expect(result.startDate, '2026-05-10');
      expect(result.endDate, '2026-05-16');
      expect(result.weekLabel, '2026년 5월 둘째주');
      expect(result.comfortableState.streakCount, 3);
      expect(result.comfortableState.recommendedMealCount, 6);
      expect(result.comfortableState.percentage, 84.3);
      expect(result.mealCount.recommendCount, 6);
      expect(result.mealCount.cautionCount, 3);
      expect(result.mealCount.riskCount, 2);
    });
  });

  // -------------------------------------------------------------------------
  group('getWeeklyReport — result:null 관용 처리 (W7)', () {
    test('result가 null이어도 예외 없이 빈 WeeklyReport를 반환한다', () async {
      adapter.onGet(
        ApiEndpoints.myPageReports,
        (server) => server.reply(200, _envelope(null)),
      );
      final result = await repo.getWeeklyReport();
      expect(result, isA<WeeklyReport>());
      expect(result.comfortableState.streakCount, 0);
      expect(result.mealCount.recommendCount, 0);
      expect(result.mealCount.cautionCount, 0);
      expect(result.mealCount.riskCount, 0);
      expect(result.mealCount.unknownCount, 0);
    });
  });
}
