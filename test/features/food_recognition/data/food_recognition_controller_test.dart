import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_recognition/data/food_recognition_providers.dart';
import 'package:can_i_eat_it/features/food_recognition/domain/entities/food_recognition_result.dart';
import 'package:can_i_eat_it/features/food_recognition/domain/repositories/food_recognition_repository.dart';

class _FakeRepository implements FoodRecognitionRepository {
  _FakeRepository(this._recognize);

  final Future<FoodRecognitionResult> Function() _recognize;

  @override
  Future<FoodRecognitionResult> recognize(Uint8List imageBytes) => _recognize();
}

FoodRecognitionResult _onDevice(List<double> scores) => FoodRecognitionResult(
      candidates: [
        for (var i = 0; i < scores.length; i++)
          FoodCandidate(label: '음식$i', score: scores[i]),
      ],
      source: RecognitionSource.onDevice,
    );

ProviderContainer _container(Future<FoodRecognitionResult> Function() recognize) {
  final container = ProviderContainer(
    overrides: [
      foodRecognitionRepositoryProvider(kFoodRecognitionEngine)
          .overrideWith((ref) async => _FakeRepository(recognize)),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  final bytes = Uint8List(0);

  test('초기 상태는 인식 전(data: null)이다', () {
    final container = _container(() async => _onDevice([0.9]));

    expect(
      container.read(foodRecognitionControllerProvider),
      const AsyncValue<List<FoodCandidate>?>.data(null),
    );
  });

  test('Top-1 점수가 임계값 이상이면 후보 전체를 그대로 돌려준다', () async {
    final container = _container(() async => _onDevice([0.5, 0.2, 0.1]));
    final notifier = container.read(foodRecognitionControllerProvider.notifier);

    await notifier.recognize(bytes);

    final candidates = container.read(foodRecognitionControllerProvider).value;
    expect(candidates?.map((c) => c.label), ['음식0', '음식1', '음식2']);
  });

  test('Top-1 점수가 임계값과 같으면 성공이다', () async {
    final container = _container(
      () async => _onDevice([kRecognitionMinTopScore, 0.1]),
    );

    await container
        .read(foodRecognitionControllerProvider.notifier)
        .recognize(bytes);

    expect(container.read(foodRecognitionControllerProvider).value, hasLength(2));
  });

  test('Top-1 점수가 임계값 미만이면 실패(빈 목록)다', () async {
    final container = _container(() async => _onDevice([0.29, 0.2, 0.1]));

    await container
        .read(foodRecognitionControllerProvider.notifier)
        .recognize(bytes);

    expect(container.read(foodRecognitionControllerProvider).value, isEmpty);
  });

  test('후보가 0개면 실패(빈 목록)다', () async {
    final container = _container(() async => _onDevice([]));

    await container
        .read(foodRecognitionControllerProvider.notifier)
        .recognize(bytes);

    expect(container.read(foodRecognitionControllerProvider).value, isEmpty);
  });

  test('점수가 없는 엔진(Gemini)은 임계값 판정을 건너뛴다', () async {
    final container = _container(
      () async => const FoodRecognitionResult(
        candidates: [FoodCandidate(label: '라멘')],
        source: RecognitionSource.gemini,
      ),
    );

    await container
        .read(foodRecognitionControllerProvider.notifier)
        .recognize(bytes);

    expect(
      container.read(foodRecognitionControllerProvider).value?.single.label,
      '라멘',
    );
  });

  test('인식 중에는 loading 상태다', () async {
    final container = _container(() async => _onDevice([0.9]));
    final notifier = container.read(foodRecognitionControllerProvider.notifier);

    final future = notifier.recognize(bytes);
    expect(container.read(foodRecognitionControllerProvider).isLoading, isTrue);
    await future;
  });

  test('저장소 예외는 error 상태가 된다', () async {
    final container = _container(() async => throw StateError('모델 로딩 실패'));

    await container
        .read(foodRecognitionControllerProvider.notifier)
        .recognize(bytes);

    expect(container.read(foodRecognitionControllerProvider).hasError, isTrue);
  });

  test('reset 하면 인식 전 상태로 돌아간다', () async {
    final container = _container(() async => _onDevice([0.9]));
    final notifier = container.read(foodRecognitionControllerProvider.notifier);
    await notifier.recognize(bytes);

    notifier.reset();

    expect(
      container.read(foodRecognitionControllerProvider),
      const AsyncValue<List<FoodCandidate>?>.data(null),
    );
  });
}
