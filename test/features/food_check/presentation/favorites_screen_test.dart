import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/favorite_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_favorite_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/favorite_item.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/favorites_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

Widget _wrap(MockFavoriteRepository repo) => ProviderScope(
      overrides: [
        // ignore: scoped_providers_should_specify_dependencies
        favoriteRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MaterialApp(home: FavoritesScreen()),
    );

MockFavoriteRepository _seeded() {
  final repo = MockFavoriteRepository();
  repo.save(FavoriteItem(
    foodName: '두부',
    level: VerdictLevel.recommend,
    savedAt: DateTime(2026, 6, 20, 8),
  ));
  repo.save(FavoriteItem(
    foodName: '커피',
    level: VerdictLevel.risk,
    savedAt: DateTime(2026, 6, 20, 9),
  ));
  return repo;
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  group('FavoritesScreen', () {
    testWidgets('빈 상태: "저장된 즐겨찾기가 없어요." 표시', (tester) async {
      await tester.pumpWidget(_wrap(MockFavoriteRepository()));
      await tester.pumpAndSettle();

      expect(find.text('저장된 즐겨찾기가 없어요.'), findsOneWidget);
    });

    testWidgets('데이터 있음: foodName + gradeLabel 표시', (tester) async {
      await tester.pumpWidget(_wrap(_seeded()));
      await tester.pumpAndSettle();

      expect(find.text('두부'), findsOneWidget);
      expect(find.text('✅ 추천'), findsOneWidget);
      expect(find.text('커피'), findsOneWidget);
      expect(find.text('🚫 위험'), findsOneWidget);
    });

    testWidgets('삭제 버튼 탭 시 항목이 목록에서 제거된다', (tester) async {
      final repo = _seeded();
      // 비동기 save 완료 대기
      await Future.microtask(() {});

      await tester.pumpWidget(_wrap(repo));
      await tester.pumpAndSettle();

      // 두부 항목의 삭제 버튼을 찾아 탭
      final deleteIcons = find.byIcon(Icons.delete);
      // 두부(최신순 첫 번째) 항목 삭제
      await tester.tap(deleteIcons.last); // last = 두부(older, 역순으로 last)
      await tester.pumpAndSettle();

      expect(find.text('두부'), findsNothing);
      // 커피는 여전히 존재
      expect(find.text('커피'), findsOneWidget);
    });
  });
}
