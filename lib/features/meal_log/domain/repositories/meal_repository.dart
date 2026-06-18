import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';

/// 식사 기록 저장소 인터페이스.
///
/// - 도메인 레이어 — 프레임워크 비종속.
/// - 서버 grade 문자열 대신 도메인 [VerdictLevel] 을 받는다.
/// - 실 구현: [MealRepositoryImpl], 테스트·오프라인: [MockMealRepository].
abstract interface class MealRepository {
  // ---------------------------------------------------------------------------
  // 타임라인 조회
  // ---------------------------------------------------------------------------

  /// [date] 날짜의 끼니 그룹 목록을 최신순으로 반환한다.
  ///
  /// 대응 API: GET /meals?date=YYYY-MM-DD
  Future<List<MealGroup>> timeline(DateTime date);

  // ---------------------------------------------------------------------------
  // 식사 기록 생성
  // ---------------------------------------------------------------------------

  /// 음식 ID로 식사 기록을 생성한다 (1식사=1음식).
  ///
  /// 대응 API: POST /meals
  /// [foodExternalId]: 필수. 서버측 음식 식별자.
  /// [eatenAt]: 섭취 시각. null 이면 서버가 현재 시각 사용.
  /// [mealGroupId]: 기존 끼니 그룹에 추가할 때 지정. null 이면 신규 그룹.
  /// [grade]: 판정 등급. null 이면 미판정.
  Future<MealRecord> create({
    required String foodExternalId,
    DateTime? eatenAt,
    String? mealGroupId,
    VerdictLevel? grade,
  });

  /// 자유 텍스트 음식명으로 식사 기록을 생성한다.
  ///
  /// 대응 API: POST /meals/text
  /// [foodTextInput]: 필수. 사용자 입력 음식명.
  Future<MealRecord> createByText({
    required String foodTextInput,
    DateTime? eatenAt,
    String? mealGroupId,
    VerdictLevel? grade,
  });

  // ---------------------------------------------------------------------------
  // 식사 기록 상세
  // ---------------------------------------------------------------------------

  /// 식사 기록 상세를 조회한다.
  ///
  /// 대응 API: GET /meals/{mealId}
  Future<MealDetail> detail(String mealId);

  // ---------------------------------------------------------------------------
  // 메모 수정
  // ---------------------------------------------------------------------------

  /// 식사 기록 메모를 수정한다.
  ///
  /// [memo]: null 또는 빈 문자열이면 메모를 삭제한다 (서버 계약: 0~200자).
  /// 대응 API: PATCH /meals/{mealId}
  Future<MealDetail> updateMemo(String mealId, String? memo);

  // ---------------------------------------------------------------------------
  // 삭제
  // ---------------------------------------------------------------------------

  /// 식사 기록을 삭제한다.
  ///
  /// 대응 API: DELETE /meals/{mealId}
  Future<void> delete(String mealId);
}
