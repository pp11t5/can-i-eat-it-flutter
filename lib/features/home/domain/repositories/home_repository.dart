import 'package:can_i_eat_it/features/home/domain/entities/recent_meal.dart';

/// 홈 화면 저장소 인터페이스 — read 전용 (W7 minor EP).
///
/// - 도메인 레이어 — 프레임워크 비종속.
/// - 실 구현: [HomeRepositoryImpl], 테스트·오프라인: [MockHomeRepository].
abstract interface class HomeRepository {
  /// 미기록 식단 개수를 조회한다.
  ///
  /// 대응 API: GET /meal-records/unrecorded-count (result.count).
  Future<int> unrecordedMealCount();

  /// 최근 식사 목록을 조회한다.
  ///
  /// 대응 API: GET /meal-records/recent-foods (result[]).
  Future<List<RecentMeal>> recentFoods();
}
