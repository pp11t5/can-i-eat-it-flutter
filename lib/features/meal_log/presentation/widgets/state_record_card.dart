import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/presentation/widgets/mood_face.dart';

/// 증상 기록 단건 카드.
///
/// [StateRecord.label] + "[date] · 식후 N분" 형태로 표시한다.
class StateRecordCard extends StatelessWidget {
  const StateRecordCard({super.key, required this.record});

  final StateRecord record;

  /// 식사 대비 경과 분 → 표시 레이블.
  ///
  /// 음수(증상 시각이 식사 이전) → "식사 전 N분/시간".
  /// 0 이상 → "식후 N분/시간".
  static String _timingLabel(int minutes) {
    if (minutes < 0) return _formatRelativeMinutes(minutes.abs(), prefix: '식사 전');
    return _formatRelativeMinutes(minutes, prefix: '식후');
  }

  static String _formatRelativeMinutes(int minutes, {required String prefix}) {
    if (minutes < 60) return '$prefix $minutes분';
    final h = minutes ~/ 60;
    final rem = minutes % 60;
    return rem == 0 ? '$prefix $h시간' : '$prefix $h시간 $rem분';
  }

  @override
  Widget build(BuildContext context) {
    final mood = SymptomStateMapper.fromLabel(record.label);
    final title = SymptomStateMapper.displayLabel(record.label);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.borderCard, width: 1),
      ),
      child: Row(
        children: [
          MoodFace(state: mood, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body2Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${record.date} · ${_timingLabel(record.timingMinutes)}',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
