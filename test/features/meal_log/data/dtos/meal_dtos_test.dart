import 'package:characters/characters.dart';
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
    // W7: timeIcon·connectedSymptoms·symptomId (P1 additive)
    // -------------------------------------------------------------------------
    group('timeIcon·connectedSymptoms·symptomId — P1 신규 필드', () {
      test('single — timeIcon "sun"·connectedSymptoms를 매핑한다', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'single',
          'mealRecordId': 'mr1',
          'mealRecordDateTime': '2026-06-17T08:00:00+09:00',
          'mealFoodName': '두부',
          'grade': 'RECOMMEND',
          'timeIcon': 'sun',
          'connectedSymptoms': {
            'symptomId': 'sym-1',
            'symptomState': 'uncomfortable',
            'afterMealMinutes': 90,
            'representativeSymptoms': ['속쓰림'],
            'etcCount': 1,
          },
        });
        final single = item! as TimelineSingle;
        expect(single.timeIcon, TimeIcon.sun);
        expect(single.connectedSymptoms, isNotNull);
        expect(single.connectedSymptoms!.symptomId, 'sym-1');
        expect(single.connectedSymptoms!.symptomState, SymptomState.uncomfortable);
        expect(single.connectedSymptoms!.representativeSymptoms, ['속쓰림']);
        expect(single.connectedSymptoms!.etcCount, 1);
      });

      test('single — timeIcon "moon" → TimeIcon.moon', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'single',
          'mealRecordId': 'mr1',
          'mealRecordDateTime': '2026-06-17T20:00:00+09:00',
          'mealFoodName': '두부',
          'grade': 'RECOMMEND',
          'timeIcon': 'moon',
        });
        expect((item! as TimelineSingle).timeIcon, TimeIcon.moon);
      });

      test('single — timeIcon·connectedSymptoms 누락 시 둘 다 null이다', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'single',
          'mealRecordId': 'mr1',
          'mealRecordDateTime': '2026-06-17T08:00:00+09:00',
          'mealFoodName': '두부',
          'grade': 'RECOMMEND',
        });
        final single = item! as TimelineSingle;
        expect(single.timeIcon, isNull);
        expect(single.connectedSymptoms, isNull);
      });

      test('single — 알 수 없는 timeIcon 문자열은 null로 폴백된다', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'single',
          'mealRecordId': 'mr1',
          'mealRecordDateTime': '2026-06-17T08:00:00+09:00',
          'mealFoodName': '두부',
          'grade': 'RECOMMEND',
          'timeIcon': 'dawn',
        });
        expect((item! as TimelineSingle).timeIcon, isNull);
      });

      // pr-review 수정1: connectedSymptoms 필수 필드 누락 시 TypeError로
      // 항목 전체가 무너지지 않고 칩만 null로 흡수돼야 한다.
      test('single — connectedSymptoms 필수 필드(symptomId) 누락 시 칩은 null이지만 항목은 유지된다', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'single',
          'mealRecordId': 'mr1',
          'mealRecordDateTime': '2026-06-17T08:00:00+09:00',
          'mealFoodName': '두부',
          'grade': 'RECOMMEND',
          'connectedSymptoms': {
            // 'symptomId' 누락 → ConnectedSymptomsDto.fromJson TypeError 유발
            'symptomState': 'uncomfortable',
            'afterMealMinutes': 90,
          },
        });
        expect(item, isNotNull);
        final single = item! as TimelineSingle;
        expect(single.mealFoodName, '두부');
        expect(single.connectedSymptoms, isNull);
      });

      // pr-review 수정1: timeIcon이 문자열이 아닌 이상값(예: 숫자)이어도
      // 캐스팅 TypeError로 항목이 무너지지 않고 null로 흡수돼야 한다.
      test('single — timeIcon이 문자열이 아니면(숫자) null로 흡수되고 항목은 유지된다', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'single',
          'mealRecordId': 'mr1',
          'mealRecordDateTime': '2026-06-17T08:00:00+09:00',
          'mealFoodName': '두부',
          'grade': 'RECOMMEND',
          'timeIcon': 1,
        });
        expect(item, isNotNull);
        final single = item! as TimelineSingle;
        expect(single.mealFoodName, '두부');
        expect(single.timeIcon, isNull);
      });

      test('group — timeIcon·connectedSymptoms를 매핑한다', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'group',
          'mealRecordId': 'mr2',
          'mealRecordDateTime': '2026-06-17T12:30:00+09:00',
          'representativeFoods': ['된장찌개', '커피'],
          'etcCount': 1,
          'timeIcon': 'sun',
          'connectedSymptoms': {
            'symptomId': 'sym-2',
            'symptomState': 'severe',
            'afterMealMinutes': 60,
          },
        });
        final group = item! as TimelineGroup;
        expect(group.timeIcon, TimeIcon.sun);
        expect(group.connectedSymptoms!.symptomId, 'sym-2');
        expect(group.connectedSymptoms!.symptomState, SymptomState.severe);
        // representativeSymptoms·etcCount 누락 → DTO 폴백(빈 목록·0)
        expect(group.connectedSymptoms!.representativeSymptoms, isEmpty);
        expect(group.connectedSymptoms!.etcCount, 0);
      });

      test('symptom — symptomId를 매핑한다', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'symptom',
          'symptomState': 'uncomfortable',
          'afterMealMinutes': 120,
          'occurredAt': '2026-06-17T14:30:00+09:00',
          'symptomId': 'sym-3',
        });
        expect((item! as TimelineSymptom).symptomId, 'sym-3');
      });

      test('symptom — symptomId 누락 시 null이다 (구 페이로드 방어)', () {
        final item = TimelineItemDto.fromJson(const {
          'timeLineType': 'symptom',
          'symptomState': 'uncomfortable',
          'afterMealMinutes': 120,
          'occurredAt': '2026-06-17T14:30:00+09:00',
        });
        expect((item! as TimelineSymptom).symptomId, isNull);
      });
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
  // MealRecordTextRequestDto — by-text (POST /meal-records · .../foods)
  // -------------------------------------------------------------------------
  group('MealRecordTextRequestDto', () {
    test('name 필드를 직렬화한다', () {
      const dto = MealRecordTextRequestDto(name: '아메리카노');
      expect(dto.toJson()['name'], '아메리카노');
    });

    test('judgedGrade 필드가 없다 (F-10)', () {
      const dto = MealRecordTextRequestDto(name: '아메리카노');
      expect(dto.toJson().containsKey('judgedGrade'), isFalse);
    });

    // 계약: null 필드는 직렬화 시 키 자체가 없어야 함 (impl이 removeWhere null 처리)
    test('eatenAt null이면 toJson에 eatenAt 값이 null이다 (impl removeWhere 대상)', () {
      const dto = MealRecordTextRequestDto(name: '아메리카노');
      expect(dto.toJson()['eatenAt'], isNull);
    });

    test('eatenAt 제공 시 값이 보존된다', () {
      const dto = MealRecordTextRequestDto(
        name: '아메리카노',
        eatenAt: '2026-06-24T08:30:00+09:00',
      );
      expect(dto.toJson()['eatenAt'], '2026-06-24T08:30:00+09:00');
    });
  });

  // -------------------------------------------------------------------------
  // MealRecordByIdRequestDto — by-id (POST /meal-records/foods/{id} · .../foods/{id})
  // -------------------------------------------------------------------------
  group('MealRecordByIdRequestDto', () {
    test('foodExternalId·judgedGrade 필드가 없다 (경로 파라미터로 전달, F-10)', () {
      const dto = MealRecordByIdRequestDto();
      final json = dto.toJson();
      expect(json.containsKey('foodExternalId'), isFalse);
      expect(json.containsKey('judgedGrade'), isFalse);
    });

    test('eatenAt null이면 toJson에 eatenAt 값이 null이다 (impl removeWhere 대상)', () {
      const dto = MealRecordByIdRequestDto();
      expect(dto.toJson()['eatenAt'], isNull);
    });

    test('eatenAt 제공 시 값이 보존된다', () {
      const dto = MealRecordByIdRequestDto(eatenAt: '2026-06-24T08:30:00+09:00');
      expect(dto.toJson()['eatenAt'], '2026-06-24T08:30:00+09:00');
    });
  });

  // -------------------------------------------------------------------------
  // clampMealName — 서버 name 제약(≤100자) 준수
  // -------------------------------------------------------------------------
  group('clampMealName', () {
    test('앞뒤 공백을 제거한다', () {
      expect(clampMealName('  아메리카노  '), '아메리카노');
    });

    test('100자 이하 문자열은 그대로 유지한다', () {
      final input = 'a' * 100;
      expect(clampMealName(input), input);
    });

    test('100자 초과 문자열은 100자로 잘린다', () {
      final input = 'a' * 150;
      final result = clampMealName(input);
      expect(result.length, 100);
      expect(result, 'a' * 100);
    });

    test('trim 후 100자를 초과하면 잘린다', () {
      final input = '  ${'가' * 150}  ';
      expect(clampMealName(input).length, 100);
    });

    // -----------------------------------------------------------------------
    // grapheme cluster 기준 절단 (pr-review 소소 수정 ③)
    //
    // String.substring은 UTF-16 코드유닛 기준이라 서로게이트 쌍(이모지 등)을
    // 반토막 낼 수 있다. 'a'*99 뒤에 이모지(2코드유닛)를 붙이면 substring(0,100)은
    // 99번째 인덱스(이모지의 상위 서로게이트)에서 잘려 깨진 문자열이 된다.
    // clampMealName은 grapheme 기준이므로 이모지를 통째로 포함하거나 제외해야 한다.
    // -----------------------------------------------------------------------
    test('서로게이트 쌍(이모지)을 반토막 내지 않는다 — 완전한 grapheme만 남는다', () {
      final input = ('a' * 99) + ('🍜' * 10);
      final result = clampMealName(input);

      // grapheme 기준으로 정확히 100개(문자소)만 남는다.
      expect(result.characters.length, 100);
      // 100번째 grapheme(마지막 이모지)이 통째로 보존된다 — 반토막 서로게이트 없음.
      expect(result.characters.last, '🍜');
      // UTF-16 code unit 기준으로는 101(99 + 이모지 2유닛)이어야 정상 — substring(0,100)이면
      // 100이 되며 이는 깨진 서로게이트를 의미했을 것.
      expect(result.length, 101);
    });

    test('이모지만으로 구성된 문자열도 grapheme 단위로 잘린다', () {
      final input = '🍜' * 150;
      final result = clampMealName(input);

      expect(result.characters.length, 100);
      expect(result, equals('🍜' * 100));
    });
  });

  // -------------------------------------------------------------------------
  // ConnectedSymptomsDto — 타임라인 single/group 연결증상
  // -------------------------------------------------------------------------
  group('ConnectedSymptomsDto', () {
    test('필드를 파싱하고 toEntity에 반영한다', () {
      final dto = ConnectedSymptomsDto.fromJson(const {
        'symptomId': 'sym-1',
        'symptomState': 'uncomfortable',
        'afterMealMinutes': 90,
        'representativeSymptoms': ['속쓰림', '더부룩함'],
        'etcCount': 2,
      });
      expect(dto.symptomId, 'sym-1');
      expect(dto.afterMealMinutes, 90);

      final entity = dto.toEntity();
      expect(entity, isA<ConnectedSymptoms>());
      expect(entity.symptomId, 'sym-1');
      expect(entity.symptomState, SymptomState.uncomfortable);
      expect(entity.representativeSymptoms, ['속쓰림', '더부룩함']);
      expect(entity.etcCount, 2);
    });

    test('representativeSymptoms·etcCount 누락 시 빈 목록·0으로 폴백된다', () {
      final entity = ConnectedSymptomsDto.fromJson(const {
        'symptomId': 'sym-2',
        'symptomState': 'severe',
        'afterMealMinutes': 30,
      }).toEntity();
      expect(entity.representativeSymptoms, isEmpty);
      expect(entity.etcCount, 0);
    });
  });
}
