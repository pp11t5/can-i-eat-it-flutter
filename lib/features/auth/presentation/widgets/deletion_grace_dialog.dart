import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/widgets/confirm_modal.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

/// 삭제 유예 계정(02a) 로그인 시 복구 여부를 묻는 다이얼로그.
///
/// 공용 [showConfirmModal](Figma ModalCard #365:2465)을 사용한다. Figma node
/// 365:1558 텍스트: 제목 "탈퇴를 진행 중인 계정이에요", 본문 "유예 기간 동안에는
/// 언제든 복구할 수 있어요\n지금 복구하시겠어요?", primary "계정 복구하고 계속하기".
Future<void> showDeletionGraceDialog(
  BuildContext context,
  WidgetRef ref, {
  required AuthProvider provider,
  required String idToken,
}) async {
  // 계정소실 위험 경로 — 복구 실패로 모달이 닫혀버리면 사용자가 로그인
  // 플로우를 처음부터 다시 타야 한다. 성공/취소 전까지 모달을 재노출한다.
  while (true) {
    final action = await showConfirmModal(
      context,
      title: '탈퇴를 진행 중인 계정이에요',
      body: '유예 기간 동안에는 언제든 복구할 수 있어요\n지금 복구하시겠어요?',
      primaryLabel: '계정 복구하고 계속하기',
      primaryColor: AppColors.primary,
      secondaryLabel: '취소',
    );

    if (!context.mounted) return;
    if (action == ConfirmModalAction.primary) {
      final recovered =
          await _onRecover(context, ref, provider: provider, idToken: idToken);
      if (recovered) return; // 복구 성공: gate 가 라우팅.
      if (!context.mounted) return;
      continue; // 복구 실패: 모달 재노출해 재시도 어포던스 제공.
    } else {
      await _onCancel(ref);
      return;
    }
  }
}

/// 복구 시도 결과를 반환한다(성공 true / 실패 false). 실패 시 호출부가 모달을
/// 재노출해 재시도할 수 있도록 예외를 삼키지 않고 bool 로 알린다.
Future<bool> _onRecover(
  BuildContext context,
  WidgetRef ref, {
  required AuthProvider provider,
  required String idToken,
}) async {
  try {
    await ref
        .read(authControllerProvider.notifier)
        .recoverAccount(provider, idToken: idToken);
    // 복구 성공: gate 가 sessionStatus 전이를 감지해 자동 라우팅 — 별도 navigation 불필요.
    return true;
  } catch (e) {
    if (!context.mounted) return false;
    // 의료성 흐름 — 무증상 실패 금지. 사용자에게 명시적 오류를 표시한다.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('계정 복구에 실패했어요. 잠시 후 다시 시도해 주세요.'),
        backgroundColor: AppColors.verdictDanger,
      ),
    );
    return false;
  }
}

Future<void> _onCancel(WidgetRef ref) async {
  await ref.read(authControllerProvider.notifier).signOut();
  // auth redirect 가드가 /login 으로 이동시킴 — 별도 navigation 불필요.
}
