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

  /// 식후 경과 분 → "식후 N분" 표시 레이블.
  ///
  /// 음수 분은 표시상 0으로 클램프한다 (식후 개념 하한).
  static String _timingLabel(int minutes) {
    final m = minutes < 0 ? 0 : minutes;
    if (m < 60) return '식후 $m분';
    final h = m ~/ 60;
    final rem = m % 60;
    return rem == 0 ? '식후 $h시간' : '식후 $h시간 $rem분';
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
