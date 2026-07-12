import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

/// 판정 로딩 화면 (Figma node 554-5332).
///
/// 배경 흰색, 화면 중앙에 스피너 + "○○님에게 맞는 음식 분석 중이에요" 텍스트.
///
/// 닉네임 우선순위: 명시적 [nickname] > 로그인 세션 displayName(GET /auth/me) > "회원".
/// (Figma는 "[닉네임]님..."으로 개인화 — 호출부가 null을 넘겨도 세션에서 직접 읽어 배선.)
class VerdictLoadingScreen extends ConsumerWidget {
  const VerdictLoadingScreen({super.key, this.nickname});

  /// 표시할 사용자 닉네임 (선택). null이면 세션 displayName → "회원" 순으로 폴백.
  final String? nickname;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final explicit = nickname?.trim();
    final sessionName =
        ref.watch(authControllerProvider).valueOrNull?.displayName?.trim();
    final displayName = (explicit != null && explicit.isNotEmpty)
        ? explicit
        : (sessionName != null && sessionName.isNotEmpty ? sessionName : '회원');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 스피너 — Figma: mingcute:loading-fill 66×66, 색 #00BF72
            const SizedBox(
              width: 66,
              height: 66,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            // "○○님에게 맞는 음식 분석 중이에요"
            // Body_1(M): Pretendard Medium 16, lineHeight 160%, color #10111A
            Text(
              '$displayName님에게 맞는 음식 분석 중이에요',
              style: AppTextStyles.body1Medium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
