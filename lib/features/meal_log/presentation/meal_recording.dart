import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';
import 'package:can_i_eat_it/features/food_check/presentation/providers/add_to_diet_handler_provider.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';

/// Riverpod [Provider] 기반 핸들러 — app 레이어 override 전용.
///
/// [addToDietHandlerProvider]를 override할 때 이 provider의 값을 사용한다.
/// WidgetRef 대신 Ref를 사용하기 위해 별도 구현.
AddToDietHandler makeHandlerFromRef(Ref ref) {
  return (BuildContext context, EatVerdict verdict, MealRecordContext ctx) async {
    final repo = ref.read(mealRepositoryProvider);

    try {
      // grade 미전송 — 서버가 analysis 를 계산한다(F-10).
      // foodExternalId 有 → by-id / null → by-text(자유 입력 음식명).
      if (verdict.foodExternalId != null) {
        await repo.appendFood(
          foodExternalId: verdict.foodExternalId!,
          eatenAt: ctx.eatenAt,
          mealRecordId: ctx.mealRecordId,
        );
      } else {
        final trimmedName = verdict.foodName.trim();
        if (trimmedName.isEmpty) {
          // 빈 이름 음식 기록 금지(의료성 — 이름 없는 식사 기록은 판정 근거를
          // 남기지 못한다, pr-review 소소 수정 ③). 방어적으로 스킵하고 실패 토스트.
          if (context.mounted) {
            await showAppToast(context, '식사 기록에 실패했어요. 다시 시도해주세요.');
          }
          return;
        }
        await repo.appendFoodByText(
          foodTextInput: trimmedName,
          eatenAt: ctx.eatenAt,
          mealRecordId: ctx.mealRecordId,
        );
      }

      // 타임라인 + weekly invalidate
      final dateKey = DateTime(
        ctx.eatenAt.year,
        ctx.eatenAt.month,
        ctx.eatenAt.day,
      );
      ref.invalidate(timelineControllerProvider(dateKey));
      ref.invalidate(monthlyControllerProvider);

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
        final message = ctx.mealRecordId != null
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
