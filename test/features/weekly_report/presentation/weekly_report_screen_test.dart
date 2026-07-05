import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/weekly_report/data/repositories/mock_weekly_report_repository.dart';
import 'package:can_i_eat_it/features/weekly_report/data/weekly_report_providers.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/repositories/weekly_report_repository.dart';
import 'package:can_i_eat_it/features/weekly_report/presentation/screens/weekly_report_screen.dart';

// ---------------------------------------------------------------------------
// 지연 응답 fake — AsyncLoading 프레임을 붙잡아 확인하는 용도.
// ---------------------------------------------------------------------------

class _DelayedWeeklyReportRepository implements WeeklyReportRepository {
  _DelayedWeeklyReportRepository(this._delegate, {required this.delay});

  final WeeklyReportRepository _delegate;
  final Duration delay;

  @override
  Future<WeeklyReport> getWeeklyReport() async {
    await Future.delayed(delay);
    return _delegate.getWeeklyReport();
  }
}

// ---------------------------------------------------------------------------
// 고정 응답 fake — unknownCount(도넛 4분할) 렌더 검증용.
// ---------------------------------------------------------------------------

class _FixedWeeklyReportRepository implements WeeklyReportRepository {
  _FixedWeeklyReportRepository(this._report);

  final WeeklyReport _report;

  @override
  Future<WeeklyReport> getWeeklyReport() async => _report;
}

const _kReportWithUnknown = WeeklyReport(
  startDate: '2026-06-29',
  endDate: '2026-07-05',
  weekLabel: '이번 주',
  comfortableState: ComfortableState(
    streakCount: 4,
    recommendedMealCount: 12,
    percentage: 68.5,
  ),
  mealCount: MealCount(
    recommendCount: 12,
    cautionCount: 5,
    riskCount: 1,
    unknownCount: 2,
  ),
);

Widget _wrap(WeeklyReportRepository repo) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      weeklyReportRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const WeeklyReportScreen(),
    ),
  );
}

void main() {
  group('WeeklyReportScreen — 타이틀·기간·카드1(속 편한 음식 현황)', () {
    testWidgets('앱바 타이틀 "주간 리포트"와 report.weekLabel을 렌더한다', (tester) async {
      await tester.pumpWidget(_wrap(MockWeeklyReportRepository.seeded()));
      await tester.pumpAndSettle();

      expect(find.text('주간 리포트'), findsOneWidget);
      expect(find.text('이번 주'), findsOneWidget); // seeded().weekLabel
    });

    testWidgets(
        '카드1 제목 "속 편한 음식을 먹은 현황이에요" + 연속 일수/권장 음식/전체 비율 값을 렌더한다',
        (tester) async {
      await tester.pumpWidget(_wrap(MockWeeklyReportRepository.seeded()));
      await tester.pumpAndSettle();

      // seeded(): streakCount 4, recommendedMealCount 12, percentage 68.5.
      expect(find.text('속 편한 음식을 먹은 현황이에요'), findsOneWidget);
      expect(find.text('4일'), findsOneWidget);
      expect(find.text('12끼'), findsOneWidget);
      expect(find.text('68.5%'), findsOneWidget);
    });
  });

  group('WeeklyReportScreen — 카드2(내 식단 분포, 도넛)', () {
    testWidgets(
        '카드2 제목 "내 식단 분포" + PieChart + 범례(권장/주의/위험 N끼) + 중앙 총끼수를 렌더한다',
        (tester) async {
      await tester.pumpWidget(_wrap(MockWeeklyReportRepository.seeded()));
      await tester.pumpAndSettle();

      // seeded(): mealCount recommend 12 / caution 5 / risk 1 → total 18.
      expect(find.text('내 식단 분포'), findsOneWidget);
      expect(find.byType(PieChart), findsOneWidget);
      expect(find.text('권장음식 12끼'), findsOneWidget);
      expect(find.text('주의 음식 5끼'), findsOneWidget);
      expect(find.text('위험 음식 1끼'), findsOneWidget);
      expect(find.text('18끼'), findsOneWidget); // 도넛 중앙 총끼수
    });

    testWidgets('시간별 평균 증상기록 카드는 아직 렌더되지 않는다', (tester) async {
      await tester.pumpWidget(_wrap(MockWeeklyReportRepository.seeded()));
      await tester.pumpAndSettle();

      expect(find.textContaining('시간별 평균 증상기록'), findsNothing);
    });
  });

  group('WeeklyReportScreen — 카드2 unknownCount 4분할 (W7)', () {
    testWidgets('unknownCount>0이면 "확인 어려움 N끼" 범례 + 총끼수에 포함된다',
        (tester) async {
      await tester.pumpWidget(
        _wrap(_FixedWeeklyReportRepository(_kReportWithUnknown)),
      );
      await tester.pumpAndSettle();

      // unknownCount 2 + recommend 12 + caution 5 + risk 1 → total 20.
      expect(find.text('확인 어려움 2끼'), findsOneWidget);
      expect(find.text('20끼'), findsOneWidget);
    });

    testWidgets('unknownCount가 0이면 "확인 어려움 0끼" 범례를 표시한다', (tester) async {
      await tester.pumpWidget(_wrap(MockWeeklyReportRepository.seeded()));
      await tester.pumpAndSettle();

      expect(find.text('확인 어려움 0끼'), findsOneWidget);
    });
  });

  group('WeeklyReportScreen — 빈 상태', () {
    testWidgets('empty 저장소(total 0) → "기록이 없어요" 렌더 + PieChart 미존재',
        (tester) async {
      await tester.pumpWidget(_wrap(MockWeeklyReportRepository.empty()));
      await tester.pumpAndSettle();

      expect(find.text('기록이 없어요'), findsOneWidget);
      expect(find.byType(PieChart), findsNothing);
    });
  });

  group('WeeklyReportScreen — 로딩 상태', () {
    testWidgets('응답이 지연되면 첫 프레임에서 CircularProgressIndicator를 표시한다',
        (tester) async {
      final repo = _DelayedWeeklyReportRepository(
        MockWeeklyReportRepository.seeded(),
        delay: const Duration(milliseconds: 500),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pump(); // Future.delayed 미해결 — 로딩 프레임만 확인.

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle(); // 남은 타이머 정리(테스트 종료 후 pending timer 방지).
    });
  });

  group('WeeklyReportScreen — 다운로드 버튼', () {
    testWidgets('로딩 상태에서는 다운로드 버튼이 비활성화된다', (tester) async {
      final repo = _DelayedWeeklyReportRepository(
        MockWeeklyReportRepository.seeded(),
        delay: const Duration(milliseconds: 500),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pump();

      final button = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.file_download_outlined),
          matching: find.byType(IconButton),
        ),
      );
      expect(button.onPressed, isNull);

      await tester.pumpAndSettle(); // 남은 타이머 정리.
    });

    testWidgets('데이터 로드 상태에서는 다운로드 버튼이 활성화된다', (tester) async {
      await tester.pumpWidget(_wrap(MockWeeklyReportRepository.seeded()));
      await tester.pumpAndSettle();

      final button = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.file_download_outlined),
          matching: find.byType(IconButton),
        ),
      );
      expect(button.onPressed, isNotNull);
    });
  });
}
