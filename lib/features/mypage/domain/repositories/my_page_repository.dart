import 'package:can_i_eat_it/features/mypage/domain/entities/my_page_summary.dart';

/// 마이페이지 요약 저장소 인터페이스 — read 전용.
///
/// - 도메인 레이어 — 프레임워크 비종속.
/// - 실 구현: [MyPageRepositoryImpl], 테스트·오프라인: [MockMyPageRepository].
abstract interface class MyPageRepository {
  /// 마이페이지 요약(프로필·음식 히스토리·주간 기록)을 조회한다.
  ///
  /// 대응 API: GET /my-page/summary.
  Future<MyPageSummary> getSummary();

  /// 닉네임을 변경한다.
  ///
  /// 대응 API: PATCH /my-page/nickname (바디 `{nickname}`, maxLength 12, minLength 1).
  /// 실패 시 [Failure]를 throw한다 — 409(중복)는 [DuplicateNicknameFailure].
  Future<void> updateNickname(String nickname);
}
