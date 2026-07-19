import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';

/// 식사 기록 저장소 인터페이스 (신 서버 계약: /meal-records + /timeline).
///
/// - 도메인 레이어 — 프레임워크 비종속.
/// - 실 구현: [MealRepositoryImpl], 테스트·오프라인: [MockMealRepository].
abstract interface class MealRepository {
  /// [date] 날짜의 타임라인 항목 목록을 반환한다.
  ///
  /// 대응 API: GET /timeline?date=YYYY-MM-DD (result.items[]).
  Future<List<TimelineItem>> timeline(DateTime date);

  /// [month] 가 속한 월의 판정 집계 목록을 반환한다.
  ///
  /// 대응 API: GET /timeline/monthly?month=YYYY-MM (result[]).
  /// [month]: 표시월 DateTime(year, month, 1) — day 값은 무시하고 연/월만 사용.
  /// (구 `weekly(DateTime date)` 대체 — B1 월 캘린더 재설계.)
  Future<List<MonthlyDay>> getMonthly(DateTime month);

  /// 음식 ID로 음식을 추가한다 (by-id).
  ///
  /// 대응 API: [mealRecordId] null → POST /meal-records/foods/{foodExternalId}(신규) /
  /// != null → POST /meal-records/{mealRecordId}/foods/{foodExternalId}(기존 식사 append).
  /// [foodExternalId]: 필수. 서버측 음식 식별자.
  /// [eatenAt]: 섭취 시각. null 이면 서버가 현재 시각 사용.
  /// [mealRecordId]: null → 신규 식사 / != null → 기존 식사에 append.
  /// 반환: 추가된 음식 단건(analysis 포함).
  Future<MealFood> appendFood({
    required String foodExternalId,
    DateTime? eatenAt,
    String? mealRecordId,
  });

  /// 자유 텍스트 음식명으로 음식을 추가한다 (by-text).
  ///
  /// 대응 API: [mealRecordId] null → POST /meal-records(신규) /
  /// != null → POST /meal-records/{mealRecordId}/foods(기존 식사 append).
  /// [foodTextInput]: 필수. 자유 입력 음식명 — 구현체가 trim 후 ≤100자로 클램프한다.
  /// [eatenAt]: 섭취 시각. null 이면 서버가 현재 시각 사용.
  /// [mealRecordId]: null → 신규 식사 / != null → 기존 식사에 append.
  /// 반환: 추가된 음식 단건(analysis 포함).
  Future<MealFood> appendFoodByText({
    required String foodTextInput,
    DateTime? eatenAt,
    String? mealRecordId,
  });

  /// 식사 상세를 조회한다.
  ///
  /// 대응 API: GET /meal-records/{mealRecordId}.
  Future<MealRecord> mealDetail(String mealRecordId);

  /// 음식 상세를 조회한다 (analysis 포함).
  ///
  /// 대응 API: GET /meal-records/foods/{mealFoodId}.
  Future<MealFood> foodDetail(String mealFoodId);

  /// 식사를 삭제한다.
  ///
  /// 대응 API: DELETE /meal-records/{mealRecordId}.
  Future<void> deleteMeal(String mealRecordId);

  /// 음식을 삭제한다 (마지막 음식이면 서버가 식사도 함께 삭제).
  ///
  /// 대응 API: DELETE /meal-records/foods/{mealFoodId}.
  Future<void> deleteFood(String mealFoodId);

  /// 증상 연결 후보 목록을 조회한다 (증상레이어 공유, W5-1은 인터페이스만).
  ///
  /// 대응 API: GET /meal-records/candidates (result[]).
  Future<List<MealCandidatesDay>> candidates();
}
