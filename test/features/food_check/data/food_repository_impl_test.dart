import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/food_repository_impl.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

// ---------------------------------------------------------------------------
// helpers
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

Map<String, dynamic> _foodSummaryJson({
  String id = 'f-1',
  String name = '두부',
  String? category = '한식',
}) =>
    {'foodExternalId': id, 'name': name, 'category': category};

Map<String, dynamic> _recentFoodJson({
  String id = 'f-1',
  String name = '두부',
  String? category = '한식',
  String searchedAt = '2026-06-01T12:00:00.000Z',
}) =>
    {
      'foodExternalId': id,
      'name': name,
      'category': category,
      'searchedAt': searchedAt,
    };

// ---------------------------------------------------------------------------
// tests
// ---------------------------------------------------------------------------

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late FoodRepositoryImpl repo;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: _baseUrl));
    adapter = DioAdapter(dio: dio, matcher: _urlMatcher);
    repo = FoodRepositoryImpl(dio: dio);
  });

  // -------------------------------------------------------------------------
  group('search — DTO 매핑 + 경로', () {
    test('GET /foods/search?q=두부&size=20 → FoodSummary 리스트 반환', () async {
      adapter.onGet(
        ApiEndpoints.foodsSearch,
        (server) => server.reply(200, _envelope([_foodSummaryJson()])),
        queryParameters: {'q': '두부', 'size': 20},
      );

      final results = await repo.search('두부');

      expect(results.length, 1);
      expect(results.first.externalId, 'f-1');
      expect(results.first.name, '두부');
      expect(results.first.category, '한식');
    });

    test('빈 쿼리는 서버 호출 없이 빈 목록 반환', () async {
      final results = await repo.search('');
      expect(results, isEmpty);
    });

    test('공백만 있는 쿼리도 빈 목록 반환', () async {
      final results = await repo.search('   ');
      expect(results, isEmpty);
    });

    test('size 파라미터가 쿼리에 포함된다', () async {
      adapter.onGet(
        ApiEndpoints.foodsSearch,
        (server) => server.reply(200, _envelope(<dynamic>[])),
        queryParameters: {'q': '라면', 'size': 5},
      );

      final results = await repo.search('라면', size: 5);
      expect(results, isEmpty);
    });

    test('복수 결과 → FoodSummary 리스트 전체 반환', () async {
      adapter.onGet(
        ApiEndpoints.foodsSearch,
        (server) => server.reply(
          200,
          _envelope([
            _foodSummaryJson(id: 'f-1', name: '두부'),
            _foodSummaryJson(id: 'f-2', name: '된장찌개', category: '찌개'),
          ]),
        ),
        queryParameters: {'q': '두', 'size': 20},
      );

      final results = await repo.search('두');
      expect(results.length, 2);
      expect(results[0].externalId, 'f-1');
      expect(results[1].name, '된장찌개');
    });
  });

  // -------------------------------------------------------------------------
  group('recentSearches — DTO 매핑 + 경로', () {
    test('GET /foods/recent?size=10 → RecentFood 리스트 반환', () async {
      adapter.onGet(
        ApiEndpoints.foodsRecent,
        (server) => server.reply(200, _envelope([_recentFoodJson()])),
        queryParameters: {'size': 10},
      );

      final results = await repo.recentSearches();

      expect(results.length, 1);
      expect(results.first.foodExternalId, 'f-1');
      expect(results.first.name, '두부');
      expect(results.first.searchedAt, isA<DateTime>());
    });

    test('빈 결과도 빈 목록 반환', () async {
      adapter.onGet(
        ApiEndpoints.foodsRecent,
        (server) => server.reply(200, _envelope(<dynamic>[])),
        queryParameters: {'size': 10},
      );

      final results = await repo.recentSearches();
      expect(results, isEmpty);
    });

    test('category null 이어도 toEntity 성공', () async {
      adapter.onGet(
        ApiEndpoints.foodsRecent,
        (server) => server.reply(
          200,
          _envelope([_recentFoodJson(category: null)]),
        ),
        queryParameters: {'size': 10},
      );

      final results = await repo.recentSearches();
      expect(results.first.category, isNull);
    });
  });

  // -------------------------------------------------------------------------
  group('addRecent — 경로 + 바디', () {
    test('POST /foods/recent {foodExternalId} 성공', () async {
      adapter.onPost(
        ApiEndpoints.foodsRecent,
        (server) => server.reply(200, _envelope(null)),
        data: {'foodExternalId': 'f-1'},
      );

      await expectLater(repo.addRecent('f-1'), completes);
    });
  });

  // -------------------------------------------------------------------------
  group('removeRecent — 경로', () {
    test('DELETE /foods/recent/f-1 성공', () async {
      adapter.onDelete(
        ApiEndpoints.foodsRecentItem('f-1'),
        (server) => server.reply(200, _envelope(null)),
      );

      await expectLater(repo.removeRecent('f-1'), completes);
    });
  });

  // -------------------------------------------------------------------------
  group('clearRecent — 경로', () {
    test('DELETE /foods/recent 성공', () async {
      adapter.onDelete(
        ApiEndpoints.foodsRecent,
        (server) => server.reply(200, _envelope(null)),
      );

      await expectLater(repo.clearRecent(), completes);
    });
  });

  // -------------------------------------------------------------------------
  group('analyze — MockFoodRepository 위임 (서버 미출시, W3)', () {
    // analyze 는 네트워크 호출 없이 MockFoodRepository 결정론적 로직에 위임한다.
    test('두부 → recommend', () async {
      final result = await repo.analyze('두부');
      expect(result.level, VerdictLevel.recommend);
    });

    test('커피 → danger', () async {
      final result = await repo.analyze('커피');
      expect(result.level, VerdictLevel.danger);
    });

    test('된장 → caution', () async {
      final result = await repo.analyze('된장');
      expect(result.level, VerdictLevel.caution);
    });

    test('모름 → unknown', () async {
      final result = await repo.analyze('모름');
      expect(result.level, VerdictLevel.unknown);
    });

    test('analyze 결과의 foodName이 입력 텍스트와 동일하다', () async {
      const input = '두부';
      final result = await repo.analyze(input);
      expect(result.foodName, input);
    });
  });
}
