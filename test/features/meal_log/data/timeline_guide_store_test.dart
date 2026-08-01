import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/meal_log/data/sources/timeline_guide_store.dart';

void main() {
  group('InMemoryTimelineGuideStore', () {
    test('계정별로 독립 — A 닫아도 B는 미노출 플래그 없음', () async {
      final store = InMemoryTimelineGuideStore();

      expect(await store.hasSeenFabGuide('user-a'), isFalse);
      expect(await store.hasSeenFabGuide('user-b'), isFalse);

      await store.markFabGuideSeen('user-a');

      expect(await store.hasSeenFabGuide('user-a'), isTrue);
      expect(await store.hasSeenFabGuide('user-b'), isFalse);
    });

    test('빈 userId 는 mark 무시 · hasSeen 은 true(가이드 미노출)', () async {
      final store = InMemoryTimelineGuideStore();
      await store.markFabGuideSeen('');
      expect(store.seenUserIds, isEmpty);
      expect(await store.hasSeenFabGuide(''), isTrue);
    });

    test('seed 로 이미 본 계정 주입 가능', () async {
      final store = InMemoryTimelineGuideStore(seenUserIds: {'seeded'});
      expect(await store.hasSeenFabGuide('seeded'), isTrue);
      expect(await store.hasSeenFabGuide('other'), isFalse);
    });

    test('clearFabGuideSeen 후 미열람으로 복귀 — 탈퇴 후 재노출', () async {
      final store = InMemoryTimelineGuideStore(seenUserIds: {'u1', 'u2'});
      await store.clearFabGuideSeen('u1');
      expect(await store.hasSeenFabGuide('u1'), isFalse);
      expect(await store.hasSeenFabGuide('u2'), isTrue);
    });
  });
}
