import 'package:can_i_eat_it/features/food_dictionary/domain/entities/dictionary_food.dart';

/// 음식 도감(내 도감) 저장소 인터페이스 — read 전용.
///
/// - 도메인 레이어 — 프레임워크 비종속.
/// - 실 구현: [DictionaryRepositoryImpl], 테스트·오프라인: [MockDictionaryRepository].
/// - 저장/삭제는 이 인터페이스의 책임이 아니다 — 기존
///   `FoodRepository.addRecent`/`removeRecent` 를 재사용한다.
abstract interface class DictionaryRepository {
  /// 권장(안전) 음식 페이지를 조회한다. 전부 verdict=recommend.
  ///
  /// 대응 API: GET /dictionary/safe?cursor&size.
  Future<DictionaryPage> getSafe({int? cursor, int size = 20});

  /// 주의·위험 음식 페이지를 조회한다. verdict는 서버 type 매핑.
  ///
  /// 대응 API: GET /dictionary/caution-risk?cursor&size.
  Future<DictionaryPage> getCautionRisk({int? cursor, int size = 20});

  /// 도감 탭 카운트를 조회한다.
  ///
  /// 대응 API: GET /dictionary/count.
  Future<DictionaryCount> getCount();
}
