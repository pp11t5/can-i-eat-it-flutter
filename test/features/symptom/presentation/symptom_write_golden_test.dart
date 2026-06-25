// 골든 셸 — PNG 미생성 상태. 마스터가 --update-goldens로 생성.
//
// 실행: flutter test --update-goldens --tags golden test/features/symptom/presentation/symptom_write_golden_test.dart
// 검증: flutter test --tags golden test/features/symptom/presentation/symptom_write_golden_test.dart

@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/domain/repositories/meal_repository.dart';
import 'package:can_i_eat_it/features/symptom/data/symptom_providers.dart';
import 'package:can_i_eat_it/features/symptom/domain/entities/symptom.dart';
import 'package:can_i_eat_it/features/symptom/domain/repositories/symptom_repository.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/symptom_write_screen.dart';

class _MockSymptomRepository implements SymptomRepository {
  @override
  Future<Symptom> create(SymptomDraft draft) async => throw UnimplementedError();
  @override
  Future<void> update(String id, SymptomDraft draft) async =>
      throw UnimplementedError();
  @override
  Future<Symptom> detail(String id) async => throw UnimplementedError();
  @override
  Future<void> updateMemo(String id, String? memo) async =>
      throw UnimplementedError();
  @override
  Future<void> delete(String id) async => throw UnimplementedError();
}

class _MockMealRepository implements MealRepository {
  @override
  Future<List<MealCandidatesDay>> candidates() async => [];
  @override
  Future<List<TimelineItem>> timeline(DateTime date) async => [];
  @override
  Future<List<WeeklyDay>> weekly(DateTime date) async => [];
  @override
  Future<MealFood> appendFood({
    required String foodExternalId,
    DateTime? eatenAt,
    String? mealRecordId,
  }) async => throw UnimplementedError();
  @override
  Future<MealFood> appendFoodByText({
    required String foodTextInput,
    DateTime? eatenAt,
    String? mealRecordId,
  }) async => throw UnimplementedError();
  @override
  Future<MealRecord> mealDetail(String mealRecordId) async =>
      throw UnimplementedError();
  @override
  Future<MealFood> foodDetail(String mealFoodId) async =>
      throw UnimplementedError();
  @override
  Future<void> deleteMeal(String mealRecordId) async =>
      throw UnimplementedError();
  @override
  Future<void> deleteFood(String mealFoodId) async =>
      throw UnimplementedError();
}

Widget _wrap() {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      symptomRepositoryProvider
          .overrideWithValue(_MockSymptomRepository()),
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(_MockMealRepository()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const SymptomWriteScreen(),
    ),
  );
}

void main() {
  testWidgets('symptom_write_screen_default', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/symptom_write_screen_default.png'),
    );
  });
}
