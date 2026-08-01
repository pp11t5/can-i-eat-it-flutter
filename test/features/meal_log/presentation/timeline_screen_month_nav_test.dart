import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/timeline_screen.dart';

/// 타임라인 화면의 월 이동(선택일 규칙, 가입월 이전 이동 금지) 테스트.
///
/// 고정 오늘: 2026-06-17 (수).

final _fixedToday = DateTime(2026, 6, 17);

Finder _iconWithLabel(String label) => find.byWidgetPredicate(
      (w) => w is AppIcon && w.semanticsLabel == label,
    );

Widget _wrapWithMock(
  Widget child, {
  DateTime? joinDate,
}) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(
        MockMealRepository.seeded(),
      ),
      // ignore: scoped_providers_should_specify_dependencies
      authControllerProvider.overrideWith(() => _FakeAuth(joinDate)),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

class _FakeAuth extends AuthController {
  _FakeAuth(this._joinDate);
  final DateTime? _joinDate;

  @override
  Future<AuthSession?> build() async {
    if (_joinDate == null) return null;
    return AuthSession(
      userId: 'u1',
      provider: AuthProvider.kakao,
      hasAgreedTerms: true,
      createdAt: _joinDate,
    );
  }
}

/// 현재 선택 캡슐(검정 배경) 안의 날짜 숫자 텍스트를 찾는다.
String _selectedDayNumber(WidgetTester tester) {
  final capsule = find
      .byWidgetPredicate((w) {
        if (w is! Container) return false;
        final deco = w.decoration;
        return deco is BoxDecoration &&
            deco.color == const Color(0xFF222222) &&
            deco.borderRadius != null;
      })
      .first;
  final numberText = find
      .descendant(of: capsule, matching: find.byType(Text))
      .evaluate()
      .map((e) => (e.widget as Text).data)
      .whereType<String>()
      .firstWhere((s) => int.tryParse(s) != null);
  return numberText;
}

void main() {
  group('TimelineScreen — 월 이동 선택일 규칙', () {
    testWidgets('이전 달(오늘 없는 달) 이동 시 선택일 = 1일', (tester) async {
      // today 6/17 → 5월에는 오늘 없음 → 1일
      await tester.pumpWidget(
        _wrapWithMock(TimelineScreen(todayOverride: _fixedToday)),
      );
      await tester.pumpAndSettle();

      await tester.tap(_iconWithLabel('이전 달'));
      await tester.pumpAndSettle();

      expect(find.text('2026년 5월'), findsOneWidget);
      expect(_selectedDayNumber(tester), equals('1'));
    });

    testWidgets('다음 달(오늘 없는 달) 이동 시 선택일 = 1일', (tester) async {
      // today 6/17 → 7월에는 오늘 없음 → 1일
      await tester.pumpWidget(
        _wrapWithMock(TimelineScreen(todayOverride: _fixedToday)),
      );
      await tester.pumpAndSettle();

      await tester.tap(_iconWithLabel('다음 달'));
      await tester.pumpAndSettle();

      expect(find.text('2026년 7월'), findsOneWidget);
      expect(_selectedDayNumber(tester), equals('1'));
    });

    testWidgets('다음 달에 오늘이 있으면 선택일 = 오늘', (tester) async {
      // today 7/20, 시작 6월 → 다음 달 7월 → 20일
      final todayInJuly = DateTime(2026, 7, 20);
      await tester.pumpWidget(
        _wrapWithMock(TimelineScreen(todayOverride: todayInJuly)),
      );
      await tester.pumpAndSettle();

      // 진입 시 visibleMonth=7월(오늘 달). 이전→6월 후 다시 7월로 이동.
      await tester.tap(_iconWithLabel('이전 달'));
      await tester.pumpAndSettle();
      expect(find.text('2026년 6월'), findsOneWidget);

      await tester.tap(_iconWithLabel('다음 달'));
      await tester.pumpAndSettle();

      expect(find.text('2026년 7월'), findsOneWidget);
      expect(_selectedDayNumber(tester), equals('20'));
    });

    testWidgets('이전 달에 오늘이 있으면 선택일 = 오늘', (tester) async {
      // today 6/17, 7월에서 시작해 이전 달 6월 → 17일
      final todayInJune = DateTime(2026, 6, 17);
      await tester.pumpWidget(
        _wrapWithMock(TimelineScreen(todayOverride: todayInJune)),
      );
      await tester.pumpAndSettle();

      await tester.tap(_iconWithLabel('다음 달'));
      await tester.pumpAndSettle();
      expect(find.text('2026년 7월'), findsOneWidget);

      await tester.tap(_iconWithLabel('이전 달'));
      await tester.pumpAndSettle();

      expect(find.text('2026년 6월'), findsOneWidget);
      expect(_selectedDayNumber(tester), equals('17'));
    });
  });

  group('TimelineScreen — 가입월 이전 이동 금지', () {
    testWidgets('가입월이면 이전 달 버튼이 비활성·gray60이다', (tester) async {
      // 오늘 6/17, 가입 6/1 → 현재 월=가입월 → 이전 불가
      await tester.pumpWidget(
        _wrapWithMock(
          TimelineScreen(todayOverride: _fixedToday),
          joinDate: DateTime(2026, 6, 1),
        ),
      );
      await tester.pumpAndSettle();

      final prevIcon = tester.widget<AppIcon>(_iconWithLabel('이전 달'));
      expect(prevIcon.color, AppColors.controlDisabled);

      await tester.tap(_iconWithLabel('이전 달'));
      await tester.pumpAndSettle();
      // 월 이동 안 됨
      expect(find.text('2026년 6월'), findsOneWidget);
      expect(find.text('2026년 5월'), findsNothing);
    });

    testWidgets('가입월보다 이후 월에서는 이전 달로 이동 가능하다', (tester) async {
      // 가입 5/10, 오늘 6/17 → 6월에서 5월로 이동 가능
      await tester.pumpWidget(
        _wrapWithMock(
          TimelineScreen(todayOverride: _fixedToday),
          joinDate: DateTime(2026, 5, 10),
        ),
      );
      await tester.pumpAndSettle();

      final prevIcon = tester.widget<AppIcon>(_iconWithLabel('이전 달'));
      expect(prevIcon.color, AppColors.textPrimary);

      await tester.tap(_iconWithLabel('이전 달'));
      await tester.pumpAndSettle();
      expect(find.text('2026년 5월'), findsOneWidget);
    });
  });
}
