import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/prefs/first_visit_prefs.dart';
import 'package:can_i_eat_it/features/health_profile/presentation/providers/profile_completeness_provider.dart';

part 'home_providers.g.dart';

/// 프로필 완성 유도 토스트 표시 여부.
///
/// 다음 두 조건 모두 충족 시 true:
/// 1. 프로필이 미완성 (`profileCompleteProvider == false`)
/// 2. 토스트가 아직 표시되지 않음 (`firstVisitPrefs.isToastShown() == false`)
@Riverpod(keepAlive: true)
Future<bool> shouldShowProfileToast(Ref ref) async {
  final isComplete = ref.watch(profileCompleteProvider);
  if (isComplete) return false;
  final prefs = ref.watch(firstVisitPrefsProvider);
  return !(await prefs.isToastShown());
}
