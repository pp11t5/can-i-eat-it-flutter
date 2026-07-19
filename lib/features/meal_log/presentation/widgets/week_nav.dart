import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';

/// 월 네비게이션 바 (구 WeekNav → MonthNav, 횡스크롤 월 캘린더 재설계).
///
/// Figma node 2756:22551:
/// - 좌측 밀착 클러스터(gap 4): ‹ YYYY년 M월 › (chevron 이 라벨에 밀착) — ±1개월 이동.
/// - 우측 정렬: 캘린더 아이콘(32) — 탭 시 캘린더 팝업([showCalendarPopup]) 오픈.
/// - [canGoNext]가 false면 현실 시간 기준 다음 달로 이동할 수 없다는 뜻이므로
///   `›` 버튼을 아예 렌더하지 않는다(공간도 차지하지 않음, `Spacer`가 정렬 유지).
class MonthNav extends StatelessWidget {
  const MonthNav({
    super.key,
    required this.label,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onOpenCalendar,
    this.canGoNext = true,
  });

  /// 'YYYY년 M월' 형태의 문자열.
  final String label;

  /// 이전 달 이동 콜백.
  final VoidCallback onPrevMonth;

  /// 다음 달 이동 콜백.
  final VoidCallback onNextMonth;

  /// 캘린더 팝업 오픈 콜백.
  final VoidCallback onOpenCalendar;

  /// 다음 달로 이동 가능한지 여부 — false면 `›` 버튼을 숨긴다.
  final bool canGoNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPrevMonth,
          icon: const AppIcon(
            AppIcons.chevronLeft,
            size: AppIconSizes.s32,
            color: AppColors.textPrimary,
            semanticsLabel: '이전 달',
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary, // Figma 실측 #1A1A1F = fontColor100
          ),
        ),
        if (canGoNext) ...[
          const SizedBox(width: 4),
          IconButton(
            onPressed: onNextMonth,
            icon: const AppIcon(
              AppIcons.chevronRight,
              size: AppIconSizes.s32,
              color: AppColors.textPrimary,
              semanticsLabel: '다음 달',
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
        ],
        const Spacer(),
        IconButton(
          onPressed: onOpenCalendar,
          icon: SvgPicture.asset(
            'assets/figma_extracted/calendar_icon.svg',
            width: AppIconSizes.s32,
            height: AppIconSizes.s32,
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary, // Figma 실측 #1A1A1F = fontColor100
              BlendMode.srcIn,
            ),
            semanticsLabel: '캘린더',
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          visualDensity: VisualDensity.compact,
          tooltip: '캘린더 열기',
        ),
      ],
    );
  }
}

/// 'YYYY년 M월' 라벨 생성 유틸 (구 weekNavLabel 대체).
String monthNavLabel(DateTime date) => '${date.year}년 ${date.month}월';
