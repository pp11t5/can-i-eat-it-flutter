import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/features/health_profile/data/dtos/health_profile_dto.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';

void main() {
  // ---------------------------------------------------------------------------
  // 테스트용 샘플 JSON (api-contract.md POST /users/profile 스키마)
  // ---------------------------------------------------------------------------
  final sampleJson = {
    'conditions': ['GERD'],
    'symptom_frequency': ['weekly_heartburn', 'post_meal_cough'],
    'diagnosed': true,
    'trigger_foods': ['spicy', 'caffeine'],
    'custom_triggers': '탄산음료',
    'medications': ['omeprazole'],
    'allergies': ['shellfish'],
  };

  // ---------------------------------------------------------------------------
  group('fromJson / toJson 라운드트립', () {
    test('fromJson이 snake_case 키를 올바르게 파싱한다', () {
      final dto = HealthProfileDto.fromJson(sampleJson);
      expect(dto.conditions, ['GERD']);
      expect(dto.symptomFrequency, ['weekly_heartburn', 'post_meal_cough']);
      expect(dto.diagnosed, isTrue);
      expect(dto.triggerFoods, ['spicy', 'caffeine']);
      expect(dto.customTriggers, '탄산음료');
      expect(dto.medications, ['omeprazole']);
      expect(dto.allergies, ['shellfish']);
    });

    test('toJson이 snake_case 키로 직렬화된다', () {
      final dto = HealthProfileDto.fromJson(sampleJson);
      final json = dto.toJson();
      expect(json.containsKey('symptom_frequency'), isTrue);
      expect(json.containsKey('trigger_foods'), isTrue);
      expect(json.containsKey('custom_triggers'), isTrue);
      expect(json['symptom_frequency'], ['weekly_heartburn', 'post_meal_cough']);
      expect(json['trigger_foods'], ['spicy', 'caffeine']);
    });

    test('fromJson → toJson 라운드트립이 원본 JSON과 동일하다', () {
      final dto = HealthProfileDto.fromJson(sampleJson);
      final json = dto.toJson();
      expect(json['conditions'], sampleJson['conditions']);
      expect(json['symptom_frequency'], sampleJson['symptom_frequency']);
      expect(json['diagnosed'], sampleJson['diagnosed']);
      expect(json['trigger_foods'], sampleJson['trigger_foods']);
      expect(json['custom_triggers'], sampleJson['custom_triggers']);
      expect(json['medications'], sampleJson['medications']);
      expect(json['allergies'], sampleJson['allergies']);
    });

    test('null custom_triggers는 직렬화 시 null을 유지한다', () {
      final jsonWithoutTriggers = Map<String, dynamic>.from(sampleJson)
        ..remove('custom_triggers');
      final dto = HealthProfileDto.fromJson(jsonWithoutTriggers);
      expect(dto.customTriggers, isNull);
      final json = dto.toJson();
      expect(json['custom_triggers'], isNull);
    });

    test('빈 배열 필드는 기본값으로 파싱된다', () {
      final dto = HealthProfileDto.fromJson({});
      expect(dto.conditions, isEmpty);
      expect(dto.symptomFrequency, isEmpty);
      expect(dto.triggerFoods, isEmpty);
      expect(dto.medications, isEmpty);
      expect(dto.allergies, isEmpty);
      expect(dto.diagnosed, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  group('toEntity / fromEntity 변환', () {
    test('toEntity가 도메인 엔티티로 올바르게 변환된다', () {
      final dto = HealthProfileDto.fromJson(sampleJson);
      final entity = dto.toEntity();
      expect(entity.conditions, dto.conditions);
      expect(entity.symptomFrequency, dto.symptomFrequency);
      expect(entity.diagnosed, dto.diagnosed);
      expect(entity.triggerFoods, dto.triggerFoods);
      expect(entity.customTriggers, dto.customTriggers);
      expect(entity.medications, dto.medications);
      expect(entity.allergies, dto.allergies);
    });

    test('fromEntity가 엔티티에서 DTO로 올바르게 변환된다', () {
      final entity = HealthProfile.sampleGerd();
      final dto = HealthProfileDto.fromEntity(entity);
      expect(dto.conditions, entity.conditions);
      expect(dto.symptomFrequency, entity.symptomFrequency);
      expect(dto.diagnosed, entity.diagnosed);
      expect(dto.triggerFoods, entity.triggerFoods);
      expect(dto.customTriggers, entity.customTriggers);
      expect(dto.medications, entity.medications);
      expect(dto.allergies, entity.allergies);
    });

    test('엔티티 → DTO → 엔티티 라운드트립이 동일 값을 유지한다', () {
      final original = HealthProfile.sampleGerd();
      final roundTripped = HealthProfileDto.fromEntity(original).toEntity();
      expect(roundTripped, equals(original));
    });

    test('DTO → 엔티티 → DTO 라운드트립이 동일 JSON을 생성한다', () {
      final dto = HealthProfileDto.fromJson(sampleJson);
      final entity = dto.toEntity();
      final backToDto = HealthProfileDto.fromEntity(entity);
      expect(backToDto.toJson(), equals(dto.toJson()));
    });
  });
}
