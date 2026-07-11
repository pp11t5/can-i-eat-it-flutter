import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/data/repositories/symptom_repository_impl.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';

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

Map<String, dynamic> _symptomResponseJson({
  String symptomId = 'sym-001',
  String symptomState = 'uncomfortable',
  String stateTitle = '조금 불편해요',
  List<String> symptomTypes = const ['acid_reflux'],
  String occurredAt = '2026-06-17T14:30:00+09:00',
  Map<String, dynamic>? linkedMeal,
  Map<String, dynamic>? analysis,
}) =>
    {
      'symptomId': symptomId,
      'symptomState': symptomState,
      'stateTitle': stateTitle,
      'symptomTypes': symptomTypes,
      'occurredAt': occurredAt,
      if (linkedMeal != null) 'linkedMeal': linkedMeal,
      if (analysis != null) 'analysis': analysis,
    };

Map<String, dynamic> _linkedMealJson() => {
      'mealRecordId': 'record-002',
      'foods': [
        {'mealFoodId': 'food-002', 'name': '된장찌개', 'category': '한식'},
      ],
    };

Map<String, dynamic> _analysisJson() => {
      'items': [
        {'emphasis': '카페인 주의', 'body': '위산 역류를 악화해요.'},
      ],
    };

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SymptomRepositoryImpl repo;

  setUp(() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );
    adapter = DioAdapter(dio: dio, matcher: _urlMatcher);
    repo = SymptomRepositoryImpl(dio: dio);
  });

  // -------------------------------------------------------------------------
  group('create — POST /symptoms', () {
    test('성공 시 Symptom을 반환한다', () async {
      adapter.onPost(
        ApiEndpoints.symptoms,
        (server) => server.reply(200, _envelope(_symptomResponseJson())),
      );
      final result = await repo.create(const SymptomDraft(
        symptomState: SymptomState.uncomfortable,
        mealRecordId: 'record-001',
        symptomTypes: [SymptomType.acidReflux],
      ));
      expect(result, isA<Symptom>());
      expect(result.symptomId, 'sym-001');
      expect(result.symptomState, SymptomState.uncomfortable);
    });

    test('linkedMeal 有 응답 — linkedMeal이 매핑된다', () async {
      adapter.onPost(
        ApiEndpoints.symptoms,
        (server) => server.reply(
          200,
          _envelope(_symptomResponseJson(linkedMeal: _linkedMealJson())),
        ),
      );
      final result = await repo.create(const SymptomDraft(
        symptomState: SymptomState.uncomfortable,
        mealRecordId: 'record-002',
      ));
      expect(result.linkedMeal, isNotNull);
      expect(result.linkedMeal!.mealRecordId, 'record-002');
      expect(result.linkedMeal!.foods.length, 1);
    });

    test('analysis 有 응답 — analysisItems가 매핑된다', () async {
      adapter.onPost(
        ApiEndpoints.symptoms,
        (server) => server.reply(
          200,
          _envelope(
              _symptomResponseJson(analysis: _analysisJson())),
        ),
      );
      final result = await repo.create(const SymptomDraft(
        symptomState: SymptomState.uncomfortable,
        mealRecordId: 'record-001',
      ));
      expect(result.analysisItems.length, 1);
      expect(result.analysisItems[0].emphasis, '카페인 주의');
    });

    test('linkedMeal 無, analysis 無 응답 — 각각 null/빈 목록', () async {
      adapter.onPost(
        ApiEndpoints.symptoms,
        (server) => server.reply(
          200,
          _envelope(_symptomResponseJson(
            symptomState: 'good',
            stateTitle: '컨디션이 좋아요',
            symptomTypes: [],
          )),
        ),
      );
      final result = await repo.create(const SymptomDraft(
        symptomState: SymptomState.good,
        mealRecordId: 'record-001',
      ));
      expect(result.linkedMeal, isNull);
      expect(result.analysisItems, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('detail — GET /symptoms/{id}', () {
    test('Symptom을 올바르게 반환한다', () async {
      adapter.onGet(
        ApiEndpoints.symptomItem('sym-001'),
        (server) => server.reply(
          200,
          _envelope(_symptomResponseJson(
            linkedMeal: _linkedMealJson(),
            analysis: _analysisJson(),
          )),
        ),
      );
      final result = await repo.detail('sym-001');
      expect(result, isA<Symptom>());
      expect(result.symptomId, 'sym-001');
      expect(result.linkedMeal, isNotNull);
      expect(result.analysisItems, isNotEmpty);
    });

    test('occurredAt ISO-8601 +09:00 오프셋이 보존된다', () async {
      adapter.onGet(
        ApiEndpoints.symptomItem('sym-001'),
        (server) => server.reply(200, _envelope(_symptomResponseJson())),
      );
      final result = await repo.detail('sym-001');
      expect(result.occurredAt, '2026-06-17T14:30:00+09:00');
    });
  });

  // -------------------------------------------------------------------------
  group('update — PUT /symptoms/{id}', () {
    test('성공 시 Future<void>가 완료된다', () async {
      adapter.onPut(
        ApiEndpoints.symptomItem('sym-001'),
        (server) => server.reply(200, _envelope(null)),
      );
      await expectLater(
        repo.update(
          'sym-001',
          SymptomDraft(
            symptomState: SymptomState.severe,
            mealRecordId: 'record-001',
            occurredAt: DateTime(2026, 6, 17, 14, 30, 0),
          ),
        ),
        completes,
      );
    });
  });

  // -------------------------------------------------------------------------
  group('updateMemo — PATCH /symptoms/{id}/memo', () {
    test('성공 시 Future<void>가 완료된다', () async {
      adapter.onPatch(
        ApiEndpoints.symptomMemo('sym-001'),
        (server) => server.reply(200, _envelope(null)),
      );
      await expectLater(repo.updateMemo('sym-001', '새 메모'), completes);
    });

    test('memo null 전송도 Future<void>가 완료된다', () async {
      adapter.onPatch(
        ApiEndpoints.symptomMemo('sym-001'),
        (server) => server.reply(200, _envelope(null)),
      );
      await expectLater(repo.updateMemo('sym-001', null), completes);
    });
  });

  // -------------------------------------------------------------------------
  group('delete — DELETE /symptoms/{id}', () {
    test('성공 시 Future<void>가 완료된다', () async {
      adapter.onDelete(
        ApiEndpoints.symptomItem('sym-001'),
        (server) => server.reply(200, _envelope(null)),
      );
      await expectLater(repo.delete('sym-001'), completes);
    });
  });

  // -------------------------------------------------------------------------
  group('symptomTypes 매핑', () {
    test('4종 모두 매핑된다', () async {
      adapter.onPost(
        ApiEndpoints.symptoms,
        (server) => server.reply(
          200,
          _envelope(_symptomResponseJson(
            symptomTypes: [
              'throat_foreign_body',
              'acid_reflux',
              'cough',
              'chest_tightness',
            ],
          )),
        ),
      );
      final result = await repo.create(const SymptomDraft(
        symptomState: SymptomState.uncomfortable,
        mealRecordId: 'record-001',
      ));
      expect(result.symptomTypes.length, 4);
      expect(result.symptomTypes, contains(SymptomType.throatForeignBody));
      expect(result.symptomTypes, contains(SymptomType.acidReflux));
      expect(result.symptomTypes, contains(SymptomType.cough));
      expect(result.symptomTypes, contains(SymptomType.chestTightness));
    });

    test('미지 symptomType은 필터링된다', () async {
      adapter.onPost(
        ApiEndpoints.symptoms,
        (server) => server.reply(
          200,
          _envelope(
              _symptomResponseJson(symptomTypes: ['acid_reflux', 'new_type'])),
        ),
      );
      final result = await repo.create(const SymptomDraft(
        symptomState: SymptomState.uncomfortable,
        mealRecordId: 'record-001',
      ));
      expect(result.symptomTypes.length, 1);
      expect(result.symptomTypes[0], SymptomType.acidReflux);
    });
  });

  // -------------------------------------------------------------------------
  group('미지 symptomState 폴백', () {
    test('미지 symptomState → SymptomState.normal 폴백', () async {
      adapter.onGet(
        ApiEndpoints.symptomItem('sym-x'),
        (server) => server.reply(
          200,
          _envelope(_symptomResponseJson(
            symptomId: 'sym-x',
            symptomState: 'super_new_state',
          )),
        ),
      );
      final result = await repo.detail('sym-x');
      expect(result.symptomState, SymptomState.normal);
    });
  });

  // -------------------------------------------------------------------------
  // symptomState "comfortable" — HTTP 스택 완전 매핑 (DTO 테스트 보완)
  // -------------------------------------------------------------------------
  group('symptomState "comfortable" HTTP 스택 매핑', () {
    test('comfortable 응답 → SymptomState.comfortable', () async {
      adapter.onGet(
        ApiEndpoints.symptomItem('sym-comfort'),
        (server) => server.reply(
          200,
          _envelope(_symptomResponseJson(
            symptomId: 'sym-comfort',
            symptomState: 'comfortable',
            stateTitle: '편안한 하루예요',
          )),
        ),
      );
      final result = await repo.detail('sym-comfort');
      expect(result.symptomState, SymptomState.comfortable);
    });
  });

  // -------------------------------------------------------------------------
  // linkedMeal.foods[].category null — HTTP 스택 완전 경로
  // -------------------------------------------------------------------------
  group('linkedMeal.foods[].category null — HTTP 스택', () {
    test('foods category null 인 항목이 엔티티에서 null로 보존된다', () async {
      adapter.onPost(
        ApiEndpoints.symptoms,
        (server) => server.reply(
          200,
          _envelope(_symptomResponseJson(
            linkedMeal: {
              'mealRecordId': 'record-003',
              'foods': [
                {
                  'mealFoodId': 'food-no-cat',
                  'name': '미분류음식',
                  'category': null,
                },
              ],
            },
          )),
        ),
      );
      final result = await repo.create(const SymptomDraft(
        symptomState: SymptomState.normal,
        mealRecordId: 'record-003',
      ));
      expect(result.linkedMeal, isNotNull);
      expect(result.linkedMeal!.foods.length, 1);
      expect(result.linkedMeal!.foods[0].name, '미분류음식');
      expect(result.linkedMeal!.foods[0].category, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // analysis.items 빈 배열 — HTTP 스택
  // -------------------------------------------------------------------------
  group('analysis.items 빈 배열 — HTTP 스택', () {
    test('analysis 있고 items=[] 이면 analysisItems 빈 목록', () async {
      adapter.onGet(
        ApiEndpoints.symptomItem('sym-empty-analysis'),
        (server) => server.reply(
          200,
          _envelope(_symptomResponseJson(
            symptomId: 'sym-empty-analysis',
            analysis: {'items': <dynamic>[]},
          )),
        ),
      );
      final result = await repo.detail('sym-empty-analysis');
      expect(result.analysisItems, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // update — 요청 바디에 occurredAt 포함 검증
  // (기존 테스트는 응답 완료만 확인; 바디 누락 시 false-green 위험 차단)
  // replyCallback(RequestOptions) 으로 바디를 캡처한다 (http_mock_adapter 0.6.1 API).
  // -------------------------------------------------------------------------
  group('update — 요청 바디 occurredAt 포함', () {
    test('PUT 바디에 occurredAt 키가 존재하고 +09:00 오프셋 포맷이다', () async {
      Map<String, dynamic>? capturedBody;
      adapter.onPut(
        ApiEndpoints.symptomItem('sym-body-check'),
        (server) => server.replyCallback(
          200,
          (requestOptions) {
            // requestOptions.data 는 impl이 PUT으로 전송한 Map
            capturedBody = requestOptions.data as Map<String, dynamic>?;
            return _envelope(null);
          },
        ),
      );
      await repo.update(
        'sym-body-check',
        SymptomDraft(
          symptomState: SymptomState.uncomfortable,
          mealRecordId: 'record-001',
          occurredAt: DateTime(2026, 6, 17, 14, 30, 0),
        ),
      );
      expect(capturedBody, isNotNull);
      expect(capturedBody!.containsKey('occurredAt'), isTrue,
          reason: 'update 바디에 occurredAt이 누락되면 서버 400 발생');
      expect(capturedBody!['occurredAt'], '2026-06-17T14:30:00+09:00');
    });
  });

  // -------------------------------------------------------------------------
  // create/update — 요청 바디 mealRecordId null/비null 검증
  // (mealRecordId=null → 서버가 "식사 미연결"로 해석하려면 body 에서 키 자체가
  //  누락돼야 한다. DTO.toJson() 만으로는 검증되지 않고 impl의
  //  removeWhere((_,v)=>v==null) 가 실제로 적용된 최종 전송 body 를 봐야 하므로
  //  update의 occurredAt 캡처 테스트와 동일하게 replyCallback으로 확인한다.)
  // -------------------------------------------------------------------------
  group('create — 요청 바디 mealRecordId null/비null', () {
    test('mealRecordId null 이면 POST 바디에 키가 없다', () async {
      Map<String, dynamic>? capturedBody;
      adapter.onPost(
        ApiEndpoints.symptoms,
        (server) => server.replyCallback(
          200,
          (requestOptions) {
            capturedBody = requestOptions.data as Map<String, dynamic>?;
            return _envelope(_symptomResponseJson());
          },
        ),
      );
      await repo.create(const SymptomDraft(
        symptomState: SymptomState.uncomfortable,
      ));
      expect(capturedBody, isNotNull);
      expect(capturedBody!.containsKey('mealRecordId'), isFalse,
          reason: 'mealRecordId null 이면 서버가 식사 미연결로 해석하도록 키가 없어야 한다');
    });

    test('mealRecordId 있으면 POST 바디에 키가 존재하고 값이 보존된다', () async {
      Map<String, dynamic>? capturedBody;
      adapter.onPost(
        ApiEndpoints.symptoms,
        (server) => server.replyCallback(
          200,
          (requestOptions) {
            capturedBody = requestOptions.data as Map<String, dynamic>?;
            return _envelope(_symptomResponseJson());
          },
        ),
      );
      await repo.create(const SymptomDraft(
        symptomState: SymptomState.uncomfortable,
        mealRecordId: 'record-001',
      ));
      expect(capturedBody, isNotNull);
      expect(capturedBody!.containsKey('mealRecordId'), isTrue);
      expect(capturedBody!['mealRecordId'], 'record-001');
    });
  });

  group('update — 요청 바디 mealRecordId null/비null', () {
    test('mealRecordId null 이면 PUT 바디에 키가 없다 (occurredAt은 유지된다)', () async {
      Map<String, dynamic>? capturedBody;
      adapter.onPut(
        ApiEndpoints.symptomItem('sym-meal-null'),
        (server) => server.replyCallback(
          200,
          (requestOptions) {
            capturedBody = requestOptions.data as Map<String, dynamic>?;
            return _envelope(null);
          },
        ),
      );
      await repo.update(
        'sym-meal-null',
        SymptomDraft(
          symptomState: SymptomState.uncomfortable,
          occurredAt: DateTime(2026, 6, 17, 14, 30, 0),
        ),
      );
      expect(capturedBody, isNotNull);
      expect(capturedBody!.containsKey('mealRecordId'), isFalse,
          reason: 'mealRecordId null 이면 서버가 식사 미연결로 해석하도록 키가 없어야 한다');
      // 회귀 방지: mealRecordId 누락 처리가 occurredAt까지 함께 지우면 안 된다.
      expect(capturedBody!.containsKey('occurredAt'), isTrue,
          reason: 'update 바디에서 occurredAt은 mealRecordId 유무와 무관하게 항상 필수');
      expect(capturedBody!['occurredAt'], '2026-06-17T14:30:00+09:00');
    });

    test('mealRecordId 있으면 PUT 바디에 키가 존재하고 값이 보존된다', () async {
      Map<String, dynamic>? capturedBody;
      adapter.onPut(
        ApiEndpoints.symptomItem('sym-meal-present'),
        (server) => server.replyCallback(
          200,
          (requestOptions) {
            capturedBody = requestOptions.data as Map<String, dynamic>?;
            return _envelope(null);
          },
        ),
      );
      await repo.update(
        'sym-meal-present',
        SymptomDraft(
          symptomState: SymptomState.uncomfortable,
          mealRecordId: 'record-777',
          occurredAt: DateTime(2026, 6, 17, 14, 30, 0),
        ),
      );
      expect(capturedBody, isNotNull);
      expect(capturedBody!.containsKey('mealRecordId'), isTrue);
      expect(capturedBody!['mealRecordId'], 'record-777');
    });
  });
}
