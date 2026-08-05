import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

/// 판정 로딩 화면 (Figma Loading_Dido / node 554-5332).
///
/// 배경 흰색, 화면 중앙에 캐릭터 GIF + 로딩 카피 2종 중 랜덤 1개.
///
/// 닉네임 우선순위: 명시적 [nickname] > 로그인 세션 displayName(GET /auth/me) > "회원".
/// (Figma는 "[닉네임]님..."으로 개인화 — 호출부가 null을 넘겨도 세션에서 직접 읽어 배선.)
class VerdictLoadingScreen extends ConsumerStatefulWidget {
  const VerdictLoadingScreen({
    super.key,
    this.nickname,
    @visibleForTesting this.messageIndex,
  });

  /// 표시할 사용자 닉네임 (선택). null이면 세션 displayName → "회원" 순으로 폴백.
  final String? nickname;

  /// 로딩 카피 인덱스 (0 또는 1). null이면 마운트 시 랜덤.
  /// 테스트·골든 고정용.
  @visibleForTesting
  final int? messageIndex;

  /// Figma Loading_Dido 캐릭터 표시 너비.
  static const double characterWidth = 200;

  /// 캐릭터 → 카피 간격.
  static const double characterTextGap = 24;

  /// 닉네임 자리에 `{name}` 을 넣는 로딩 카피 템플릿.
  static const List<String> messageTemplates = [
    '{name}님에게 맞는 음식 분석 중..',
    '{name}님이 먹어도 되...려나?',
  ];

  /// [displayName] 과 인덱스에 맞는 카피 문자열.
  static String messageFor(String displayName, int index) {
    final i = index % messageTemplates.length;
    return messageTemplates[i].replaceAll('{name}', displayName);
  }

  @override
  ConsumerState<VerdictLoadingScreen> createState() =>
      _VerdictLoadingScreenState();
}

class _VerdictLoadingScreenState extends ConsumerState<VerdictLoadingScreen> {
  late final int _messageIndex;

  @override
  void initState() {
    super.initState();
    final forced = widget.messageIndex;
    _messageIndex = forced != null
        ? forced % VerdictLoadingScreen.messageTemplates.length
        : Random().nextInt(VerdictLoadingScreen.messageTemplates.length);
  }

  @override
  Widget build(BuildContext context) {
    final explicit = widget.nickname?.trim();
    final sessionName =
        ref.watch(authControllerProvider).valueOrNull?.displayName?.trim();
    final displayName = (explicit != null && explicit.isNotEmpty)
        ? explicit
        : (sessionName != null && sessionName.isNotEmpty ? sessionName : '회원');
    final message =
        VerdictLoadingScreen.messageFor(displayName, _messageIndex);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.characterSearching,
              width: VerdictLoadingScreen.characterWidth,
              fit: BoxFit.contain,
              gaplessPlayback: true,
            ),
            const SizedBox(height: VerdictLoadingScreen.characterTextGap),
            // Body_1(M): 16/500, height 1.6 · Foundation/font color/50
            Text(
              message,
              style: AppTextStyles.body1Medium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
