import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_recognition_result.freezed.dart';

// ---------------------------------------------------------------------------
// RecognitionSource enum — 인식 엔진 판별자 (ADR-0009 §2-B2)
// ---------------------------------------------------------------------------

/// 음식 인식에 사용된 엔진.
///
/// - [onDevice]: 기기 내 MobileNetV3 TFLite 추론 (150클래스 닫힌 집합).
/// - [gemini]: 자체 백엔드 API 경유 Gemini 인식 (개방형 결과, 서버가 AI 소유 — ADR-0003 원칙).
enum RecognitionSource { onDevice, gemini }

// ---------------------------------------------------------------------------
// FoodCandidate — 인식 후보 단건
// ---------------------------------------------------------------------------

/// 음식 인식 후보 단건 (ADR-0009 §2-B2).
@freezed
abstract class FoodCandidate with _$FoodCandidate {
  const factory FoodCandidate({
    /// 음식명. 자유 문자열 — 150클래스 제약은 OnDevice 구현 내부 사정이며,
    /// 이 라벨은 검색어로 기존 `food_check`의 judgeByText/judgeById에 넘어간다.
    required String label,

    /// 신뢰도 점수.
    ///
    /// OnDevice: softmax 원점수(재정규화 없음, `top3_output.md` 그대로).
    /// Gemini: 항상 null — Gemini는 확률을 산출하지 않으므로 점수를 지어내지 않는다.
    double? score,
  }) = _FoodCandidate;
}

// ---------------------------------------------------------------------------
// FoodRecognitionResult — 인식 결과 (단일 최소공통 스키마)
// ---------------------------------------------------------------------------

/// 음식 사진 인식 결과 엔티티 (ADR-0009 §2-B2, 결정 B2).
///
/// OnDevice(150클래스 닫힌 집합)와 Gemini(개방형 결과)의 비대칭을 흡수하는
/// 단일 최소공통 스키마. UI·컨트롤러는 [source]를 몰라도 동작해야 한다.
@freezed
abstract class FoodRecognitionResult with _$FoodRecognitionResult {
  const factory FoodRecognitionResult({
    /// 인식 후보 목록. 0~3개 (Top-3, `top3_output.md`).
    @Default(<FoodCandidate>[]) List<FoodCandidate> candidates,

    /// 이 결과를 생성한 엔진.
    required RecognitionSource source,
  }) = _FoodRecognitionResult;
}
