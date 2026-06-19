import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/mypage/presentation/widgets/profile_image_picker.dart';

void main() {
  group('ProfileImagePicker', () {
    testWidgets('초기 상태(이미지 없음)에서 Icons.person 플레이스홀더를 표시한다',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileImagePicker(
              image: null,
              onImageSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });
  });
}
