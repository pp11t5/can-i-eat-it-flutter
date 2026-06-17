import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';

void main() {
  // -------------------------------------------------------------------------
  // group 1: 카탈로그 그룹별 개수
  // -------------------------------------------------------------------------
  group('카탈로그 그룹별 항목 수', () {
    test('conditions 카탈로그는 4개다 (1 enabled + 3 disabled)', () {
      expect(conditionOptions.length, 4);
    });

    test('symptomFrequency 카탈로그는 6개다', () {
      expect(symptomFrequencyOptions.length, 6);
    });

    test('triggerFood 카탈로그는 12개다', () {
      expect(triggerFoodOptions.length, 12);
    });

    test('allergy 카탈로그는 8개다', () {
      expect(allergyOptions.length, 8);
    });
  });

  // -------------------------------------------------------------------------
  // group 2: conditions enabled/disabled 구조
  // -------------------------------------------------------------------------
  group('conditions enabled/disabled 구조', () {
    test('GERD는 enabled:true이고 캡션이 있다', () {
      final gerd =
          conditionOptions.firstWhere((e) => e.code == 'GERD');
      expect(gerd.enabled, isTrue);
      expect(gerd.caption, isNotNull);
      expect(gerd.caption, isNotEmpty);
    });

    test('GERD 캡션은 "소화가 잘 안 되고 더부룩해요"다', () {
      final gerd =
          conditionOptions.firstWhere((e) => e.code == 'GERD');
      expect(gerd.caption, '소화가 잘 안 되고 더부룩해요');
    });

    test('GERD 외 나머지 3개 조건은 enabled:false다', () {
      final disabled = conditionOptions.where((e) => e.code != 'GERD').toList();
      expect(disabled.length, 3);
      for (final e in disabled) {
        expect(e.enabled, isFalse, reason: '${e.code} should be disabled');
      }
    });

    test('비활성 조건은 caption이 null이다', () {
      for (final e in conditionOptions.where((e) => !e.enabled)) {
        expect(e.caption, isNull, reason: '${e.code} disabled item should have no caption');
      }
    });
  });

  // -------------------------------------------------------------------------
  // group 3: 코드↔라벨 라운드트립
  // -------------------------------------------------------------------------
  group('conditions 코드↔라벨 라운드트립', () {
    test('GERD 코드는 역류성 식도염 라벨로 매핑된다', () {
      final gerd = conditionOptions.firstWhere((e) => e.code == 'GERD');
      expect(gerd.label, '역류성 식도염');
    });

    test('역류성 식도염 라벨을 가진 항목의 코드는 GERD다', () {
      final entry =
          conditionOptions.firstWhere((e) => e.label == '역류성 식도염');
      expect(entry.code, 'GERD');
    });

    test('존재하지 않는 코드는 firstWhereOrNull이 null을 반환한다', () {
      final match = conditionOptions
          .where((e) => e.code == 'UNKNOWN')
          .toList();
      expect(match, isEmpty);
    });

    test('모든 condition 코드가 비어 있지 않고 고유하다', () {
      final codes = conditionOptions.map((e) => e.code).toList();
      expect(codes.every((c) => c.isNotEmpty), isTrue);
      expect(codes.toSet().length, codes.length);
    });
  });

  group('symptomFrequency 코드↔라벨 라운드트립', () {
    test('heartburn_reflux 코드가 올바른 라벨로 매핑된다', () {
      expect(
        labelForCode(symptomFrequencyOptions, 'heartburn_reflux'),
        '주에 1번 이상 속이 쓰리거나 신물이 올라와요',
      );
    });

    test('post_meal_cough 코드가 올바른 라벨로 매핑된다', () {
      expect(
        labelForCode(symptomFrequencyOptions, 'post_meal_cough'),
        '밥을 먹고 나면 기침이 나요',
      );
    });

    test('throat_globus 라벨이 코드로 역조회된다', () {
      expect(
        codeForLabel(symptomFrequencyOptions, '목에 이물감이 있어요'),
        'throat_globus',
      );
    });

    test('none_but_manage 코드가 존재한다', () {
      expect(
        labelForCode(symptomFrequencyOptions, 'none_but_manage'),
        isNotNull,
      );
    });

    test('모든 symptomFrequency 항목이 고유한 코드를 가진다', () {
      final codes = symptomFrequencyOptions.map((e) => e.code).toList();
      expect(codes.toSet().length, codes.length);
    });
  });

  group('triggerFood 코드↔라벨 라운드트립', () {
    test('spicy 코드는 매운 음식 라벨로 매핑된다', () {
      expect(labelForCode(triggerFoodOptions, 'spicy'), '매운 음식');
    });

    test('caffeine 코드는 커피·카페인 라벨로 매핑된다', () {
      expect(labelForCode(triggerFoodOptions, 'caffeine'), '커피·카페인');
    });

    test('초콜릿 라벨은 chocolate 코드로 역조회된다', () {
      expect(codeForLabel(triggerFoodOptions, '초콜릿'), 'chocolate');
    });

    test('모든 triggerFood 항목이 고유한 코드를 가진다', () {
      final codes = triggerFoodOptions.map((e) => e.code).toList();
      expect(codes.toSet().length, codes.length);
    });

    test('모든 triggerFood 코드가 비어 있지 않다', () {
      expect(triggerFoodOptions.every((e) => e.code.isNotEmpty), isTrue);
    });
  });

  group('allergy 코드↔라벨 라운드트립', () {
    test('egg 코드는 계란 라벨로 매핑된다', () {
      expect(labelForCode(allergyOptions, 'egg'), '계란');
    });

    test('crustacean 코드는 갑각류 라벨로 매핑된다', () {
      expect(labelForCode(allergyOptions, 'crustacean'), '갑각류');
    });

    test('콩(대두) 라벨은 soy 코드로 역조회된다', () {
      expect(codeForLabel(allergyOptions, '콩(대두)'), 'soy');
    });

    test('모든 allergy 항목이 고유한 코드를 가진다', () {
      final codes = allergyOptions.map((e) => e.code).toList();
      expect(codes.toSet().length, codes.length);
    });

    test('모든 allergy 코드가 비어 있지 않다', () {
      expect(allergyOptions.every((e) => e.code.isNotEmpty), isTrue);
    });
  });
}
