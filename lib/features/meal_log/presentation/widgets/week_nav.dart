import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';

/// 주차 네비게이션 바.
///
/// Figma node 1351-14768 Frame 34:
/// - 좌측 밀착 클러스터: ‹ N월 N주차 › (chevron 이 라벨에 밀착)
/// - onPrevWeek / onNextWeek 콜백
class WeekNav extends StatelessWidget {
  const WeekNav({
    super.key,
    required this.label,
    required this.onPrevWeek,
    required this.onNextWeek,
  });

  /// 'N월 N주차' 형태의 문자열.
  final String label;

  /// 이전 주 이동 콜백.
  final VoidCallback onPrevWeek;

  /// 다음 주 이동 콜백.
  final VoidCallback onNextWeek;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onPrevWeek,
            icon: const Icon(Icons.chevron_left),
            color: AppColors.textPrimary,
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.body1Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: onNextWeek,
            icon: const Icon(Icons.chevron_right),
            color: AppColors.textPrimary,
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

/// 'N월 N주차' 라벨 생성 유틸.
///
/// 월 기준 주차: 해당 월의 1일이 속하는 주를 1주차로 계산.
String weekNavLabel(DateTime date) {
  final month = date.month;
  final weekOfMonth = _weekOfMonth(date);
  return '$month월 $weekOfMonth주차';
}

/// 월 기준 주차 계산 (1일이 속한 주 = 1주차).
int _weekOfMonth(DateTime date) {
  final firstDayOfMonth = DateTime(date.year, date.month, 1);
  // 1일의 요일(월=1, 일=7). DateTime.weekday 기준(월=1, 일=7).
  final firstWeekday = firstDayOfMonth.weekday; // 1(Mon)~7(Sun)
  // 일요일 시작 기준으로 보정: 일=0, 월=1, ..., 토=6
  final firstWeekdaySunStart = firstWeekday % 7; // Sun=0
  final dayOfMonth = date.day;
  return ((dayOfMonth + firstWeekdaySunStart - 1) ~/ 7) + 1;
}
