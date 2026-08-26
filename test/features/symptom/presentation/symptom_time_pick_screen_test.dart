import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/core/utils/kst_time.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_time_pick_screen.dart';

Widget _wrap(DateTime initialDateTime, {DateTime? joinDate}) {
  return MaterialApp(
    theme: AppTheme.light,
    home: SymptomTimePickScreen(
      initialDateTime: initialDateTime,
      joinDate: joinDate,
    ),
  );
}

Future<void> _openManualWheel(WidgetTester tester) async {
  await tester.tap(find.text('직접 입력'));
  await tester.pumpAndSettle();
}

List<ListWheelScrollView> _wheelsOf(WidgetTester tester) {
  return tester
      .widgetList<ListWheelScrollView>(find.byType(ListWheelScrollView))
      .toList();
}

ListWheelChildBuilderDelegate _delegateOf(ListWheelScrollView wheel) {
  return wheel.childDelegate as ListWheelChildBuilderDelegate;
}

void main() {
  group('SymptomTimePickScreen — 렌더링', () {
    testWidgets('AppBar 타이틀 "시간 설정" 표시', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      expect(find.text('시간 설정'), findsOneWidget);
    });

    testWidgets('제목·부제목이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      expect(find.text('언제 그런 증상을 느끼셨나요?'), findsOneWidget);
      expect(find.text('기억나는 시간을 알려주세요'), findsOneWidget);
    });

    testWidgets('빠른 선택 칩 6개가 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      expect(find.text('지금'), findsOneWidget);
      expect(find.text('10분 전'), findsOneWidget);
      expect(find.text('30분 전'), findsOneWidget);
      expect(find.text('1시간 전'), findsOneWidget);
      expect(find.text('2시간 전'), findsOneWidget);
      expect(find.text('직접 입력'), findsOneWidget);
    });

    testWidgets('"확인" 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      expect(find.text('확인'), findsOneWidget);
    });

    testWidgets('기본(지금)에서는 휠이 숨겨진다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      expect(find.text('빠른 선택'), findsOneWidget);
      expect(find.text('직접 선택'), findsNothing);
      expect(find.byType(ListWheelScrollView), findsNothing);
    });

    testWidgets('"직접 입력" 탭 시 휠이 노출된다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await _openManualWheel(tester);
      expect(find.text('직접 선택'), findsOneWidget);
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
    });

    testWidgets('직접 입력 휠 좌우 열은 옆에서 본 원통 각도다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await _openManualWheel(tester);

      final wheels = _wheelsOf(tester);
      expect(wheels[0].offAxisFraction, -0.45);
      expect(wheels[1].offAxisFraction, 0);
      expect(wheels[2].offAxisFraction, 0.45);
    });

    testWidgets('직접 입력 휠은 현재 시각을 기본 선택한다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await _openManualWheel(tester);

      final now = nowKst();
      final wheels = _wheelsOf(tester);
      final dateCtrl = wheels[0].controller! as FixedExtentScrollController;
      final hourCtrl = wheels[1].controller! as FixedExtentScrollController;
      final minuteCtrl = wheels[2].controller! as FixedExtentScrollController;
      expect(dateCtrl.selectedItem, 6);
      expect(hourCtrl.selectedItem, now.hour);
      expect(minuteCtrl.selectedItem, now.minute);
    });

    testWidgets('다른 빠른 선택 후 직접 입력이어도 휠은 현재 시각부터다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('10분 전'));
      await tester.pumpAndSettle();
      await _openManualWheel(tester);

      final now = nowKst();
      final wheels = _wheelsOf(tester);
      final hourCtrl = wheels[1].controller! as FixedExtentScrollController;
      final minuteCtrl = wheels[2].controller! as FixedExtentScrollController;
      expect(hourCtrl.selectedItem, now.hour);
      expect(minuteCtrl.selectedItem, now.minute);
    });

    testWidgets('지금 초기화 후 직접 입력 → 날짜 휠은 오늘(마지막)을 선택한다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await _openManualWheel(tester);

      final dateWheel = tester.widget<ListWheelScrollView>(
        find.byType(ListWheelScrollView).first,
      );
      final controller = dateWheel.controller! as FixedExtentScrollController;
      expect(controller.selectedItem, 6);
    });
  });

  group('SymptomTimePickScreen — 칩 선택', () {
    testWidgets('"지금"과 같은 시각 초기화 시 "지금" 칩이 선택 상태', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('지금'));
      await tester.pumpAndSettle();
      expect(find.text('지금'), findsOneWidget);
      expect(find.byType(ListWheelScrollView), findsNothing);
    });

    testWidgets('"30분 전" 칩 탭 — 에러 없이 상태 변경', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('30분 전'));
      await tester.pumpAndSettle();
      expect(find.text('30분 전'), findsOneWidget);
      expect(find.byType(ListWheelScrollView), findsNothing);
    });

    testWidgets('"1시간 전" 칩 탭 — 에러 없이 상태 변경', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await tester.tap(find.text('1시간 전'));
      await tester.pumpAndSettle();
      expect(find.text('1시간 전'), findsOneWidget);
    });
  });

  group('SymptomTimePickScreen — 직접 입력 휠', () {
    testWidgets('오늘이면 현재 시각 이후 시·분은 휠에 없다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await _openManualWheel(tester);

      final now = nowKst();
      final wheels = _wheelsOf(tester);
      expect(wheels, hasLength(3));

      expect(_delegateOf(wheels[1]).childCount, now.hour + 1);
      expect(_delegateOf(wheels[2]).childCount, now.minute + 1);

      if (now.hour < 23) {
        expect(
          find.text('${(now.hour + 1).toString().padLeft(2, '0')}시'),
          findsNothing,
        );
      }
      if (now.minute < 59) {
        expect(
          find.text('${(now.minute + 1).toString().padLeft(2, '0')}분'),
          findsNothing,
        );
      }
    });

    testWidgets('날짜 휠은 과거가 위, 오늘이 마지막이다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await _openManualWheel(tester);

      final dateCtrl = _wheelsOf(tester).first.controller!
          as FixedExtentScrollController;
      expect(dateCtrl.selectedItem, 6);

      final yesterday = nowKst().subtract(const Duration(days: 1));
      const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      final yesterdayLabel =
          '${yesterday.month}월 ${yesterday.day}일 (${weekdays[yesterday.weekday - 1]})';
      expect(find.text(yesterdayLabel), findsOneWidget);
      expect(find.text('오늘'), findsOneWidget);
    });

    testWidgets('어제 날짜를 고르면 시 0–23, 분 0–59가 모두 있다', (tester) async {
      await tester.pumpWidget(_wrap(nowKst()));
      await tester.pumpAndSettle();
      await _openManualWheel(tester);

      final dateCtrl = _wheelsOf(tester).first.controller!
          as FixedExtentScrollController;
      expect(dateCtrl.selectedItem, 6);
      dateCtrl.jumpToItem(5);
      await tester.pumpAndSettle();

      final wheels = _wheelsOf(tester);
      expect(_delegateOf(wheels[1]).childCount, 24);
      expect(_delegateOf(wheels[2]).childCount, 60);
    });

    testWidgets('가입일이 오늘이면 날짜 휠에 오늘만 있다', (tester) async {
      final now = nowKst();
      await tester.pumpWidget(_wrap(now, joinDate: now));
      await tester.pumpAndSettle();
      await _openManualWheel(tester);

      final dateWheel = _wheelsOf(tester).first;
      expect(_delegateOf(dateWheel).childCount, 1);
      expect(find.text('오늘'), findsOneWidget);

      final yesterday = now.subtract(const Duration(days: 1));
      const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      final yesterdayLabel =
          '${yesterday.month}월 ${yesterday.day}일 (${weekdays[yesterday.weekday - 1]})';
      expect(find.text(yesterdayLabel), findsNothing);
    });

    testWidgets('어제 시각으로 열면 직접 입력 휠이 바로 보인다', (tester) async {
      final yesterday = nowKst().subtract(const Duration(days: 1));
      await tester.pumpWidget(_wrap(yesterday));
      await tester.pumpAndSettle();

      expect(find.text('직접 선택'), findsOneWidget);
      final dateCtrl = _wheelsOf(tester).first.controller!
          as FixedExtentScrollController;
      expect(dateCtrl.selectedItem, 5);
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

      expect(result, isA<DateTime>());
      expect(result!.isAfter(nowKst()), isFalse);
    });

    testWidgets('직접 입력 후 확인 → 결과가 현재 시각 이후가 아니다', (tester) async {
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
      await _openManualWheel(tester);
      await tester.tap(find.text('확인'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.isAfter(nowKst()), isFalse);
    });
  });
}
