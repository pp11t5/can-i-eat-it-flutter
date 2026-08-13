import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/auth/presentation/screens/terms_detail_screen.dart';
import 'package:can_i_eat_it/features/mypage/domain/medical_sources_catalog.dart';

/// 음식 판정에 참고한 의학 정보 출처 목록 (Figma 3544:24117).
///
/// 마이페이지 약관 섹션과 판정 화면 [MedicalSourcesLink]에서 진입한다.
class MedicalSourcesScreen extends StatelessWidget {
  const MedicalSourcesScreen({super.key, this.onOpenSource});

  /// 테스트 seam. null이면 원문을 [TermsDetailScreen]으로 연다.
  final void Function(MedicalSourceItem item)? onOpenSource;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 64,
        leading: const IconTheme(
          data: IconThemeData(size: 32),
          child: BackButton(color: AppColors.textPrimary),
        ),
        title: Text(
          '의학 정보 출처',
          style: AppTextStyles.body1Medium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.surfaceMuted, width: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.sectionGap,
          AppSpacing.screenPadding,
          AppSpacing.sectionGap,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              MedicalSourcesCatalog.intro,
              style: AppTextStyles.body2Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            for (var i = 0; i < MedicalSourcesCatalog.sections.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.sectionGap),
              _SourceSection(
                section: MedicalSourcesCatalog.sections[i],
                onOpen: (item) => _open(context, item),
              ),
            ],
            const SizedBox(height: AppSpacing.sectionGap),
            Text(
              MedicalSourcesCatalog.citation,
              style: AppTextStyles.caption2Regular.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.iconTextGap),
            Text(
              MedicalSourcesCatalog.lastReviewed,
              style: AppTextStyles.caption2Regular.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, MedicalSourceItem item) {
    final url = item.url;
    if (url == null) return;
    if (onOpenSource != null) {
      onOpenSource!(item);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TermsDetailScreen(title: item.title, url: url),
      ),
    );
  }
}

class _SourceSection extends StatelessWidget {
  const _SourceSection({required this.section, required this.onOpen});

  final MedicalSourceSection section;
  final ValueChanged<MedicalSourceItem> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.label,
          style: AppTextStyles.body2Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.cardPadding),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusModal),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < section.items.length; i++) ...[
                if (i > 0) ...[
                  const SizedBox(height: AppSpacing.cardPadding),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.divider,
                  ),
                  const SizedBox(height: AppSpacing.cardPadding),
                ],
                _SourceRow(
                  item: section.items[i],
                  onTap: () => onOpen(section.items[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.item, required this.onTap});

  final MedicalSourceItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.url == null ? null : onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.body2Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.itemGap),
                Text(
                  item.subtitle,
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          SvgPicture.asset(
            AppIcons.chevronRight,
            width: AppIconSizes.s24,
            height: AppIconSizes.s24,
            colorFilter: const ColorFilter.mode(
              AppColors.textTertiary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
