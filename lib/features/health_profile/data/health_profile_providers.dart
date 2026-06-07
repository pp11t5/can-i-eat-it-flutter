import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/health_profile/domain/repositories/health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';

part 'health_profile_providers.g.dart';

/// [HealthProfileRepository] 공급자.
///
/// 기본값: [MockHealthProfileRepository.noProfile] (신규 사용자, 온보딩 필요).
/// 실 구현 교체 지점: ProviderScope override로 retrofit 구현을 주입한다.
@riverpod
HealthProfileRepository healthProfileRepository(Ref ref) =>
    MockHealthProfileRepository.noProfile();

/// 건강 프로필 상태 컨트롤러 (AsyncNotifier).
///
/// [build]: [HealthProfileRepository.currentProfile]을 호출해 초기 프로필을 로드한다.
/// [submit]: 온보딩 완료 시 프로필을 저장하고 상태를 갱신한다.
/// 다음 Phase의 온보딩 컨트롤러가 [submit]을 호출한다.
@riverpod
class HealthProfileController extends _$HealthProfileController {
  @override
  Future<HealthProfile?> build() async {
    return ref.watch(healthProfileRepositoryProvider).currentProfile();
  }

  /// 온보딩 완료 시 프로필을 저장하고 상태를 갱신한다 (온보딩 게이트 플립).
  Future<void> submit(HealthProfile profile) async {
    await ref.read(healthProfileRepositoryProvider).submitProfile(profile);
    state = AsyncData(profile);
  }
}
