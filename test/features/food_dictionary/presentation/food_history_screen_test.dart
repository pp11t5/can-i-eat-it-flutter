import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/food_dictionary_providers.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/repositories/mock_dictionary_repository.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/entities/dictionary_food.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/repositories/dictionary_repository.dart';
import 'package:can_i_eat_it/features/food_dictionary/presentation/screens/food_history_screen.dart';

// ---------------------------------------------------------------------------
// 지연 응답 fake — AsyncLoading 프레임을 붙잡아 확인하는 용도.
// ---------------------------------------------------------------------------

class _DelayedDictionaryRepository implements DictionaryRepository {
  _DelayedDictionaryRepository(this._delegate, {required this.delay});

  final DictionaryRepository _delegate;
  final Duration delay;

  @override
  Future<DictionaryPage> getSafe({int? cursor, int size = 20}) async {
    await Future.delayed(delay);
    return _delegate.getSafe(cursor: cursor, size: size);
  }

  @override
  Future<DictionaryPage> getCautionRisk({int? cursor, int size = 20}) async {
    await Future.delayed(delay);
    return _delegate.getCautionRisk(cursor: cursor, size: size);
  }

  @override
  Future<DictionaryCount> getCount() async {
    await Future.delayed(delay);
    return _delegate.getCount();
  }
}

Widget _wrap(DictionaryRepository repo) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      dictionaryRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const FoodHistoryScreen(),
    ),
  );
}

void main() {
  group('FoodHistoryScreen — 타이틀·세그먼트', () {
    testWidgets('앱바 타이틀 "음식 히스토리"를 렌더한다', (tester) async {
      await tester.pumpWidget(_wrap(MockDictionaryRepository.seeded()));
      await tester.pumpAndSettle();

      expect(find.text('음식 히스토리'), findsOneWidget);
    });

    testWidgets('세그먼트 라벨 "권장 음식 N"/"주의 음식 N"을 렌더한다', (tester) async {
      await tester.pumpWidget(_wrap(MockDictionaryRepository.seeded()));
      await tester.pumpAndSettle();

      // seeded(): safe 3건, caution-risk 2건.
      expect(find.text('권장 음식 3'), findsOneWidget);
      expect(find.text('주의 음식 2'), findsOneWidget);
    });
  });

  group('FoodHistoryScreen — 권장 탭', () {
    testWidgets('권장 탭 카드에 "권장" 배지와 아이템 이름이 렌더된다', (tester) async {
      await tester.pumpWidget(_wrap(MockDictionaryRepository.seeded()));
      await tester.pumpAndSettle();

      expect(find.text('두부'), findsOneWidget);
      expect(find.text('흰쌀밥'), findsOneWidget);
      expect(find.text('바나나'), findsOneWidget);
      expect(find.text('권장'), findsNWidgets(3));
    });
  });

  group('FoodHistoryScreen — 주의 탭 전환', () {
    testWidgets('"주의 음식" 세그먼트 탭 → 탭 전환되어 주의/위험 배지 목록이 표시된다',
        (tester) async {
      await tester.pumpWidget(_wrap(MockDictionaryRepository.seeded()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('주의 음식 2'));
      await tester.pumpAndSettle();

      expect(find.text('된장찌개'), findsOneWidget);
      expect(find.text('커피'), findsOneWidget);
      expect(find.text('주의'), findsOneWidget);
      expect(find.text('위험'), findsOneWidget);
    });

    testWidgets('주의 탭 전환 후 권장 탭 카드는 화면에 상호작용 불가 상태가 된다(IndexedStack)',
        (tester) async {
      await tester.pumpWidget(_wrap(MockDictionaryRepository.seeded()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('주의 음식 2'));
      await tester.pumpAndSettle();

      // IndexedStack은 오프스크린 자식도 트리에 유지하지만 페인트·hitTest 대상에서
      // 제외한다 — hitTestable로 "화면에 보이지 않음"을 확인.
      expect(find.text('두부').hitTestable(), findsNothing);
    });
  });

  group('FoodHistoryScreen — 빈 상태', () {
    testWidgets('empty 저장소 권장 탭 → "아직 권장 음식이 없어요" 렌더', (tester) async {
      await tester.pumpWidget(_wrap(MockDictionaryRepository.empty()));
      await tester.pumpAndSettle();

      expect(find.text('아직 권장 음식이 없어요'), findsOneWidget);
    });

    testWidgets('empty 저장소 주의 탭 → "아직 주의·위험 음식이 없어요" 렌더', (tester) async {
      await tester.pumpWidget(_wrap(MockDictionaryRepository.empty()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('주의 음식 0'));
      await tester.pumpAndSettle();

      expect(find.text('아직 주의·위험 음식이 없어요'), findsOneWidget);
    });
  });

  group('FoodHistoryScreen — 로딩 상태', () {
    testWidgets('응답이 지연되면 첫 프레임에서 CircularProgressIndicator를 표시한다',
        (tester) async {
      final repo = _DelayedDictionaryRepository(
        MockDictionaryRepository.seeded(),
        delay: const Duration(milliseconds: 500),
      );

      await tester.pumpWidget(_wrap(repo));
      await tester.pump(); // Future.delayed 미해결 — 로딩 프레임만 확인.

      expect(find.byType(CircularProgressIndicator), findsWidgets);

      await tester.pumpAndSettle(); // 남은 타이머 정리(테스트 종료 후 pending timer 방지).
    });
  });
}
