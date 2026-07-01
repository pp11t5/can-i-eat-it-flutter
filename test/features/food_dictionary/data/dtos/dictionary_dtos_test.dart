import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/dtos/dictionary_dtos.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/entities/dictionary_food.dart';

void main() {
  // -------------------------------------------------------------------------
  // SafeFoodItemDto — GET /dictionary/safe items[]
  // -------------------------------------------------------------------------
  group('SafeFoodItemDto', () {
    test('foodId·name·code를 파싱하고 toEntity에 반영한다', () {
      final dto = SafeFoodItemDto.fromJson(const {
        'foodId': 'f1',
        'name': '두부',
        'code': 'BEAN',
      });
      expect(dto.foodId, 'f1');
      expect(dto.name, '두부');
      expect(dto.code, 'BEAN');

      final entity = dto.toEntity();
      expect(entity, isA<DictionaryFoodItem>());
      expect(entity.foodId, 'f1');
      expect(entity.name, '두부');
      expect(entity.categoryCode, 'BEAN');
      expect(entity.verdict, VerdictLevel.recommend);
    });

    test('code 키 누락 시 categoryCode는 null이다', () {
      final entity = SafeFoodItemDto.fromJson(const {
        'foodId': 'f2',
        'name': '흰쌀밥',
      }).toEntity();
      expect(entity.categoryCode, isNull);
    });

    test('code 명시 null이어도 categoryCode는 null이다', () {
      final entity = SafeFoodItemDto.fromJson(const {
        'foodId': 'f3',
        'name': '바나나',
        'code': null,
      }).toEntity();
      expect(entity.categoryCode, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // CautionRiskFoodItemDto — GET /dictionary/caution-risk items[]
  // -------------------------------------------------------------------------
  group('CautionRiskFoodItemDto — type별 VerdictLevel 매핑 (파라미터라이즈)', () {
    // 'safe'→recommend, 'caution'→caution, 'risk'→risk, 그 외→unknown 폴백.
    final cases = <String, VerdictLevel>{
      'safe': VerdictLevel.recommend,
      'caution': VerdictLevel.caution,
      'risk': VerdictLevel.risk,
      'weird': VerdictLevel.unknown,
    };

    for (final entry in cases.entries) {
      test('type "${entry.key}" → VerdictLevel.${entry.value.name}', () {
        final entity = CautionRiskFoodItemDto.fromJson({
          'foodId': 'f-${entry.key}',
          'name': '된장찌개',
          'code': 'KOREAN',
          'type': entry.key,
        }).toEntity();
        expect(entity.verdict, entry.value);
        expect(entity.foodId, 'f-${entry.key}');
        expect(entity.categoryCode, 'KOREAN');
      });
    }

    test('code 키 누락 시 categoryCode는 null이다', () {
      final entity = CautionRiskFoodItemDto.fromJson(const {
        'foodId': 'f1',
        'name': '커피',
        'type': 'risk',
      }).toEntity();
      expect(entity.categoryCode, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // SafeDictionaryPageDto — GET /dictionary/safe result
  // -------------------------------------------------------------------------
  group('SafeDictionaryPageDto', () {
    test('items·nextCursor·hasNext를 파싱하고 toEntity에 반영한다', () {
      final dto = SafeDictionaryPageDto.fromJson(const {
        'items': [
          {'foodId': 'f1', 'name': '두부', 'code': 'BEAN'},
        ],
        'nextCursor': 5,
        'hasNext': true,
      });
      expect(dto.nextCursor, 5);
      expect(dto.hasNext, isTrue);

      final entity = dto.toEntity();
      expect(entity, isA<DictionaryPage>());
      expect(entity.items.length, 1);
      expect(entity.items[0].foodId, 'f1');
      expect(entity.items[0].verdict, VerdictLevel.recommend);
      expect(entity.nextCursor, 5);
      expect(entity.hasNext, isTrue);
    });

    test('nextCursor 명시 null이면 toEntity의 nextCursor도 null이다', () {
      final entity = SafeDictionaryPageDto.fromJson(const {
        'items': <dynamic>[],
        'nextCursor': null,
        'hasNext': false,
      }).toEntity();
      expect(entity.nextCursor, isNull);
    });

    test('hasNext 누락 시 기본값 false로 폴백된다', () {
      final entity = SafeDictionaryPageDto.fromJson(const {
        'items': <dynamic>[],
      }).toEntity();
      expect(entity.hasNext, isFalse);
    });

    test('items 누락 시 빈 목록으로 폴백된다', () {
      final entity = SafeDictionaryPageDto.fromJson(const {
        'hasNext': false,
      }).toEntity();
      expect(entity.items, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // CautionRiskDictionaryPageDto — GET /dictionary/caution-risk result
  // -------------------------------------------------------------------------
  group('CautionRiskDictionaryPageDto', () {
    test('items·nextCursor·hasNext를 파싱하고 toEntity에 반영한다', () {
      final dto = CautionRiskDictionaryPageDto.fromJson(const {
        'items': [
          {'foodId': 'f4', 'name': '커피', 'code': 'BEVERAGE', 'type': 'risk'},
        ],
        'nextCursor': 3,
        'hasNext': true,
      });
      expect(dto.nextCursor, 3);
      expect(dto.hasNext, isTrue);

      final entity = dto.toEntity();
      expect(entity.items.length, 1);
      expect(entity.items[0].foodId, 'f4');
      expect(entity.items[0].verdict, VerdictLevel.risk);
      expect(entity.nextCursor, 3);
      expect(entity.hasNext, isTrue);
    });

    test('nextCursor 명시 null이면 toEntity의 nextCursor도 null이다', () {
      final entity = CautionRiskDictionaryPageDto.fromJson(const {
        'items': <dynamic>[],
        'nextCursor': null,
        'hasNext': false,
      }).toEntity();
      expect(entity.nextCursor, isNull);
    });

    test('hasNext 누락 시 기본값 false로 폴백된다', () {
      final entity = CautionRiskDictionaryPageDto.fromJson(const {
        'items': <dynamic>[],
      }).toEntity();
      expect(entity.hasNext, isFalse);
    });

    test('items 누락 시 빈 목록으로 폴백된다', () {
      final entity = CautionRiskDictionaryPageDto.fromJson(const {
        'hasNext': false,
      }).toEntity();
      expect(entity.items, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // DictionaryCountDto — GET /dictionary/count result
  // -------------------------------------------------------------------------
  group('DictionaryCountDto', () {
    test('safeCount·cautionRiskCount를 파싱하고 toEntity에 반영한다', () {
      final dto = DictionaryCountDto.fromJson(const {
        'safeCount': 12,
        'cautionRiskCount': 8,
      });
      expect(dto.safeCount, 12);
      expect(dto.cautionRiskCount, 8);

      final entity = dto.toEntity();
      expect(entity, isA<DictionaryCount>());
      expect(entity.safeCount, 12);
      expect(entity.cautionRiskCount, 8);
    });

    test('키 누락 시 각 카운트는 0으로 폴백된다', () {
      final entity = DictionaryCountDto.fromJson(const {}).toEntity();
      expect(entity.safeCount, 0);
      expect(entity.cautionRiskCount, 0);
    });
  });
}
