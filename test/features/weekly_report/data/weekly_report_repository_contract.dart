import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/repositories/weekly_report_repository.dart';

/// [WeeklyReportRepository] 계약 테스트 스위트.
///
/// Mock·실 구현 모두 이 계약을 통과해야 한다.
///
/// [seeded]: `true`면 현실적인 값(스트릭>0, 도넛 분포 양수)이 존재한다고
/// 가정한다. `false`면 빈 상태로 간주해 모든 카운트·퍼센트가 0임을 검증한다.
///
/// 사용법:
/// ```dart
/// weeklyReportRepositoryContract(MockWeeklyReportRepository.seeded, seeded: true);
/// ```
void weeklyReportRepositoryContract(
  WeeklyReportRepository Function() makeRepo, {
  required bool seeded,
}) {
  // -------------------------------------------------------------------------
  group('getWeeklyReport — 반환 형태', () {
    test('getWeeklyReport는 WeeklyReport를 반환한다', () async {
      final repo = makeRepo();
      final result = await repo.getWeeklyReport();
      expect(result, isA<WeeklyReport>());
    });

    test('getWeeklyReport는 Future를 반환한다 (await 가능)', () async {
      final repo = makeRepo();
      await expectLater(repo.getWeeklyReport(), completes);
    });

    test('startDate·endDate·weekLabel은 비어 있지 않다', () async {
      final repo = makeRepo();
      final result = await repo.getWeeklyReport();
      expect(result.startDate, isNotEmpty);
      expect(result.endDate, isNotEmpty);
      expect(result.weekLabel, isNotEmpty);
    });
  });

  // -------------------------------------------------------------------------
  group('필드 비음수 계약', () {
    test('comfortableState·mealCount의 모든 필드는 비음수다', () async {
      final repo = makeRepo();
      final result = await repo.getWeeklyReport();
      expect(result.comfortableState.streakCount, greaterThanOrEqualTo(0));
      expect(
        result.comfortableState.recommendedMealCount,
        greaterThanOrEqualTo(0),
      );
      expect(result.comfortableState.percentage, greaterThanOrEqualTo(0));
      expect(result.mealCount.recommendCount, greaterThanOrEqualTo(0));
      expect(result.mealCount.cautionCount, greaterThanOrEqualTo(0));
      expect(result.mealCount.riskCount, greaterThanOrEqualTo(0));
    });
  });

  if (seeded) {
    // -------------------------------------------------------------------------
    group('seeded — 값 존재 계약', () {
      test('comfortableState.streakCount는 0보다 크다', () async {
        final repo = makeRepo();
        final result = await repo.getWeeklyReport();
        expect(result.comfortableState.streakCount, greaterThan(0));
      });

      test('mealCount의 카운트 합은 0보다 크다', () async {
        final repo = makeRepo();
        final result = await repo.getWeeklyReport();
        final total = result.mealCount.recommendCount +
            result.mealCount.cautionCount +
            result.mealCount.riskCount;
        expect(total, greaterThan(0));
      });
    });
  } else {
    // -------------------------------------------------------------------------
    group('empty — 빈 상태 계약', () {
      test('comfortableState는 모두 0이다', () async {
        final repo = makeRepo();
        final result = await repo.getWeeklyReport();
        expect(result.comfortableState.streakCount, 0);
        expect(result.comfortableState.recommendedMealCount, 0);
        expect(result.comfortableState.percentage, 0);
      });

      test('mealCount는 모두 0이다', () async {
        final repo = makeRepo();
        final result = await repo.getWeeklyReport();
        expect(result.mealCount.recommendCount, 0);
        expect(result.mealCount.cautionCount, 0);
        expect(result.mealCount.riskCount, 0);
      });
    });
  }
}
