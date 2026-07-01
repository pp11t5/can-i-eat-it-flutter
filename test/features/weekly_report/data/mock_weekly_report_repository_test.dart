import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/weekly_report/data/repositories/mock_weekly_report_repository.dart';

import 'weekly_report_repository_contract.dart';

void main() {
  // -------------------------------------------------------------------------
  group('MockWeeklyReportRepository.seeded — 저장소 계약', () {
    weeklyReportRepositoryContract(
      MockWeeklyReportRepository.seeded,
      seeded: true,
    );
  });

  // -------------------------------------------------------------------------
  group('MockWeeklyReportRepository.empty — 저장소 계약', () {
    weeklyReportRepositoryContract(
      MockWeeklyReportRepository.empty,
      seeded: false,
    );
  });
}
