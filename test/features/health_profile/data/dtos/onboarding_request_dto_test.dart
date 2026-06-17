import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/health_profile/data/dtos/onboarding_request_dto.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';

void main() {
  // -------------------------------------------------------------------------
  // toJson 키 구성 검증 (W3-4 서버 스키마 정합)
  // -------------------------------------------------------------------------
  group('OnboardingRequestDto.toJson — 서버 스키마 키 검증', () {
    test('toJson 결과에 symptoms/triggers/allergens/medications/customTriggerText 키만 존재한다',
        () {
      const dto = OnboardingRequestDto(
        symptoms: ['heartburn_reflux'],
        triggers: ['caffeine'],
        allergens: ['milk'],
        medications: ['omeprazole'],
        customTriggerText: '탄산음료',
      );
      final json = dto.toJson();

      expect(json.containsKey('symptoms'), isTrue);
      expect(json.containsKey('triggers'), isTrue);
      expect(json.containsKey('allergens'), isTrue);
      expect(json.containsKey('medications'), isTrue);
      expect(json.containsKey('customTriggerText'), isTrue);

      // 제거된 필드가 없는지 확인
      expect(json.containsKey('symptomFrequency'), isFalse);
      expect(json.containsKey('diagnosed'), isFalse);
      expect(json.containsKey('conditions'), isFalse);
    });

    test('customTriggerText 가 null 이면 toJson 에 null 로 포함된다', () {
      const dto = OnboardingRequestDto(symptoms: ['heartburn_reflux']);
      final json = dto.toJson();

      expect(json.containsKey('customTriggerText'), isTrue);
      expect(json['customTriggerText'], isNull);
      // 제거 필드 없음
      expect(json.containsKey('symptomFrequency'), isFalse);
      expect(json.containsKey('diagnosed'), isFalse);
    });

    test('빈 DTO 의 toJson 은 빈 리스트와 null customTriggerText 를 반환한다', () {
      const dto = OnboardingRequestDto();
      final json = dto.toJson();

      expect(json['symptoms'], <String>[]);
      expect(json['triggers'], <String>[]);
      expect(json['allergens'], <String>[]);
      expect(json['medications'], <String>[]);
      expect(json['customTriggerText'], isNull);
    });
  });

  // -------------------------------------------------------------------------
  // fromEntity 매핑 검증
  // -------------------------------------------------------------------------
  group('OnboardingRequestDto.fromEntity — 필드 매핑', () {
    test('symptomFrequency → symptoms 로 매핑된다 (conditions/diagnosed 는 전송 안 함)',
        () {
      const entity = HealthProfile(
        conditions: ['GERD'],
        symptomFrequency: ['post_meal_cough', 'heartburn_reflux'],
        diagnosed: true,
        triggerFoods: ['caffeine'],
        allergies: ['egg'],
        medications: ['omeprazole'],
      );
      final dto = OnboardingRequestDto.fromEntity(entity);

      expect(dto.symptoms, ['post_meal_cough', 'heartburn_reflux']);
      expect(dto.triggers, ['caffeine']);
      expect(dto.allergens, ['egg']);
      expect(dto.medications, ['omeprazole']);
      expect(dto.customTriggerText, isNull);
    });

    test('customTriggers 가 있으면 customTriggerText 로 매핑된다', () {
      const entity = HealthProfile(
        triggerFoods: ['spicy'],
        customTriggers: '탄산음료',
      );
      final dto = OnboardingRequestDto.fromEntity(entity);

      expect(dto.triggers, ['spicy']);
      expect(dto.customTriggerText, '탄산음료');
    });

    test('customTriggers 가 빈 문자열이면 customTriggerText 는 null 이다', () {
      const entity = HealthProfile(customTriggers: '');
      final dto = OnboardingRequestDto.fromEntity(entity);

      expect(dto.customTriggerText, isNull);
    });

    test('customTriggers 가 null 이면 customTriggerText 는 null 이다', () {
      const entity = HealthProfile();
      final dto = OnboardingRequestDto.fromEntity(entity);

      expect(dto.customTriggerText, isNull);
    });

    test('sampleGerd 엔티티 매핑 — toJson 에서 서버 키만 나온다', () {
      final dto = OnboardingRequestDto.fromEntity(HealthProfile.sampleGerd());
      final json = dto.toJson();

      // symptoms = symptomFrequency (weekly_heartburn, post_meal_cough)
      expect(json['symptoms'], ['weekly_heartburn', 'post_meal_cough']);
      expect(json['triggers'], ['spicy', 'caffeine']);
      expect(json['allergens'], ['shellfish']);
      expect(json['medications'], ['omeprazole']);
      expect(json['customTriggerText'], '탄산음료');

      // 금지 키
      expect(json.containsKey('symptomFrequency'), isFalse);
      expect(json.containsKey('diagnosed'), isFalse);
      expect(json.containsKey('conditions'), isFalse);
    });

    test('빈 HealthProfile → 빈 DTO — 모든 리스트가 비어 있다', () {
      final dto = OnboardingRequestDto.fromEntity(const HealthProfile());

      expect(dto.symptoms, isEmpty);
      expect(dto.triggers, isEmpty);
      expect(dto.allergens, isEmpty);
      expect(dto.medications, isEmpty);
      expect(dto.customTriggerText, isNull);
    });
  });
}
