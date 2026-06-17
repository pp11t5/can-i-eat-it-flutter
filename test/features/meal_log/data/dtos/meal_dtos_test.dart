import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/data/dtos/meal_dtos.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';

// ---------------------------------------------------------------------------
// OpenAPI 스펙에서 직접 도출한 fixture JSON (구현 코드 참조 금지)
// ---------------------------------------------------------------------------

/// 실서버 MealRecordSummary 응답 fixture.
const _mealRecordSummaryJson = {
  'mealId': 'm1',
  'mealGroupId': 'g1',
  'eatenAt': '2026-06-17T09:02:00+09:00',
  'food': {
    'externalId': 'f1',
    'name': '아메리카노',
    'category': 'beverage',
  },
  'judgedGrade': 'CAUTION',
};

/// 실서버 MealRecordDetail 응답 fixture.
const _mealRecordDetailJson = {
  'mealId': 'm1',
  'mealGroupId': 'g1',
  'eatenAt': '2026-06-17T09:02:00+09:00',
  'memo': '점심 후',
  'judgedGrade': 'RISK',
  'food': {
    'externalId': 'f1',
    'name': '커피',
    'category': 'beverage',
    'description': '카페인 함유 음료',
  },
  'stateRecords': [
    {
      'label': '속쓰림',
      'date': '2026-06-17',
      'timing': '식후 90분',
    },
  ],
};

/// 실서버 MealGroup 응답 fixture.
const _mealGroupJson = {
  'mealGroupId': 'g1',
  'eatenAt': '2026-06-17T09:02:00+09:00',
  'records': [
    {
      'mealId': 'm1',
      'mealGroupId': 'g1',
      'eatenAt': '2026-06-17T09:02:00+09:00',
      'food': {
        'externalId': 'f1',
        'name': '아메리카노',
        'category': 'beverage',
      },
      'judgedGrade': 'CAUTION',
    },
  ],
};

void main() {
  // -------------------------------------------------------------------------
  // StateRecordDto
  // -------------------------------------------------------------------------

  group('StateRecordDto.fromJson', () {
    const json = {
      'label': '속쓰림',
      'date': '2026-06-17',
      'timing': '식후 90분',
    };

    test('label 필드를 정확히 파싱한다', () {
      final dto = StateRecordDto.fromJson(json);
      expect(dto.label, '속쓰림');
    });

    test('date 필드를 정확히 파싱한다', () {
      final dto = StateRecordDto.fromJson(json);
      expect(dto.date, '2026-06-17');
    });

    test('timing 필드를 정확히 파싱한다', () {
      final dto = StateRecordDto.fromJson(json);
      expect(dto.timing, '식후 90분');
    });
  });

  group('StateRecordDto.toEntity', () {
    test('toEntity는 StateRecord를 반환한다', () {
      final dto = StateRecordDto.fromJson(
        const {'label': '속쓰림', 'date': '2026-06-17', 'timing': '식후 90분'},
      );
      expect(dto.toEntity(), isA<StateRecord>());
    });

    test('toEntity는 label·date·timing을 보존한다', () {
      final entity = StateRecordDto.fromJson(
        const {'label': '위산역류', 'date': '2026-06-10', 'timing': '식후 30분'},
      ).toEntity();
      expect(entity.label, '위산역류');
      expect(entity.date, '2026-06-10');
      expect(entity.timing, '식후 30분');
    });
  });

  // -------------------------------------------------------------------------
  // MealFoodDetailDto
  // -------------------------------------------------------------------------

  group('MealFoodDetailDto.fromJson', () {
    test('externalId 필드는 단일 문자열이다 (배열 아님)', () {
      final dto = MealFoodDetailDto.fromJson(
        const {
          'externalId': 'f1',
          'name': '커피',
          'category': 'beverage',
          'description': '카페인 함유 음료',
        },
      );
      expect(dto.externalId, 'f1');
      expect(dto.externalId, isA<String>());
    });

    test('name 필드를 정확히 파싱한다', () {
      final dto = MealFoodDetailDto.fromJson(
        const {'externalId': 'f1', 'name': '커피'},
      );
      expect(dto.name, '커피');
    });

    test('category null이면 null을 반환한다', () {
      final dto = MealFoodDetailDto.fromJson(
        const {'externalId': 'f1', 'name': '커피'},
      );
      expect(dto.category, isNull);
    });

    test('category 값이 있으면 정확히 파싱한다', () {
      final dto = MealFoodDetailDto.fromJson(
        const {'externalId': 'f1', 'name': '커피', 'category': 'beverage'},
      );
      expect(dto.category, 'beverage');
    });

    test('description null이면 null을 반환한다', () {
      final dto = MealFoodDetailDto.fromJson(
        const {'externalId': 'f1', 'name': '커피'},
      );
      expect(dto.description, isNull);
    });

    test('description 값이 있으면 정확히 파싱한다', () {
      final dto = MealFoodDetailDto.fromJson(
        const {
          'externalId': 'f1',
          'name': '커피',
          'description': '카페인 함유 음료',
        },
      );
      expect(dto.description, '카페인 함유 음료');
    });
  });

  group('MealFoodDetailDto.toEntity', () {
    test('toEntity는 MealFood를 반환한다', () {
      final dto = MealFoodDetailDto.fromJson(
        const {'externalId': 'f1', 'name': '커피'},
      );
      expect(dto.toEntity(), isA<MealFood>());
    });

    test('toEntity는 externalId·name을 보존한다', () {
      final entity = MealFoodDetailDto.fromJson(
        const {'externalId': 'f1', 'name': '커피'},
      ).toEntity();
      expect(entity.externalId, 'f1');
      expect(entity.name, '커피');
    });

    test('toEntity는 category·description null을 보존한다', () {
      final entity = MealFoodDetailDto.fromJson(
        const {'externalId': 'f1', 'name': '커피'},
      ).toEntity();
      expect(entity.category, isNull);
      expect(entity.description, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // MealRecordSummaryDto
  // -------------------------------------------------------------------------

  group('MealRecordSummaryDto.fromJson — 실서버 fixture', () {
    test('mealId 필드를 정확히 파싱한다', () {
      final dto = MealRecordSummaryDto.fromJson(_mealRecordSummaryJson);
      expect(dto.mealId, 'm1');
    });

    test('mealGroupId 필드를 정확히 파싱한다', () {
      final dto = MealRecordSummaryDto.fromJson(_mealRecordSummaryJson);
      expect(dto.mealGroupId, 'g1');
    });

    test('eatenAt 값이 그대로 보존된다', () {
      final dto = MealRecordSummaryDto.fromJson(_mealRecordSummaryJson);
      expect(dto.eatenAt, '2026-06-17T09:02:00+09:00');
    });

    test('food.externalId는 단일 문자열 "f1"이다', () {
      final dto = MealRecordSummaryDto.fromJson(_mealRecordSummaryJson);
      expect(dto.food.externalId, 'f1');
    });

    test('food.name을 정확히 파싱한다', () {
      final dto = MealRecordSummaryDto.fromJson(_mealRecordSummaryJson);
      expect(dto.food.name, '아메리카노');
    });

    test('food.category를 정확히 파싱한다', () {
      final dto = MealRecordSummaryDto.fromJson(_mealRecordSummaryJson);
      expect(dto.food.category, 'beverage');
    });

    test('judgedGrade 문자열 "CAUTION"이 그대로 보존된다', () {
      final dto = MealRecordSummaryDto.fromJson(_mealRecordSummaryJson);
      expect(dto.judgedGrade, 'CAUTION');
    });

    test('judgedGrade null이면 null을 반환한다', () {
      const json = {
        'mealId': 'm2',
        'mealGroupId': 'g1',
        'eatenAt': '2026-06-17T09:02:00+09:00',
        'food': {'externalId': 'f2', 'name': '물'},
        // judgedGrade 누락
      };
      final dto = MealRecordSummaryDto.fromJson(json);
      expect(dto.judgedGrade, isNull);
    });
  });

  group('MealRecordSummaryDto.toEntity', () {
    test('toEntity는 MealRecord를 반환한다', () {
      final dto = MealRecordSummaryDto.fromJson(_mealRecordSummaryJson);
      expect(dto.toEntity(), isA<MealRecord>());
    });

    test('judgedGrade "CAUTION" → VerdictLevel.caution', () {
      final entity =
          MealRecordSummaryDto.fromJson(_mealRecordSummaryJson).toEntity();
      expect(entity.judgedGrade, VerdictLevel.caution);
    });

    test('judgedGrade null → entity.judgedGrade null', () {
      const json = {
        'mealId': 'm2',
        'mealGroupId': 'g1',
        'eatenAt': '2026-06-17T09:02:00+09:00',
        'food': {'externalId': 'f2', 'name': '물'},
      };
      final entity = MealRecordSummaryDto.fromJson(json).toEntity();
      expect(entity.judgedGrade, isNull);
    });

    test('eatenAt이 엔티티에 그대로 전달된다', () {
      final entity =
          MealRecordSummaryDto.fromJson(_mealRecordSummaryJson).toEntity();
      expect(entity.eatenAt, '2026-06-17T09:02:00+09:00');
    });

    test('food.externalId가 엔티티에 그대로 전달된다', () {
      final entity =
          MealRecordSummaryDto.fromJson(_mealRecordSummaryJson).toEntity();
      expect(entity.food.externalId, 'f1');
    });
  });

  // -------------------------------------------------------------------------
  // MealRecordDetailDto
  // -------------------------------------------------------------------------

  group('MealRecordDetailDto.fromJson — 실서버 fixture', () {
    test('mealId 필드를 정확히 파싱한다', () {
      final dto = MealRecordDetailDto.fromJson(_mealRecordDetailJson);
      expect(dto.mealId, 'm1');
    });

    test('memo 필드를 정확히 파싱한다', () {
      final dto = MealRecordDetailDto.fromJson(_mealRecordDetailJson);
      expect(dto.memo, '점심 후');
    });

    test('judgedGrade 문자열 "RISK"가 그대로 보존된다', () {
      final dto = MealRecordDetailDto.fromJson(_mealRecordDetailJson);
      expect(dto.judgedGrade, 'RISK');
    });

    test('food.externalId는 단일 문자열 "f1"이다', () {
      final dto = MealRecordDetailDto.fromJson(_mealRecordDetailJson);
      expect(dto.food.externalId, 'f1');
    });

    test('food.description을 정확히 파싱한다', () {
      final dto = MealRecordDetailDto.fromJson(_mealRecordDetailJson);
      expect(dto.food.description, '카페인 함유 음료');
    });

    test('stateRecords 1건을 파싱한다', () {
      final dto = MealRecordDetailDto.fromJson(_mealRecordDetailJson);
      expect(dto.stateRecords.length, 1);
    });

    test('stateRecords[0].label을 정확히 파싱한다', () {
      final dto = MealRecordDetailDto.fromJson(_mealRecordDetailJson);
      expect(dto.stateRecords[0].label, '속쓰림');
    });

    test('stateRecords[0].date를 정확히 파싱한다', () {
      final dto = MealRecordDetailDto.fromJson(_mealRecordDetailJson);
      expect(dto.stateRecords[0].date, '2026-06-17');
    });

    test('stateRecords[0].timing을 정확히 파싱한다', () {
      final dto = MealRecordDetailDto.fromJson(_mealRecordDetailJson);
      expect(dto.stateRecords[0].timing, '식후 90분');
    });

    test('memo null이면 null을 반환한다', () {
      final json = Map<String, dynamic>.from(_mealRecordDetailJson)
        ..remove('memo');
      final dto = MealRecordDetailDto.fromJson(json);
      expect(dto.memo, isNull);
    });

    test('judgedGrade null이면 null을 반환한다', () {
      final json = Map<String, dynamic>.from(_mealRecordDetailJson)
        ..remove('judgedGrade');
      final dto = MealRecordDetailDto.fromJson(json);
      expect(dto.judgedGrade, isNull);
    });

    test('stateRecords 누락이면 빈 목록으로 폴백된다', () {
      final json = Map<String, dynamic>.from(_mealRecordDetailJson)
        ..remove('stateRecords');
      final dto = MealRecordDetailDto.fromJson(json);
      expect(dto.stateRecords, isEmpty);
    });

    test('stateRecords 빈 배열이면 빈 목록이다', () {
      final json = Map<String, dynamic>.from(_mealRecordDetailJson)
        ..['stateRecords'] = <dynamic>[];
      final dto = MealRecordDetailDto.fromJson(json);
      expect(dto.stateRecords, isEmpty);
    });

    test('food.category null이면 null을 반환한다', () {
      final detailJson = {
        'mealId': 'm1',
        'mealGroupId': 'g1',
        'eatenAt': '2026-06-17T09:02:00+09:00',
        'judgedGrade': 'RISK',
        'food': {
          'externalId': 'f1',
          'name': '커피',
          // category 누락
        },
        'stateRecords': <dynamic>[],
      };
      final dto = MealRecordDetailDto.fromJson(detailJson);
      expect(dto.food.category, isNull);
    });

    test('food.description null이면 null을 반환한다', () {
      final detailJson = {
        'mealId': 'm1',
        'mealGroupId': 'g1',
        'eatenAt': '2026-06-17T09:02:00+09:00',
        'judgedGrade': 'RISK',
        'food': {
          'externalId': 'f1',
          'name': '커피',
          // description 누락
        },
        'stateRecords': <dynamic>[],
      };
      final dto = MealRecordDetailDto.fromJson(detailJson);
      expect(dto.food.description, isNull);
    });
  });

  group('MealRecordDetailDto.toEntity', () {
    test('toEntity는 MealDetail을 반환한다', () {
      final dto = MealRecordDetailDto.fromJson(_mealRecordDetailJson);
      expect(dto.toEntity(), isA<MealDetail>());
    });

    test('judgedGrade "RISK" → VerdictLevel.risk', () {
      final entity =
          MealRecordDetailDto.fromJson(_mealRecordDetailJson).toEntity();
      expect(entity.judgedGrade, VerdictLevel.risk);
    });

    test('judgedGrade null → entity.judgedGrade null', () {
      final json = Map<String, dynamic>.from(_mealRecordDetailJson)
        ..remove('judgedGrade');
      final entity = MealRecordDetailDto.fromJson(json).toEntity();
      expect(entity.judgedGrade, isNull);
    });

    test('memo가 엔티티에 그대로 전달된다', () {
      final entity =
          MealRecordDetailDto.fromJson(_mealRecordDetailJson).toEntity();
      expect(entity.memo, '점심 후');
    });

    test('stateRecords 1건이 엔티티에 그대로 전달된다', () {
      final entity =
          MealRecordDetailDto.fromJson(_mealRecordDetailJson).toEntity();
      expect(entity.stateRecords.length, 1);
      expect(entity.stateRecords[0].label, '속쓰림');
      expect(entity.stateRecords[0].date, '2026-06-17');
      expect(entity.stateRecords[0].timing, '식후 90분');
    });

    test('stateRecords 누락이면 엔티티 stateRecords가 빈 목록이다', () {
      final json = Map<String, dynamic>.from(_mealRecordDetailJson)
        ..remove('stateRecords');
      final entity = MealRecordDetailDto.fromJson(json).toEntity();
      expect(entity.stateRecords, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // MealGroupDto
  // -------------------------------------------------------------------------

  group('MealGroupDto.fromJson — 실서버 fixture', () {
    test('mealGroupId 필드를 정확히 파싱한다', () {
      final dto = MealGroupDto.fromJson(_mealGroupJson);
      expect(dto.mealGroupId, 'g1');
    });

    test('eatenAt 값이 그대로 보존된다', () {
      final dto = MealGroupDto.fromJson(_mealGroupJson);
      expect(dto.eatenAt, '2026-06-17T09:02:00+09:00');
    });

    test('records 1건을 파싱한다', () {
      final dto = MealGroupDto.fromJson(_mealGroupJson);
      expect(dto.records.length, 1);
    });

    test('records[0].mealId를 정확히 파싱한다', () {
      final dto = MealGroupDto.fromJson(_mealGroupJson);
      expect(dto.records[0].mealId, 'm1');
    });

    test('records 누락이면 빈 목록으로 폴백된다', () {
      const json = {
        'mealGroupId': 'g1',
        'eatenAt': '2026-06-17T09:02:00+09:00',
        // records 누락
      };
      final dto = MealGroupDto.fromJson(json);
      expect(dto.records, isEmpty);
    });
  });

  group('MealGroupDto.toEntity', () {
    test('toEntity는 MealGroup을 반환한다', () {
      final dto = MealGroupDto.fromJson(_mealGroupJson);
      expect(dto.toEntity(), isA<MealGroup>());
    });

    test('mealGroupId·eatenAt이 엔티티에 그대로 전달된다', () {
      final entity = MealGroupDto.fromJson(_mealGroupJson).toEntity();
      expect(entity.mealGroupId, 'g1');
      expect(entity.eatenAt, '2026-06-17T09:02:00+09:00');
    });

    test('records[0].judgedGrade "CAUTION" → VerdictLevel.caution', () {
      final entity = MealGroupDto.fromJson(_mealGroupJson).toEntity();
      expect(entity.records[0].judgedGrade, VerdictLevel.caution);
    });

    test('records[0].food.externalId가 엔티티에 전달된다', () {
      final entity = MealGroupDto.fromJson(_mealGroupJson).toEntity();
      expect(entity.records[0].food.externalId, 'f1');
    });
  });
}
