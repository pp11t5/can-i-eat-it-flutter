import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:can_i_eat_it/features/food_recognition/data/sources/food_image_preprocessor.dart';
import 'package:can_i_eat_it/features/food_recognition/domain/entities/food_recognition_result.dart';
import 'package:can_i_eat_it/features/food_recognition/domain/repositories/food_recognition_repository.dart';

/// 온디바이스 MobileNetV3 TFLite 구현. [Interpreter]·라벨은 외부에서 주입한다.
class OnDeviceFoodRecognitionRepository implements FoodRecognitionRepository {
  OnDeviceFoodRecognitionRepository({
    required Interpreter interpreter,
    required List<String> labels,
  })  : _interpreter = interpreter,
        _labels = labels;

  final Interpreter _interpreter;
  final List<String> _labels;

  /// 사진 1장을 추론해 Top-3 후보를 반환한다 (판정은 하지 않는다).
  @override
  Future<FoodRecognitionResult> recognize(Uint8List imageBytes) async {
    final input = FoodImagePreprocessor.preprocess(imageBytes);
    final output = [List<double>.filled(_labels.length, 0.0)];
    _interpreter.run(input, output);

    return FoodRecognitionResult(
      candidates: topCandidates(scores: output[0], labels: _labels),
      source: RecognitionSource.onDevice,
    );
  }

  /// 점수 내림차순 Top-[k]. 원점수를 그대로 쓰고(재정규화 없음) 인덱스를 라벨에 매핑한다.
  static List<FoodCandidate> topCandidates({
    required List<double> scores,
    required List<String> labels,
    int k = 3,
  }) {
    final rankedIndices = List<int>.generate(scores.length, (i) => i)
      ..sort((a, b) => scores[b].compareTo(scores[a]));

    return rankedIndices
        .take(k)
        .map((i) => FoodCandidate(label: labels[i], score: scores[i]))
        .toList();
  }
}
