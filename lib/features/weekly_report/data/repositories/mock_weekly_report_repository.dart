import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/repositories/weekly_report_repository.dart';

/// [WeeklyReportRepository] 인메모리 Mock 구현. UI 선개발·테스트용.
///
/// - [MockWeeklyReportRepository.seeded()]: 현실적인 값(스트릭>0, 도넛 분포 양수).
/// - [MockWeeklyReportRepository.empty()]: 전부 0.
class MockWeeklyReportRepository implements WeeklyReportRepository {
  MockWeeklyReportRepository({WeeklyReport? initial})
      : _report = initial ?? _emptyReport;

  /// 빈 상태.
  factory MockWeeklyReportRepository.empty() =>
      MockWeeklyReportRepository(initial: _emptyReport);

  /// 샘플 데이터.
  factory MockWeeklyReportRepository.seeded() =>
      MockWeeklyReportRepository(initial: _seededReport);

  final WeeklyReport _report;

  @override
  Future<WeeklyReport> getWeeklyReport() async => _report;
}

// ---------------------------------------------------------------------------
// 시드 데이터
// ---------------------------------------------------------------------------

const _emptyReport = WeeklyReport(
  startDate: '2026-06-29',
  endDate: '2026-07-05',
  weekLabel: '이번 주',
  comfortableState: ComfortableState(
    streakCount: 0,
    recommendedMealCount: 0,
    percentage: 0,
  ),
  mealCount: MealCount(
    recommendCount: 0,
    cautionCount: 0,
    riskCount: 0,
  ),
);

const _seededReport = WeeklyReport(
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
  ),
);
