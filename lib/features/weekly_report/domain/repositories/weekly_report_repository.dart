import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';

/// 주간 리포트(마이페이지) 저장소 인터페이스 — read 전용.
///
/// - 도메인 레이어 — 프레임워크 비종속.
/// - 실 구현: [WeeklyReportRepositoryImpl], 테스트·오프라인: [MockWeeklyReportRepository].
/// - 증상 시간대·트리거 후보는 백엔드 변경 예정으로 이 인터페이스에는 아직
///   포함하지 않는다 (seam: 필요 시 별도 메서드로 추가).
abstract interface class WeeklyReportRepository {
  /// 이번 주 리포트(도넛 분포 + 연속편안)를 조회한다.
  ///
  /// 대응 API: GET /my-page/reports.
  Future<WeeklyReport> getWeeklyReport();
}
