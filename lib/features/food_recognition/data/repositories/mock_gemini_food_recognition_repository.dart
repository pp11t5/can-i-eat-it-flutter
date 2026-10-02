import 'dart:typed_data';

import 'package:can_i_eat_it/features/food_recognition/domain/entities/food_recognition_result.dart';
import 'package:can_i_eat_it/features/food_recognition/domain/repositories/food_recognition_repository.dart';

/// Gemini 경로의 임시 Mock. 백엔드 계약 확정 시 `dio` 기반 구현으로 교체한다.
/// Gemini는 확률을 주지 않으므로 [FoodCandidate.score]는 항상 null이다.
class MockGeminiFoodRecognitionRepository implements FoodRecognitionRepository {
  const MockGeminiFoodRecognitionRepository();

  @override
  Future<FoodRecognitionResult> recognize(Uint8List imageBytes) async {
    return const FoodRecognitionResult(
      candidates: [
        FoodCandidate(label: '김치찌개'),
        FoodCandidate(label: '된장찌개'),
        FoodCandidate(label: '순두부찌개'),
      ],
      source: RecognitionSource.gemini,
    );
  }
}
