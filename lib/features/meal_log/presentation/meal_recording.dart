import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/food_check/presentation/providers/add_to_diet_handler_provider.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';

// ---------------------------------------------------------------------------
// 식단 추가 핸들러 구현 (meal_log 레이어)
// ---------------------------------------------------------------------------

/// 실제 식단 추가 핸들러.
///
/// - foodExternalId 있음 → [MealRepository.create]
/// - foodExternalId null(by-text) → [MealRepository.createByText]
/// - 성공 시: 타임라인 invalidate → 모달 스택 pop(타임라인까지) → 토스트
///   - mealGroupId 있음 → T6 "현재 식사에 음식을 추가했어요."
///   - mealGroupId null  → T7 "식사를 기록했어요. 식후 2시간 뒤 증상 확인 알림을 보내드릴게요."
/// - 실패 시: 에러 토스트
Future<void> addToDietHandlerImpl(
  BuildContext context,
  EatVerdict verdict,
  MealRecordContext ctx,
  WidgetRef ref,
) async {
  final repo = ref.read(mealRepositoryProvider);
  try {
    if (verdict.foodExternalId != null) {
      await repo.create(
        foodExternalId: verdict.foodExternalId!,
        eatenAt: ctx.eatenAt,
        mealGroupId: ctx.mealGroupId,
        grade: verdict.level,
      );
    } else {
      await repo.createByText(
        foodTextInput: verdict.foodName,
        eatenAt: ctx.eatenAt,
        mealGroupId: ctx.mealGroupId,
        grade: verdict.level,
      );
    }

    // 타임라인 invalidate: eatenAt 날짜 기준
    final dateKey = DateTime(
      ctx.eatenAt.year,
      ctx.eatenAt.month,
      ctx.eatenAt.day,
    );
    ref.invalidate(timelineControllerProvider(dateKey));

    // 모달 스택 pop — /verdict + /check + /meal/record 까지 닫기
    if (context.mounted) {
      // canPop을 반복해 타임라인/홈까지 복귀
      var popped = 0;
      while (context.mounted && context.canPop() && popped < 3) {
        context.pop();
        popped++;
      }
    }

    // 토스트
    if (context.mounted) {
      final message = ctx.mealGroupId != null
          ? '현재 식사에 음식을 추가했어요.'
          : '식사를 기록했어요. 식후 2시간 뒤 증상 확인 알림을 보내드릴게요.';
      await showAppToast(context, message);
    }
  } catch (_) {
    if (context.mounted) {
      await showAppToast(context, '식사 기록에 실패했어요. 다시 시도해주세요.');
    }
  }
}

/// [WidgetRef] 를 캡처한 [AddToDietHandler] 클로저를 반환한다.
///
/// app 레이어의 ProviderScope override에서 사용:
/// ```dart
/// addToDietHandlerProvider.overrideWith(
///   (ref) => makeMealRecordingHandler(ref),
/// )
/// ```
AddToDietHandler makeMealRecordingHandler(WidgetRef ref) {
  return (BuildContext context, EatVerdict verdict, MealRecordContext ctx) =>
      addToDietHandlerImpl(context, verdict, ctx, ref);
}

/// Riverpod [Provider] 기반 핸들러 — app 레이어 override 전용.
///
/// [addToDietHandlerProvider]를 override할 때 이 provider의 값을 사용한다.
/// WidgetRef 대신 Ref를 사용하기 위해 별도 구현.
AddToDietHandler makeHandlerFromRef(Ref ref) {
  return (BuildContext context, EatVerdict verdict, MealRecordContext ctx) async {
    final repo = ref.read(mealRepositoryProvider);
    try {
      if (verdict.foodExternalId != null) {
        await repo.create(
          foodExternalId: verdict.foodExternalId!,
          eatenAt: ctx.eatenAt,
          mealGroupId: ctx.mealGroupId,
          grade: verdict.level,
        );
      } else {
        await repo.createByText(
          foodTextInput: verdict.foodName,
          eatenAt: ctx.eatenAt,
          mealGroupId: ctx.mealGroupId,
          grade: verdict.level,
        );
      }

      // 타임라인 invalidate
      final dateKey = DateTime(
        ctx.eatenAt.year,
        ctx.eatenAt.month,
        ctx.eatenAt.day,
      );
      ref.invalidate(timelineControllerProvider(dateKey));

      // 모달 스택 pop — /verdict + /check + /meal/record 최대 3단
      if (context.mounted) {
        var popped = 0;
        while (context.mounted && context.canPop() && popped < 3) {
          context.pop();
          popped++;
        }
      }

      // 토스트
      if (context.mounted) {
        final message = ctx.mealGroupId != null
            ? '현재 식사에 음식을 추가했어요.'
            : '식사를 기록했어요. 식후 2시간 뒤 증상 확인 알림을 보내드릴게요.';
        await showAppToast(context, message);
      }
    } catch (_) {
      if (context.mounted) {
        await showAppToast(context, '식사 기록에 실패했어요. 다시 시도해주세요.');
      }
    }
  };
}
