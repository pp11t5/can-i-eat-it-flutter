import 'package:can_i_eat_this/features/food_check/presentation/screens/food_check_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FoodCheckScreen 초기 상태에서 안내 문구와 판별 버튼을 보여준다',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: FoodCheckScreen()),
      ),
    );

    expect(find.text('먹어도 돼?'), findsOneWidget);
    expect(find.text('판별하기'), findsOneWidget);
    expect(find.text('음식을 입력하고 판별해 보세요.'), findsOneWidget);
  });
}
