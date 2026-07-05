import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/features/mypage/data/repositories/my_page_repository_impl.dart';
import 'package:can_i_eat_it/features/mypage/domain/entities/my_page_summary.dart';

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
  late MyPageRepositoryImpl repo;

  setUp(() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );
    adapter = DioAdapter(dio: dio, matcher: _urlMatcher);
    repo = MyPageRepositoryImpl(dio: dio);
  });

  // -------------------------------------------------------------------------
  group('getSummary — GET /my-page/summary (result 객체 래핑, 실서버 봉투 1:1)', () {
    test('profile·foodHistory·weeklySummary를 MyPageSummary로 정확히 파싱한다', () async {
      adapter.onGet(
        ApiEndpoints.myPageSummary,
        (server) => server.reply(
          200,
          _envelope({
            'profile': {
              'nickName': '홍길동',
              'profileImage': 'https://example.com/a.png',
              'disease': 'gerd',
            },
            'foodHistory': {
              'safeCount': 12,
              'cautionCount': 4,
            },
            'weeklySummary': {
              'mealRecordCount': 9,
              'recentSymptomCount': 2,
              'streakCount': 4,
              'mealCount': {
                'recommendCount': 9,
                'cautionCount': 3,
                'riskCount': 1,
                'unknownCount': 0,
              },
            },
          }),
        ),
      );
      final result = await repo.getSummary();
      expect(result, isA<MyPageSummary>());
      expect(result.profile.nickName, '홍길동');
      expect(result.profile.profileImage, 'https://example.com/a.png');
      expect(result.profile.disease, MyPageDisease.gerd);
      expect(result.foodHistory.safeCount, 12);
      expect(result.foodHistory.cautionCount, 4);
      expect(result.weeklySummary.mealRecordCount, 9);
      expect(result.weeklySummary.recentSymptomCount, 2);
      expect(result.weeklySummary.streakCount, 4);
      expect(result.weeklySummary.mealCount.recommendCount, 9);
      expect(result.weeklySummary.mealCount.cautionCount, 3);
      expect(result.weeklySummary.mealCount.riskCount, 1);
    });
  });

  // -------------------------------------------------------------------------
  group('getSummary — result:null 관용 처리 (W7)', () {
    test('result가 null이어도 예외 없이 빈 MyPageSummary를 반환한다', () async {
      adapter.onGet(
        ApiEndpoints.myPageSummary,
        (server) => server.reply(200, _envelope(null)),
      );
      final result = await repo.getSummary();
      expect(result, isA<MyPageSummary>());
      expect(result.profile.nickName, '');
      expect(result.profile.disease, MyPageDisease.unknown);
      expect(result.foodHistory.safeCount, 0);
      expect(result.foodHistory.cautionCount, 0);
      expect(result.weeklySummary.mealRecordCount, 0);
      expect(result.weeklySummary.mealCount.recommendCount, 0);
    });
  });
}
