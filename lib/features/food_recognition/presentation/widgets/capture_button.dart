import 'package:flutter/material.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';

/// 카메라 셔터 버튼. 누르는 동안 안쪽 원이 회색이 된다.
///
/// [onPressed] 가 null 이면 비활성이다.
class CaptureButton extends StatefulWidget {
  const CaptureButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  State<CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton> {
  static const double _size = 80;
  // 링과 안쪽 원은 간격 없이 붙는다 (안쪽 원 지름 80 - 6×2 = 68).
  static const double _ringWidth = 6;

  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onPressed == null || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: widget.onPressed != null,
      label: '사진 찍기',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: Container(
          width: _size,
          height: _size,
          // padding 을 주지 않는다. Container 가 border 두께만큼 여백을 자동으로
          // 더하므로, 또 주면 링과 안쪽 원 사이에 틈이 생긴다.
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            border: Border.fromBorderSide(
              BorderSide(color: AppColors.captureRing, width: _ringWidth),
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _pressed ? AppColors.capturePressed : AppColors.surface,
            ),
          ),
        ),
      ),
    );
  }
}
