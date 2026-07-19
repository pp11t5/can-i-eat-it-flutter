import 'package:can_i_eat_it/features/mypage/domain/entities/my_page_summary.dart';
import 'package:can_i_eat_it/features/mypage/domain/repositories/my_page_repository.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';

/// [MyPageRepository] 인메모리 Mock 구현. UI 선개발·테스트용.
///
/// - [MockMyPageRepository.seeded()]: 현실적인 값(닉네임·카운트 양수).
/// - [MockMyPageRepository.empty()]: 전부 0/빈 문자열.
class MockMyPageRepository implements MyPageRepository {
  MockMyPageRepository({MyPageSummary? initial})
      : _summary = initial ?? _emptySummary;

  /// 빈 상태.
  factory MockMyPageRepository.empty() =>
      MockMyPageRepository(initial: _emptySummary);

  /// 샘플 데이터.
  factory MockMyPageRepository.seeded() =>
      MockMyPageRepository(initial: _seededSummary);

  MyPageSummary _summary;

  @override
  Future<MyPageSummary> getSummary() async => _summary;

  /// 로컬 in-memory 닉네임 갱신(항상 성공) — UI 선개발·테스트용.
  @override
  Future<void> updateNickname(String nickname) async {
    _summary = _summary.copyWith(
      profile: _summary.profile.copyWith(nickName: nickname),
    );
  }
}

// ---------------------------------------------------------------------------
// 시드 데이터
// ---------------------------------------------------------------------------

const _emptySummary = MyPageSummary(
  profile: MyPageProfileSummary(nickName: '', disease: MyPageDisease.unknown),
  foodHistory: FoodHistorySummary(safeCount: 0, cautionCount: 0),
  weeklySummary: WeeklySummary(
    mealRecordCount: 0,
    recentSymptomCount: 0,
    streakCount: 0,
    mealCount: MealCount(
      recommendCount: 0,
      cautionCount: 0,
      riskCount: 0,
      unknownCount: 0,
    ),
  ),
);

const _seededSummary = MyPageSummary(
  profile: MyPageProfileSummary(
    nickName: '홍길동',
    disease: MyPageDisease.gerd,
  ),
  foodHistory: FoodHistorySummary(safeCount: 12, cautionCount: 4),
  weeklySummary: WeeklySummary(
    mealRecordCount: 9,
    recentSymptomCount: 2,
    streakCount: 4,
    mealCount: MealCount(
      recommendCount: 9,
      cautionCount: 3,
      riskCount: 1,
      unknownCount: 0,
    ),
  ),
);
