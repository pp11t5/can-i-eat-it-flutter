import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';

/// 홈 화면 최근 검색어 칩.
///
/// - 탭 시 [onSearch] 콜백 호출.
/// - X 버튼 탭 시 [onDelete] 콜백 호출.
class RecentSearchChip extends StatelessWidget {
  const RecentSearchChip({
    super.key,
    required this.label,
    required this.onSearch,
    required this.onDelete,
  });

  final String label;
  final VoidCallback onSearch;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ActionChip(
          label: Text(label),
          onPressed: onSearch,
          backgroundColor: AppColors.surfaceMuted,
          side: BorderSide.none,
          avatar: const Icon(Icons.history, size: 16),
        ),
        GestureDetector(
          onTap: onDelete,
          behavior: HitTestBehavior.opaque,
          child: const Padding(
            padding: EdgeInsets.only(left: 2),
            child: Icon(Icons.close, size: 14, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
