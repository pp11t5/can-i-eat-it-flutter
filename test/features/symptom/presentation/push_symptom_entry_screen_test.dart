import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/symptom/presentation/screens/push_symptom_entry_screen.dart';

Widget _wrap(String mealRecordId) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(MockMealRepository.seeded()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: PushSymptomEntryScreen(mealRecordId: mealRecordId),
    ),
  );
}

void main() {
  testWidgets('식사를 확인한 뒤 증상 작성 화면에 식사를 프리필한다', (tester) async {
    await tester.pumpWidget(_wrap('record-001'));
    await tester.pumpAndSettle();

    expect(find.text('증상 기록 작성'), findsOneWidget);
    expect(find.text('두부'), findsOneWidget);
  });

  testWidgets('삭제됐거나 접근할 수 없는 식사는 폼을 열지 않는다', (tester) async {
    await tester.pumpWidget(_wrap('missing-record'));
    await tester.pumpAndSettle();

    expect(find.text('식사 정보를 찾을 수 없어요.'), findsOneWidget);
    expect(find.text('증상 기록 작성'), findsNothing);
  });
}
