import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/core/app_info/app_info_provider.dart';

/// 앱 버전 표시 위젯.
///
/// [appInfoProvider]를 watch해 "버전 x.y.z (buildNumber)" 형식으로 표시한다.
/// 로딩·에러 시 빈 SizedBox 반환.
class AppVersionWidget extends ConsumerWidget {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoAsync = ref.watch(appInfoProvider);

    return infoAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (info) => Text(
        '버전 ${info.version} (${info.buildNumber})',
        textAlign: TextAlign.center,
        style: AppTextStyles.caption1Medium.copyWith(
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
