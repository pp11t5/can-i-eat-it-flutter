import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/health_profile/domain/profile_completeness.dart';

void main() {
  group('isProfileComplete', () {
    test('null 프로필이면 false', () {
      expect(isProfileComplete(null), isFalse);
    });

    test('conditions 비어있으면 false', () {
      final profile = HealthProfile.sampleGerd().copyWith(conditions: []);
      expect(isProfileComplete(profile), isFalse);
    });

    test('triggerFoods 비어있으면 false', () {
      final profile = HealthProfile.sampleGerd().copyWith(triggerFoods: []);
      expect(isProfileComplete(profile), isFalse);
    });

    test('conditions AND triggerFoods 모두 비어있지 않으면 true', () {
      final profile = HealthProfile.sampleGerd();
      // sampleGerd: conditions=['GERD'], triggerFoods 비어있지 않다고 가정.
      // 방어적으로 copyWith로 명시.
      final complete = profile.copyWith(
        conditions: ['GERD'],
        triggerFoods: ['coffee'],
      );
      expect(isProfileComplete(complete), isTrue);
    });

    test('빈 HealthProfile(conditions·triggerFoods 모두 빈 리스트)이면 false', () {
      final profile = HealthProfile.sampleGerd().copyWith(
        conditions: [],
        triggerFoods: [],
      );
      expect(isProfileComplete(profile), isFalse);
    });
  });
}
