import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/data/dtos/meal_dtos.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/meal_repository_impl.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

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

/// 타임라인 single 항목.
Map<String, dynamic> _timelineSingle() => {
      'timeLineType': 'single',
      'mealRecordId': 'mr1',
      'mealRecordDateTime': '2026-06-17T08:00:00+09:00',
      'mealFoodName': '두부',
      'grade': 'RECOMMEND',
    };

/// 타임라인 group 항목.
Map<String, dynamic> _timelineGroup() => {
      'timeLineType': 'group',
      'mealRecordId': 'mr2',
      'mealRecordDateTime': '2026-06-17T12:30:00+09:00',
      'representativeFoods': ['된장찌개', '커피'],
      'etcCount': 1,
    };

/// POST /meal-records · foodDetail 응답.
Map<String, dynamic> _foodDetailJson() => {
      'mealFoodId': 'mf1',
      'eatenAt': '2026-06-17T09:02:00+09:00',
      'food': {
        'mealRecordExternalId': 'mr1',
        'name': '커피',
        'category': 'beverage',
      },
      'analysis': {'judgmentGrade': 'RISK'},
    };

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
  group('timeline — GET /timeline?date= (result.items[] 객체 래핑, F-9)', () {
    test('date 쿼리가 "YYYY-MM-DD" 형식으로 전달된다', () async {
      adapter.onGet(
        ApiEndpoints.timeline,
        (server) => server.reply(200, _envelope({'items': <dynamic>[]})),
        queryParameters: {'date': '2026-06-17'},
      );
      // UTC 2026-06-17T00:00 → KST 09:00 → '2026-06-17'
      final result = await repo.timeline(DateTime.utc(2026, 6, 17));
      expect(result, isA<List<TimelineItem>>());
    });

    test('result.items[] 를 TimelineItem 목록으로 unwrap한다', () async {
      adapter.onGet(
        ApiEndpoints.timeline,
        (server) => server.reply(
          200,
          _envelope({
            'items': [_timelineSingle(), _timelineGroup()],
          }),
        ),
        queryParameters: {'date': '2026-06-17'},
      );
      final result = await repo.timeline(DateTime.utc(2026, 6, 17));
      expect(result.length, 2);
      expect(result[0], isA<TimelineSingle>());
      expect(result[1], isA<TimelineGroup>());
    });

    test('알 수 없는 timeLineType은 스킵된다', () async {
      adapter.onGet(
        ApiEndpoints.timeline,
        (server) => server.reply(
          200,
          _envelope({
            'items': [
              _timelineSingle(),
              {'timeLineType': 'futureType', 'mealRecordId': 'x'},
            ],
          }),
        ),
        queryParameters: {'date': '2026-06-17'},
      );
      final result = await repo.timeline(DateTime.utc(2026, 6, 17));
      expect(result.length, 1);
      expect(result[0], isA<TimelineSingle>());
    });

    test('items 누락 시 빈 목록을 반환한다', () async {
      adapter.onGet(
        ApiEndpoints.timeline,
        (server) => server.reply(200, _envelope(<String, dynamic>{})),
        queryParameters: {'date': '2026-06-17'},
      );
      final result = await repo.timeline(DateTime.utc(2026, 6, 17));
      expect(result, isEmpty);
    });

    test('KST 일자 경계: UTC 15:00 → 다음날 date 쿼리', () async {
      adapter.onGet(
        ApiEndpoints.timeline,
        (server) => server.reply(200, _envelope({'items': <dynamic>[]})),
        queryParameters: {'date': '2026-06-18'},
      );
      final result = await repo.timeline(DateTime.utc(2026, 6, 17, 15, 0, 0));
      expect(result, isEmpty);
    });

    // 계약 verbatim: symptom variant 매핑
    test('symptom variant → TimelineSymptom, symptomState·afterMealMinutes 매핑', () async {
      adapter.onGet(
        ApiEndpoints.timeline,
        (server) => server.reply(
          200,
          _envelope({
            'items': [
              {
                'timeLineType': 'symptom',
                'symptomState': 'uncomfortable',
                'afterMealMinutes': 90,
                'occurredAt': '2026-06-24T10:00:00+09:00',
              },
            ],
          }),
        ),
        queryParameters: {'date': '2026-06-24'},
      );
      final result = await repo.timeline(DateTime.utc(2026, 6, 24));
      expect(result.length, 1);
      expect(result[0], isA<TimelineSymptom>());
      final symptom = result[0] as TimelineSymptom;
      expect(symptom.symptomState, SymptomState.uncomfortable);
      expect(symptom.afterMealMinutes, 90);
      expect(symptom.occurredAt, '2026-06-24T10:00:00+09:00');
    });

    // 계약: 미지 timeLineType 스킵 (single 1개 + unknownX 1개 → 결과 1개)
    test('미지 timeLineType "unknownX"는 스킵된다', () async {
      adapter.onGet(
        ApiEndpoints.timeline,
        (server) => server.reply(
          200,
          _envelope({
            'items': [
              _timelineSingle(),
              {'timeLineType': 'unknownX', 'mealRecordId': 'x'},
            ],
          }),
        ),
        queryParameters: {'date': '2026-06-17'},
      );
      final result = await repo.timeline(DateTime.utc(2026, 6, 17));
      expect(result.length, 1);
      expect(result[0], isA<TimelineSingle>());
    });
  });

  // -------------------------------------------------------------------------
  group(
      'getMonthly — GET /timeline/monthly?month=yyyy-MM (result[] 직접 배열, '
      '구 weekly?date= 대체 — B1)', () {
    test('month 쿼리가 "yyyy-MM" 형식(day 없이)으로 전달된다', () async {
      adapter.onGet(
        ApiEndpoints.timelineMonthly,
        (server) => server.reply(
          200,
          _envelope([
            {
              'day': 17,
              'dayOfWeek': 'WED',
              'judgementList': ['RECOMMEND', 'RISK'],
            },
          ]),
        ),
        queryParameters: {'month': '2026-06'},
      );
      // day 값(24)은 무시되고 연/월만 쿼리에 반영되어야 한다.
      final result = await repo.getMonthly(DateTime.utc(2026, 6, 24));
      expect(result.length, 1);
    });

    test('result[] 를 MonthlyDay 목록으로 unwrap한다', () async {
      adapter.onGet(
        ApiEndpoints.timelineMonthly,
        (server) => server.reply(
          200,
          _envelope([
            {
              'day': 17,
              'dayOfWeek': 'WED',
              'judgementList': ['RECOMMEND', 'RISK'],
            },
          ]),
        ),
        queryParameters: {'month': '2026-06'},
      );
      final result = await repo.getMonthly(DateTime.utc(2026, 6, 1));
      expect(result.length, 1);
      expect(result[0].day, 17);
      expect(result[0].judgements, [VerdictLevel.recommend, VerdictLevel.risk]);
    });

    // 계약: judgementList 대문자 grade → VerdictLevel, UNKNOWN 폴백
    test('judgementList UNKNOWN grade → VerdictLevel.unknown 폴백', () async {
      adapter.onGet(
        ApiEndpoints.timelineMonthly,
        (server) => server.reply(
          200,
          _envelope([
            {
              'day': 24,
              'dayOfWeek': 'WED',
              'judgementList': ['UNKNOWN'],
            },
          ]),
        ),
        queryParameters: {'month': '2026-06'},
      );
      final result = await repo.getMonthly(DateTime.utc(2026, 6, 1));
      expect(result[0].judgements[0], VerdictLevel.unknown);
    });

    // 계약: judgementList ≤3 (서버가 최대 3개 보냄, 클라이언트 통과 검증)
    test('judgementList 3개 모두 매핑된다 (≤3 경계)', () async {
      adapter.onGet(
        ApiEndpoints.timelineMonthly,
        (server) => server.reply(
          200,
          _envelope([
            {
              'day': 24,
              'dayOfWeek': 'WED',
              'judgementList': ['RECOMMEND', 'CAUTION', 'RISK'],
            },
          ]),
        ),
        queryParameters: {'month': '2026-06'},
      );
      final result = await repo.getMonthly(DateTime.utc(2026, 6, 1));
      expect(result[0].judgements.length, 3);
      expect(result[0].judgements, [
        VerdictLevel.recommend,
        VerdictLevel.caution,
        VerdictLevel.risk,
      ]);
    });
  });

  // -------------------------------------------------------------------------
  group(
      'appendFood — 신규(POST /meal-records/foods/{id}) · '
      '기존(POST /meal-records/{id}/foods/{id})', () {
    test('mealRecordId 없으면 POST /meal-records/foods/{id}로 신규 식사를 생성한다',
        () async {
      adapter.onPost(
        ApiEndpoints.mealRecordsByFoodId('f1'),
        (server) => server.reply(200, _envelope(_foodDetailJson())),
      );
      final result = await repo.appendFood(foodExternalId: 'f1');
      expect(result, isA<MealFood>());
      expect(result.mealFoodId, 'mf1');
      expect(result.mealRecordExternalId, 'mr1');
      expect(result.analysis!.judgmentGrade, VerdictLevel.risk);
    });

    test('mealRecordId 있으면 POST /meal-records/{id}/foods/{id}로 기존 식사에 추가한다',
        () async {
      adapter.onPost(
        ApiEndpoints.mealRecordFoodById('mr1', 'f1'),
        (server) => server.reply(200, _envelope(_foodDetailJson())),
      );
      final result =
          await repo.appendFood(foodExternalId: 'f1', mealRecordId: 'mr1');
      expect(result, isA<MealFood>());
      expect(result.mealRecordExternalId, 'mr1');
    });

    // 계약: POST 바디에 foodExternalId·judgedGrade 필드가 있으면 안 된다 (경로 파라미터로
    // 전달되므로 바디에 불필요, F-10). DTO 레벨에서 직접 검증(impl 경유 없이 확실하게).
    test('POST 바디에 foodExternalId·judgedGrade 키가 없다 — DTO toJson 직접 검증', () {
      final body = const MealRecordByIdRequestDto(
        eatenAt: '2026-06-24T08:30:00+09:00',
      ).toJson()..removeWhere((_, v) => v == null);
      expect(body.containsKey('judgedGrade'), isFalse,
          reason: '서버가 analysis를 계산하므로 클라이언트는 judgedGrade를 보내면 안 된다');
      expect(body.containsKey('foodExternalId'), isFalse,
          reason: 'foodExternalId는 경로 파라미터로 전달되므로 바디에 없어야 한다');
      expect(body['eatenAt'], '2026-06-24T08:30:00+09:00');
    });
  });

  // -------------------------------------------------------------------------
  group(
      'appendFoodByText — 신규(POST /meal-records) · '
      '기존(POST /meal-records/{id}/foods)', () {
    test('mealRecordId 없으면 POST /meal-records로 신규 식사를 생성한다', () async {
      adapter.onPost(
        ApiEndpoints.mealRecords,
        (server) => server.reply(200, _envelope(_foodDetailJson())),
      );
      final result = await repo.appendFoodByText(foodTextInput: '아메리카노');
      expect(result, isA<MealFood>());
      expect(result.mealFoodId, 'mf1');
    });

    test('mealRecordId 있으면 POST /meal-records/{id}/foods로 기존 식사에 추가한다',
        () async {
      adapter.onPost(
        ApiEndpoints.mealRecordFoods('mr1'),
        (server) => server.reply(200, _envelope(_foodDetailJson())),
      );
      final result = await repo.appendFoodByText(
        foodTextInput: '아메리카노',
        mealRecordId: 'mr1',
      );
      expect(result, isA<MealFood>());
      expect(result.mealRecordExternalId, 'mr1');
    });

    test('name은 trim되고 100자를 초과하면 100자로 잘려 전송된다', () async {
      Map<String, dynamic>? capturedBody;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            capturedBody = options.data as Map<String, dynamic>?;
            handler.next(options);
          },
        ),
      );
      adapter.onPost(
        ApiEndpoints.mealRecords,
        (server) => server.reply(200, _envelope(_foodDetailJson())),
      );
      final longName = '  ${'가' * 150}  ';
      await repo.appendFoodByText(foodTextInput: longName);
      expect(capturedBody!['name'], hasLength(100));
      expect(capturedBody!['name'], '가' * 100);
    });
  });

  // -------------------------------------------------------------------------
  group('mealDetail — GET /meal-records/{id}', () {
    test('MealRecord가 올바르게 반환된다', () async {
      adapter.onGet(
        ApiEndpoints.mealRecordItem('mr1'),
        (server) => server.reply(
          200,
          _envelope({
            'mealRecordId': 'mr1',
            'eatenAt': '2026-06-17T09:02:00+09:00',
            'meals': [
              {
                'mealFoodId': 'mf1',
                'name': '커피',
                'eatenAt': '2026-06-17T09:02:00+09:00',
              },
            ],
            'stateRecords': [
              {
                'stateRecordId': 'sr1',
                'label': '속쓰림',
                'date': '2026-06-17',
                'timingMinutes': 90,
              },
            ],
          }),
        ),
      );
      final result = await repo.mealDetail('mr1');
      expect(result, isA<MealRecord>());
      expect(result.mealRecordId, 'mr1');
      expect(result.foods.length, 1);
      expect(result.stateRecords.length, 1);
      expect(result.stateRecords[0].timingMinutes, 90);
    });

    // 계약: stateRecords 키 누락 → 빈 리스트
    test('stateRecords 키 누락 시 빈 목록을 반환한다', () async {
      adapter.onGet(
        ApiEndpoints.mealRecordItem('mr2'),
        (server) => server.reply(
          200,
          _envelope({
            'mealRecordId': 'mr2',
            'eatenAt': '2026-06-24T09:00:00+09:00',
            'meals': [
              {
                'mealFoodId': 'mf2',
                'name': '두부',
                'eatenAt': '2026-06-24T09:00:00+09:00',
              },
            ],
            // stateRecords 키 없음
          }),
        ),
      );
      final result = await repo.mealDetail('mr2');
      expect(result.stateRecords, isEmpty);
    });

    // 계약: stateRecords 명시 null → 빈 리스트
    test('stateRecords 명시 null이어도 빈 목록을 반환한다', () async {
      adapter.onGet(
        ApiEndpoints.mealRecordItem('mr3'),
        (server) => server.reply(
          200,
          _envelope({
            'mealRecordId': 'mr3',
            'eatenAt': '2026-06-24T09:00:00+09:00',
            'meals': [
              {
                'mealFoodId': 'mf3',
                'name': '된장찌개',
                'eatenAt': '2026-06-24T09:00:00+09:00',
              },
            ],
            'stateRecords': null,
          }),
        ),
      );
      final result = await repo.mealDetail('mr3');
      expect(result.stateRecords, isEmpty);
    });

    // 계약: meals[].category null 방어
    test('meals[].category null이어도 MealFood.category가 null로 매핑된다', () async {
      adapter.onGet(
        ApiEndpoints.mealRecordItem('mr4'),
        (server) => server.reply(
          200,
          _envelope({
            'mealRecordId': 'mr4',
            'eatenAt': '2026-06-24T09:00:00+09:00',
            'meals': [
              {
                'mealFoodId': 'mf4',
                'name': '두부',
                'category': null,
                'eatenAt': '2026-06-24T09:00:00+09:00',
              },
            ],
            'stateRecords': [],
          }),
        ),
      );
      final result = await repo.mealDetail('mr4');
      expect(result.foods[0].category, isNull);
    });
  });

  // -------------------------------------------------------------------------
  group('foodDetail — GET /meal-records/foods/{id}', () {
    test('MealFood(analysis 포함)를 반환한다', () async {
      adapter.onGet(
        ApiEndpoints.mealRecordFood('mf1'),
        (server) => server.reply(200, _envelope(_foodDetailJson())),
      );
      final result = await repo.foodDetail('mf1');
      expect(result.mealFoodId, 'mf1');
      expect(result.analysis, isNotNull);
    });
  });

  // -------------------------------------------------------------------------
  group('deleteMeal — DELETE /meal-records/{id}', () {
    test('성공 시 Future<void>가 완료된다', () async {
      adapter.onDelete(
        ApiEndpoints.mealRecordItem('mr1'),
        (server) => server.reply(200, _envelope(null)),
      );
      await expectLater(repo.deleteMeal('mr1'), completes);
    });
  });

  // -------------------------------------------------------------------------
  group('deleteFood — DELETE /meal-records/foods/{id}', () {
    test('성공 시 Future<void>가 완료된다', () async {
      adapter.onDelete(
        ApiEndpoints.mealRecordFood('mf1'),
        (server) => server.reply(200, _envelope(null)),
      );
      await expectLater(repo.deleteFood('mf1'), completes);
    });
  });

  // -------------------------------------------------------------------------
  group('candidates — GET /meal-records/candidates (result[] 직접 배열)', () {
    test('result[] 를 MealCandidatesDay 목록으로 unwrap한다', () async {
      adapter.onGet(
        ApiEndpoints.mealRecordCandidates,
        (server) => server.reply(
          200,
          _envelope([
            {
              'date': '2026-06-17',
              'meals': [
                {
                  'mealRecordId': 'mr1',
                  'representativeFood': {'name': '된장찌개'},
                  'otherFoodCount': 2,
                  'eatenAt': '2026-06-17T12:30:00+09:00',
                },
              ],
            },
          ]),
        ),
      );
      final result = await repo.candidates();
      expect(result.length, 1);
      expect(result[0].meals[0].representativeFoodName, '된장찌개');
    });

    // 계약 verbatim: representativeFood.category null 방어
    test('representativeFood.category null → representativeFoodCategory가 null이다', () async {
      adapter.onGet(
        ApiEndpoints.mealRecordCandidates,
        (server) => server.reply(
          200,
          _envelope([
            {
              'date': '2026-06-24',
              'meals': [
                {
                  'mealRecordId': 'mr1',
                  'representativeFood': {'name': '두부', 'category': null},
                  'otherFoodCount': 2,
                  'eatenAt': '2026-06-24T12:30:00+09:00',
                },
              ],
            },
          ]),
        ),
      );
      final result = await repo.candidates();
      expect(result[0].meals[0].representativeFoodCategory, isNull);
      expect(result[0].meals[0].representativeFoodName, '두부');
    });

    // 계약: eatenAt ISO-8601 +09:00 오프셋 보존
    test('eatenAt ISO-8601 +09:00 오프셋이 보존된다', () async {
      adapter.onGet(
        ApiEndpoints.mealRecordCandidates,
        (server) => server.reply(
          200,
          _envelope([
            {
              'date': '2026-06-24',
              'meals': [
                {
                  'mealRecordId': 'mr2',
                  'representativeFood': {'name': '된장찌개', 'category': null},
                  'otherFoodCount': 0,
                  'eatenAt': '2026-06-24T12:30:00+09:00',
                },
              ],
            },
          ]),
        ),
      );
      final result = await repo.candidates();
      expect(result[0].meals[0].eatenAt, '2026-06-24T12:30:00+09:00');
    });
  });
}
