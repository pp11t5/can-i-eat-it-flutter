import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/food_check/data/favorite_providers.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

/// 즐겨찾기 목록 화면.
///
/// 마이페이지에서 `context.push('/favorites')` 로 진입한다.
/// - 빈 상태: "저장된 즐겨찾기가 없어요." 가운데 표시.
/// - 데이터: ListView — 항목별 삭제 버튼 제공.
class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  Future<void> _remove(String foodName) async {
    await ref.read(favoriteRepositoryProvider).remove(foodName);
    ref.invalidate(favoriteListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(favoriteListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '즐겨찾기',
          style: AppTextStyles.body1Bold.copyWith(color: AppColors.textPrimary),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppColors.divider),
        ),
      ),
      body: listAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            '즐겨찾기를 불러오지 못했어요.',
            style: AppTextStyles.body2Regular
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
        data: (items) => items.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bookmark_border,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '아직 즐겨찾기가 없어요',
                      style: AppTextStyles.body1Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '판정 결과에서 북마크를 탭해 저장해보세요',
                      style: AppTextStyles.body2Regular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: AppColors.divider, height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(
                      item.foodName,
                      style: AppTextStyles.body1Medium
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    subtitle: Text(
                      _gradeLabel(item.level),
                      style: AppTextStyles.body2Regular
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete,
                          color: AppColors.textSecondary),
                      onPressed: () => _remove(item.foodName),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

/// [VerdictLevel] → 이모지+한국어 라벨.
String _gradeLabel(VerdictLevel level) => switch (level) {
      VerdictLevel.recommend => '✅ 추천',
      VerdictLevel.caution => '⚠️ 주의',
      VerdictLevel.risk => '🚫 위험',
      VerdictLevel.unknown => '❓ 확인어려움',
    };

/// 테스트에서 `_gradeLabel` 에 접근할 수 있도록 공개 래퍼.
@visibleForTesting
String gradeLabelForTest(VerdictLevel level) => _gradeLabel(level);
