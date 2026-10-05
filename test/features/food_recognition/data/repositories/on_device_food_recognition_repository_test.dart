import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:can_i_eat_it/features/food_recognition/data/repositories/on_device_food_recognition_repository.dart';
import 'package:can_i_eat_it/features/food_recognition/domain/entities/food_recognition_result.dart';

// ---------------------------------------------------------------------------
// Fake Interpreter — 네이티브 TFLite 바인딩 없이 run()만 흉내낸다.
// (`Interpreter`는 tflite_flutter의 실 FFI 클래스라 mockito 코드 생성 없이
// 공개 인터페이스만 override. 이 테스트에서 쓰는 멤버는 run()뿐이다.)
// ---------------------------------------------------------------------------
class _FakeInterpreter implements Interpreter {
  _FakeInterpreter(this._scores);

  final List<double> _scores;
  Object? lastInput;

  @override
  void run(Object input, Object output) {
    lastInput = input;
    final row = (output as List)[0] as List;
    for (var i = 0; i < _scores.length; i++) {
      row[i] = _scores[i];
    }
  }

  @override
  int get lastNativeInferenceDurationMicroSeconds => 0;

  @override
  void close() {}

  @override
  void allocateTensors() {}

  @override
  void invoke() {}

  @override
  void runForMultipleInputs(List<Object> inputs, Map<int, Object> outputs) {}

  @override
  void runInference(List<Object> inputs) {}

  @override
  List<Tensor> getInputTensors() => throw UnimplementedError();

  @override
  List<Tensor> getOutputTensors() => throw UnimplementedError();

  @override
  void resizeInputTensor(int tensorIndex, List<int> shape) {}

  @override
  Tensor getInputTensor(int index) => throw UnimplementedError();

  @override
  Tensor getOutputTensor(int index) => throw UnimplementedError();

  @override
  int getInputIndex(String opName) => throw UnimplementedError();

  @override
  int getOutputIndex(String opName) => throw UnimplementedError();

  @override
  void resetVariableTensors() {}

  @override
  int get address => 0;

  @override
  bool get isAllocated => true;

  @override
  bool get isDeleted => false;
}

Uint8List _pngBytes({int width = 8, int height = 8}) {
  final image = img.Image(width: width, height: height);
  img.fill(image, color: img.ColorRgb8(10, 20, 30));
  return img.encodePng(image);
}

void main() {
  // ---------------------------------------------------------------------------
  group('topCandidates — Top-3, 재정규화 없이 원점수 유지 (top3_output.md)', () {
    test('점수 내림차순 Top-3, 인덱스→라벨 매핑', () {
      final labels = ['가지볶음', '간장게장', '갈비구이', '갈비찜', '갈비탕'];
      final scores = [0.1, 0.62, 0.05, 0.21, 0.02];

      final candidates = OnDeviceFoodRecognitionRepository.topCandidates(
        scores: scores,
        labels: labels,
      );

      expect(candidates.length, 3);
      expect(candidates[0].label, '간장게장');
      expect(candidates[0].score, 0.62);
      expect(candidates[1].label, '갈비찜');
      expect(candidates[1].score, 0.21);
      expect(candidates[2].label, '가지볶음');
      expect(candidates[2].score, 0.1);
    });

    test('추가 softmax·재정규화 없음 — 원점수 합이 1이 아니어도 그대로', () {
      final labels = ['a', 'b', 'c'];
      final scores = [0.9, 0.9, 0.9]; // 합이 1을 훌쩍 넘는 원점수

      final candidates = OnDeviceFoodRecognitionRepository.topCandidates(
        scores: scores,
        labels: labels,
      );

      expect(candidates.every((c) => c.score == 0.9), isTrue);
    });

    test('k보다 적은 클래스는 있는 만큼만 반환', () {
      final candidates = OnDeviceFoodRecognitionRepository.topCandidates(
        scores: [0.3, 0.7],
        labels: ['x', 'y'],
      );
      expect(candidates.length, 2);
      expect(candidates[0].label, 'y');
    });
  });

  // ---------------------------------------------------------------------------
  group('OnDeviceFoodRecognitionRepository.recognize', () {
    test('FoodRecognitionResult(candidates: Top-3, source: onDevice) 반환', () async {
      final labels = List.generate(150, (i) => 'label_$i');
      final scores = List<double>.filled(150, 0.0);
      scores[7] = 0.62; // 1위
      scores[2] = 0.21; // 2위
      scores[100] = 0.08; // 3위

      final fakeInterpreter = _FakeInterpreter(scores);
      final repo = OnDeviceFoodRecognitionRepository(
        interpreter: fakeInterpreter,
        labels: labels,
      );

      final result = await repo.recognize(_pngBytes());

      expect(result.source, RecognitionSource.onDevice);
      expect(result.candidates.length, 3);
      expect(result.candidates[0].label, 'label_7');
      expect(result.candidates[0].score, 0.62);
      expect(result.candidates[1].label, 'label_2');
      expect(result.candidates[2].label, 'label_100');

      // Interpreter에 [1,224,224,3] 입력이 그대로 전달됐는지 sanity check.
      final input = fakeInterpreter.lastInput as List;
      expect(input.length, 1);
      expect((input[0] as List).length, 224);
      expect(((input[0] as List)[0] as List).length, 224);
      expect((((input[0] as List)[0] as List)[0] as List).length, 3);
    });

    test('빈 입력에서도 FoodCandidate 타입(score nullable 아님)으로 매핑', () async {
      final labels = List.generate(150, (i) => 'label_$i');
      final fakeInterpreter = _FakeInterpreter(List<double>.filled(150, 0.0));
      final repo = OnDeviceFoodRecognitionRepository(
        interpreter: fakeInterpreter,
        labels: labels,
      );

      final result = await repo.recognize(_pngBytes());

      for (final candidate in result.candidates) {
        expect(candidate.score, isNotNull); // OnDevice는 항상 원점수를 채운다.
      }
    });
  });
}
