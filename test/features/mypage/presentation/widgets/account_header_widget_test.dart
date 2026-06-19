import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/account_header_widget.dart';

const _testSession = AuthSession(
  userId: 'user-1',
  provider: AuthProvider.kakao,
  hasAgreedTerms: true,
  displayName: '홍길동',
  email: 'hong@example.com',
);

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  group('AccountHeaderWidget — 이메일 복사', () {
    testWidgets('이메일을 길게 탭하면 스낵바 "이메일이 복사됐어요"가 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(const AccountHeaderWidget(session: _testSession)),
      );
      await _settle(tester);

      await tester.longPress(find.text('hong@example.com'));
      await _settle(tester);

      expect(find.text('이메일이 복사됐어요'), findsOneWidget);
    });
  });
}
