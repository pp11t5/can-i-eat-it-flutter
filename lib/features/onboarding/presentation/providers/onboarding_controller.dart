import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/analytics/analytics_event.dart';
import 'package:can_i_eat_it/core/analytics/analytics_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';

part 'onboarding_controller.freezed.dart';
part 'onboarding_controller.g.dart';

// ---------------------------------------------------------------------------
// OnboardingDraft — 온보딩 4스텝 입력 로컬 누적 모델
// ---------------------------------------------------------------------------

/// 온보딩 입력을 로컬에 누적하는 드래프트 모델.
///
/// 완료 시 [toHealthProfile]로 [HealthProfile]로 변환해 제출한다.
/// 드래프트는 [OnboardingController]가 소유하므로 제출 실패 시에도 입력이 보존된다.
@freezed
abstract class OnboardingDraft with _$OnboardingDraft {
  const factory OnboardingDraft({
    /// 질환 코드 목록. 기본값 ['GERD'] — 현재 GERD 단일 질환 지원.
    @Default(['GERD']) List<String> conditions,

    /// 증상 빈도 코드 목록. 복수 선택.
    @Default(<String>[]) List<String> symptomFrequency,

    /// 의사 진단 여부.
    @Default(false) bool diagnosed,

    /// 트리거 음식 코드 목록. 복수 선택.
    @Default(<String>[]) List<String> triggerFoods,

    /// 사용자 직접 입력 트리거.
    String? customTriggers,

    /// 복용약 목록.
    @Default(<String>[]) List<String> medications,

    /// 알레르기 코드 목록. 복수 선택.
    @Default(<String>[]) List<String> allergies,
  }) = _OnboardingDraft;
}

extension OnboardingDraftX on OnboardingDraft {
  /// 드래프트를 [HealthProfile] 엔티티로 변환한다.
  HealthProfile toHealthProfile() => HealthProfile(
        conditions: conditions,
        symptomFrequency: symptomFrequency,
        diagnosed: diagnosed,
        triggerFoods: triggerFoods,
        customTriggers: customTriggers,
        medications: medications,
        allergies: allergies,
      );
}

// ---------------------------------------------------------------------------
// OnboardingController — 드래프트 상태 관리 (동기 Notifier)
// ---------------------------------------------------------------------------

/// 온보딩 입력 드래프트를 관리하는 컨트롤러.
///
/// 각 스텝의 입력을 불변 copyWith로 누적한다.
/// 제출은 [OnboardingSubmit]이 담당하므로 이 컨트롤러의 state는 항상 보존된다.
@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  // -------------------------------------------------------------------------
  // 질환
  // -------------------------------------------------------------------------

  /// 질환 목록을 교체한다.
  void setConditions(List<String> conditions) {
    state = state.copyWith(conditions: List.unmodifiable(conditions));
  }

  // -------------------------------------------------------------------------
  // 증상 빈도
  // -------------------------------------------------------------------------

  /// 증상 빈도 코드를 토글(추가/제거)한다.
  void toggleSymptom(String code) {
    final current = state.symptomFrequency;
    final updated = current.contains(code)
        ? current.where((c) => c != code).toList()
        : [...current, code];
    state = state.copyWith(symptomFrequency: List.unmodifiable(updated));
  }

  // -------------------------------------------------------------------------
  // 진단 여부
  // -------------------------------------------------------------------------

  /// 의사 진단 여부를 설정한다.
  void setDiagnosed(bool value) {
    state = state.copyWith(diagnosed: value);
  }

  // -------------------------------------------------------------------------
  // 트리거 음식
  // -------------------------------------------------------------------------

  /// 트리거 음식 코드를 토글(추가/제거)한다.
  void toggleTrigger(String code) {
    final current = state.triggerFoods;
    final updated = current.contains(code)
        ? current.where((c) => c != code).toList()
        : [...current, code];
    state = state.copyWith(triggerFoods: List.unmodifiable(updated));
  }

  /// 사용자 직접 입력 트리거를 설정한다.
  void setCustomTriggers(String? value) {
    state = state.copyWith(customTriggers: value);
  }

  // -------------------------------------------------------------------------
  // 복용약
  // -------------------------------------------------------------------------

  /// 복용약 목록을 교체한다.
  void setMedications(List<String> medications) {
    state = state.copyWith(medications: List.unmodifiable(medications));
  }

  /// 복용약을 추가한다. 이미 존재하면 무시한다.
  void addMedication(String medication) {
    if (state.medications.contains(medication)) return;
    state = state.copyWith(
      medications: List.unmodifiable([...state.medications, medication]),
    );
  }

  /// 복용약을 제거한다.
  void removeMedication(String medication) {
    state = state.copyWith(
      medications: List.unmodifiable(
        state.medications.where((m) => m != medication).toList(),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // 알레르기
  // -------------------------------------------------------------------------

  /// 알레르기 코드를 토글(추가/제거)한다.
  void toggleAllergy(String code) {
    final current = state.allergies;
    final updated = current.contains(code)
        ? current.where((c) => c != code).toList()
        : [...current, code];
    state = state.copyWith(allergies: List.unmodifiable(updated));
  }
}

// ---------------------------------------------------------------------------
// OnboardingSubmit — 제출 상태 (AsyncNotifier)
// ---------------------------------------------------------------------------

/// 온보딩 완료 제출을 담당하는 AsyncNotifier.
///
/// 드래프트는 [OnboardingController]가 소유하므로 제출 실패 시에도 입력이 보존된다.
/// 성공 시 [healthProfileControllerProvider] 게이트를 플립하고
/// [FunnelEvent.onboardingCompleted]를 발화한다.
@riverpod
class OnboardingSubmit extends _$OnboardingSubmit {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// 현재 드래프트를 제출한다.
  ///
  /// - 성공: [healthProfileControllerProvider] ready 플립 + onboardingCompleted 발화.
  /// - 실패: [AsyncError]로 전이, 드래프트 보존(재시도 가능).
  Future<void> submit() async {
    state = const AsyncLoading();
    final draft = ref.read(onboardingControllerProvider);
    try {
      await ref
          .read(healthProfileControllerProvider.notifier)
          .submit(draft.toHealthProfile());
      await ref
          .read(analyticsServiceProvider)
          .logFunnel(FunnelEvent.onboardingCompleted);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
