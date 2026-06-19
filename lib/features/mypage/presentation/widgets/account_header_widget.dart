import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';

/// 마이페이지 상단 계정 헤더.
///
/// 아바타(네트워크 이미지 또는 이니셜 fallback) + displayName + email을 표시한다.
class AccountHeaderWidget extends StatelessWidget {
  const AccountHeaderWidget({super.key, required this.session});

  final AuthSession session;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 16), // Figma 1316:4994
      child: Row(
        children: [
          _Avatar(
            imageUrl: session.profileImageUrl,
            displayName: session.displayName,
          ),
          const SizedBox(width: 12), // Figma 1316:4994 — 아바타↔텍스트 12px
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  session.displayName ?? '사용자',
                  style: AppTextStyles.body1Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (session.email != null && session.email!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(
                        ClipboardData(text: session.email!),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('이메일이 복사됐어요'),
                        ),
                      );
                    },
                    child: Text(
                      session.email!,
                      style: AppTextStyles.body2Regular.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.imageUrl, this.displayName});

  final String? imageUrl;
  final String? displayName;

  String get _initial {
    final name = displayName ?? '';
    return name.isNotEmpty ? name.characters.first : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${displayName ?? '사용자'} 프로필 사진',
      child: CircleAvatar(
        radius: 28, // Figma 1316:4994 — 아바타 직경 56px
        backgroundColor: AppColors.surfaceSelected,
        child: ClipOval(
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _InitialText(initial: _initial),
                )
              : _InitialText(initial: _initial),
        ),
      ),
    );
  }
}

class _InitialText extends StatelessWidget {
  const _InitialText({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initial,
        style: AppTextStyles.header1Bold.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
