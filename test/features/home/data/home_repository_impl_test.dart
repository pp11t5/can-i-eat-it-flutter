import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/features/home/data/repositories/home_repository_impl.dart';
import 'package:can_i_eat_it/features/home/domain/entities/recent_meal.dart';

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
  late HomeRepositoryImpl repo;

  setUp(() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );
    adapter = DioAdapter(dio: dio, matcher: _urlMatcher);
    repo = HomeRepositoryImpl(dio: dio);
  });

  // -------------------------------------------------------------------------
  group('unrecordedMealCount — GET /meal-records/unrecorded-count', () {
    test('result.count를 정확히 반환한다', () async {
      adapter.onGet(
        ApiEndpoints.mealRecordsUnrecordedCount,
        (server) => server.reply(200, _envelope({'count': 3})),
      );
      final result = await repo.unrecordedMealCount();
      expect(result, 3);
    });

    test('count 누락 시 0으로 폴백된다', () async {
      adapter.onGet(
        ApiEndpoints.mealRecordsUnrecordedCount,
        (server) => server.reply(200, _envelope(<String, dynamic>{})),
      );
      final result = await repo.unrecordedMealCount();
      expect(result, 0);
    });
  });

  // -------------------------------------------------------------------------
  group('recentFoods — GET /meal-records/recent-foods', () {
    test('result[]를 List<RecentMeal>로 정확히 파싱한다', () async {
      adapter.onGet(
        ApiEndpoints.mealRecordsRecentFoods,
        (server) => server.reply(
          200,
          _envelope([
            {
              'foodName': '된장찌개',
              'category': 'soup_stew',
              'eatenAt': '2026-07-05T12:30:00+09:00',
              'symptomState': 'comfortable',
            },
            {
              'foodName': '아메리카노',
              'eatenAt': '2026-07-05T09:00:00+09:00',
            },
          ]),
        ),
      );
      final result = await repo.recentFoods();
      expect(result, isA<List<RecentMeal>>());
      expect(result, hasLength(2));
      expect(result[0].foodName, '된장찌개');
      expect(result[0].symptomState, isNotNull);
      expect(result[1].foodName, '아메리카노');
      expect(result[1].symptomState, isNull);
    });

    test('빈 목록도 정상 처리한다', () async {
      adapter.onGet(
        ApiEndpoints.mealRecordsRecentFoods,
        (server) => server.reply(200, _envelope(<dynamic>[])),
      );
      final result = await repo.recentFoods();
      expect(result, isEmpty);
    });
  });
}
