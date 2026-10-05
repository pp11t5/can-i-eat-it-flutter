import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:can_i_eat_it/features/food_recognition/data/repositories/mock_gemini_food_recognition_repository.dart';
import 'package:can_i_eat_it/features/food_recognition/data/repositories/on_device_food_recognition_repository.dart';
import 'package:can_i_eat_it/features/food_recognition/domain/entities/food_recognition_result.dart';
import 'package:can_i_eat_it/features/food_recognition/domain/repositories/food_recognition_repository.dart';

part 'food_recognition_providers.g.dart';

const _modelAssetPath = 'assets/ml/food_mobilenetv3_fp16.tflite';
const _labelsAssetPath = 'assets/ml/labels.txt';

/// `model_metadata.json`의 `num_classes`와 일치해야 한다.
const _expectedLabelCount = 150;

/// MobileNetV3 TFLite [Interpreter] (앱 전역 1회 로드).
@Riverpod(keepAlive: true)
Future<Interpreter> foodRecognitionInterpreter(Ref ref) =>
    Interpreter.fromAsset(_modelAssetPath);

/// 음식 라벨 목록. 인덱스가 모델 출력 클래스 인덱스와 1:1 대응한다.
@Riverpod(keepAlive: true)
Future<List<String>> foodRecognitionLabels(Ref ref) async {
  final raw = await rootBundle.loadString(_labelsAssetPath);
  final labels = const LineSplitter()
      .convert(raw)
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
  assert(
    labels.length == _expectedLabelCount,
    'labels.txt는 $_expectedLabelCount줄이어야 한다 (실제: ${labels.length}줄)',
  );
  return labels;
}

/// 사용할 인식 엔진. 이 값만 바꾸면 OnDevice ↔ Gemini가 전환된다 (ADR-0009).
const kFoodRecognitionEngine = RecognitionSource.onDevice;

/// [engine]에 맞는 [FoodRecognitionRepository]를 제공한다.
/// Gemini는 백엔드 계약 전까지 Mock이다.
@riverpod
Future<FoodRecognitionRepository> foodRecognitionRepository(
  Ref ref,
  RecognitionSource engine,
) async {
  switch (engine) {
    case RecognitionSource.onDevice:
      final interpreter =
          await ref.watch(foodRecognitionInterpreterProvider.future);
      final labels = await ref.watch(foodRecognitionLabelsProvider.future);
      return OnDeviceFoodRecognitionRepository(
        interpreter: interpreter,
        labels: labels,
      );
    case RecognitionSource.gemini:
      return const MockGeminiFoodRecognitionRepository();
  }
}
