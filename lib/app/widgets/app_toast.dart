import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// 앱 공용 토스트 메시지.
///
/// OverlayEntry 기반, 화면 하단 고정.
/// - 등장: fade + 위로 슬라이드 16dp, 250ms easeOut.
/// - 퇴장: fade + 아래 슬라이드, 250ms easeIn.
/// - 표시 시간: 2.5초.
///
/// 사용 예:
/// ```dart
/// showAppToast(context, '네트워크 연결을 확인해 주세요.');
/// ```
Future<void> showAppToast(BuildContext context, String message) async {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _AppToastWidget(
      message: message,
      onDismissed: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

class _AppToastWidget extends StatefulWidget {
  const _AppToastWidget({
    required this.message,
    required this.onDismissed,
  });

  final String message;
  final VoidCallback onDismissed;

  @override
  State<_AppToastWidget> createState() => _AppToastWidgetState();
}

class _AppToastWidgetState extends State<_AppToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _slideY;

  static const Duration _animDuration = Duration(milliseconds: 250);
  static const Duration _showDuration = Duration(milliseconds: 2500);
  static const double _slideDistance = 16.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _animDuration);

    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideY = Tween<double>(begin: _slideDistance, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) async {
      await Future<void>.delayed(_showDuration);
      if (!mounted) return;
      await _controller.reverse(from: 1);
      widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSpacing.screenPadding,
      right: AppSpacing.screenPadding,
      bottom: MediaQuery.of(context).padding.bottom + AppSpacing.sectionGap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, _slideY.value),
          child: Opacity(
            opacity: _opacity.value,
            child: child,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardPadding,
              vertical: AppSpacing.itemGap,
            ),
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            ),
            child: Text(
              widget.message,
              style: AppTextStyles.body2Regular.copyWith(
                color: AppColors.surface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
