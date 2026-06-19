import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_button.dart';
import 'package:can_i_eat_it/app/widgets/selectable_chip.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/profile_image_picker.dart';
import 'package:can_i_eat_it/features/onboarding/domain/onboarding_options.dart';

/// 마이페이지 프로필 편집 화면 (`/mypage/edit`).
///
/// 진입 시 [healthProfileControllerProvider] 에서 현재 프로필을 로드해 로컬 state 로 복사.
/// 저장 시: 캐시 전체 프로필에서 편집된 필드만 copyWith → submit() 호출 → pop.
/// symptomFrequency·diagnosed 는 편집 UI 제외 — copyWith 로 원본 보존.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  // ── 편집 로컬 state ──────────────────────────────────────────────────────
  File? _selectedImage;
  List<String> _conditions = [];
  List<String> _triggerFoods = [];
  String? _customTriggers;
  List<String> _medications = [];
  List<String> _allergies = [];

  bool _initialized = false;
  bool _isSaving = false;

  final _customController = TextEditingController();
  final _medicationsController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    _medicationsController.dispose();
    super.dispose();
  }

  /// 현재 프로필로부터 로컬 state 를 초기화한다 (1회만).
  void _initFromProfile(HealthProfile? profile) {
    if (_initialized) return;
    _initialized = true;
    if (profile == null) return;
    _conditions = List.of(profile.conditions);
    _triggerFoods = List.of(profile.triggerFoods);
    _customTriggers = profile.customTriggers;
    _medications = List.of(profile.medications);
    _allergies = List.of(profile.allergies);
    _customController.text = profile.customTriggers ?? '';
    _medicationsController.text = profile.medications.join(', ');
  }

  void _toggleCondition(String code) {
    setState(() {
      // 단일 선택
      _conditions = _conditions.contains(code) ? [] : [code];
    });
  }

  void _toggleTrigger(String code) {
    setState(() {
      if (_triggerFoods.contains(code)) {
        _triggerFoods = List.of(_triggerFoods)..remove(code);
      } else {
        _triggerFoods = [..._triggerFoods, code];
      }
    });
  }

  void _toggleAllergy(String code) {
    setState(() {
      if (_allergies.contains(code)) {
        _allergies = List.of(_allergies)..remove(code);
      } else {
        _allergies = [..._allergies, code];
      }
    });
  }

  Future<void> _save(HealthProfile? current) async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      // 편집 필드만 교체, symptomFrequency·diagnosed 원본 보존
      final base = current ?? const HealthProfile();
      final updated = base.copyWith(
        conditions: _conditions,
        triggerFoods: _triggerFoods,
        customTriggers:
            _customTriggers?.trim().isEmpty ?? true ? null : _customTriggers,
        medications: _medications,
        allergies: _allergies,
      );
      await ref.read(healthProfileControllerProvider.notifier).submit(updated);
      if (mounted && _selectedImage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('프로필 이미지가 업데이트됐어요 (서버 연동 준비 중)'),
          ),
        );
      }
      if (mounted) Navigator.of(context).maybePop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(healthProfileControllerProvider);

    return profileAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Text(
            '프로필을 불러오지 못했어요.',
            style:
                AppTextStyles.body2Regular.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ),
      data: (profile) {
        _initFromProfile(profile);
        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 탑바 ─────────────────────────────────────────────────────
                SizedBox(
                  height: 64,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).maybePop(),
                          child: SvgPicture.asset(
                            'assets/figma_extracted/chevron_left.svg',
                            width: 32,
                            height: 32,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '프로필 편집',
                          style: AppTextStyles.body1Bold.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── 스크롤 본문 ───────────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.sectionGap),

                        // ── 프로필 이미지 ─────────────────────────────────────
                        Center(
                          child: ProfileImagePicker(
                            image: _selectedImage,
                            onImageSelected: (file) {
                              setState(() => _selectedImage = file);
                            },
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sectionGap),

                        // ── 질환 (단일 선택) ──────────────────────────────────
                        const _SectionLabel(label: '질환'),
                        const SizedBox(height: AppSpacing.itemGap),
                        Wrap(
                          spacing: AppSpacing.itemGap,
                          runSpacing: AppSpacing.itemGap,
                          children: conditionOptions
                              .where((o) => o.enabled)
                              .map((o) => SelectableChip(
                                    label: o.label,
                                    selected: _conditions.contains(o.code),
                                    onTap: () => _toggleCondition(o.code),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: AppSpacing.sectionGap),

                        // ── 트리거 음식 (다중 선택) ───────────────────────────
                        const _SectionLabel(label: '트리거 음식'),
                        const SizedBox(height: AppSpacing.itemGap),
                        Wrap(
                          spacing: AppSpacing.itemGap,
                          runSpacing: AppSpacing.itemGap,
                          children: triggerFoodOptions
                              .map((o) => SelectableChip(
                                    label: o.label,
                                    selected: _triggerFoods.contains(o.code),
                                    onTap: () => _toggleTrigger(o.code),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: AppSpacing.itemGap),
                        // 기타 트리거 직접 입력
                        TextField(
                          controller: _customController,
                          style: AppTextStyles.body1Regular
                              .copyWith(color: AppColors.textPrimary),
                          decoration: _inputDecoration('직접 입력 (예: 탄산음료)'),
                          onChanged: (v) => setState(
                            () => _customTriggers =
                                v.trim().isEmpty ? null : v.trim(),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sectionGap),

                        // ── 복용약 (TextField 입력, 쉼표 구분) ────────────────
                        const _SectionLabel(label: '복용약'),
                        const SizedBox(height: AppSpacing.itemGap),
                        TextField(
                          controller: _medicationsController,
                          style: AppTextStyles.body1Regular
                              .copyWith(color: AppColors.textPrimary),
                          decoration:
                              _inputDecoration('예: omeprazole, 오메프라졸'),
                          onChanged: (v) => setState(() {
                            _medications = v
                                .split(',')
                                .map((s) => s.trim())
                                .where((s) => s.isNotEmpty)
                                .toList();
                          }),
                        ),
                        const SizedBox(height: AppSpacing.sectionGap),

                        // ── 알레르기 (다중 선택) ──────────────────────────────
                        const _SectionLabel(label: '알레르기'),
                        const SizedBox(height: AppSpacing.itemGap),
                        Wrap(
                          spacing: AppSpacing.itemGap,
                          runSpacing: AppSpacing.itemGap,
                          children: allergyOptions
                              .map((o) => SelectableChip(
                                    label: o.label,
                                    selected: _allergies.contains(o.code),
                                    onTap: () => _toggleAllergy(o.code),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: AppSpacing.contentGap),
                      ],
                    ),
                  ),
                ),

                // ── 저장 버튼 CTA ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                    vertical: AppSpacing.sectionGap,
                  ),
                  child: AppButton.primary(
                    label: _isSaving ? '저장 중...' : '저장',
                    onPressed: _isSaving ? null : () => _save(profile),
                    isExpanded: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle:
            AppTextStyles.body1Regular.copyWith(color: AppColors.textTertiary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
          vertical: AppSpacing.cardPadding,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style:
          AppTextStyles.body1Bold.copyWith(color: AppColors.textPrimary),
    );
  }
}
