import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/onboarding/presentation/providers/onboarding_controller.dart';

void main() {
  // -------------------------------------------------------------------------
  // 헬퍼
  // -------------------------------------------------------------------------
  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  // -------------------------------------------------------------------------
  // group 1: 초기 드래프트
  // -------------------------------------------------------------------------
  group('OnboardingController 초기 드래프트', () {
    test('빌드 시 conditions 기본값은 [GERD]이다', () {
      final container = makeContainer();
      final draft = container.read(onboardingControllerProvider);
      expect(draft.conditions, ['GERD']);
    });

    test('빌드 시 symptomFrequency 기본값은 빈 리스트이다', () {
      final container = makeContainer();
      final draft = container.read(onboardingControllerProvider);
      expect(draft.symptomFrequency, isEmpty);
    });

    test('빌드 시 diagnosed 기본값은 false이다', () {
      final container = makeContainer();
      final draft = container.read(onboardingControllerProvider);
      expect(draft.diagnosed, isFalse);
    });

    test('빌드 시 triggerFoods, medications, allergies 기본값은 빈 리스트이다', () {
      final container = makeContainer();
      final draft = container.read(onboardingControllerProvider);
      expect(draft.triggerFoods, isEmpty);
      expect(draft.medications, isEmpty);
      expect(draft.allergies, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // group 2: toggleSymptom
  // -------------------------------------------------------------------------
  group('toggleSymptom', () {
    test('없는 코드를 토글하면 추가된다', () {
      final container = makeContainer();
      final notifier = container.read(onboardingControllerProvider.notifier);

      notifier.toggleSymptom('heartburn_reflux');

      expect(
        container.read(onboardingControllerProvider).symptomFrequency,
        ['heartburn_reflux'],
      );
    });

    test('있는 코드를 토글하면 제거된다', () {
      final container = makeContainer();
      final notifier = container.read(onboardingControllerProvider.notifier);

      notifier.toggleSymptom('heartburn_reflux');
      notifier.toggleSymptom('heartburn_reflux');

      expect(
        container.read(onboardingControllerProvider).symptomFrequency,
        isEmpty,
      );
    });

    test('여러 증상을 순서대로 추가할 수 있다', () {
      final container = makeContainer();
      final notifier = container.read(onboardingControllerProvider.notifier);

      notifier.toggleSymptom('heartburn_reflux');
      notifier.toggleSymptom('post_meal_cough');
      notifier.toggleSymptom('throat_globus');

      expect(
        container.read(onboardingControllerProvider).symptomFrequency,
        ['heartburn_reflux', 'post_meal_cough', 'throat_globus'],
      );
    });
  });

  // -------------------------------------------------------------------------
  // group 3: setDiagnosed
  // -------------------------------------------------------------------------
  group('setDiagnosed', () {
    test('setDiagnosed(true) 호출 시 diagnosed가 true가 된다', () {
      final container = makeContainer();
      container.read(onboardingControllerProvider.notifier).setDiagnosed(true);
      expect(container.read(onboardingControllerProvider).diagnosed, isTrue);
    });

    test('setDiagnosed를 true→false로 토글할 수 있다', () {
      final container = makeContainer();
      final notifier = container.read(onboardingControllerProvider.notifier);

      notifier.setDiagnosed(true);
      notifier.setDiagnosed(false);

      expect(container.read(onboardingControllerProvider).diagnosed, isFalse);
    });
  });

  // -------------------------------------------------------------------------
  // group 4: toggleTrigger
  // -------------------------------------------------------------------------
  group('toggleTrigger', () {
    test('없는 트리거 코드를 토글하면 추가된다', () {
      final container = makeContainer();
      container.read(onboardingControllerProvider.notifier).toggleTrigger('spicy');
      expect(
        container.read(onboardingControllerProvider).triggerFoods,
        ['spicy'],
      );
    });

    test('있는 트리거 코드를 토글하면 제거된다', () {
      final container = makeContainer();
      final notifier = container.read(onboardingControllerProvider.notifier);

      notifier.toggleTrigger('spicy');
      notifier.toggleTrigger('spicy');

      expect(
        container.read(onboardingControllerProvider).triggerFoods,
        isEmpty,
      );
    });
  });

  // -------------------------------------------------------------------------
  // group 5: setCustomTriggers
  // -------------------------------------------------------------------------
  group('setCustomTriggers', () {
    test('값을 설정하면 customTriggers에 저장된다', () {
      final container = makeContainer();
      container
          .read(onboardingControllerProvider.notifier)
          .setCustomTriggers('탄산음료');
      expect(
        container.read(onboardingControllerProvider).customTriggers,
        '탄산음료',
      );
    });

    test('null로 설정하면 customTriggers가 null이 된다', () {
      final container = makeContainer();
      final notifier = container.read(onboardingControllerProvider.notifier);
      notifier.setCustomTriggers('탄산음료');
      notifier.setCustomTriggers(null);
      expect(
        container.read(onboardingControllerProvider).customTriggers,
        isNull,
      );
    });
  });

  // -------------------------------------------------------------------------
  // group 6: medications
  // -------------------------------------------------------------------------
  group('medications', () {
    test('addMedication으로 복용약이 추가된다', () {
      final container = makeContainer();
      container
          .read(onboardingControllerProvider.notifier)
          .addMedication('omeprazole');
      expect(
        container.read(onboardingControllerProvider).medications,
        ['omeprazole'],
      );
    });

    test('이미 존재하는 복용약을 addMedication 호출해도 중복 추가되지 않는다', () {
      final container = makeContainer();
      final notifier = container.read(onboardingControllerProvider.notifier);
      notifier.addMedication('omeprazole');
      notifier.addMedication('omeprazole');
      expect(
        container.read(onboardingControllerProvider).medications.length,
        1,
      );
    });

    test('removeMedication으로 복용약이 제거된다', () {
      final container = makeContainer();
      final notifier = container.read(onboardingControllerProvider.notifier);
      notifier.addMedication('omeprazole');
      notifier.removeMedication('omeprazole');
      expect(
        container.read(onboardingControllerProvider).medications,
        isEmpty,
      );
    });

    test('setMedications으로 목록을 교체한다', () {
      final container = makeContainer();
      container
          .read(onboardingControllerProvider.notifier)
          .setMedications(['omeprazole', 'antacid']);
      expect(
        container.read(onboardingControllerProvider).medications,
        ['omeprazole', 'antacid'],
      );
    });
  });

  // -------------------------------------------------------------------------
  // group 7: toggleAllergy
  // -------------------------------------------------------------------------
  group('toggleAllergy', () {
    test('없는 알레르기 코드를 토글하면 추가된다', () {
      final container = makeContainer();
      container
          .read(onboardingControllerProvider.notifier)
          .toggleAllergy('egg');
      expect(
        container.read(onboardingControllerProvider).allergies,
        ['egg'],
      );
    });

    test('있는 알레르기 코드를 토글하면 제거된다', () {
      final container = makeContainer();
      final notifier = container.read(onboardingControllerProvider.notifier);
      notifier.toggleAllergy('egg');
      notifier.toggleAllergy('egg');
      expect(
        container.read(onboardingControllerProvider).allergies,
        isEmpty,
      );
    });
  });

  // -------------------------------------------------------------------------
  // group 8: setConditions
  // -------------------------------------------------------------------------
  group('setConditions', () {
    test('setConditions로 질환 목록을 교체한다', () {
      final container = makeContainer();
      container
          .read(onboardingControllerProvider.notifier)
          .setConditions(['GERD', 'GASTRITIS']);
      expect(
        container.read(onboardingControllerProvider).conditions,
        ['GERD', 'GASTRITIS'],
      );
    });
  });

  // -------------------------------------------------------------------------
  // group 9: toHealthProfile 변환
  // -------------------------------------------------------------------------
  group('toHealthProfile 변환', () {
    test('드래프트 전체 필드가 HealthProfile로 올바르게 변환된다', () {
      final container = makeContainer();
      final notifier = container.read(onboardingControllerProvider.notifier);

      notifier.toggleSymptom('heartburn_reflux');
      notifier.setDiagnosed(true);
      notifier.toggleTrigger('spicy');
      notifier.setCustomTriggers('탄산음료');
      notifier.addMedication('omeprazole');
      notifier.toggleAllergy('shellfish');

      final draft = container.read(onboardingControllerProvider);
      final profile = draft.toHealthProfile();

      expect(profile.conditions, ['GERD']);
      expect(profile.symptomFrequency, ['heartburn_reflux']);
      expect(profile.diagnosed, isTrue);
      expect(profile.triggerFoods, ['spicy']);
      expect(profile.customTriggers, '탄산음료');
      expect(profile.medications, ['omeprazole']);
      expect(profile.allergies, ['shellfish']);
    });

    test('기본 드래프트를 toHealthProfile 변환 시 conditions는 [GERD]이다', () {
      final container = makeContainer();
      final profile =
          container.read(onboardingControllerProvider).toHealthProfile();
      expect(profile.conditions, ['GERD']);
      expect(profile.diagnosed, isFalse);
    });
  });
}
