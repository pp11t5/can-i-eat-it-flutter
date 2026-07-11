import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_icon_sizes.dart';

/// Figma **SVG** 아이콘 렌더러.
///
/// 모노크롬 아이콘은 [color] 를 지정해 [BlendMode.srcIn] 으로 틴팅하고,
/// 브랜드·다색 아이콘은 [color] 를 생략해 원본색을 유지한다.
/// 이모지·[IconData]([Icons]) 사용은 금지 — 모든 글리프는 이 위젯 또는
/// `CategoryIcon` 을 경유한다. 경로는 `AppIcons` 상수 사용을 권장.
///
/// **SVG 전용**: `SvgPicture` 로만 렌더한다. PNG 경로(`AppImages`)를 넘기면
/// 런타임에 깨지므로 [asset] 이 `.svg` 가 아니면 assert 로 조기 실패한다.
/// PNG 는 `Image.asset` 을 직접 사용.
///
/// **접근성**: 의미를 나르는 아이콘(단독 버튼의 close/search/chevron 등)은
/// [semanticsLabel] 을 반드시 지정한다(미지정 시 스크린리더에서 누락).
/// 인접 [Text] 라벨이 이미 의미를 전달하는 장식용 아이콘만 생략 가능.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.asset, {
    super.key,
    this.size = AppIconSizes.s24,
    this.color,
    this.semanticsLabel,
  });

  /// SVG 에셋 경로(권장: `AppIcons` 상수).
  final String asset;

  /// 아이콘 한 변 크기(권장: [AppIconSizes]).
  final double size;

  /// 틴팅 색. null 이면 원본색 유지(브랜드·다색 에셋).
  final Color? color;

  /// 접근성 라벨(의미 전달 아이콘은 필수).
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    assert(
      asset.toLowerCase().endsWith('.svg'),
      'AppIcon 은 SVG 전용이다. PNG 는 AppImages + Image.asset 사용: $asset',
    );
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
