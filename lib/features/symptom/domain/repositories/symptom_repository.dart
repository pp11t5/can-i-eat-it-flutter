import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';

/// 증상 기록 저장소 인터페이스 (/symptoms 서버 계약 확정).
///
/// - 도메인 레이어 — 프레임워크 비종속.
/// - 실 구현: [SymptomRepositoryImpl], 테스트·오프라인: [MockSymptomRepository].
/// - GET 리스트 엔드포인트 없음 (서버 계약 확정값).
abstract interface class SymptomRepository {
  /// 증상을 생성한다.
  ///
  /// 대응 API: POST /symptoms.
  /// [draft.occurredAt] null 이면 서버가 현재 시각 사용.
  /// 반환: 생성된 증상 단건.
  Future<Symptom> create(SymptomDraft draft);

  /// 증상 단건을 조회한다.
  ///
  /// 대응 API: GET /symptoms/{symptomId}.
  Future<Symptom> detail(String symptomId);

  /// 증상을 수정한다.
  ///
  /// 대응 API: PUT /symptoms/{symptomId}.
  /// [draft.occurredAt] 은 update 시 필수 (서버 계약) — 호출자가 보장한다.
  Future<void> update(String symptomId, SymptomDraft draft);

  /// 증상 메모만 수정한다.
  ///
  /// 대응 API: PATCH /symptoms/{symptomId}/memo.
  /// [memo] null 이면 서버에 null 값 전송 (메모 초기화).
  Future<void> updateMemo(String symptomId, String? memo);

  /// 증상을 삭제한다.
  ///
  /// 대응 API: DELETE /symptoms/{symptomId}.
  Future<void> delete(String symptomId);
}
