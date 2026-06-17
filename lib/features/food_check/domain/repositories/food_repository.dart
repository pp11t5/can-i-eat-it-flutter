import '../entities/eat_verdict.dart';
import '../entities/food_summary.dart';
import '../entities/recent_food.dart';

/// 최대 보관 최근검색 항목 개수.
const int kRecentFoodMaxCount = 10;

/// 음식 저장소 인터페이스 (ADR-0007 §3-1 (C)).
///
/// search·recent·judgment 를 단일 저장소로 통합한다.
///
/// 실 구현(dio datasource)은 이 인터페이스를 구현해 Riverpod override로 교체한다.
/// 인터페이스는 불변 — datasource 교체 시 이 파일은 수정하지 않는다.
abstract interface class FoodRepository {
  // ---------------------------------------------------------------------------
  // 판정 (W3-3 — 서버 judgment 2엔드포인트 충실 정합)
  // ---------------------------------------------------------------------------

  /// 자유 텍스트 음식명을 판정한다 (substitutes 없음, category 없음).
  ///
  /// 대응 API: GET /foods/judgment?foodTextInput=<text>
  /// 직접 분석 진입(매칭 없음·raw text) 경로에서 사용.
  Future<EatVerdict> judgeByText(String foodTextInput);

  /// 등록 음식(externalId)을 판정한다 (substitutes·category 포함).
  ///
  /// 대응 API: GET /foods/{foodExternalId}/judgment
  /// 검색 결과 셀 탭 경로에서 사용.
  Future<EatVerdict> judgeById(String foodExternalId);

  // ---------------------------------------------------------------------------
  // 검색
  // ---------------------------------------------------------------------------

  /// 검색어 [q] 로 음식 목록을 조회한다.
  ///
  /// [size]: 최대 반환 개수 (기본값 20).
  /// 대응 API: GET /foods/search?q=[q]&size=[size]
  Future<List<FoodSummary>> search(String q, {int size = 20});

  // ---------------------------------------------------------------------------
  // 최근 검색
  // ---------------------------------------------------------------------------

  /// 최근 검색 목록을 최신순으로 반환한다.
  ///
  /// [size]: 최대 반환 개수 (기본값 [kRecentFoodMaxCount]).
  /// 대응 API: GET /foods/recent?size=[size]
  Future<List<RecentFood>> recentSearches({int size = kRecentFoodMaxCount});

  /// 최근 검색 항목을 추가한다.
  ///
  /// [foodExternalId]: 서버측 음식 식별자.
  /// 대응 API: POST /foods/recent { "foodExternalId": [foodExternalId] }
  Future<void> addRecent(String foodExternalId);

  /// 특정 최근 검색 항목을 제거한다. 존재하지 않으면 무시한다.
  ///
  /// 대응 API: DELETE /foods/recent/{foodExternalId}
  Future<void> removeRecent(String foodExternalId);

  /// 모든 최근 검색 항목을 삭제한다.
  ///
  /// 대응 API: DELETE /foods/recent
  Future<void> clearRecent();
}
