import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/widgets/confirm_modal.dart';

/// [showConfirmModal]을 호출하는 트리거 버튼을 감싼 테스트용 화면.
class _Trigger extends StatelessWidget {
  const _Trigger({
    required this.onResult,
    this.body,
  });

  final ValueChanged<ConfirmModalAction?> onResult;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final action = await showConfirmModal(
              context,
              title: '정말 탈퇴하시겠어요?',
              body: body,
              primaryLabel: '탈퇴하기',
              primaryColor: AppColors.danger,
              secondaryLabel: '취소하기',
            );
            onResult(action);
          },
          child: const Text('열기'),
        ),
      ),
    );
  }
}

void main() {
  group('ConfirmModal — 렌더링', () {
    testWidgets('제목·본문·두 버튼이 모두 렌더된다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: _Trigger(
            body: '탈퇴 후 2주 동안 로그인으로\n간편하게 복구할 수 있어요',
            onResult: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();

      expect(find.text('정말 탈퇴하시겠어요?'), findsOneWidget);
      expect(
        find.text('탈퇴 후 2주 동안 로그인으로\n간편하게 복구할 수 있어요'),
        findsOneWidget,
      );
      expect(find.text('탈퇴하기'), findsOneWidget);
      expect(find.text('취소하기'), findsOneWidget);
    });

    testWidgets('body가 null이면 본문 없이 제목·버튼만 렌더된다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: _Trigger(onResult: (_) {})),
      );

      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();

      expect(find.text('정말 탈퇴하시겠어요?'), findsOneWidget);
      expect(find.text('탈퇴하기'), findsOneWidget);
      expect(find.text('취소하기'), findsOneWidget);
    });
  });

  group('ConfirmModal — 선택 결과', () {
    testWidgets('primary 탭 시 ConfirmModalAction.primary 반환 후 닫힌다',
        (tester) async {
      ConfirmModalAction? result;
      await tester.pumpWidget(
        MaterialApp(
          home: _Trigger(onResult: (action) => result = action),
        ),
      );

      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('탈퇴하기'));
      await tester.pumpAndSettle();

      expect(result, ConfirmModalAction.primary);
      expect(find.text('정말 탈퇴하시겠어요?'), findsNothing);
    });

    testWidgets('secondary 탭 시 ConfirmModalAction.secondary 반환 후 닫힌다',
        (tester) async {
      ConfirmModalAction? result;
      await tester.pumpWidget(
        MaterialApp(
          home: _Trigger(onResult: (action) => result = action),
        ),
      );

      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('취소하기'));
      await tester.pumpAndSettle();

      expect(result, ConfirmModalAction.secondary);
      expect(find.text('정말 탈퇴하시겠어요?'), findsNothing);
    });
  });
}
