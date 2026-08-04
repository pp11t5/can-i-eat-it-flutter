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
    /// 질환 코드 목록. 기본 빈 목록 — 사용자가 선택해야 체크·다음 버튼 활성.
    @Default(<String>[]) List<String> conditions,

    /// 증상 빈도 코드 목록. 복수 선택.
    @Default(<String>[]) List<String> symptomFrequency,

    /// 의사 진단 여부.
    @Default(false) bool diagnosed,

    /// 트리거 음식 코드 목록. 복수 선택.
    @Default(<String>[]) List<String> triggerFoods,

    /// 사용자 직접 입력 트리거 목록 (+ 버튼으로 추가).
    ///
    /// 제출 시 [toHealthProfile]에서 `', '`로 조인해 [HealthProfile.customTriggers]
    /// (서버 `customTriggerText` 단일 문자열)로 보낸다.
    @Default(<String>[]) List<String> customTriggers,

    /// 복용약 목록.
    @Default(<String>[]) List<String> medications,

    /// 알레르기 코드 목록. 복수 선택.
    @Default(<String>[]) List<String> allergies,
  }) = _OnboardingDraft;
}

extension OnboardingDraftX on OnboardingDraft {
  /// 드래프트를 [HealthProfile] 엔티티로 변환한다.
  ///
  /// [customTriggers] 목록은 서버 `customTriggerText` 스키마에 맞춰
  /// 빈 목록이면 null, 아니면 `', '` 조인 문자열로 보낸다.
  HealthProfile toHealthProfile() => HealthProfile(
        conditions: conditions,
        symptomFrequency: symptomFrequency,
        diagnosed: diagnosed,
        triggerFoods: triggerFoods,
        customTriggers:
            customTriggers.isEmpty ? null : customTriggers.join(', '),
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

  /// 질환 코드를 토글한다 (단일 선택).
  ///
  /// - 미선택 코드를 탭 → 해당 코드만 선택 (`[code]`).
  /// - 이미 선택된 코드를 다시 탭 → 해제 (`[]`).
  void toggleCondition(String code) {
    if (state.conditions.contains(code)) {
      state = state.copyWith(conditions: const <String>[]);
    } else {
      state = state.copyWith(conditions: List.unmodifiable([code]));
    }
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

  /// 사용자 직접 입력 트리거를 추가한다. 이미 존재하면 무시한다.
  void addCustomTrigger(String trigger) {
    final trimmed = trigger.trim();
    if (trimmed.isEmpty) return;
    if (state.customTriggers.contains(trimmed)) return;
    state = state.copyWith(
      customTriggers: List.unmodifiable([...state.customTriggers, trimmed]),
    );
  }

  /// 사용자 직접 입력 트리거를 제거한다.
  void removeCustomTrigger(String trigger) {
    state = state.copyWith(
      customTriggers: List.unmodifiable(
        state.customTriggers.where((t) => t != trigger).toList(),
      ),
    );
  }

  /// 사용자 직접 입력 트리거 목록을 교체한다.
  void setCustomTriggers(List<String> triggers) {
    state = state.copyWith(customTriggers: List.unmodifiable(triggers));
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
    // 재진입 가드: 빠른 더블탭/중복 호출 시 제출·onboardingCompleted 퍼널 중복 방지
    // (실 서버에서는 중복 POST 방지). pr-reviewer M1.
    if (state is AsyncLoading) return;
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
