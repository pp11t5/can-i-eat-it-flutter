import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/data/dtos/meal_dtos.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

// ---------------------------------------------------------------------------
// 신 서버 계약 fixture JSON
// ---------------------------------------------------------------------------

/// POST /meal-records · GET foods/{id} 응답 (analysis 포함).
const _foodDetailJson = {
  'mealFoodId': 'mf1',
  'eatenAt': '2026-06-17T09:02:00+09:00',
  'food': {
    'mealRecordExternalId': 'mr1',
    'name': '커피',
    'category': 'beverage',
  },
  'analysis': {
    'judgmentGrade': 'RISK',
    'triggerAnalysis': {'ment': '트리거', 'content': '카페인이 위산을 자극해요.'},
    'allergyAnalysis': {'ment': '알레르기', 'content': '충돌 없음'},
  },
  'stateRecord': {
    'stateRecordId': 'sr1',
    'label': '속쓰림',
    'date': '2026-06-17',
    'timingMinutes': 90,
  },
};

/// GET /meal-records/{id} 응답.
const _mealRecordDetailJson = {
  'mealRecordId': 'mr1',
  'eatenAt': '2026-06-17T09:02:00+09:00',
  'meals': [
    {
      'mealFoodId': 'mf1',
      'name': '커피',
      'category': 'beverage',
      'eatenAt': '2026-06-17T09:02:00+09:00',
    },
    {
      'mealFoodId': 'mf2',
      'name': '된장찌개',
      'eatenAt': '2026-06-17T09:05:00+09:00',
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
};

void main() {
  // -------------------------------------------------------------------------
  // AnalysisSectionDto
  // -------------------------------------------------------------------------
  group('AnalysisSectionDto', () {
    test('ment·content를 파싱하고 toEntity에 보존한다', () {
      final dto = AnalysisSectionDto.fromJson(
        const {'ment': '트리거', 'content': '본문'},
      );
      expect(dto.ment, '트리거');
      expect(dto.content, '본문');
      final entity = dto.toEntity();
      expect(entity, isA<AnalysisSection>());
      expect(entity.ment, '트리거');
      expect(entity.content, '본문');
    });
  });

  // -------------------------------------------------------------------------
  // MealAnalysisDto
  // -------------------------------------------------------------------------
  group('MealAnalysisDto', () {
    test('judgmentGrade "RISK" → VerdictLevel.risk', () {
      final dto = MealAnalysisDto.fromJson(
        const {'judgmentGrade': 'RISK'},
      );
      expect(dto.toEntity().judgmentGrade, VerdictLevel.risk);
    });

    test('triggerAnalysis·allergyAnalysis 누락 시 null로 폴백된다', () {
      final entity = MealAnalysisDto.fromJson(
        const {'judgmentGrade': 'UNKNOWN'},
      ).toEntity();
      expect(entity.judgmentGrade, VerdictLevel.unknown);
      expect(entity.trigger, isNull);
      expect(entity.allergy, isNull);
    });

    test('triggerAnalysis만 있으면 allergy는 null이다', () {
      final entity = MealAnalysisDto.fromJson(
        const {
          'judgmentGrade': 'CAUTION',
          'triggerAnalysis': {'ment': 't', 'content': 'c'},
        },
      ).toEntity();
      expect(entity.trigger, isNotNull);
      expect(entity.allergy, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // StateRecordDto
  // -------------------------------------------------------------------------
  group('StateRecordDto', () {
    const json = {
      'stateRecordId': 'sr1',
      'label': '속쓰림',
      'date': '2026-06-17',
      'timingMinutes': 90,
    };

    test('필드를 정확히 파싱한다', () {
      final dto = StateRecordDto.fromJson(json);
      expect(dto.stateRecordId, 'sr1');
      expect(dto.label, '속쓰림');
      expect(dto.date, '2026-06-17');
      expect(dto.timingMinutes, 90);
    });

    test('toEntity는 StateRecord를 반환하고 timingMinutes를 보존한다', () {
      final entity = StateRecordDto.fromJson(json).toEntity();
      expect(entity, isA<StateRecord>());
      expect(entity.stateRecordId, 'sr1');
      expect(entity.timingMinutes, 90);
    });
  });

  // -------------------------------------------------------------------------
  // MealFoodRecordDetailDto
  // -------------------------------------------------------------------------
  group('MealFoodRecordDetailDto.fromJson — 신 fixture', () {
    test('mealFoodId·food.name·food.category를 파싱한다', () {
      final dto = MealFoodRecordDetailDto.fromJson(_foodDetailJson);
      expect(dto.mealFoodId, 'mf1');
      expect(dto.food.name, '커피');
      expect(dto.food.category, 'beverage');
    });

    test('food.mealRecordExternalId를 파싱한다', () {
      final dto = MealFoodRecordDetailDto.fromJson(_foodDetailJson);
      expect(dto.food.mealRecordExternalId, 'mr1');
    });

    test('analysis가 있으면 toEntity가 analysis를 채운다', () {
      final entity = MealFoodRecordDetailDto.fromJson(_foodDetailJson).toEntity();
      expect(entity, isA<MealFood>());
      expect(entity.mealFoodId, 'mf1');
      expect(entity.mealRecordExternalId, 'mr1');
      expect(entity.analysis, isNotNull);
      expect(entity.analysis!.judgmentGrade, VerdictLevel.risk);
      expect(entity.analysis!.trigger!.content, '카페인이 위산을 자극해요.');
    });

    test('analysis 누락 시 toEntity의 analysis는 null이다', () {
      final json = Map<String, dynamic>.from(_foodDetailJson)
        ..remove('analysis');
      final entity = MealFoodRecordDetailDto.fromJson(json).toEntity();
      expect(entity.analysis, isNull);
    });

    test('category 누락 시 null이다', () {
      final json = {
        'mealFoodId': 'mf1',
        'eatenAt': '2026-06-17T09:02:00+09:00',
        'food': {'name': '물'},
      };
      final entity = MealFoodRecordDetailDto.fromJson(json).toEntity();
      expect(entity.category, isNull);
      expect(entity.mealRecordExternalId, isNull);
    });

    // 계약: stateRecord null 방어 (stateRecord 키 없음)
    test('stateRecord 키 누락 시 toEntity는 예외 없이 완료된다', () {
      final json = Map<String, dynamic>.from(_foodDetailJson)
        ..remove('stateRecord');
      // MealFoodRecordDetailDto.toEntity()가 stateRecord를 직접 매핑하지 않으므로
      // 예외 없이 완료되어야 한다.
      expect(() => MealFoodRecordDetailDto.fromJson(json).toEntity(), returnsNormally);
    });

    // 계약: analysis 명시 null (키 존재, 값 null)
    test('analysis 명시 null이어도 toEntity의 analysis는 null이다', () {
      final json = Map<String, dynamic>.from(_foodDetailJson)
        ..['analysis'] = null;
      final entity = MealFoodRecordDetailDto.fromJson(json).toEntity();
      expect(entity.analysis, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // MealRecordDetailDto
  // -------------------------------------------------------------------------
  group('MealRecordDetailDto.fromJson — 신 fixture', () {
    test('mealRecordId·eatenAt을 파싱한다', () {
      final dto = MealRecordDetailDto.fromJson(_mealRecordDetailJson);
      expect(dto.mealRecordId, 'mr1');
      expect(dto.eatenAt, '2026-06-17T09:02:00+09:00');
    });

    test('meals 2건을 foods로 매핑하고 analysis는 null이다', () {
      final entity = MealRecordDetailDto.fromJson(_mealRecordDetailJson).toEntity();
      expect(entity, isA<MealRecord>());
      expect(entity.foods.length, 2);
      expect(entity.foods[0].mealFoodId, 'mf1');
      expect(entity.foods[0].analysis, isNull);
    });

    test('stateRecords 1건을 매핑한다', () {
      final entity = MealRecordDetailDto.fromJson(_mealRecordDetailJson).toEntity();
      expect(entity.stateRecords.length, 1);
      expect(entity.stateRecords[0].timingMinutes, 90);
    });

    test('stateRecords 누락 시 빈 목록으로 폴백된다', () {
      final json = Map<String, dynamic>.from(_mealRecordDetailJson)
        ..remove('stateRecords');
      final entity = MealRecordDetailDto.fromJson(json).toEntity();
      expect(entity.stateRecords, isEmpty);
    });

    test('stateRecords 명시 null이어도 빈 목록으로 폴백된다', () {
      final json = Map<String, dynamic>.from(_mealRecordDetailJson)
        ..['stateRecords'] = null;
      final entity = MealRecordDetailDto.fromJson(json).toEntity();
      expect(entity.stateRecords, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // TimelineItemDto — 수동 디스패치
  // -------------------------------------------------------------------------
  group('TimelineItemDto.fromJson — timeLineType 분기', () {
    test('single → TimelineSingle, grade 매핑', () {
      final item = TimelineItemDto.fromJson(const {
        'timeLineType': 'single',
        'mealRecordId': 'mr1',
        'mealRecordDateTime': '2026-06-17T08:00:00+09:00',
        'mealFoodName': '두부',
        'grade': 'RECOMMEND',
      });
      expect(item, isA<TimelineSingle>());
      final single = item! as TimelineSingle;
      expect(single.mealRecordId, 'mr1');
      expect(single.mealFoodName, '두부');
      expect(single.grade, VerdictLevel.recommend);
    });

    test('single — etcCount 0 이 보존된다 (계약 verbatim)', () {
      final item = TimelineItemDto.fromJson(const {
        'timeLineType': 'single',
        'mealRecordId': 'mr1',
        'mealRecordDateTime': '2026-06-24T08:30:00+09:00',
        'mealFoodName': '두부',
        'grade': 'RECOMMEND',
        'etcCount': 0,
      });
      expect((item! as TimelineSingle).etcCount, 0);
    });

    test('group → TimelineGroup, representativeFoods·etcCount 매핑', () {
      final item = TimelineItemDto.fromJson(const {
        'timeLineType': 'group',
        'mealRecordId': 'mr2',
        'mealRecordDateTime': '2026-06-17T12:30:00+09:00',
        'representativeFoods': ['된장찌개', '커피'],
        'etcCount': 2,
      });
      expect(item, isA<TimelineGroup>());
      final group = item! as TimelineGroup;
      expect(group.representativeFoods, ['된장찌개', '커피']);
      expect(group.etcCount, 2);
    });

    test('symptom → TimelineSymptom, symptomState 매핑', () {
      final item = TimelineItemDto.fromJson(const {
        'timeLineType': 'symptom',
        'symptomState': 'uncomfortable',
        'afterMealMinutes': 120,
        'occurredAt': '2026-06-17T14:30:00+09:00',
      });
      expect(item, isA<TimelineSymptom>());
      final symptom = item! as TimelineSymptom;
      expect(symptom.symptomState, SymptomState.uncomfortable);
      expect(symptom.afterMealMinutes, 120);
    });

    test('알 수 없는 timeLineType은 null을 반환한다 (스킵용)', () {
      final item = TimelineItemDto.fromJson(const {
        'timeLineType': 'futureType',
        'mealRecordId': 'x',
      });
      expect(item, isNull);
    });

    test('timeLineType 누락 시 null을 반환한다', () {
      final item = TimelineItemDto.fromJson(const {'mealRecordId': 'x'});
      expect(item, isNull);
    });

    // 계약 verbatim: "unknownX"는 무시돼야 함
    test('"unknownX" timeLineType도 null을 반환한다', () {
      final item = TimelineItemDto.fromJson(const {
        'timeLineType': 'unknownX',
        'mealRecordId': 'mr-x',
      });
      expect(item, isNull);
    });

    test('symptom — occurredAt 필드가 보존된다 (계약 verbatim)', () {
      final item = TimelineItemDto.fromJson(const {
        'timeLineType': 'symptom',
        'symptomState': 'uncomfortable',
        'afterMealMinutes': 90,
        'occurredAt': '2026-06-24T10:00:00+09:00',
      });
      expect(item, isA<TimelineSymptom>());
      expect((item! as TimelineSymptom).occurredAt, '2026-06-24T10:00:00+09:00');
    });

    test('group — etcCount가 2일 때 보존된다 (계약 verbatim)', () {
      final item = TimelineItemDto.fromJson(const {
        'timeLineType': 'group',
        'mealRecordId': 'mr2',
        'mealRecordDateTime': '2026-06-24T09:00:00+09:00',
        'representativeFoods': ['김치', '된장찌개'],
        'etcCount': 2,
      });
      final group = item! as TimelineGroup;
      expect(group.representativeFoods, ['김치', '된장찌개']);
      expect(group.etcCount, 2);
    });

    // -------------------------------------------------------------------------
    // S-2 회귀: 알려진 타입이라도 필수 필드 누락 시 항목만 스킵 (TypeError 방지)
    // -------------------------------------------------------------------------
    group('필수 필드 누락 — 해당 항목만 null 반환 (whereType 스킵)', () {
      test('혼합 리스트: 유효 single + mealFoodName 누락 single + afterMealMinutes 누락 symptom → 유효 항목만', () {
        final rawItems = [
          // 유효 single
          const {
            'timeLineType': 'single',
            'mealRecordId': 'mr-ok',
            'mealRecordDateTime': '2026-06-24T08:00:00+09:00',
            'mealFoodName': '두부',
            'grade': 'RECOMMEND',
          },
          // mealFoodName 누락 single → null 반환(스킵)
          const {
            'timeLineType': 'single',
            'mealRecordId': 'mr-bad',
            'mealRecordDateTime': '2026-06-24T09:00:00+09:00',
            // 'mealFoodName' 누락
            'grade': 'CAUTION',
          },
          // afterMealMinutes 누락 symptom → null 반환(스킵)
          const {
            'timeLineType': 'symptom',
            'symptomState': 'uncomfortable',
            // 'afterMealMinutes' 누락
            'occurredAt': '2026-06-24T10:00:00+09:00',
          },
        ];

        // whereType<TimelineItem>() 으로 null 항목을 걸러내는 실제 호출부 패턴을 재현한다.
        final items = rawItems
            .map((j) => TimelineItemDto.fromJson(j as Map<String, dynamic>))
            .whereType<TimelineItem>()
            .toList();

        // 예외 없이 완료되고 유효 항목 1개만 남아야 한다.
        expect(items.length, 1);
        expect(items[0], isA<TimelineSingle>());
        expect((items[0] as TimelineSingle).mealRecordId, 'mr-ok');
      });

      test('single: mealRecordId 누락 → null 반환', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'single',
          // 'mealRecordId' 누락
          'mealRecordDateTime': '2026-06-24T08:00:00+09:00',
          'mealFoodName': '두부',
          'grade': 'RECOMMEND',
        });
        expect(item, isNull);
      });

      test('single: grade 누락 → null 반환', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'single',
          'mealRecordId': 'mr1',
          'mealRecordDateTime': '2026-06-24T08:00:00+09:00',
          'mealFoodName': '두부',
          // 'grade' 누락
        });
        expect(item, isNull);
      });

      test('group: mealRecordDateTime 누락 → null 반환', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'group',
          'mealRecordId': 'mr2',
          // 'mealRecordDateTime' 누락
          'representativeFoods': ['된장찌개'],
        });
        expect(item, isNull);
      });

      test('symptom: occurredAt 누락 → null 반환', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'symptom',
          'symptomState': 'uncomfortable',
          'afterMealMinutes': 90,
          // 'occurredAt' 누락
        });
        expect(item, isNull);
      });

      test('symptom: symptomState 누락 → null 반환', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'symptom',
          // 'symptomState' 누락
          'afterMealMinutes': 90,
          'occurredAt': '2026-06-24T10:00:00+09:00',
        });
        expect(item, isNull);
      });
    });
  });

  // -------------------------------------------------------------------------
  // WeeklyDayDto
  // -------------------------------------------------------------------------
  group('WeeklyDayDto', () {
    test('judgementList를 VerdictLevel 목록으로 매핑한다', () {
      final entity = WeeklyDayDto.fromJson(const {
        'date': '2026-06-17',
        'dayOfWeek': 'WED',
        'judgementList': ['RECOMMEND', 'CAUTION', 'RISK'],
      }).toEntity();
      expect(entity, isA<WeeklyDay>());
      expect(entity.date, '2026-06-17');
      expect(entity.judgements, [
        VerdictLevel.recommend,
        VerdictLevel.caution,
        VerdictLevel.risk,
      ]);
    });

    test('judgementList 누락 시 빈 목록으로 폴백된다', () {
      final entity = WeeklyDayDto.fromJson(const {
        'date': '2026-06-17',
        'dayOfWeek': 'WED',
      }).toEntity();
      expect(entity.judgements, isEmpty);
    });

    // 계약: judgementList ≤3 대문자 grade
    test('judgementList는 최대 3개(계약 ≤3) — 3개 모두 매핑된다', () {
      final entity = WeeklyDayDto.fromJson(const {
        'date': '2026-06-24',
        'dayOfWeek': 'WED',
        'judgementList': ['RECOMMEND', 'CAUTION', 'RISK'],
      }).toEntity();
      expect(entity.judgements.length, lessThanOrEqualTo(3));
      expect(entity.judgements.length, 3);
    });

    // 계약: 미지 grade는 unknown 폴백
    test('미지 grade 문자열은 VerdictLevel.unknown으로 폴백된다', () {
      final entity = WeeklyDayDto.fromJson(const {
        'date': '2026-06-24',
        'dayOfWeek': 'WED',
        'judgementList': ['UNKNOWN', 'NEWGRADE'],
      }).toEntity();
      expect(entity.judgements[0], VerdictLevel.unknown);
      expect(entity.judgements[1], VerdictLevel.unknown);
    });

    // 계약: dayOfWeek 'WED' 보존
    test('dayOfWeek 값이 엔티티에 보존된다', () {
      final entity = WeeklyDayDto.fromJson(const {
        'date': '2026-06-24',
        'dayOfWeek': 'WED',
        'judgementList': ['RECOMMEND'],
      }).toEntity();
      expect(entity.dayOfWeek, 'WED');
    });
  });

  // -------------------------------------------------------------------------
  // MealCandidatesDayDto
  // -------------------------------------------------------------------------
  group('MealCandidatesDayDto', () {
    test('representativeFood를 평탄화해 매핑한다', () {
      final entity = MealCandidatesDayDto.fromJson(const {
        'date': '2026-06-17',
        'meals': [
          {
            'mealRecordId': 'mr1',
            'representativeFood': {'name': '된장찌개', 'category': 'korean'},
            'otherFoodCount': 2,
            'eatenAt': '2026-06-17T12:30:00+09:00',
          },
        ],
      }).toEntity();
      expect(entity, isA<MealCandidatesDay>());
      expect(entity.meals.length, 1);
      expect(entity.meals[0].representativeFoodName, '된장찌개');
      expect(entity.meals[0].representativeFoodCategory, 'korean');
      expect(entity.meals[0].otherFoodCount, 2);
    });

    // 계약 verbatim: representativeFood.category null 방어
    test('representativeFood.category null → representativeFoodCategory가 null이다', () {
      final entity = MealCandidatesDayDto.fromJson(const {
        'date': '2026-06-24',
        'meals': [
          {
            'mealRecordId': 'mr1',
            'representativeFood': {'name': '두부', 'category': null},
            'otherFoodCount': 2,
            'eatenAt': '2026-06-24T12:30:00+09:00',
          },
        ],
      }).toEntity();
      expect(entity.meals[0].representativeFoodCategory, isNull);
      expect(entity.meals[0].representativeFoodName, '두부');
    });

    // 계약: category 키 아예 없을 때도 null 방어
    test('representativeFood.category 키 누락 → representativeFoodCategory가 null이다', () {
      final entity = MealCandidatesDayDto.fromJson(const {
        'date': '2026-06-24',
        'meals': [
          {
            'mealRecordId': 'mr2',
            'representativeFood': {'name': '두부'},
            'otherFoodCount': 0,
            'eatenAt': '2026-06-24T08:00:00+09:00',
          },
        ],
      }).toEntity();
      expect(entity.meals[0].representativeFoodCategory, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // CreateMealRecordRequestDto
  // -------------------------------------------------------------------------
  group('CreateMealRecordRequestDto', () {
    test('judgedGrade 필드가 없다 (F-10)', () {
      const dto = CreateMealRecordRequestDto(foodExternalId: 'f1');
      final json = dto.toJson();
      expect(json.containsKey('judgedGrade'), isFalse);
      expect(json['foodExternalId'], 'f1');
    });

    // 계약: null 필드는 직렬화 시 키 자체가 없어야 함 (impl이 removeWhere null 처리)
    // toJson() 자체에서는 null 키가 포함될 수 있으므로 impl의 removeWhere 패턴 검증
    test('eatenAt null이면 toJson에 eatenAt 값이 null이다 (impl removeWhere 대상)', () {
      const dto = CreateMealRecordRequestDto(foodExternalId: 'f1');
      final json = dto.toJson();
      // toJson은 null을 포함할 수 있음 — impl이 removeWhere(null)로 제거한다.
      // 여기서는 null이거나 키가 없어야 한다.
      expect(json['eatenAt'], isNull);
    });

    test('mealRecordId null이면 toJson에 mealRecordId 값이 null이다 (impl removeWhere 대상)', () {
      const dto = CreateMealRecordRequestDto(foodExternalId: 'f2');
      final json = dto.toJson();
      expect(json['mealRecordId'], isNull);
    });

    // impl이 removeWhere 후 전송할 때 judgedGrade가 절대 없는지 이중 확인
    test('eatenAt·mealRecordId 제공 시에도 judgedGrade 필드는 없다', () {
      const dto = CreateMealRecordRequestDto(
        foodExternalId: 'f3',
        eatenAt: '2026-06-24T08:30:00+09:00',
        mealRecordId: 'mr1',
      );
      final json = dto.toJson();
      expect(json.containsKey('judgedGrade'), isFalse);
      expect(json['foodExternalId'], 'f3');
      expect(json['eatenAt'], '2026-06-24T08:30:00+09:00');
      expect(json['mealRecordId'], 'mr1');
    });
  });
}
