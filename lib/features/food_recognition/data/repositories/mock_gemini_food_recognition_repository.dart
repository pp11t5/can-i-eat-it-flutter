import 'dart:typed_data';

import 'package:can_i_eat_it/features/food_recognition/domain/entities/food_recognition_result.dart';
import 'package:can_i_eat_it/features/food_recognition/domain/repositories/food_recognition_repository.dart';

/// [FoodRecognitionRepository] Gemini 경로의 임시 Mock 구현 (ADR-0009 §6, 구현 순서 5).
///
/// 백엔드 `/foods/recognize`류 엔드포인트의 요청/응답 계약이 나오기 전까지만 쓰는
/// 임시 구현이다. 계약이 확정되면 이 파일은 `dio` 기반 실 구현으로 **교체**된다 —
/// [FoodRecognitionRepository] 인터페이스는 그대로 유지(ADR-0009 결정 C2).
///
/// 항상 [RecognitionSource.gemini]를 반환하고, [FoodCandidate.score]는 항상
/// `null`이다 — Gemini는 확률을 산출하지 않으므로 점수를 지어내지 않는다
/// (ADR-0009 §2-B2).
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
