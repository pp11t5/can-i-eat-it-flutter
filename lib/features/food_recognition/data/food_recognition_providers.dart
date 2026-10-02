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

/// `model_metadata.json`의 `num_classes` 와 정합(ADR-0009 §4).
const _expectedLabelCount = 150;

// ---------------------------------------------------------------------------
// OnDevice 추론 자원 — 앱 전역 1회 로드 (ADR-0009 결정 D4)
// ---------------------------------------------------------------------------

/// MobileNetV3 TFLite [Interpreter]. 앱 전역에서 1회만 로드하고 재사용한다.
@Riverpod(keepAlive: true)
Future<Interpreter> foodRecognitionInterpreter(Ref ref) =>
    Interpreter.fromAsset(_modelAssetPath);

/// 150개 음식 라벨 목록. 인덱스는 모델 출력 텐서의 클래스 인덱스와 1:1 대응.
///
/// 줄 수가 [_expectedLabelCount](=150, `model_metadata.json` num_classes)와
/// 다르면 라벨-모델 불일치를 조용히 넘기지 않고 즉시 assert로 드러낸다.
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
    'labels.txt는 $_expectedLabelCount줄이어야 한다(model_metadata.json num_classes 정합) '
    '— 실제: ${labels.length}줄',
  );
  return labels;
}

// ---------------------------------------------------------------------------
// 활성 엔진 상수 (ADR-0009 2026-10-02 구현 메모, 결정 D 수정)
// ---------------------------------------------------------------------------

/// 현재 활성 인식 엔진 — 이 값만 바꾸면 OnDevice ↔ Gemini 전환된다.
/// 런타임 자동/사용자 트리거 전환은 없음(ADR-0009 2026-10-02 구현 메모, 결정 D 수정).
const kFoodRecognitionEngine = RecognitionSource.onDevice;

// ---------------------------------------------------------------------------
// FoodRecognitionRepository 공급자 — 엔진 교체 (ADR-0009 결정 D4)
// ---------------------------------------------------------------------------

/// [FoodRecognitionRepository] 공급자. [engine]에 따라 구현체를 교체한다.
///
/// - [RecognitionSource.onDevice]: [foodRecognitionInterpreterProvider] /
///   [foodRecognitionLabelsProvider]를 await해 [OnDeviceFoodRecognitionRepository] 생성.
/// - [RecognitionSource.gemini]: 백엔드 `/foods/recognize` 계약 전까지
///   [MockGeminiFoodRecognitionRepository] (ADR-0009 §6, 구현 순서 5).
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
