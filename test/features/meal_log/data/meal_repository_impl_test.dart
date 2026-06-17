import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/meal_repository_impl.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';

// ---------------------------------------------------------------------------
// 헬퍼 — food_repository_impl_test 패턴 동일
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

/// MealRecordSummary JSON (POST /meals 응답 대응).
Map<String, dynamic> _mealRecordSummaryJson({
  String mealId = 'm1',
  String mealGroupId = 'g1',
  String eatenAt = '2026-06-17T09:02:00+09:00',
  String foodExternalId = 'f1',
  String foodName = '아메리카노',
  String? foodCategory = 'beverage',
  String? judgedGrade = 'CAUTION',
}) =>
    {
      'mealId': mealId,
      'mealGroupId': mealGroupId,
      'eatenAt': eatenAt,
      'food': {
        'externalId': foodExternalId,
        'name': foodName,
        'category': foodCategory,
      },
      'judgedGrade': judgedGrade,
    };

/// MealGroup JSON (GET /meals?date= 응답 항목).
Map<String, dynamic> _mealGroupJson({
  String mealGroupId = 'g1',
  String eatenAt = '2026-06-17T09:02:00+09:00',
  List<Map<String, dynamic>>? records,
}) =>
    {
      'mealGroupId': mealGroupId,
      'eatenAt': eatenAt,
      'records': records ??
          [
            _mealRecordSummaryJson(),
          ],
    };

/// MealRecordDetail JSON (GET /meals/{id} 응답).
Map<String, dynamic> _mealRecordDetailJson({
  String mealId = 'm1',
  String mealGroupId = 'g1',
  String eatenAt = '2026-06-17T09:02:00+09:00',
  String? memo,
  String? judgedGrade = 'RISK',
  String foodExternalId = 'f1',
  String foodName = '커피',
  String? foodCategory = 'beverage',
  String? foodDescription,
  List<Map<String, dynamic>>? stateRecords,
}) =>
    {
      'mealId': mealId,
      'mealGroupId': mealGroupId,
      'eatenAt': eatenAt,
      'memo': memo,
      'judgedGrade': judgedGrade,
      'food': {
        'externalId': foodExternalId,
        'name': foodName,
        'category': foodCategory,
        'description': foodDescription,
      },
      'stateRecords': stateRecords ?? <dynamic>[],
    };

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late MealRepositoryImpl repo;

  setUp(() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );
    adapter = DioAdapter(dio: dio, matcher: _urlMatcher);
    repo = MealRepositoryImpl(dio: dio);
  });

  // -------------------------------------------------------------------------
  group('timeline — GET /meals?date= 직렬화·unwrap', () {
    test('date 쿼리 파라미터가 "YYYY-MM-DD" 형식으로 전달된다', () async {
      adapter.onGet(
        ApiEndpoints.meals,
        (server) => server.reply(200, _envelope([_mealGroupJson()])),
        queryParameters: {'date': '2026-06-17'},
      );

      // UTC 2026-06-17T00:00:00 → KST 2026-06-17T09:00:00 → '2026-06-17'
      final result = await repo.timeline(DateTime.utc(2026, 6, 17));
      expect(result, isA<List<MealGroup>>());
    });

    test('봉투 unwrap 후 List<MealGroup>이 반환된다', () async {
      adapter.onGet(
        ApiEndpoints.meals,
        (server) => server.reply(200, _envelope([_mealGroupJson()])),
        queryParameters: {'date': '2026-06-17'},
      );

      final result = await repo.timeline(DateTime.utc(2026, 6, 17));
      expect(result.length, 1);
      expect(result[0], isA<MealGroup>());
    });

    test('MealGroup 필드가 올바르게 매핑된다', () async {
      adapter.onGet(
        ApiEndpoints.meals,
        (server) => server.reply(200, _envelope([_mealGroupJson()])),
        queryParameters: {'date': '2026-06-17'},
      );

      final result = await repo.timeline(DateTime.utc(2026, 6, 17));
      expect(result[0].mealGroupId, 'g1');
      expect(result[0].eatenAt, '2026-06-17T09:02:00+09:00');
    });

    test('records[0].judgedGrade "CAUTION" → VerdictLevel.caution', () async {
      adapter.onGet(
        ApiEndpoints.meals,
        (server) => server.reply(200, _envelope([_mealGroupJson()])),
        queryParameters: {'date': '2026-06-17'},
      );

      final result = await repo.timeline(DateTime.utc(2026, 6, 17));
      expect(result[0].records[0].judgedGrade, VerdictLevel.caution);
    });

    test('빈 배열 응답은 빈 List<MealGroup>을 반환한다', () async {
      adapter.onGet(
        ApiEndpoints.meals,
        (server) => server.reply(200, _envelope(<dynamic>[])),
        queryParameters: {'date': '2026-06-17'},
      );

      final result = await repo.timeline(DateTime.utc(2026, 6, 17));
      expect(result, isEmpty);
    });

    test('KST 일자 경계: UTC 15:00 → date 쿼리가 다음날 날짜이다', () async {
      // UTC 2026-06-17T15:00 = KST 2026-06-18T00:00 → '2026-06-18'
      adapter.onGet(
        ApiEndpoints.meals,
        (server) => server.reply(200, _envelope(<dynamic>[])),
        queryParameters: {'date': '2026-06-18'},
      );

      final result = await repo.timeline(DateTime.utc(2026, 6, 17, 15, 0, 0));
      expect(result, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('detail — GET /meals/{mealId}', () {
    test('MealDetail이 올바르게 반환된다', () async {
      adapter.onGet(
        ApiEndpoints.mealItem('m1'),
        (server) => server.reply(
          200,
          _envelope(
            _mealRecordDetailJson(
              judgedGrade: 'RISK',
              memo: '점심 후',
              stateRecords: [
                {'label': '속쓰림', 'date': '2026-06-17', 'timing': '식후 90분'},
              ],
            ),
          ),
        ),
      );

      final result = await repo.detail('m1');
      expect(result, isA<MealDetail>());
      expect(result.mealId, 'm1');
      expect(result.judgedGrade, VerdictLevel.risk);
      expect(result.memo, '점심 후');
      expect(result.stateRecords.length, 1);
      expect(result.stateRecords[0].label, '속쓰림');
      expect(result.stateRecords[0].timing, '식후 90분');
    });

    test('judgedGrade null이면 entity.judgedGrade가 null이다', () async {
      adapter.onGet(
        ApiEndpoints.mealItem('m2'),
        (server) => server.reply(
          200,
          _envelope(_mealRecordDetailJson(mealId: 'm2', judgedGrade: null)),
        ),
      );

      final result = await repo.detail('m2');
      expect(result.judgedGrade, isNull);
    });
  });

  // -------------------------------------------------------------------------
  group('updateMemo — PATCH /meals/{mealId}', () {
    test('PATCH 성공 시 MealDetail이 반환된다', () async {
      adapter.onPatch(
        ApiEndpoints.mealItem('m1'),
        (server) => server.reply(
          200,
          _envelope(_mealRecordDetailJson(memo: '새 메모')),
        ),
        data: {'memo': '새 메모'},
      );

      final result = await repo.updateMemo('m1', '새 메모');
      expect(result, isA<MealDetail>());
      expect(result.memo, '새 메모');
    });
  });

  // -------------------------------------------------------------------------
  group('delete — DELETE /meals/{mealId}', () {
    test('DELETE 성공 시 Future<void>가 완료된다', () async {
      adapter.onDelete(
        ApiEndpoints.mealItem('m1'),
        (server) => server.reply(200, _envelope(null)),
      );

      await expectLater(repo.delete('m1'), completes);
    });
  });
}
