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
import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

/// 이름(닉네임) 변경 화면 (Figma node 2760-23911).
///
/// 진입 시 현재 세션 [displayName]으로 입력 필드를 프리필한다.
/// 저장 → [AuthController.updateNickname] 호출 → 성공 시 세션 갱신 + pop + 토스트.
///
/// 글자수 상한 15 (Figma·사용자 결정 — 서버 계약은 maxLength 12,
/// scratchpad api-contracts.md "Nickname (D3)" 참조). 서버가 400(length)으로
/// 거부하면 상한을 12로 하향해야 한다 — [_onSave]의 TODO 참조.
class NameEditScreen extends ConsumerStatefulWidget {
  const NameEditScreen({super.key});

  @override
  ConsumerState<NameEditScreen> createState() => _NameEditScreenState();
}

class _NameEditScreenState extends ConsumerState<NameEditScreen> {
  static const int _maxLength = 15;

  late final TextEditingController _controller;
  bool _isSaving = false;

  /// 서버 409(중복 닉네임) 시 표면화되는 에러 문구. 사용자가 텍스트를 고치면 초기화.
  String? _duplicateError;

  @override
  void initState() {
    super.initState();
    final displayName =
        ref.read(authControllerProvider).valueOrNull?.displayName ?? '';
    _controller = TextEditingController(text: displayName);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      if (_duplicateError != null) _duplicateError = null;
    });
  }

  int get _length => _controller.text.length;
  bool get _isOverLimit => _length > _maxLength;
  bool get _hasError => _isOverLimit || _duplicateError != null;

  String get _errorMessage =>
      _duplicateError ?? '이름은 15자 이내로 설정할 수 있어요.';

  bool get _canSave =>
      !_isSaving && !_isOverLimit && _controller.text.trim().isNotEmpty;

  Future<void> _onSave() async {
    if (!_canSave) return;

    setState(() => _isSaving = true);
    final nickname = _controller.text.trim();

    try {
      await ref.read(globalLoadingControllerProvider.notifier).run(
            () => ref
                .read(authControllerProvider.notifier)
                .updateNickname(nickname),
          );
      if (!mounted) return;
      unawaited(showAppToast(context, '이름을 변경했어요.'));
      context.pop();
    } on DuplicateNicknameFailure {
      if (!mounted) return;
      setState(() => _duplicateError = '이미 사용 중인 이름이에요');
    } catch (_) {
      // 400(length) 등 그 외 실패 — 에러 토스트.
      // TODO(be-confirm): 서버 계약 maxLength=12 로 400이 발생하면 클라이언트
      // 상한을 15→12로 하향해야 한다(scratchpad api-contracts.md "Nickname (D3)",
      // 팀 공지 필요).
      if (!mounted) return;
      unawaited(showAppToast(context, '저장 중 오류가 발생했어요. 다시 시도해 주세요.'));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

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
          '이름 변경',
          style: AppTextStyles.body1Medium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: AppColors.surfaceBackground, width: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sectionGap,
                vertical: AppSpacing.cardPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이름을 수정하세요.',
                    style: AppTextStyles.header1Bold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionGap),
                  _NicknameInputCard(
                    controller: _controller,
                    length: _length,
                    maxLength: _maxLength,
                    hasError: _hasError,
                  ),
                  if (_hasError) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _errorMessage,
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.verdictDanger,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.cardPadding,
              AppSpacing.cardPadding,
              AppSpacing.cardPadding,
              AppSpacing.sectionGap + MediaQuery.of(context).padding.bottom,
            ),
            child: AppButton.primary(
              label: '저장하기',
              onPressed: _canSave ? _onSave : null,
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 닉네임 입력 카드
// ---------------------------------------------------------------------------

class _NicknameInputCard extends StatelessWidget {
  const _NicknameInputCard({
    required this.controller,
    required this.length,
    required this.maxLength,
    required this.hasError,
  });

  final TextEditingController controller;
  final int length;
  final int maxLength;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        // Figma 에러 상태 fill #FFEDED — 아직 디자인 토큰으로 승격되지 않아 인라인 사용
        // (app_colors.dart AppColors.danger 프로모션과 동일 전례).
        color: hasError ? const Color(0xFFFFEDED) : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: hasError ? AppColors.verdictDanger : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              style: AppTextStyles.body1Medium.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.itemGap),
          Text(
            '$length / $maxLength',
            style: AppTextStyles.body1Medium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// [Future]를 무시(fire-and-forget). lint: unawaited_futures 억제용
/// (allergy_med_edit_screen.dart와 동일 패턴).
void unawaited(Future<void> future) {}
