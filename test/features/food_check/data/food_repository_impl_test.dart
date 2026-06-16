import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/error/failure.dart';
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

Map<String, dynamic> _errorEnvelope(String code, String message) => {
      'isSuccess': false,
      'code': code,
      'message': message,
      'traceId': null,
      'result': null,
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

/// by-text 응답 JSON 샘플.
Map<String, dynamic> _textJudgmentJson({
  String foodName = '두부',
  String grade = 'RECOMMEND',
  String personalTitle = '두부, 안심하고 드세요',
}) =>
    {
      'foodName': foodName,
      'grade': grade,
      'personalTitle': personalTitle,
      'items': [
        {'emphasis': '트리거/증상 분석', 'body': '역류 트리거에 해당하지 않아요.'},
        {'emphasis': '알레르기/복용약 분석', 'body': '알레르기 충돌 없어요.'},
      ],
      'stateRecords': {'total': 0, 'records': <dynamic>[]},
    };

/// by-id 응답 JSON 샘플.
Map<String, dynamic> _idJudgmentJson({
  String foodExternalId = 'food-ext-1',
  String foodName = '커피',
  String grade = 'RISK',
  String personalTitle = '커피, 지금은 피하는 게 좋아요',
}) =>
    {
      'foodExternalId': foodExternalId,
      'foodName': foodName,
      'category': '음료',
      'grade': grade,
      'personalTitle': personalTitle,
      'items': [
        {'emphasis': '트리거/증상 분석', 'body': '카페인이 위산 분비를 촉진해요.'},
        {'emphasis': '알레르기/복용약 분석', 'body': '복용약 충돌 없어요.'},
      ],
      'stateRecords': {
        'total': 2,
        'records': [
          {'label': '속쓰림', 'date': '2026-06-10', 'timing': '식후 30분'},
        ],
      },
      'substitutes': [
        {'foodExternalId': 'sub-1', 'name': '디카페인 커피'},
      ],
    };

// ---------------------------------------------------------------------------
// tests
// ---------------------------------------------------------------------------

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late FoodRepositoryImpl repo;

  setUp(() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        // 실 앱 dioProvider와 동일하게 400/403을 정상 Response로 전달해
        // unwrap()이 봉투 code를 읽어 Failure로 매핑하도록 한다.
        // 401은 throw (AuthInterceptor 담당), 5xx는 throw (NetworkFailure 폴백).
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );
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
  group('judgeByText — DTO 매핑 + 경로 (W3-3)', () {
    test('GET /foods/judgment?foodTextInput=두부 → EatVerdict recommend 반환', () async {
      adapter.onGet(
        ApiEndpoints.foodsJudgmentByText,
        (server) => server.reply(200, _envelope(_textJudgmentJson())),
        queryParameters: {'foodTextInput': '두부'},
      );

      final result = await repo.judgeByText('두부');

      expect(result.level, VerdictLevel.recommend);
      expect(result.foodName, '두부');
      expect(result.personalTitle, isNotEmpty);
      expect(result.items.length, 2);
      expect(result.substitutes, isEmpty);  // by-text 규약
      expect(result.foodExternalId, isNull); // by-text 규약
    });

    test('grade=UNKNOWN → VerdictLevel.unknown (성공 응답, AsyncData 경로)', () async {
      adapter.onGet(
        ApiEndpoints.foodsJudgmentByText,
        (server) => server.reply(
          200,
          _envelope(_textJudgmentJson(
            foodName: '모름음식',
            grade: 'UNKNOWN',
            personalTitle: '모름음식, 확인이 어려워요',
          )),
        ),
        queryParameters: {'foodTextInput': '모름음식'},
      );

      final result = await repo.judgeByText('모름음식');

      // grade=UNKNOWN은 성공(EatVerdict 반환) — AsyncError로 흘리면 안 됨 (D1, R3)
      expect(result.level, VerdictLevel.unknown);
    });

    test('FOOD400_1 응답 → InvalidFoodQueryFailure throw', () async {
      adapter.onGet(
        ApiEndpoints.foodsJudgmentByText,
        (server) => server.reply(
          400,
          _errorEnvelope('FOOD400_1', '잘못된 검색어입니다.'),
        ),
        queryParameters: {'foodTextInput': ''},
      );

      await expectLater(
        repo.judgeByText(''),
        throwsA(isA<InvalidFoodQueryFailure>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('judgeById — DTO 매핑 + 경로 (W3-3)', () {
    test('GET /foods/{id}/judgment → EatVerdict risk 반환 (substitutes 포함)', () async {
      adapter.onGet(
        ApiEndpoints.foodsJudgmentById('food-ext-1'),
        (server) => server.reply(200, _envelope(_idJudgmentJson())),
      );

      final result = await repo.judgeById('food-ext-1');

      expect(result.level, VerdictLevel.risk);
      expect(result.foodName, '커피');
      expect(result.foodExternalId, 'food-ext-1');
      expect(result.category, '음료');
      expect(result.items.length, 2);
      expect(result.substitutes.length, 1);
      expect(result.substitutes.first.name, '디카페인 커피');
      expect(result.stateRecords.total, 2);
      expect(result.stateRecords.records.length, 1);
    });

    test('FOOD404_1 응답 → FoodNotFoundFailure throw', () async {
      adapter.onGet(
        ApiEndpoints.foodsJudgmentById('no-such-id'),
        (server) => server.reply(
          404,
          _errorEnvelope('FOOD404_1', '음식을 찾을 수 없어요.'),
        ),
      );

      await expectLater(
        repo.judgeById('no-such-id'),
        throwsA(isA<FoodNotFoundFailure>()),
      );
    });
  });
}
