import 'package:can_i_eat_it/features/food_check/domain/entities/food_symptom.dart';

/// 음식별 증상 이력 저장소 인터페이스 — read 전용 (W7 minor EP, UI 배선 defer).
///
/// - 도메인 레이어 — 프레임워크 비종속.
/// - 실 구현: [FoodSymptomRepositoryImpl], 테스트·오프라인: [MockFoodSymptomRepository].
abstract interface class FoodSymptomRepository {
  /// [foodExternalId] 음식에 연결된 과거 증상 이력을 조회한다.
  ///
  /// 대응 API: GET /foods/{foodExternalId}/symptoms (result[]).
  Future<List<FoodSymptom>> getSymptoms(String foodExternalId);
}
