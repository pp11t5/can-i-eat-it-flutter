import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/data/symptom_providers.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';

part 'symptom_write_controller.g.dart';

// ---------------------------------------------------------------------------
// SymptomWriteFormState — 폼 상태
// ---------------------------------------------------------------------------

/// 증상 작성 폼 상태.
class SymptomWriteFormState {
  const SymptomWriteFormState({
    this.mood,
    this.symptomTypes = const [],
    required this.occurredAt,
    this.linkedMealId,
    this.linkedMealDisplayName,
    this.memo = '',
  });

  /// 선택된 mood (null=미선택).
  final SymptomState? mood;

  /// 선택된 증상 유형 목록.
  final List<SymptomType> symptomTypes;

  /// 발생 시각 (KST wall-clock).
  final DateTime occurredAt;

  /// 선택된 원인 식사 ID. null=미선택.
  final String? linkedMealId;

  /// 원인 식사 표시명. null=미선택.
  final String? linkedMealDisplayName;

  /// 추가 메모.
  final String memo;

  SymptomWriteFormState copyWith({
    SymptomState? mood,
    bool clearMood = false,
    List<SymptomType>? symptomTypes,
    DateTime? occurredAt,
    String? linkedMealId,
    bool clearLinkedMeal = false,
    String? linkedMealDisplayName,
    String? memo,
  }) {
    return SymptomWriteFormState(
      mood: clearMood ? null : (mood ?? this.mood),
      symptomTypes: symptomTypes ?? this.symptomTypes,
      occurredAt: occurredAt ?? this.occurredAt,
      linkedMealId:
          clearLinkedMeal ? null : (linkedMealId ?? this.linkedMealId),
      linkedMealDisplayName: clearLinkedMeal
          ? null
          : (linkedMealDisplayName ?? this.linkedMealDisplayName),
      memo: memo ?? this.memo,
    );
  }
}

// ---------------------------------------------------------------------------
// SymptomWriteController — 제출 AsyncNotifier
// ---------------------------------------------------------------------------

/// 증상 작성/수정 제출 컨트롤러.
///
/// [existingSymptom] 이 null 이면 신규 생성, 비-null 이면 수정 모드.
/// 폼 상태([SymptomWriteFormState])는 [SymptomWriteFormController]가 소유한다.
@riverpod
class SymptomWriteController extends _$SymptomWriteController {
  @override
  AsyncValue<void> build(String? existingSymptomId) => const AsyncData(null);

  /// [formState]를 제출한다.
  ///
  /// - mood 미선택 시 예외.
  /// - 성공 시 타임라인/주간 invalidate.
  /// - 반환값: 성공 시 생성/수정된 symptomId.
  Future<String?> submit(SymptomWriteFormState formState) async {
    if (state is AsyncLoading) return null;
    state = const AsyncLoading();

    final repo = ref.read(symptomRepositoryProvider);

    final draft = SymptomDraft(
      symptomState: formState.mood!,
      // TODO(contract): mealRecordId 필수(minLen1) vs "선택 안 할래요" 미연결 — 서버 계약 확인 필요.
      // 현재 linkedMealId null 시 빈 문자열로 대체 (저장 버튼 비활성화로 사전 차단).
      mealRecordId: formState.linkedMealId ?? '',
      symptomTypes: formState.symptomTypes,
      occurredAt: formState.occurredAt,
      memo: formState.memo.trim().isEmpty ? null : formState.memo.trim(),
    );

    try {
      String symptomId;
      if (existingSymptomId == null) {
        final result = await repo.create(draft);
        symptomId = result.symptomId;
      } else {
        await repo.update(existingSymptomId!, draft);
        symptomId = existingSymptomId!;
      }

      // 타임라인·주간 캐시 invalidate
      ref.invalidate(timelineControllerProvider);
      ref.invalidate(weeklyControllerProvider);

      state = const AsyncData(null);
      return symptomId;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}
