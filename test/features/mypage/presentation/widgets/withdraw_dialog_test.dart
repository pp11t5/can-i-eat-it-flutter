import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/withdraw_dialog.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

const _testSession = AuthSession(
  userId: 'u',
  provider: AuthProvider.kakao,
  hasAgreedTerms: true,
);

/// 다이얼로그를 띄우는 버튼을 가진 테스트용 앱.
class _TestApp extends ConsumerWidget {
  const _TestApp({required this.authRepo});

  final MockAuthRepository authRepo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (ctx) => ElevatedButton(
            onPressed: () => showWithdrawDialog(ctx, ref),
            child: const Text('탈퇴 다이얼로그 열기'),
          ),
        ),
      ),
    );
  }
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('WithdrawDialog', () {
    testWidgets('다이얼로그가 열리면 탈퇴 확인 텍스트가 표시된다', (tester) async {
      final repo = MockAuthRepository(initialSession: _testSession);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            authRepositoryProvider.overrideWithValue(repo),
          ],
          child: _TestApp(authRepo: repo),
        ),
      );

      await tester.tap(find.text('탈퇴 다이얼로그 열기'));
      await _settle(tester);

      expect(find.text('정말 탈퇴하시겠어요?'), findsOneWidget);
    });

    testWidgets('취소 버튼 탭 시 다이얼로그가 닫힌다', (tester) async {
      final repo = MockAuthRepository(initialSession: _testSession);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            authRepositoryProvider.overrideWithValue(repo),
          ],
          child: _TestApp(authRepo: repo),
        ),
      );

      await tester.tap(find.text('탈퇴 다이얼로그 열기'));
      await _settle(tester);

      await tester.tap(find.text('취소'));
      await _settle(tester);

      expect(find.text('정말 탈퇴하시겠어요?'), findsNothing);
    });

    testWidgets('탈퇴 버튼 탭 시 MockAuthRepository.withdraw 가 호출된다', (tester) async {
      // MockAuthRepository.withdraw() 는 _session=null 로 설정한다.
      // 탈퇴 후 authControllerProvider.state.value 가 null 이 되는지로 검증.
      final repo = MockAuthRepository(initialSession: _testSession);

      late WidgetRef capturedRef;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // ignore: scoped_providers_should_specify_dependencies
            authRepositoryProvider.overrideWithValue(repo),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) => Consumer(
                  builder: (_, ref, __) {
                    capturedRef = ref;
                    return ElevatedButton(
                      onPressed: () => showWithdrawDialog(ctx, ref),
                      child: const Text('탈퇴 다이얼로그 열기'),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // 초기 세션 로드
      await _settle(tester);

      await tester.tap(find.text('탈퇴 다이얼로그 열기'));
      await _settle(tester);

      await tester.tap(find.text('탈퇴'));
      await _settle(tester);

      // withdraw 성공 → authControllerProvider state 가 null 로 전이
      expect(capturedRef.read(authControllerProvider).value, isNull);
    });
  });
}
