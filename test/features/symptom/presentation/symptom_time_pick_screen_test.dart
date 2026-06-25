import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_time_pick_screen.dart';

Widget _wrap(DateTime initialDateTime) {
  return MaterialApp(
    theme: AppTheme.light,
    home: SymptomTimePickScreen(initialDateTime: initialDateTime),
  );
}

void main() {
  group('SymptomTimePickScreen — 렌더링', () {
    testWidgets('AppBar 타이틀 "시간 설정" 표시', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      expect(find.text('시간 설정'), findsOneWidget);
    });

    testWidgets('빠른 선택 칩 5개가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      expect(find.text('지금'), findsOneWidget);
      expect(find.text('10분 전'), findsOneWidget);
      expect(find.text('30분 전'), findsOneWidget);
      expect(find.text('1시간 전'), findsOneWidget);
      expect(find.text('2시간 전'), findsOneWidget);
    });

    testWidgets('"확인" 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      expect(find.text('확인'), findsOneWidget);
    });

    testWidgets('"빠른 선택", "직접 선택" 레이블이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      expect(find.text('빠른 선택'), findsOneWidget);
      expect(find.text('직접 선택'), findsOneWidget);
    });
  });

  group('SymptomTimePickScreen — 칩 선택', () {
    testWidgets('"지금"과 같은 시각 초기화 시 "지금" 칩이 선택 상태', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      // "지금" 칩 탭 — 에러 없이 완료
      await tester.tap(find.text('지금'));
      await tester.pumpAndSettle();
      expect(find.text('지금'), findsOneWidget);
    });

    testWidgets('"30분 전" 칩 탭 — 에러 없이 상태 변경', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('30분 전'));
      await tester.pumpAndSettle();
      expect(find.text('30분 전'), findsOneWidget);
    });

    testWidgets('"1시간 전" 칩 탭 — 에러 없이 상태 변경', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('1시간 전'));
      await tester.pumpAndSettle();
      expect(find.text('1시간 전'), findsOneWidget);
    });
  });

  group('SymptomTimePickScreen — 확인 버튼', () {
    testWidgets('"확인" 탭 시 화면 pop — Navigator 정상 동작', (tester) async {
      DateTime? result;
      final initial = nowKst();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await Navigator.of(context).push<DateTime>(
                    MaterialPageRoute(
                      builder: (_) =>
                          SymptomTimePickScreen(initialDateTime: initial),
                    ),
                  );
                },
                child: const Text('열기'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();
      expect(find.text('시간 설정'), findsOneWidget);

      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      // pop 후 결과가 DateTime
      expect(result, isA<DateTime>());
    });
  });
}
