import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/account_actions_widget.dart';

Widget _wrap() => MaterialApp(
      home: Scaffold(
        body: AccountActionsWidget(onLogout: () {}),
      ),
    );

void main() {
  group('AccountActionsWidget — 로그아웃 버튼 색상', () {
    testWidgets('로그아웃 버튼의 foregroundColor가 AppColors.danger이다', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      final button = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );
      final style = button.style;
      final foreground = style
          ?.foregroundColor
          ?.resolve(<WidgetState>{});
      expect(foreground, equals(AppColors.danger));
    });
  });
}
