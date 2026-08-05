import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_write_screen.dart';

/// 푸시에서 전달된 식사를 확인한 뒤 증상 작성 폼을 연다.
///
/// ID만 신뢰하지 않고 서버에서 식사를 다시 조회하므로, 삭제됐거나 다른 계정의
/// 식사인 경우 연결되지 않은 증상 기록을 만들지 않는다.
class PushSymptomEntryScreen extends ConsumerWidget {
  const PushSymptomEntryScreen({super.key, required this.mealRecordId});

  final String mealRecordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealAsync =
        ref.watch(mealRecordDetailControllerProvider(mealRecordId));

    return mealAsync.when(
      loading: () => const _PushEntryLoading(),
      error: (error, _) {
        // 흔한 원인: FCM targetId가 internal PK(숫자)이고 API는 external UUID를 기대.
        debugPrint(
          '[FCM] push symptom entry meal lookup failed '
          'mealRecordId=$mealRecordId error=$error',
        );
        return const _PushEntryUnavailable();
      },
      data: (meal) => SymptomWriteScreen(
        initialMealRecordId: meal.mealRecordId,
        initialMealName: _mealDisplayName(meal),
      ),
    );
  }

  static String _mealDisplayName(MealRecord meal) {
    if (meal.foods.isEmpty) return '식사';
    final first = meal.foods.first.name;
    final rest = meal.foods.length - 1;
    return rest > 0 ? '$first 외 $rest개 음식' : first;
  }
}

class _PushEntryLoading extends StatelessWidget {
  const _PushEntryLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _PushEntryUnavailable extends StatelessWidget {
  const _PushEntryUnavailable();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '식사 정보를 찾을 수 없어요.',
                style: AppTextStyles.body1Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.itemGap),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('돌아가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
