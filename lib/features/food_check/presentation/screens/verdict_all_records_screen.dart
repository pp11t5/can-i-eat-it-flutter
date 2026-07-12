import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/presentation/widgets/mood_face.dart';

/// 판정 결과 "증상 기록 모두 보기" 화면 (Figma node 1706:4452).
///
/// [VerdictDetailCard] 의 "모두 보기" 탭 진입점. 판정에 연결된 전체 증상 기록을
/// 무드 얼굴 + 라벨 + 날짜·타이밍 카드 리스트로 보여준다(≤3 제한 없이 전체).
class VerdictAllRecordsScreen extends StatelessWidget {
  const VerdictAllRecordsScreen({super.key, required this.stateRecords});

  final VerdictStateRecords stateRecords;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.cardPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 헤더 카운트는 실제 렌더되는 records 수 기준(Figma: 카운트==표시수).
                    // total 은 서버 전체 집계(≥records.length)일 수 있어 목적지가
                    // 캡된 records 뿐인 이 화면에선 표시 수와 불일치하므로 사용 안 함.
                    Text(
                      '${stateRecords.records.length}개의 증상 기록',
                      style: AppTextStyles.body1Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.itemGap),
                    for (var i = 0; i < stateRecords.records.length; i++) ...[
                      if (i > 0) const SizedBox(height: AppSpacing.itemGap),
                      _RecordCard(record: stateRecords.records[i]),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const AppIcon(
              AppIcons.chevronLeft,
              size: AppIconSizes.s32,
              color: AppColors.textPrimary,
              semanticsLabel: '뒤로',
            ),
            onPressed: onBack,
          ),
          Expanded(
            child: Text(
              '증상 기록',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Medium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final VerdictStateRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding), // 16
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Row(
        children: [
          MoodFace(state: SymptomStateMapper.fromLabel(record.label), size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              record.label,
              style: AppTextStyles.body2Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '${record.date} · ${record.timing}',
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
