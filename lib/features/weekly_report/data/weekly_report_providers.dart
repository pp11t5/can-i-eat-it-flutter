import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/weekly_report/data/repositories/weekly_report_repository_impl.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/repositories/weekly_report_repository.dart';

part 'weekly_report_providers.g.dart';

// ---------------------------------------------------------------------------
// WeeklyReportRepository 공급자
// ---------------------------------------------------------------------------

/// [WeeklyReportRepository] 공급자.
///
/// 기본값: [WeeklyReportRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [weeklyReportRepositoryProvider.overrideWithValue(MockWeeklyReportRepository.seeded())]
@riverpod
WeeklyReportRepository weeklyReportRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return WeeklyReportRepositoryImpl(dio: dio);
}

// ---------------------------------------------------------------------------
// WeeklyReport 조회 (W6-6 주간 리포트 화면)
// ---------------------------------------------------------------------------

/// 이번 주 리포트를 조회한다. [WeeklyReportScreen]이 구독.
@riverpod
Future<WeeklyReport> weeklyReport(Ref ref) =>
    ref.watch(weeklyReportRepositoryProvider).getWeeklyReport();
