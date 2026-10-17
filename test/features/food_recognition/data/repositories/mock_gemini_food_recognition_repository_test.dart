import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_recognition/data/repositories/mock_gemini_food_recognition_repository.dart';
import 'package:can_i_eat_it/features/food_recognition/domain/entities/food_recognition_result.dart';

void main() {
  test('항상 source=gemini, score=null인 1~3개 후보를 반환한다 (ADR-0009 §2-B2)', () async {
    const repository = MockGeminiFoodRecognitionRepository();

    final result = await repository.recognize(Uint8List(0));

    expect(result.source, RecognitionSource.gemini);
    expect(result.candidates, isNotEmpty);
    expect(result.candidates.length, lessThanOrEqualTo(3));
    for (final candidate in result.candidates) {
      expect(candidate.score, isNull);
      expect(candidate.label, isNotEmpty);
    }
  });
}
