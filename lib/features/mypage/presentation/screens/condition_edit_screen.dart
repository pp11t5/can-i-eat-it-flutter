import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/app/widgets/global_loading.dart';
import 'package:can_i_eat_it/app/widgets/option_card.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';

/// 건강 고민(질환) 편집 화면.
///
/// 온보딩 Step 1 [OnboardingConditionScreen] 본문 콘텐츠를 재사용하고,
/// 레이아웃은 [AllergyMedEditScreen]과 동일하게 상단 AppBar + 하단 저장하기 버튼.
///
/// 진입 시 [healthProfileControllerProvider] 값으로 conditions를 초기화한다.
/// 저장 시 [HealthProfileController.updateConditions]로 로컬 상태·캐시를 갱신한다.
///
/// TODO(be): 서버 disease PATCH API가 생기면 repository 경유로 교체.
class ConditionEditScreen extends ConsumerStatefulWidget {
  const ConditionEditScreen({super.key});

  @override
  ConsumerState<ConditionEditScreen> createState() =>
      _ConditionEditScreenState();
}

class _ConditionEditScreenState extends ConsumerState<ConditionEditScreen> {
  late Set<String> _selectedConditions;
  bool _initialized = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedConditions = {};
  }

  /// 프로필 로드 성공 시 최초 1회 로컬 상태를 초기화한다.
  ///
  /// build() 내에서 호출되므로 setState를 직접 호출할 수 없다.
  /// addPostFrameCallback으로 다음 프레임에 setState를 예약한다.
  void _initFromProfile(HealthProfile profile) {
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _selectedConditions = Set<String>.from(profile.conditions);
      });
    });
  }

  /// 질환 단일 선택 토글 — 온보딩 [OnboardingController.toggleCondition]과 동일 규칙.
  void _toggleCondition(String code) {
    setState(() {
      if (_selectedConditions.contains(code)) {
        _selectedConditions = {};
      } else {
        _selectedConditions = {code};
      }
    });
  }

  Future<void> _onSave() async {
    if (_isSaving) return;
    if (_selectedConditions.isEmpty) return;

    final profileController = ref.read(healthProfileControllerProvider.notifier);

    setState(() => _isSaving = true);

    try {
      await ref.read(globalLoadingControllerProvider.notifier).run(
            () => profileController.updateConditions(
              conditions: _selectedConditions.toList(),
            ),
          );

      if (!mounted) return;
      unawaited(
        showAppToast(
          context,
          '건강 정보를 저장했어요. 신호등 판정·리포트에 바로 반영돼요.',
        ),
      );
      context.pop();
    } catch (_) {
      if (!mounted) return;
      unawaited(showAppToast(context, '저장 중 오류가 발생했어요. 다시 시도해 주세요.'));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(healthProfileControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          iconSize: 32,
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            'assets/figma_extracted/chevron_left.svg',
            width: 32,
            height: 32,
          ),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        title: Text(
          '건강 고민',
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ConditionLoadErrorBody(
          onRetry: () => ref.invalidate(healthProfileControllerProvider),
        ),
        data: (profile) {
          if (profile == null) {
            return _ConditionLoadErrorBody(
              onRetry: () => ref.invalidate(healthProfileControllerProvider),
            );
          }
          _initFromProfile(profile);
          return _buildForm(context);
        },
      ),
    );
  }

  /// 폼 본문 — 온보딩 condition 콘텐츠 + 하단 저장하기.
  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.sectionGap),
                    Text(
                      '어떤 건강 고민이 있으세요?',
                      style: AppTextStyles.header1Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '현재는 역류성 식도염만 지원해요\n향후 다른 질환도 추가될 예정이에요',
                      style: AppTextStyles.body1Medium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.contentGap),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  itemCount: conditionOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final entry = conditionOptions[index];
                    final isSelected =
                        _selectedConditions.contains(entry.code);
                    return OptionCard(
                      label: entry.label,
                      caption: entry.caption,
                      selected: isSelected,
                      enabled: entry.enabled,
                      onTap: entry.enabled
                          ? () => _toggleCondition(entry.code)
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // 저장하기 버튼 — AllergyMedEditScreen과 동일 패딩
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.itemGap,
            AppSpacing.screenPadding,
            AppSpacing.sectionGap + MediaQuery.of(context).padding.bottom,
          ),
          child: AppButton.primary(
            label: '저장하기',
            onPressed: (_isSaving || _selectedConditions.isEmpty)
                ? null
                : _onSave,
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 조회 실패 에러 바디
// ---------------------------------------------------------------------------

class _ConditionLoadErrorBody extends StatelessWidget {
  const _ConditionLoadErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '건강 정보를 불러오지 못했어요.\n다시 시도해 주세요.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body1Bold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.itemGap),
            TextButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

/// [Future]를 무시(fire-and-forget). lint: unawaited_futures 억제용.
void unawaited(Future<void> future) {}
