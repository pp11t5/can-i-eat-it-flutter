import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';

void main() {
  // ---------------------------------------------------------------------------
  group('기본값', () {
    test('기본 생성자는 모든 List 필드를 빈 리스트로, diagnosed를 false로 초기화한다', () {
      const profile = HealthProfile();
      expect(profile.conditions, isEmpty);
      expect(profile.symptomFrequency, isEmpty);
      expect(profile.diagnosed, isFalse);
      expect(profile.triggerFoods, isEmpty);
      expect(profile.customTriggers, isNull);
      expect(profile.medications, isEmpty);
      expect(profile.allergies, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  group('copyWith', () {
    test('copyWith로 특정 필드만 변경되고 나머지는 유지된다', () {
      const profile = HealthProfile(
        conditions: ['GERD'],
        diagnosed: true,
      );
      final updated = profile.copyWith(diagnosed: false);
      expect(updated.conditions, ['GERD']);
      expect(updated.diagnosed, isFalse);
    });

    test('copyWith로 List 필드를 교체하면 원본은 불변이다', () {
      const profile = HealthProfile(triggerFoods: ['spicy']);
      final updated = profile.copyWith(triggerFoods: ['spicy', 'caffeine']);
      expect(profile.triggerFoods, ['spicy']);
      expect(updated.triggerFoods, ['spicy', 'caffeine']);
    });

    test('copyWith로 nullable String 필드를 설정할 수 있다', () {
      const profile = HealthProfile();
      final updated = profile.copyWith(customTriggers: '탄산음료');
      expect(updated.customTriggers, '탄산음료');
    });
  });

  // ---------------------------------------------------------------------------
  group('sampleGerd', () {
    test('sampleGerd 팩토리는 GERD 조건을 포함한다', () {
      final sample = HealthProfile.sampleGerd();
      expect(sample.conditions, contains('GERD'));
    });

    test('sampleGerd 팩토리는 diagnosed가 true다', () {
      final sample = HealthProfile.sampleGerd();
      expect(sample.diagnosed, isTrue);
    });

    test('sampleGerd 팩토리는 트리거 음식 목록을 포함한다', () {
      final sample = HealthProfile.sampleGerd();
      expect(sample.triggerFoods, isNotEmpty);
    });

    test('sampleGerd 팩토리는 증상빈도 목록을 포함한다', () {
      final sample = HealthProfile.sampleGerd();
      expect(sample.symptomFrequency, isNotEmpty);
    });

    test('sampleGerd 팩토리는 복용약 목록을 포함한다', () {
      final sample = HealthProfile.sampleGerd();
      expect(sample.medications, isNotEmpty);
    });

    test('sampleGerd 팩토리는 알레르기 목록을 포함한다', () {
      final sample = HealthProfile.sampleGerd();
      expect(sample.allergies, isNotEmpty);
    });

    test('sampleGerd 팩토리는 customTriggers가 null이 아니다', () {
      final sample = HealthProfile.sampleGerd();
      expect(sample.customTriggers, isNotNull);
    });

    test('동일 sampleGerd 두 인스턴스는 값이 같다(freezed equality)', () {
      final a = HealthProfile.sampleGerd();
      final b = HealthProfile.sampleGerd();
      expect(a, equals(b));
    });
  });
}
