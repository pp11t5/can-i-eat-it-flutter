import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/health_profile/domain/repositories/health_profile_repository.dart';

part 'health_profile_providers.g.dart';

/// [HealthProfileRepository] 공급자.
///
/// 기본값: [MockHealthProfileRepository.noProfile] (테스트·오프라인 안전).
/// 실 앱에서는 main.dart ProviderScope override 로 [HealthProfileRepositoryImpl] 을 주입한다.
/// (ADR-0007 §3-1 (6-D): 서버 API 계약 기반 실연동)
@riverpod
HealthProfileRepository healthProfileRepository(Ref ref) =>
    MockHealthProfileRepository.noProfile();

/// 알레르기·복용약 편집 화면 전용 — 캐시 폴백 없이 서버 최신 상태를 조회한다.
///
/// [HealthProfileController]([currentProfile] 기반)와 달리 실패 시 에러를 그대로
/// 전파한다 — stale 데이터 위에서 편집·PATCH하는 것을 막기 위함(의료안전, pr-review ②-1).
/// allergy_med_edit_screen이 이 provider를 watch하고, 에러 상태에서는 재시도
/// UI를 보이며 저장 자체를 막는다.
@riverpod
Future<HealthProfile> medicalInfoStrict(Ref ref) =>
    ref.watch(healthProfileRepositoryProvider).fetchMedicalInfoStrict();

/// 온보딩 완료 여부 AsyncNotifier (ADR-0007 §3-1 (6-D)).
///
/// [sessionStatus] provider가 이 값을 `hasProfile` 소스로 사용한다.
/// [HealthProfileRepository.onboardedStatus]를 호출해 boolean을 반환한다.
/// 로딩 중에는 hasProfile=null → SessionStatus.loading 유지.
@riverpod
Future<bool> onboardedStatus(Ref ref) =>
    ref.watch(healthProfileRepositoryProvider).onboardedStatus();

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
  ///
  /// [submitProfile] 성공 후 [onboardedStatusProvider]를 무효화해
  /// sessionStatus가 재평가되도록 한다.
  Future<void> submit(HealthProfile profile) async {
    await ref.read(healthProfileRepositoryProvider).submitProfile(profile);
    state = AsyncData(profile);
    // onboardedStatus 캐시 무효화 → sessionStatus 재평가 트리거
    ref.invalidate(onboardedStatusProvider);
  }

  /// 알레르기·복용약만 갱신한다 (`PATCH /my-page/health-info`, W7 마이그레이션).
  ///
  /// [submit]과 달리 온보딩 게이트에 영향을 주지 않으므로 [onboardedStatusProvider]를
  /// invalidate 하지 않는다(이 화면은 온보딩 완료 사용자만 진입).
  Future<void> updateHealthInfo({
    required List<String> allergies,
    required List<String> medications,
  }) async {
    await ref.read(healthProfileRepositoryProvider).updateHealthInfo(
          allergies: allergies,
          medications: medications,
        );
    final base = state.valueOrNull ?? const HealthProfile();
    state = AsyncData(base.copyWith(allergies: allergies, medications: medications));
  }
}
