import 'dart:typed_data';

import '../entities/food_recognition_result.dart';

/// 음식 사진 인식 저장소. 엔진(OnDevice/Gemini)별 구현체를 provider가 골라 쓴다.
/// 신호등 판정은 하지 않는다 — 후보 라벨을 `food_check` 판정에 넘긴다 (ADR-0009).
abstract interface class FoodRecognitionRepository {
  /// 사진 1장([imageBytes])으로 음식 후보를 인식한다.
  Future<FoodRecognitionResult> recognize(Uint8List imageBytes);
}
