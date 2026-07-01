import 'package:flutter/material.dart';

/// 음식 카테고리 코드 → 일러스트 아이콘.
///
/// 서버 카테고리 코드(예: `rice_porridge`)를 `assets/illustrations/food_icon_<token>.png`
/// 토큰으로 매핑한다. 매핑되지 않는 코드/null 은 `regular` 로 폴백한다.
class CategoryIcon extends StatelessWidget {
  const CategoryIcon({super.key, required this.code, this.size = 32});

  /// 서버 음식 카테고리 코드. null 이면 `regular` 폴백.
  final String? code;

  /// 아이콘 한 변 크기.
  final double size;

  static const Map<String, String> _tokenByCode = {
    'rice_porridge': 'rice',
    'noodles': 'noodles',
    'bread_bakery': 'bread',
    'soup_stew': 'soup',
    'grilled_jeon': 'grilled',
    'fried': 'fried',
    'stirfry_braise': 'braise',
    'steam_boil': 'boiled',
    'sashimi_sushi': 'sushi',
    'salad_vegetable': 'vege',
    'snack_dessert': 'dessert',
    'fruit': 'fruit',
    'beverage': 'beverage',
  };

  String get _token {
    final normalized = code?.toLowerCase();
    if (normalized == null) return 'regular';
    return _tokenByCode[normalized] ?? 'regular';
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/illustrations/food_icon_$_token.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
