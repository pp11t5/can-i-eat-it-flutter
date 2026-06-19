import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/profile_completeness.dart';

part 'profile_completeness_provider.g.dart';

/// 현재 건강 프로필 완성 여부 computed provider.
///
/// [healthProfileControllerProvider]를 watch해 [isProfileComplete]로 판별한다.
/// 로딩 중·에러·프로필 없음 → false.
@riverpod
bool profileComplete(Ref ref) {
  final profileAsync = ref.watch(healthProfileControllerProvider);
  return profileAsync.whenData((p) => isProfileComplete(p)).valueOrNull ?? false;
}

/// 현재 건강 프로필 완성도 (0–100) computed provider.
///
/// [healthProfileControllerProvider]를 watch해 [profileCompletenessPercent]로 계산한다.
/// 로딩 중·에러·프로필 없음 → 0.
@riverpod
int profileCompletenessPercentage(Ref ref) {
  final profileAsync = ref.watch(healthProfileControllerProvider);
  return profileAsync
          .whenData((p) => profileCompletenessPercent(p))
          .valueOrNull ??
      0;
}
