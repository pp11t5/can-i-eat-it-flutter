import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          _Avatar(
            imageUrl: session.profileImageUrl,
            displayName: session.displayName,
          ),
          const SizedBox(width: 16),
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
                if (session.email != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    session.email!,
                    style: AppTextStyles.body2Regular.copyWith(
                      color: AppColors.textSecondary,
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
    return CircleAvatar(
      radius: 32,
      backgroundColor: AppColors.surfaceSelected,
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _InitialText(initial: _initial),
              )
            : _InitialText(initial: _initial),
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
