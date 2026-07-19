import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/app/widgets/global_loading.dart';
import 'package:can_i_eat_it/app/widgets/selectable_chip.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';

/// 알레르기·복용약 편집 화면 (Figma 577-10291).
///
/// 진입 시 [medicalInfoStrictProvider]로 서버 최신 allergies/medications를 로드해
/// 로컬 상태를 초기화한다. [healthProfileControllerProvider]([currentProfile] 기반,
/// 캐시 폴백 허용)와 달리 이 조회는 실패 시 캐시로 폴백하지 않고 에러를 그대로
/// 노출한다 — stale 데이터를 편집 진실로 오인해 PATCH로 알레르기 정보를 덮어써
/// 소실시키는 것을 방지하기 위함(의료안전, pr-review ②-1). 조회 실패 시 폼 대신
/// 에러+재시도 UI를 보이고 저장 자체를 막는다.
///
/// 저장 시 `PATCH /my-page/health-info {allergens[], medications[]}`로 allergies·
/// medications만 갱신한다(W7 마이그레이션 — 과거 POST /onboarding 전체 재제출 방식 폐기).
///
/// [T9] 토스트: '건강 정보를 저장했어요. 신호등 판정·리포트에 바로 반영돼요.'
class AllergyMedEditScreen extends ConsumerStatefulWidget {
  const AllergyMedEditScreen({super.key});

  @override
  ConsumerState<AllergyMedEditScreen> createState() =>
      _AllergyMedEditScreenState();
}

class _AllergyMedEditScreenState extends ConsumerState<AllergyMedEditScreen> {
  late Set<String> _selectedAllergies;
  late List<String> _medications;
  bool _initialized = false;
  bool _isSaving = false;

  final _medController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedAllergies = {};
    _medications = [];
  }

  @override
  void dispose() {
    _medController.dispose();
    super.dispose();
  }

  /// 서버 조회([medicalInfoStrictProvider])가 성공하면 최초 1회 로컬 상태를 초기화한다.
  ///
  /// build() 내에서 호출되므로 setState를 직접 호출할 수 없다.
  /// addPostFrameCallback으로 다음 프레임에 setState를 예약한다.
  void _initFromProfile(HealthProfile profile) {
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _selectedAllergies = Set<String>.from(profile.allergies);
        _medications = List<String>.from(profile.medications);
      });
    });
  }

  void _toggleAllergy(String code) {
    setState(() {
      if (_selectedAllergies.contains(code)) {
        _selectedAllergies.remove(code);
      } else {
        _selectedAllergies.add(code);
      }
    });
  }

  void _addMedication() {
    final text = _medController.text.trim();
    if (text.isEmpty) return;
    if (_medications.contains(text)) {
      _medController.clear();
      return;
    }
    setState(() {
      _medications = [..._medications, text];
    });
    _medController.clear();
  }

  void _removeMedication(String med) {
    setState(() {
      _medications = _medications.where((m) => m != med).toList();
    });
  }

  Future<void> _onSave() async {
    if (_isSaving) return;

    final profileController = ref.read(healthProfileControllerProvider.notifier);

    setState(() => _isSaving = true);

    try {
      // PATCH이므로 allergies/medications 두 필드만 전송한다 — 다른 건강 정보를
      // 재제출하지 않으므로 base 프로필 부재를 경고할 필요가 없다(W7 마이그레이션).
      await ref.read(globalLoadingControllerProvider.notifier).run(
            () => profileController.updateHealthInfo(
              allergies: _selectedAllergies.toList(),
              medications: _medications,
            ),
          );

      if (!mounted) return;
      // T9 토스트
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
    // 편집 전용 strict 조회 — 캐시 폴백 없음(의료안전, pr-review ②-1).
    // 실패 시 stale 데이터를 편집 진실로 오인하지 않도록 폼 대신 에러+재시도를 보인다.
    final medicalInfoAsync = ref.watch(medicalInfoStrictProvider);

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
          '알레르기',
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      body: medicalInfoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _MedicalInfoErrorBody(
          onRetry: () => ref.invalidate(medicalInfoStrictProvider),
        ),
        data: (profile) {
          // 조회 성공 시 로컬 상태 초기화 (최초 1회)
          _initFromProfile(profile);
          return _buildForm(context);
        },
      ),
    );
  }

  /// 폼 본문 — 조회 성공 시에만 렌더된다(저장 버튼도 이 안에만 존재 — 조회 실패 시
  /// 저장 자체가 불가능하도록 화면에서 사라진다).
  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.sectionGap,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더
                Text(
                  '알레르기와 복용 중인 약을 알려주세요',
                  style: AppTextStyles.header1Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),

                // 알레르기 섹션
                Text(
                  '알레르기',
                  style: AppTextStyles.body1Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.itemGap),
                Wrap(
                  spacing: AppSpacing.itemGap,
                  runSpacing: AppSpacing.itemGap,
                  children: allergyOptions.map((entry) {
                    final isSelected =
                        _selectedAllergies.contains(entry.code);
                    return SelectableChip(
                      label: entry.label,
                      selected: isSelected,
                      onTap: () => _toggleAllergy(entry.code),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.sectionGap),

                // 복용약 섹션
                Text(
                  '복용 중인 약',
                  style: AppTextStyles.body1Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.itemGap),
                TextField(
                  controller: _medController,
                  style: AppTextStyles.body1Regular.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'PPI, 제산제',
                    hintStyle: AppTextStyles.body1Regular.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.cardPadding,
                      vertical: AppSpacing.cardPadding,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusCard,
                      ),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusCard,
                      ),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                  onSubmitted: (_) => _addMedication(),
                ),
                const SizedBox(height: AppSpacing.itemGap),
                AppButton.secondary(
                  label: '＋ 복용약 추가',
                  onPressed: _addMedication,
                  isExpanded: true,
                ),
                // 추가된 약 목록
                if (_medications.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sectionGap),
                  Wrap(
                    spacing: AppSpacing.itemGap,
                    runSpacing: AppSpacing.itemGap,
                    children: _medications.map((med) {
                      return _MedicationChip(
                        label: med,
                        onRemove: () => _removeMedication(med),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: AppSpacing.sectionGap),
              ],
            ),
          ),
        ),

        // 저장하기 버튼
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.itemGap,
            AppSpacing.screenPadding,
            AppSpacing.sectionGap + MediaQuery.of(context).padding.bottom,
          ),
          child: AppButton.primary(
            label: '저장하기',
            onPressed: _isSaving ? null : _onSave,
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 조회 실패 에러 바디 (medicalInfoStrictProvider 전용)
// ---------------------------------------------------------------------------

/// [medicalInfoStrictProvider] 조회 실패 시 폼 대신 노출되는 에러+재시도 UI.
///
/// 저장 버튼은 폼([_AllergyMedEditScreenState._buildForm]) 안에만 존재하므로
/// 이 상태에서는 저장 자체가 불가능하다(의료안전, pr-review ②-1).
class _MedicalInfoErrorBody extends StatelessWidget {
  const _MedicalInfoErrorBody({required this.onRetry});

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

// ---------------------------------------------------------------------------
// 복용약 칩 (삭제 버튼 포함)
// ---------------------------------------------------------------------------

class _MedicationChip extends StatelessWidget {
  const _MedicationChip({
    required this.label,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.chipPaddingH,
        vertical: AppSpacing.chipPaddingV,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceSelected,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.body2Medium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          GestureDetector(
            onTap: onRemove,
            child: const AppIcon(
              AppIcons.closeSmall,
              size: AppIconSizes.s16,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// [Future]를 무시(fire-and-forget). lint: unawaited_futures 억제용.
void unawaited(Future<void> future) {}
