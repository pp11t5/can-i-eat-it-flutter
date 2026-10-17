import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_recognition_result.freezed.dart';

/// 인식에 사용된 엔진. [onDevice]는 150클래스 TFLite, [gemini]는 백엔드 경유(개방형).
enum RecognitionSource { onDevice, gemini }

/// 인식 후보 1건.
@freezed
abstract class FoodCandidate with _$FoodCandidate {
  const factory FoodCandidate({
    /// 음식명. 기존 `food_check` 판정의 검색어로 쓴다.
    required String label,

    /// OnDevice는 softmax 원점수, Gemini는 null.
    double? score,
  }) = _FoodCandidate;
}

/// 음식 사진 인식 결과. 엔진 차이를 흡수한 공통 스키마라 호출부는 [source]를 몰라도 된다.
@freezed
abstract class FoodRecognitionResult with _$FoodRecognitionResult {
  const factory FoodRecognitionResult({
    /// 후보 0~3개.
    @Default(<FoodCandidate>[]) List<FoodCandidate> candidates,

    /// 결과를 만든 엔진.
    required RecognitionSource source,
  }) = _FoodRecognitionResult;
}
