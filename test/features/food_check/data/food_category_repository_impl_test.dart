import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/food_category_repository_impl.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_category.dart';

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
  late FoodCategoryRepositoryImpl repo;

  setUp(() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );
    adapter = DioAdapter(dio: dio, matcher: _urlMatcher);
    repo = FoodCategoryRepositoryImpl(dio: dio);
  });

  group('getCategories — GET /foods/categories', () {
    test('result[]를 List<FoodCategory>로 정확히 파싱한다', () async {
      adapter.onGet(
        ApiEndpoints.foodCategories,
        (server) => server.reply(
          200,
          _envelope([
            {'code': 'soup_stew', 'displayName': '국·찌개'},
            {'code': 'noodles', 'displayName': '면'},
          ]),
        ),
      );
      final result = await repo.getCategories();
      expect(result, isA<List<FoodCategory>>());
      expect(result, hasLength(2));
      expect(result.first.code, 'soup_stew');
    });

    test('빈 목록도 정상 처리한다', () async {
      adapter.onGet(
        ApiEndpoints.foodCategories,
        (server) => server.reply(200, _envelope(<dynamic>[])),
      );
      final result = await repo.getCategories();
      expect(result, isEmpty);
    });
  });
}
