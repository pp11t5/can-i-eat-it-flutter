import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_profile.freezed.dart';

/// 사용자 건강 프로필 엔티티.
///
/// 질환·증상빈도·트리거·복용약·알레르기를 담는다.
/// onboarding / mypage / food_check 피처가 이 엔티티를 사용한다.
@freezed
abstract class HealthProfile with _$HealthProfile {
  const factory HealthProfile({
    /// 질환 코드 목록. 예: ['GERD']. 다중 질환 확장 대비.
    @Default(<String>[]) List<String> conditions,

    /// 증상 빈도 목록. 예: ['weekly_heartburn', 'post_meal_cough'].
    @Default(<String>[]) List<String> symptomFrequency,

    /// 의사 진단 여부.
    @Default(false) bool diagnosed,

    /// 트리거 음식 목록. 예: ['spicy', 'caffeine'].
    @Default(<String>[]) List<String> triggerFoods,

    /// 사용자 직접 입력 트리거. 예: '탄산음료'.
    String? customTriggers,

    /// 복용약 목록. 예: ['omeprazole'].
    @Default(<String>[]) List<String> medications,

    /// 알레르기 목록. 예: ['shellfish'].
    @Default(<String>[]) List<String> allergies,
  }) = _HealthProfile;

  // ---------------------------------------------------------------------------
  // 샘플 named factory
  // ---------------------------------------------------------------------------

  /// 온보딩 완료 데모·Mock·골든 테스트용 대표 샘플.
  ///
  /// GERD 진단 완료, 주요 트리거·복용약·알레르기 포함.
  factory HealthProfile.sampleGerd() => const HealthProfile(
        conditions: ['GERD'],
        symptomFrequency: ['weekly_heartburn', 'post_meal_cough'],
        diagnosed: true,
        triggerFoods: ['spicy', 'caffeine'],
        customTriggers: '탄산음료',
        medications: ['omeprazole'],
        allergies: ['shellfish'],
      );
}
