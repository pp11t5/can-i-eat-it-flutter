import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<SvgPicture> pumpIcon(WidgetTester tester, Widget icon) async {
    await tester.pumpWidget(
      Directionality(textDirection: TextDirection.ltr, child: icon),
    );
    return tester.widget<SvgPicture>(find.byType(SvgPicture));
  }

  testWidgets('요청한 크기로 렌더', (tester) async {
    final svg = await pumpIcon(
      tester,
      const AppIcon(AppIcons.close, size: AppIconSizes.s32),
    );
    expect(svg.width, AppIconSizes.s32);
    expect(svg.height, AppIconSizes.s32);
  });

  testWidgets('크기 미지정 시 기본 24', (tester) async {
    final svg = await pumpIcon(tester, const AppIcon(AppIcons.search));
    expect(svg.width, AppIconSizes.s24);
    expect(svg.height, AppIconSizes.s24);
  });

  testWidgets('색 지정 시 srcIn 틴팅', (tester) async {
    const tint = Color(0xFF123456);
    final svg = await pumpIcon(
      tester,
      const AppIcon(AppIcons.chevronLeft, color: tint),
    );
    expect(svg.colorFilter, const ColorFilter.mode(tint, BlendMode.srcIn));
  });

  testWidgets('색 미지정 시 틴팅 없음(브랜드·다색 에셋)', (tester) async {
    final svg = await pumpIcon(tester, const AppIcon(AppIcons.kakaoSymbol));
    expect(svg.colorFilter, isNull);
  });

  testWidgets('PNG 경로는 build 시 assert 로 실패(SVG 전용 가드)', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: AppIcon('assets/illustrations/icon_fire.png'),
      ),
    );
    expect(tester.takeException(), isA<AssertionError>());
  });
}
