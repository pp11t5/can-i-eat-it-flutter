import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';

/// 건강 프로필 완성 여부를 판별한다.
///
/// 완성 조건: [conditions] AND [triggerFoods] 모두 비어있지 않음.
/// [profile]이 null이면 false.
bool isProfileComplete(HealthProfile? profile) {
  if (profile == null) return false;
  return profile.conditions.isNotEmpty && profile.triggerFoods.isNotEmpty;
}
