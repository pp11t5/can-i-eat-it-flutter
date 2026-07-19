import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/app/widgets/category_icon.dart';
import 'package:can_i_eat_it/app/widgets/global_loading.dart';
import 'package:can_i_eat_it/app/widgets/selectable_chip.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';
import 'package:can_i_eat_it/features/symptom/presentation/providers/symptom_write_controller.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_meal_pick_screen.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_time_pick_screen.dart';
import 'package:can_i_eat_it/features/symptom/presentation/widgets/mood_face.dart';

// ---------------------------------------------------------------------------
// 화면 전용 mood 라벨 (symptom_state.dart의 label은 변경 금지)
// SymptomState 순서: comfortable / good / normal / uncomfortable / severe
// ---------------------------------------------------------------------------
const _moodLabels = ['편안', '양호', '보통', '불편', '심각'];
const _moodOrder = [
  SymptomState.comfortable,
  SymptomState.good,
  SymptomState.normal,
  SymptomState.uncomfortable,
  SymptomState.severe,
];

// ---------------------------------------------------------------------------
// 증상 칩 정의
// ---------------------------------------------------------------------------

/// "없음" 칩 sentinel — symptomTypes=[] 로 매핑.
const _kNoneLabel = '없음';

const _symptomChipDefs = [
  (label: _kNoneLabel, type: null),
  (label: '목 이물감이 있어요', type: SymptomType.throatForeignBody),
  (label: '신물이 느껴져요', type: SymptomType.acidReflux),
  (label: '기침이 나요', type: SymptomType.cough),
  (label: '가슴이 답답해요', type: SymptomType.chestTightness),
];

// ---------------------------------------------------------------------------
// SymptomWriteArgs — 원인 식사 프리필 진입 인자
// ---------------------------------------------------------------------------

/// [SymptomWriteScreen] 신규 작성 진입 시 원인 식사를 프리필하기 위한 인자.
///
/// 미기록 식단 목록 등에서 특정 식사를 원인으로 지정해 증상 작성으로 진입할 때 사용.
class SymptomWriteArgs {
  const SymptomWriteArgs({this.initialMealRecordId, this.initialMealName});

  /// 프리필할 원인 식사 ID.
  final String? initialMealRecordId;

  /// 프리필할 원인 식사 표시명.
  final String? initialMealName;
}

// ---------------------------------------------------------------------------
// SymptomWriteScreen
// ---------------------------------------------------------------------------

/// 증상 작성/수정 화면.
///
/// [existingSymptom] null → 신규 작성 모드.
/// [existingSymptom] 비-null → 수정 모드 (폼 프리필 + update 호출).
///
/// [initialMealRecordId]/[initialMealName] 은 신규 작성 모드에서만 적용되는
/// 원인 식사 프리필 인자([existingSymptom] 이 우선한다).
class SymptomWriteScreen extends ConsumerStatefulWidget {
  const SymptomWriteScreen({
    super.key,
    this.existingSymptom,
    this.initialMealRecordId,
    this.initialMealName,
  });

  final Symptom? existingSymptom;

  /// 신규 작성 모드 전용 원인 식사 프리필 ID.
  final String? initialMealRecordId;

  /// 신규 작성 모드 전용 원인 식사 프리필 표시명.
  final String? initialMealName;

  @override
  ConsumerState<SymptomWriteScreen> createState() =>
      _SymptomWriteScreenState();
}

class _SymptomWriteScreenState extends ConsumerState<SymptomWriteScreen> {
  late SymptomWriteFormState _formState;
  final _memoController = TextEditingController();

  bool get _isEditMode => widget.existingSymptom != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingSymptom;
    if (existing != null) {
      // 수정 모드: 기존 값으로 프리필
      final occurredAt = _parseOccurredAt(existing.occurredAt);
      _formState = SymptomWriteFormState(
        mood: existing.symptomState,
        symptomTypes: List<SymptomType>.from(existing.symptomTypes),
        occurredAt: occurredAt,
        linkedMealId: existing.linkedMeal?.mealRecordId,
        linkedMealDisplayName: existing.linkedMeal?.foods.isNotEmpty == true
            ? existing.linkedMeal!.foods.first.name
            : null,
        memo: '',
      );
    } else {
      // 신규 모드: 빈 폼 (원인 식사 프리필 인자가 있으면 시딩)
      _formState = SymptomWriteFormState(
        occurredAt: nowKst(),
        linkedMealId: widget.initialMealRecordId,
        linkedMealDisplayName: widget.initialMealRecordId != null
            ? widget.initialMealName
            : null,
      );
    }
    _memoController.text = _formState.memo;
    _memoController.addListener(() {
      setState(() {
        _formState = _formState.copyWith(memo: _memoController.text);
      });
    });
  }

  DateTime _parseOccurredAt(String iso) {
    try {
      return parseKst(iso);
    } catch (_) {
      return nowKst();
    }
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // 저장 가능 여부
  // --------------------------------------------------------------------------

  /// mood 선택만 필수. mealRecordId는 서버 계약상 nullable이므로 "선택 안
  /// 할래요"(linkedMealId=null, 식사 미연결)여도 저장 가능하다.
  bool get _canSave => _formState.mood != null;

  // --------------------------------------------------------------------------
  // 이벤트 핸들러
  // --------------------------------------------------------------------------

  void _onMoodTap(SymptomState mood) {
    setState(() {
      _formState = _formState.copyWith(mood: mood);
    });
  }

  void _onSymptomChipTap(SymptomType? type) {
    if (type == null) {
      // "없음" 선택: 나머지 전부 해제
      setState(() {
        _formState = _formState.copyWith(symptomTypes: []);
      });
      return;
    }
    final current = List<SymptomType>.from(_formState.symptomTypes);
    if (current.contains(type)) {
      current.remove(type);
    } else {
      current.add(type);
    }
    setState(() {
      _formState = _formState.copyWith(symptomTypes: current);
    });
  }

  Future<void> _onTimeTap() async {
    final result = await Navigator.of(context).push<DateTime>(
      MaterialPageRoute(
        builder: (_) =>
            SymptomTimePickScreen(initialDateTime: _formState.occurredAt),
      ),
    );
    if (result != null) {
      setState(() {
        _formState = _formState.copyWith(occurredAt: result);
      });
    }
  }

  Future<void> _onMealTap() async {
    final result = await Navigator.of(context).push<MealPickResult?>(
      MaterialPageRoute(
        builder: (_) => SymptomMealPickScreen(
          initialMealRecordId: _formState.linkedMealId,
        ),
      ),
    );
    if (result == null) {
      // 단순 dismiss(AppBar/시스템 뒤로가기) — 변경 없음, 기존 linkedMeal 보존
      return;
    }
    if (result.cleared) {
      // "선택 안 할래요" 명시적 해제
      setState(() {
        _formState = _formState.copyWith(clearLinkedMeal: true);
      });
      return;
    }
    setState(() {
      _formState = _formState.copyWith(
        linkedMealId: result.mealRecordId,
        linkedMealDisplayName: result.displayName,
      );
    });
  }

  Future<void> _onSave() async {
    if (!_canSave) return;
    final ctrl = ref.read(
      symptomWriteControllerProvider(
        _isEditMode ? widget.existingSymptom!.symptomId : null,
      ).notifier,
    );
    final id = await ref
        .read(globalLoadingControllerProvider.notifier)
        .run(() => ctrl.submit(_formState));
    if (!mounted) return;
    if (id != null) {
      await showAppToast(
          context, _isEditMode ? '증상 기록을 수정했어요.' : '증상 기록을 저장했어요.');
      if (mounted) Navigator.of(context).pop();
    } else {
      await showAppToast(context, '저장에 실패했어요. 다시 시도해 주세요.');
    }
  }

  // --------------------------------------------------------------------------
  // 표시 헬퍼
  // --------------------------------------------------------------------------

  String _formatOccurredAt(DateTime dt) {
    final now = nowKst();
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final isToday = dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day;
    final isNow = isToday &&
        dt.hour == now.hour &&
        dt.minute == now.minute;
    final datePart = isToday
        ? ''
        : ' · ${dt.month}월 ${dt.day}일';
    final suffix = isNow ? ' (지금)' : '';
    return '$h:$m$datePart${isToday && !isNow ? ' · ${dt.month}월 ${dt.day}일' : ''}$suffix';
  }

  // --------------------------------------------------------------------------
  // build
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(
      symptomWriteControllerProvider(
        _isEditMode ? widget.existingSymptom!.symptomId : null,
      ),
    );
    final isLoading = submitState is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 64,
        leading: IconButton(
          icon: const AppIcon(
            AppIcons.close,
            size: AppIconSizes.s32,
            color: AppColors.textPrimary,
            semanticsLabel: '닫기',
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '증상 기록 작성',
          style: AppTextStyles.body1Medium
              .copyWith(color: AppColors.textPrimary),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sectionGap),

                  // ── 섹션 1: mood ──────────────────────────────────────
                  const _SectionLabel(label: '지금 속은 어때요?'),
                  const SizedBox(height: 16),
                  _MoodSelector(
                    selected: _formState.mood,
                    onTap: _onMoodTap,
                  ),
                  const SizedBox(height: 48),

                  // ── 섹션 2: 증상 유형 ──────────────────────────────────
                  const _SectionLabel(label: '어떤 증상이 느껴지시나요?'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: AppSpacing.itemGap,
                    runSpacing: AppSpacing.itemGap,
                    children: _symptomChipDefs.map((def) {
                      final isNone = def.type == null;
                      final selected = isNone
                          ? _formState.symptomTypes.isEmpty
                          : _formState.symptomTypes.contains(def.type);
                      return SelectableChip(
                        label: def.label,
                        selected: selected,
                        onTap: () => _onSymptomChipTap(def.type),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 48),

                  // ── 섹션 3: 시간 ───────────────────────────────────────
                  const _SectionLabel(label: '언제 그런 증상을 느끼셨어요?'),
                  const SizedBox(height: 16),
                  _TapCard(
                    onTap: _onTimeTap,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formatOccurredAt(_formState.occurredAt),
                            style: AppTextStyles.body2Medium
                                .copyWith(color: AppColors.textPrimary),
                          ),
                        ),
                        // Figma: 시간 카드 우측 정적 장식(무드 얼굴 에셋). 시계 아님.
                        Image.asset(AppImages.moodComfortable,
                            width: 24, height: 24),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // ── 섹션 4: 원인 식사 ──────────────────────────────────
                  const _SectionLabel(label: '어떤 식사를 먹고 증상이 느껴졌나요?'),
                  const SizedBox(height: 16),
                  _TapCard(
                    onTap: _onMealTap,
                    child: Row(
                      children: [
                        if (_formState.linkedMealId != null) ...[
                          // 카테고리 코드 미보유 → regular 폴백. 데이터 확장 시 코드 전달.
                          const CategoryIcon(code: null, size: 32),
                          const SizedBox(width: AppSpacing.itemGap),
                        ],
                        Expanded(
                          child: Text(
                            _formState.linkedMealId == null
                                ? '최근 음식을 선택해 주세요'
                                : (_formState.linkedMealDisplayName ?? '식사 선택됨'),
                            style: AppTextStyles.body2Medium.copyWith(
                              color: _formState.linkedMealId == null
                                  ? AppColors.textTertiary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        // Figma: 식사 카드 우측 정적 장식(무드 얼굴 에셋). 링크 아님.
                        Image.asset(AppImages.moodComfortable,
                            width: 24, height: 24),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // ── 섹션 5: 메모 ───────────────────────────────────────
                  const _SectionLabel(label: '추가 메모 기록'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _memoController,
                    maxLength: 200,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    style: AppTextStyles.body2Regular
                        .copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: '구체적인 상태를 써주세요',
                      hintStyle: AppTextStyles.body2Medium
                          .copyWith(color: AppColors.textSecondary),
                      counterStyle: AppTextStyles.caption1Medium
                          .copyWith(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusCard),
                        borderSide: const BorderSide(
                            color: AppColors.border, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusCard),
                        borderSide: const BorderSide(
                            color: AppColors.border, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusCard),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(AppSpacing.cardPadding),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                ],
              ),
            ),
          ),

          // 하단 저장 버튼
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.itemGap,
              AppSpacing.screenPadding,
              MediaQuery.of(context).padding.bottom + AppSpacing.screenPadding,
            ),
            child: SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: (_canSave && !isLoading) ? _onSave : null,
                style: FilledButton.styleFrom(
                  backgroundColor:
                      (_canSave && !isLoading) ? AppColors.primary : AppColors.surfaceMuted,
                  foregroundColor:
                      (_canSave && !isLoading) ? AppColors.onPrimary : AppColors.textTertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                  ),
                  textStyle: AppTextStyles.body1Bold,
                ),
                // 진행 중 스피너는 전역 로딩 오버레이가 담당(이중 표시 방지) —
                // 이 버튼은 비활성 색상으로만 진행 중임을 표시한다.
                child: const Text('저장하기'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _SectionLabel
// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.body1Bold
          .copyWith(color: const Color(0xFF222222)),
    );
  }
}

// ---------------------------------------------------------------------------
// _TapCard — 탭 가능한 카드
// ---------------------------------------------------------------------------

class _TapCard extends StatelessWidget {
  const _TapCard({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(color: AppColors.borderCard),
        ),
        child: child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _MoodSelector — mood 5단계 가로 선택기
// ---------------------------------------------------------------------------

class _MoodSelector extends StatelessWidget {
  const _MoodSelector({required this.selected, required this.onTap});

  final SymptomState? selected;
  final void Function(SymptomState) onTap;

  @override
  Widget build(BuildContext context) {
    const circle = 40.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 원 행 + 뒤 연결선
        SizedBox(
          height: circle,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 첫~마지막 원 중심을 잇는 연결선 (원 뒤)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: circle / 2),
                child: Container(height: 1, color: AppColors.border),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_moodOrder.length, (i) {
                  final mood = _moodOrder[i];
                  final isSelected = selected == mood;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(mood),
                    child: SizedBox(
                      width: circle,
                      height: circle,
                      // 선택: Figma 무드 얼굴 에셋 / 미선택: 빈 테두리 원
                      child: isSelected
                          ? MoodFace(state: mood, size: circle)
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFFCFCFC),
                                border: Border.all(
                                    color: AppColors.border, width: 1),
                              ),
                            ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        // 라벨 행 (Figma: 전부 gray/50)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_moodOrder.length, (i) {
            return SizedBox(
              width: circle,
              child: Text(
                _moodLabels[i],
                textAlign: TextAlign.center,
                style: AppTextStyles.body2Medium
                    .copyWith(color: AppColors.textSecondary),
              ),
            );
          }),
        ),
      ],
    );
  }
}
