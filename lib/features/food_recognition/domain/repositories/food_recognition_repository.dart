import 'dart:typed_data';

import '../entities/food_recognition_result.dart';

/// 음식 사진 인식 저장소 인터페이스 (ADR-0009 §2-B2, 결정 D4).
///
/// 엔진(OnDevice/Gemini)별 구현체가 이 인터페이스를 구현하고, Riverpod provider가
/// 런타임에 엔진을 골라 교체한다. 신호등 판정(recommend/caution/risk/unknown)은
/// 이 저장소의 책임이 아니다 — 인식된 [FoodCandidate.label]은 기존
/// `food_check`의 judgeByText/judgeById로 넘겨 판정한다.
///
/// 인터페이스는 불변 — 구현체 교체 시 이 파일은 수정하지 않는다.
abstract interface class FoodRecognitionRepository {
  /// 사진 1장([imageBytes])으로 음식 후보를 인식한다.
  ///
  /// OnDevice: 기기 내 TFLite 추론. Gemini: 자체 백엔드 `/foods/recognize`류
  /// API 경유(백엔드 계약 전까지는 Mock 구현체가 대신한다).
  Future<FoodRecognitionResult> recognize(Uint8List imageBytes);
}
