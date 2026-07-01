import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/repositories/dictionary_repository_impl.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/entities/dictionary_food.dart';

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
  late DictionaryRepositoryImpl repo;

  setUp(() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );
    adapter = DioAdapter(dio: dio, matcher: _urlMatcher);
    repo = DictionaryRepositoryImpl(dio: dio);
  });

  // -------------------------------------------------------------------------
  group('getSafe — GET /dictionary/safe (result 객체 래핑)', () {
    test('items[]·categoryCode·hasNext를 DictionaryPage로 정확히 파싱한다', () async {
      adapter.onGet(
        ApiEndpoints.dictionarySafe,
        (server) => server.reply(
          200,
          _envelope({
            'items': [
              {'foodId': 'f1', 'name': '로제 파스타', 'code': 'noodles'},
            ],
            'nextCursor': null,
            'hasNext': false,
          }),
        ),
      );
      final result = await repo.getSafe();
      expect(result, isA<DictionaryPage>());
      expect(result.items.length, 1);
      expect(result.items[0].foodId, 'f1');
      expect(result.items[0].verdict, VerdictLevel.recommend);
      expect(result.items[0].categoryCode, 'noodles');
      expect(result.hasNext, isFalse);
      expect(result.nextCursor, isNull);
    });
  });

  // -------------------------------------------------------------------------
  group('getCautionRisk — GET /dictionary/caution-risk (result 객체 래핑)', () {
    test('items[].type "risk" → verdict==risk 로 정확히 파싱한다', () async {
      adapter.onGet(
        ApiEndpoints.dictionaryCautionRisk,
        (server) => server.reply(
          200,
          _envelope({
            'items': [
              {
                'foodId': 'f2',
                'name': '커피',
                'code': 'BEVERAGE',
                'type': 'risk',
              },
            ],
            'nextCursor': 3,
            'hasNext': true,
          }),
        ),
      );
      final result = await repo.getCautionRisk();
      expect(result.items.length, 1);
      expect(result.items[0].foodId, 'f2');
      expect(result.items[0].verdict, VerdictLevel.risk);
      expect(result.nextCursor, 3);
      expect(result.hasNext, isTrue);
    });
  });

  // -------------------------------------------------------------------------
  group('getCount — GET /dictionary/count (result 객체 직접)', () {
    test('safeCount·cautionRiskCount를 DictionaryCount로 정확히 파싱한다', () async {
      adapter.onGet(
        ApiEndpoints.dictionaryCount,
        (server) => server.reply(
          200,
          _envelope({'safeCount': 12, 'cautionRiskCount': 8}),
        ),
      );
      final result = await repo.getCount();
      expect(result, isA<DictionaryCount>());
      expect(result.safeCount, 12);
      expect(result.cautionRiskCount, 8);
    });
  });

  // -------------------------------------------------------------------------
  // cursor 쿼리 전달 검증.
  //
  // UrlRequestMatcher(matchMethod: true)는 route·method만 매칭하고
  // queryParameters는 검사하지 않으므로(matches_request.dart 확인), 실제
  // 전송된 쿼리는 인터셉터로 직접 캡처해 검증한다 (meal_repository_impl_test와
  // 달리 실질 검증이 필요해 도입 — 1행 근거).
  // -------------------------------------------------------------------------
  group('getSafe — cursor 쿼리 파라미터 전달', () {
    test('cursor 지정 시 queryParameters에 cursor가 포함된다', () async {
      Map<String, dynamic>? captured;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options.queryParameters;
            handler.next(options);
          },
        ),
      );
      adapter.onGet(
        ApiEndpoints.dictionarySafe,
        (server) => server.reply(
          200,
          _envelope({'items': <dynamic>[], 'hasNext': false}),
        ),
      );
      await repo.getSafe(cursor: 5, size: 10);
      expect(captured, isNotNull);
      expect(captured!['cursor'], 5);
      expect(captured!['size'], 10);
    });

    test('cursor 미지정 시 queryParameters에 cursor 키가 없다', () async {
      Map<String, dynamic>? captured;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            captured = options.queryParameters;
            handler.next(options);
          },
        ),
      );
      adapter.onGet(
        ApiEndpoints.dictionarySafe,
        (server) => server.reply(
          200,
          _envelope({'items': <dynamic>[], 'hasNext': false}),
        ),
      );
      await repo.getSafe(size: 10);
      expect(captured, isNotNull);
      expect(captured!.containsKey('cursor'), isFalse);
      expect(captured!['size'], 10);
    });
  });
}
