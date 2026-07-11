import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_icon_sizes.dart';

/// Figma SVG 아이콘 렌더러.
///
/// 모노크롬 아이콘은 [color] 를 지정해 [BlendMode.srcIn] 으로 틴팅하고,
/// 브랜드·다색 아이콘은 [color] 를 생략해 원본색을 유지한다.
/// 이모지·[IconData]([Icons]) 사용은 금지 — 모든 글리프는 이 위젯 또는
/// `CategoryIcon` 을 경유한다. 경로는 `AppIcons` 상수 사용을 권장.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.asset, {
    super.key,
    this.size = AppIconSizes.s24,
    this.color,
    this.semanticsLabel,
  });

  /// 에셋 경로(권장: `AppIcons` 상수).
  final String asset;

  /// 아이콘 한 변 크기(권장: [AppIconSizes]).
  final double size;

  /// 틴팅 색. null 이면 원본색 유지(브랜드·다색 에셋).
  final Color? color;

  /// 접근성 라벨.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      semanticsLabel: semanticsLabel,
      colorFilter:
          color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
