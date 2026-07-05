import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/food_symptom_repository_impl.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_symptom.dart';

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
  late FoodSymptomRepositoryImpl repo;
  const foodExternalId = 'food-1';

  setUp(() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );
    adapter = DioAdapter(dio: dio, matcher: _urlMatcher);
    repo = FoodSymptomRepositoryImpl(dio: dio);
  });

  group('getSymptoms — GET /foods/{foodExternalId}/symptoms', () {
    test('result[]를 List<FoodSymptom>으로 정확히 파싱한다', () async {
      adapter.onGet(
        ApiEndpoints.foodSymptoms(foodExternalId),
        (server) => server.reply(
          200,
          _envelope([
            {
              'symptomId': 'symptom-1',
              'symptomState': 'uncomfortable',
              'symptomTypes': ['heartburn_reflux'],
              'occurredAt': '2026-06-20T20:30:00+09:00',
              'mealRecordId': 'meal-1',
              'afterMealMinutes': 30,
            },
          ]),
        ),
      );
      final result = await repo.getSymptoms(foodExternalId);
      expect(result, isA<List<FoodSymptom>>());
      expect(result, hasLength(1));
      expect(result.first.symptomId, 'symptom-1');
    });

    test('빈 목록도 정상 처리한다', () async {
      adapter.onGet(
        ApiEndpoints.foodSymptoms(foodExternalId),
        (server) => server.reply(200, _envelope(<dynamic>[])),
      );
      final result = await repo.getSymptoms(foodExternalId);
      expect(result, isEmpty);
    });
  });
}
