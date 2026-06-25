import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/data/dtos/symptom_dtos.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';

// ---------------------------------------------------------------------------
// 인라인 const 픽스처 (서버 스펙 역산, .json 금지)
// ---------------------------------------------------------------------------

/// linkedMeal 有, analysis 有 응답.
const _responseWithAll = {
  'symptomId': 'sym-001',
  'symptomState': 'uncomfortable',
  'stateTitle': '조금 불편해요',
  'symptomTypes': ['acid_reflux', 'cough'],
  'occurredAt': '2026-06-17T14:30:00+09:00',
  'linkedMeal': {
    'mealRecordId': 'record-002',
    'foods': [
      {'mealFoodId': 'food-002', 'name': '된장찌개', 'category': '한식'},
      {'mealFoodId': 'food-003', 'name': '커피', 'category': null},
    ],
  },
  'analysis': {
    'items': [
      {'emphasis': '카페인 주의', 'body': '위산 역류를 악화해요.'},
      {'emphasis': '나트륨 주의', 'body': '위 점막을 자극해요.'},
    ],
  },
};

/// linkedMeal 無, analysis 無 응답.
const _responseNoMealNoAnalysis = {
  'symptomId': 'sym-002',
  'symptomState': 'good',
  'stateTitle': '컨디션이 좋아요',
  'symptomTypes': [],
  'occurredAt': '2026-06-18T09:00:00+09:00',
};

/// symptomTypes 미지값 포함 응답.
const _responseUnknownTypes = {
  'symptomId': 'sym-003',
  'symptomState': 'normal',
  'stateTitle': '보통이에요',
  'symptomTypes': ['acid_reflux', 'future_type_x'],
  'occurredAt': '2026-06-19T10:00:00+09:00',
};

/// 미지 symptomState 응답 (normal 폴백 기대).
const _responseUnknownState = {
  'symptomId': 'sym-004',
  'symptomState': 'super_new_state',
  'stateTitle': '알 수 없는 상태',
  'symptomTypes': [],
  'occurredAt': '2026-06-20T08:00:00+09:00',
};

void main() {
  // -------------------------------------------------------------------------
  // SymptomResponseDto — fromJson → toEntity
  // -------------------------------------------------------------------------

  group('SymptomResponseDto.fromJson — linkedMeal 有, analysis 有', () {
    test('symptomId 파싱', () {
      final dto = SymptomResponseDto.fromJson(_responseWithAll);
      expect(dto.symptomId, 'sym-001');
    });

    test('symptomState "uncomfortable" → SymptomState.uncomfortable', () {
      final entity = SymptomResponseDto.fromJson(_responseWithAll).toEntity();
      expect(entity.symptomState, SymptomState.uncomfortable);
    });

    test('stateTitle 보존', () {
      final entity = SymptomResponseDto.fromJson(_responseWithAll).toEntity();
      expect(entity.stateTitle, '조금 불편해요');
    });

    test('occurredAt ISO-8601 +09:00 오프셋 보존', () {
      final entity = SymptomResponseDto.fromJson(_responseWithAll).toEntity();
      expect(entity.occurredAt, '2026-06-17T14:30:00+09:00');
    });

    test('symptomTypes 2종 매핑 (acid_reflux, cough)', () {
      final entity = SymptomResponseDto.fromJson(_responseWithAll).toEntity();
      expect(entity.symptomTypes.length, 2);
      expect(entity.symptomTypes, contains(SymptomType.acidReflux));
      expect(entity.symptomTypes, contains(SymptomType.cough));
    });

    test('linkedMeal 有 — mealRecordId, foods 매핑', () {
      final entity = SymptomResponseDto.fromJson(_responseWithAll).toEntity();
      expect(entity.linkedMeal, isNotNull);
      expect(entity.linkedMeal!.mealRecordId, 'record-002');
      expect(entity.linkedMeal!.foods.length, 2);
      expect(entity.linkedMeal!.foods[0].name, '된장찌개');
      expect(entity.linkedMeal!.foods[0].category, '한식');
      expect(entity.linkedMeal!.foods[1].name, '커피');
      expect(entity.linkedMeal!.foods[1].category, isNull);
    });

    test('analysis 有 — items 2건 매핑 (emphasis/body)', () {
      final entity = SymptomResponseDto.fromJson(_responseWithAll).toEntity();
      expect(entity.analysisItems.length, 2);
      expect(entity.analysisItems[0].emphasis, '카페인 주의');
      expect(entity.analysisItems[0].body, '위산 역류를 악화해요.');
      expect(entity.analysisItems[1].emphasis, '나트륨 주의');
    });
  });

  group('SymptomResponseDto.fromJson — linkedMeal 無, analysis 無', () {
    test('linkedMeal null', () {
      final entity =
          SymptomResponseDto.fromJson(_responseNoMealNoAnalysis).toEntity();
      expect(entity.linkedMeal, isNull);
    });

    test('analysisItems 빈 목록 (@Default [])', () {
      final entity =
          SymptomResponseDto.fromJson(_responseNoMealNoAnalysis).toEntity();
      expect(entity.analysisItems, isEmpty);
    });

    test('symptomTypes 빈 목록 (@Default [])', () {
      final entity =
          SymptomResponseDto.fromJson(_responseNoMealNoAnalysis).toEntity();
      expect(entity.symptomTypes, isEmpty);
    });

    test('symptomState "good" → SymptomState.good', () {
      final entity =
          SymptomResponseDto.fromJson(_responseNoMealNoAnalysis).toEntity();
      expect(entity.symptomState, SymptomState.good);
    });
  });

  group('SymptomResponseDto.fromJson — 미지값 폴백', () {
    test('미지 symptomState → SymptomState.normal 폴백', () {
      final entity =
          SymptomResponseDto.fromJson(_responseUnknownState).toEntity();
      expect(entity.symptomState, SymptomState.normal);
    });

    test('미지 symptomType → 필터링되어 제거, 알려진 타입만 남음', () {
      final entity =
          SymptomResponseDto.fromJson(_responseUnknownTypes).toEntity();
      expect(entity.symptomTypes.length, 1);
      expect(entity.symptomTypes[0], SymptomType.acidReflux);
    });
  });

  group('SymptomResponseDto — analysis.items 키 누락/null 방어', () {
    test('analysis 키 자체 없음 → analysisItems 빈 목록', () {
      final json = Map<String, dynamic>.from(_responseWithAll)
        ..remove('analysis');
      final entity = SymptomResponseDto.fromJson(json).toEntity();
      expect(entity.analysisItems, isEmpty);
    });

    test('analysis.items 빈 배열 → analysisItems 빈 목록', () {
      final json = {
        ..._responseNoMealNoAnalysis,
        'analysis': {'items': <dynamic>[]},
      };
      final entity = SymptomResponseDto.fromJson(json).toEntity();
      expect(entity.analysisItems, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // 요청 DTO — toJson + null removeWhere
  // -------------------------------------------------------------------------

  group('SymptomCreateRequestDto.toJson + removeWhere(null)', () {
    test('occurredAt null 이면 removeWhere 후 키 없음', () {
      final body = const SymptomCreateRequestDto(
        symptomState: 'uncomfortable',
        symptomTypes: ['acid_reflux'],
        mealRecordId: 'record-001',
      ).toJson()
        ..removeWhere((_, v) => v == null);
      expect(body.containsKey('occurredAt'), isFalse);
      expect(body['symptomState'], 'uncomfortable');
      expect(body['mealRecordId'], 'record-001');
    });

    test('occurredAt 있으면 toServerOffset 값이 보존된다', () {
      final dt = DateTime(2026, 6, 17, 14, 30, 0);
      final body = SymptomCreateRequestDto(
        symptomState: 'uncomfortable',
        mealRecordId: 'record-001',
        occurredAt: toServerOffset(dt),
      ).toJson()
        ..removeWhere((_, v) => v == null);
      expect(body['occurredAt'], '2026-06-17T14:30:00+09:00');
    });

    test('memo null 이면 removeWhere 후 키 없음', () {
      final body = const SymptomCreateRequestDto(
        symptomState: 'normal',
        mealRecordId: 'record-001',
      ).toJson()
        ..removeWhere((_, v) => v == null);
      expect(body.containsKey('memo'), isFalse);
    });

    test('memo 있으면 직렬화됨', () {
      final body = const SymptomCreateRequestDto(
        symptomState: 'normal',
        mealRecordId: 'record-001',
        memo: '메모 내용',
      ).toJson()
        ..removeWhere((_, v) => v == null);
      expect(body['memo'], '메모 내용');
    });

    test('symptomTypes 빈 목록 → [] 직렬화됨', () {
      final body = const SymptomCreateRequestDto(
        symptomState: 'good',
        mealRecordId: 'record-001',
      ).toJson();
      expect(body['symptomTypes'], <String>[]);
    });
  });

  group('SymptomUpdateRequestDto.toJson — occurredAt 필수', () {
    test('occurredAt 포함 직렬화', () {
      final body = const SymptomUpdateRequestDto(
        symptomState: 'severe',
        symptomTypes: ['throat_foreign_body'],
        occurredAt: '2026-06-17T14:30:00+09:00',
        mealRecordId: 'record-001',
      ).toJson()
        ..removeWhere((_, v) => v == null);
      expect(body['occurredAt'], '2026-06-17T14:30:00+09:00');
      expect(body['symptomState'], 'severe');
      expect(body['mealRecordId'], 'record-001');
    });

    test('memo null → removeWhere 후 키 없음', () {
      final body = const SymptomUpdateRequestDto(
        symptomState: 'normal',
        occurredAt: '2026-06-17T14:30:00+09:00',
        mealRecordId: 'record-001',
      ).toJson()
        ..removeWhere((_, v) => v == null);
      expect(body.containsKey('memo'), isFalse);
    });
  });

  group('SymptomMemoUpdateRequestDto.toJson', () {
    test('memo 있으면 직렬화됨', () {
      final body = const SymptomMemoUpdateRequestDto(memo: '새 메모').toJson();
      expect(body['memo'], '새 메모');
    });

    test('memo null 이면 null 값으로 직렬화됨', () {
      final body = const SymptomMemoUpdateRequestDto().toJson();
      expect(body['memo'], isNull);
    });
  });

  // -------------------------------------------------------------------------
  // toServerOffset 직렬화 직전 1회만 검증
  // -------------------------------------------------------------------------

  group('toServerOffset — KST 직렬화 계약', () {
    test('KST wall-clock → ISO-8601 +09:00 오프셋 포맷', () {
      final dt = DateTime(2026, 6, 17, 9, 2, 0);
      expect(toServerOffset(dt), '2026-06-17T09:02:00+09:00');
    });

    test('자정 직렬화', () {
      final dt = DateTime(2026, 6, 17);
      expect(toServerOffset(dt), '2026-06-17T00:00:00+09:00');
    });
  });

  // -------------------------------------------------------------------------
  // SymptomResponseDto — symptomState 5종 전체 fromJson 매핑
  // (comfortable·severe는 위 그룹에서 미커버 — 계약 5-enum 완전성 보장)
  // -------------------------------------------------------------------------

  group('SymptomResponseDto.fromJson — symptomState 5종 완전 매핑', () {
    // comfortable — 위 픽스처에 등장하지 않은 값
    test('"comfortable" → SymptomState.comfortable', () {
      final json = <String, dynamic>{
        'symptomId': 'sym-c',
        'symptomState': 'comfortable',
        'stateTitle': '편안한 하루예요',
        'symptomTypes': <String>[],
        'occurredAt': '2026-06-21T08:00:00+09:00',
      };
      final entity = SymptomResponseDto.fromJson(json).toEntity();
      expect(entity.symptomState, SymptomState.comfortable);
    });

    // severe — SymptomDraft 입력 쪽에서만 쓰이고 응답 역직렬화 테스트 없음
    test('"severe" → SymptomState.severe', () {
      final json = <String, dynamic>{
        'symptomId': 'sym-s',
        'symptomState': 'severe',
        'stateTitle': '많이 힘드셨군요',
        'symptomTypes': <String>[],
        'occurredAt': '2026-06-22T10:00:00+09:00',
      };
      final entity = SymptomResponseDto.fromJson(json).toEntity();
      expect(entity.symptomState, SymptomState.severe);
    });
  });
}
