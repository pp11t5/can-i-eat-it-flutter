import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/features/food_check/data/recent_food_providers.dart';

/// 검색 기록 전체 삭제 확인 다이얼로그.
///
/// 타이틀: "최근 검색 삭제"
/// 내용: "최근 검색 기록을 모두 삭제하시겠어요?"
/// 버튼: "취소" / "삭제"(빨간색)
Future<void> showClearSearchHistoryDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  await showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      title: const Text('검색 기록 삭제'),
      content: const Text('모든 검색 기록을 삭제하시겠어요?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(ctx).pop();
            await ref
                .read(recentFoodControllerProvider.notifier)
                .clear();
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('삭제'),
        ),
      ],
    ),
  );
}
