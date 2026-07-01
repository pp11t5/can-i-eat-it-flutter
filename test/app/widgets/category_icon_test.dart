import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/widgets/category_icon.dart';

/// [CategoryIcon]이 렌더한 Image의 에셋 경로를 추출한다.
///
/// 프로덕션 코드가 Image.asset(cacheWidth/cacheHeight 미지정)을 사용하므로
/// image 프로퍼티가 AssetImage로 캐스팅 가능하다는 전제.
String _assetNameOf(WidgetTester tester) {
  final image = tester.widget<Image>(find.byType(Image));
  return (image.image as AssetImage).assetName;
}

void main() {
  group('CategoryIcon — 알려진 코드 매핑', () {
    testWidgets('soup_stew → food_icon_soup.png', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CategoryIcon(code: 'soup_stew')),
      );

      expect(_assetNameOf(tester), 'assets/illustrations/food_icon_soup.png');
    });

    testWidgets('rice_porridge → food_icon_rice.png', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CategoryIcon(code: 'rice_porridge')),
      );

      expect(_assetNameOf(tester), 'assets/illustrations/food_icon_rice.png');
    });

    testWidgets('대문자 코드도 소문자로 정규화되어 매핑된다 (SOUP_STEW)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CategoryIcon(code: 'SOUP_STEW')),
      );

      expect(_assetNameOf(tester), 'assets/illustrations/food_icon_soup.png');
    });
  });

  group('CategoryIcon — 폴백', () {
    testWidgets('미지 코드 → food_icon_regular.png로 폴백', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CategoryIcon(code: 'not_a_real_category')),
      );

      expect(
        _assetNameOf(tester),
        'assets/illustrations/food_icon_regular.png',
      );
    });

    testWidgets('code가 null이면 food_icon_regular.png로 폴백', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CategoryIcon(code: null)),
      );

      expect(
        _assetNameOf(tester),
        'assets/illustrations/food_icon_regular.png',
      );
    });
  });

  group('CategoryIcon — size', () {
    testWidgets('기본 size는 32', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CategoryIcon(code: 'soup_stew')),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.width, 32);
      expect(image.height, 32);
    });

    testWidgets('size 인자가 Image 크기에 반영된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CategoryIcon(code: 'soup_stew', size: 48)),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.width, 48);
      expect(image.height, 48);
    });
  });
}
