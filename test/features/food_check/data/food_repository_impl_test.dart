import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/features/food_check/data/dtos/food_summary_dto.dart';
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
    // 실서버 GET /foods/search 응답 키는 'externalId' (recent는 'foodExternalId').
    {'externalId': id, 'name': name, 'category': category};

Map<String, dynamic> _searchResultJson({
  List<Map<String, dynamic>> foods = const [],
  bool hasExactMatch = false,
}) =>
    {'foods': foods, 'hasExactMatch': hasExactMatch};

Map<String, dynamic> _recentFoodJson({
  int id = 1,
  String query = '두부',
  String searchedAt = '2026-06-01T12:00:00.000Z',
}) =>
    {
      'id': id,
      'query': query,
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
          {
            'stateRecordId': 'state-1',
            'label': '속쓰림',
            'date': '2026-06-10',
            'timingMinutes': 30,
          },
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
    test('GET /foods/search?q=두부&size=10 → 결과와 정확 일치 여부를 반환', () async {
      adapter.onGet(
        ApiEndpoints.foodsSearch,
        (server) => server.reply(
          200,
          _envelope(_searchResultJson(
            foods: [_foodSummaryJson()],
            hasExactMatch: true,
          )),
        ),
        queryParameters: {'q': '두부', 'size': 10},
      );

      final result = await repo.search('두부');

      expect(result.foods, hasLength(1));
      expect(result.foods.first.externalId, 'f-1');
      expect(result.foods.first.name, '두부');
      expect(result.foods.first.category, '한식');
      expect(result.hasExactMatch, isTrue);
    });

    test('빈 쿼리는 서버 호출 없이 빈 목록 반환', () async {
      final result = await repo.search('');
      expect(result.foods, isEmpty);
    });

    test('공백만 있는 쿼리도 빈 목록 반환', () async {
      final result = await repo.search('   ');
      expect(result.foods, isEmpty);
    });

    test('size 파라미터가 쿼리에 포함된다', () async {
      adapter.onGet(
        ApiEndpoints.foodsSearch,
        (server) => server.reply(200, _envelope(_searchResultJson())),
        queryParameters: {'q': '라면', 'size': 5},
      );

      final result = await repo.search('라면', size: 5);
      expect(result.foods, isEmpty);
    });

    test('복수 결과와 hasExactMatch=false를 함께 반환', () async {
      adapter.onGet(
        ApiEndpoints.foodsSearch,
        (server) => server.reply(
          200,
          _envelope(_searchResultJson(
            foods: [
              _foodSummaryJson(id: 'f-1', name: '두부'),
              _foodSummaryJson(id: 'f-2', name: '된장찌개', category: '찌개'),
            ],
          )),
        ),
        queryParameters: {'q': '두', 'size': 10},
      );

      final result = await repo.search('두');
      expect(result.foods, hasLength(2));
      expect(result.foods[0].externalId, 'f-1');
      expect(result.foods[1].name, '된장찌개');
      expect(result.hasExactMatch, isFalse);
    });

    // -----------------------------------------------------------------------
    // W3-4 회귀 테스트: 실서버 응답 형태(externalId 키) 6건 파싱 검증
    // 실측: {"result":{"foods":[{"externalId":"...","name":"..."}],"hasExactMatch":false}}
    // -----------------------------------------------------------------------
    test('실서버 응답 형태(externalId 키) 6건 → FoodSummary 6건 정상 파싱', () async {
      final serverLikePayload = [
        {
          'externalId': 'cc948505-46c9-454d-987e-e7577486cede',
          'name': '된장찌개',
          'category': 'soup_stew'
        },
        {
          'externalId': 'aa111111-0000-0000-0000-000000000001',
          'name': '김치찌개',
          'category': 'soup_stew'
        },
        {
          'externalId': 'bb222222-0000-0000-0000-000000000002',
          'name': '두부',
          'category': 'tofu'
        },
        {
          'externalId': 'cc333333-0000-0000-0000-000000000003',
          'name': '미역국',
          'category': 'soup'
        },
        {
          'externalId': 'dd444444-0000-0000-0000-000000000004',
          'name': '고등어구이',
          'category': 'fish'
        },
        {
          'externalId': 'ee555555-0000-0000-0000-000000000005',
          'name': '바나나',
          'category': 'fruit'
        },
      ];

      adapter.onGet(
        ApiEndpoints.foodsSearch,
        (server) => server.reply(
          200,
          _envelope(_searchResultJson(foods: serverLikePayload)),
        ),
        queryParameters: {'q': '찌개', 'size': 10},
      );

      final result = await repo.search('찌개');

      expect(result.foods, hasLength(6),
          reason: '실서버 externalId 키 파싱 실패 시 빈 목록 반환 버그 재현');
      expect(
          result.foods[0].externalId, 'cc948505-46c9-454d-987e-e7577486cede');
      expect(result.foods[0].name, '된장찌개');
      expect(result.foods[0].category, 'soup_stew');
      expect(
          result.foods[1].externalId, 'aa111111-0000-0000-0000-000000000001');
      expect(result.foods[1].name, '김치찌개');
      expect(
          result.foods[5].externalId, 'ee555555-0000-0000-0000-000000000005');
      expect(result.foods[5].name, '바나나');
    });

    test('FoodSummaryDto.fromJson — externalId 키로 직접 역직렬화', () {
      // DTO 단위: 실서버 JSON을 직접 fromJson에 넣어 externalId 키를 읽는지 검증.
      const serverJson = {
        'externalId': 'cc948505-46c9-454d-987e-e7577486cede',
        'name': '된장찌개',
        'category': 'soup_stew',
      };

      final dto = FoodSummaryDto.fromJson(serverJson);
      final entity = dto.toEntity();

      expect(entity.externalId, 'cc948505-46c9-454d-987e-e7577486cede');
      expect(entity.name, '된장찌개');
      expect(entity.category, 'soup_stew');
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
      expect(results.first.id, 1);
      expect(results.first.query, '두부');
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

    test('서버 recent DTO(id·query·searchedAt)를 파싱한다', () async {
      adapter.onGet(
        ApiEndpoints.foodsRecent,
        (server) => server.reply(
          200,
          _envelope([_recentFoodJson(id: 42, query: '된장찌개')]),
        ),
        queryParameters: {'size': 10},
      );

      final results = await repo.recentSearches();
      expect(results.first.id, 42);
      expect(results.first.query, '된장찌개');
    });
  });

  // -------------------------------------------------------------------------
  group('removeRecent — 경로', () {
    test('DELETE /foods/recent/{id} 성공', () async {
      adapter.onDelete(
        ApiEndpoints.foodsRecentItem(42),
        (server) => server.reply(200, _envelope(null)),
      );

      await expectLater(repo.removeRecent(42), completes);
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
    test('GET /foods/judgment?name=두부 → EatVerdict recommend 반환', () async {
      adapter.onGet(
        ApiEndpoints.foodsJudgmentByText,
        (server) => server.reply(200, _envelope(_textJudgmentJson())),
        queryParameters: {'name': '두부'},
      );

      final result = await repo.judgeByText('두부');

      expect(result.level, VerdictLevel.recommend);
      expect(result.foodName, '두부');
      expect(result.personalTitle, isNotEmpty);
      expect(result.items.length, 2);
      expect(result.substitutes, isEmpty); // by-text 규약
      expect(result.foodExternalId, isNull); // by-text 규약
    });

    test('grade=UNKNOWN → VerdictLevel.unknown (성공 응답, AsyncData 경로)',
        () async {
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
        queryParameters: {'name': '모름음식'},
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
        queryParameters: {'name': ''},
      );

      await expectLater(
        repo.judgeByText(''),
        throwsA(isA<InvalidFoodQueryFailure>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  group('judgeById — DTO 매핑 + 경로 (W3-3)', () {
    test('GET /foods/{id}/judgment → EatVerdict risk 반환 (substitutes 포함)',
        () async {
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
