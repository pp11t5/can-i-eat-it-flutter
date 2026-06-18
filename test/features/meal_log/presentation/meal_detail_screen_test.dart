import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/meal_detail_screen.dart';

/// 위젯 테스트용 래퍼: go_router 없이 직접 Navigator 스택으로 감싼다.
Widget _wrap(Widget child, {MockMealRepository? repo}) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(
        repo ?? MockMealRepository.seeded(),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

void main() {
  group('MealDetailScreen — 기본 렌더', () {
    testWidgets('음식명·판정라벨 표시', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealDetailScreen(mealId: 'meal-002')),
      );
      await tester.pumpAndSettle();

      // 음식명
      expect(find.text('커피'), findsOneWidget);
      // 판정 라벨 (risk → '위험')
      expect(find.text('위험'), findsOneWidget);
    });

    testWidgets('메모 있으면 메모 섹션 표시', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealDetailScreen(mealId: 'meal-003')),
      );
      await tester.pumpAndSettle();

      expect(find.text('소량만 먹었음'), findsOneWidget);
    });

    testWidgets('상태기록 있으면 증상 기록 섹션 표시', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealDetailScreen(mealId: 'meal-002')),
      );
      await tester.pumpAndSettle();

      // meal-002에는 stateRecords 2개
      expect(find.text('2개의 증상 기록'), findsOneWidget);
      expect(find.text('속쓰림'), findsOneWidget);
    });

    testWidgets('상태기록 0개면 증상 기록 섹션 미표시', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealDetailScreen(mealId: 'meal-001')),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('개의 증상 기록'), findsNothing);
    });
  });

  group('MealDetailScreen — 삭제 P6 다이얼로그', () {
    testWidgets('삭제 버튼 탭 → P6 다이얼로그 표시', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealDetailScreen(mealId: 'meal-001')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('기록 삭제하기'));
      await tester.pumpAndSettle();

      expect(find.text('이 기록을 삭제할까요?'), findsOneWidget);
      expect(find.text('삭제하기'), findsOneWidget);
      expect(find.text('취소하기'), findsOneWidget);
    });

    testWidgets('취소하기 탭 → 다이얼로그 닫힘, 화면 유지', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealDetailScreen(mealId: 'meal-001')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('기록 삭제하기'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('취소하기'));
      await tester.pumpAndSettle();

      expect(find.text('이 기록을 삭제할까요?'), findsNothing);
      expect(find.byType(MealDetailScreen), findsOneWidget);
    });

    testWidgets('삭제하기 탭 → delete() 호출됨', (tester) async {
      final repo = MockMealRepository.seeded();
      await tester.pumpWidget(
        _wrap(const MealDetailScreen(mealId: 'meal-001'), repo: repo),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('기록 삭제하기'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('삭제하기'));
      // pump만 사용 — showAppToast의 2.5s 타이머가 pumpAndSettle을 블록함
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 삭제 후 해당 mealId 조회 시 예외 — repository 레벨 확인
      expect(
        () => repo.detail('meal-001'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('MealDetailScreen — 수정 모드', () {
    testWidgets('수정하기 탭 → 편집 모드 진입 (TextField 표시)', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealDetailScreen(mealId: 'meal-003')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('수정하기'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      // 스티키 CTA 숨겨짐
      expect(find.text('기록 삭제하기'), findsNothing);
    });

    testWidgets('수정 후 dirty 상태에서 취소 → P7 다이얼로그 표시', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealDetailScreen(mealId: 'meal-001')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('수정하기'));
      await tester.pumpAndSettle();

      // 내용 입력 (dirty)
      await tester.enterText(find.byType(TextField), '새로운 메모');
      await tester.pumpAndSettle();

      // 취소 버튼
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      expect(find.text('저장하지 않고 나갈까요?'), findsOneWidget);
    });

    testWidgets('dirty 없이 취소 → P7 다이얼로그 미표시, 조회 모드 복귀', (tester) async {
      await tester.pumpWidget(
        _wrap(const MealDetailScreen(mealId: 'meal-001')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('수정하기'));
      await tester.pumpAndSettle();

      // 내용 변경 없이 취소
      await tester.tap(find.text('취소'));
      await tester.pumpAndSettle();

      expect(find.text('저장하지 않고 나갈까요?'), findsNothing);
      expect(find.byType(TextField), findsNothing);
    });
  });
}
