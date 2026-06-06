import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';

void main() {
  // -------------------------------------------------------------------------
  // group 1: 카탈로그 그룹별 개수
  // -------------------------------------------------------------------------
  group('카탈로그 그룹별 항목 수', () {
    test('conditions 카탈로그는 1개다', () {
      expect(conditionOptions.length, 1);
    });

    test('symptomFrequency 카탈로그는 5개다', () {
      expect(symptomFrequencyOptions.length, 5);
    });

    test('triggerFood 카탈로그는 8개다', () {
      expect(triggerFoodOptions.length, 8);
    });

    test('allergy 카탈로그는 6개다', () {
      expect(allergyOptions.length, 6);
    });
  });

  // -------------------------------------------------------------------------
  // group 2: 코드↔라벨 라운드트립
  // -------------------------------------------------------------------------
  group('conditions 코드↔라벨 라운드트립', () {
    test('GERD 코드는 역류성 식도염 라벨로 매핑된다', () {
      expect(labelForCode(conditionOptions, 'GERD'), '역류성 식도염');
    });

    test('역류성 식도염 라벨은 GERD 코드로 역조회된다', () {
      expect(codeForLabel(conditionOptions, '역류성 식도염'), 'GERD');
    });

    test('존재하지 않는 코드는 null을 반환한다', () {
      expect(labelForCode(conditionOptions, 'UNKNOWN'), isNull);
    });

    test('존재하지 않는 라벨은 null을 반환한다', () {
      expect(codeForLabel(conditionOptions, '없는질환'), isNull);
    });
  });

  group('symptomFrequency 코드↔라벨 라운드트립', () {
    test('weekly_heartburn 코드가 올바른 라벨로 매핑된다', () {
      expect(
        labelForCode(symptomFrequencyOptions, 'weekly_heartburn'),
        '주에 1번 이상 속이 쓰리거나 신물이 올라와요',
      );
    });

    test('post_meal_cough 코드가 올바른 라벨로 매핑된다', () {
      expect(
        labelForCode(symptomFrequencyOptions, 'post_meal_cough'),
        '밥을 먹고 나면 기침이 나요',
      );
    });

    test('throat_lump 라벨이 코드로 역조회된다', () {
      expect(
        codeForLabel(symptomFrequencyOptions, '목에 이물감이 있어요'),
        'throat_lump',
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

    test('caffeine 코드는 카페인 라벨로 매핑된다', () {
      expect(labelForCode(triggerFoodOptions, 'caffeine'), '카페인');
    });

    test('초콜릿 라벨은 chocolate 코드로 역조회된다', () {
      expect(codeForLabel(triggerFoodOptions, '초콜릿'), 'chocolate');
    });

    test('모든 triggerFood 항목이 고유한 코드를 가진다', () {
      final codes = triggerFoodOptions.map((e) => e.code).toList();
      expect(codes.toSet().length, codes.length);
    });
  });

  group('allergy 코드↔라벨 라운드트립', () {
    test('egg 코드는 계란 라벨로 매핑된다', () {
      expect(labelForCode(allergyOptions, 'egg'), '계란');
    });

    test('shellfish 코드는 갑각류 라벨로 매핑된다', () {
      expect(labelForCode(allergyOptions, 'shellfish'), '갑각류');
    });

    test('대두 라벨은 soy 코드로 역조회된다', () {
      expect(codeForLabel(allergyOptions, '대두'), 'soy');
    });

    test('모든 allergy 항목이 고유한 코드를 가진다', () {
      final codes = allergyOptions.map((e) => e.code).toList();
      expect(codes.toSet().length, codes.length);
    });
  });

  // -------------------------------------------------------------------------
  // group 3: diagnosedLabel
  // -------------------------------------------------------------------------
  group('diagnosedLabel', () {
    test('diagnosedLabel이 빈 문자열이 아니다', () {
      expect(diagnosedLabel, isNotEmpty);
    });

    test('diagnosedLabel 내용이 PRD 카피와 일치한다', () {
      expect(diagnosedLabel, '예전에 진단받았지만 지금은 관리만 하고 있어요');
    });
  });
}
