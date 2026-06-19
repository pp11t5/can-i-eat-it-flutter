import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:can_i_eat_it/features/verdict_history/data/repositories/verdict_history_repository_impl.dart';
import 'package:can_i_eat_it/features/verdict_history/domain/entities/verdict_history_item.dart';

VerdictHistoryItem _item(String name, String verdict, {int minsAgo = 0}) =>
    VerdictHistoryItem(
      foodName: name,
      verdict: verdict,
      checkedAt: DateTime.now().subtract(Duration(minutes: minsAgo)),
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('VerdictHistoryRepositoryImpl', () {
    test('초기 상태에서 getHistory는 빈 목록 반환', () async {
      final repo = VerdictHistoryRepositoryImpl();
      expect(await repo.getHistory(), isEmpty);
    });

    test('addItem 후 getHistory에서 항목 반환 (최신 순 prepend)', () async {
      final repo = VerdictHistoryRepositoryImpl();
      await repo.addItem(_item('두부', 'safe', minsAgo: 5));
      await repo.addItem(_item('커피', 'avoid'));

      final items = await repo.getHistory();
      expect(items.length, 2);
      // 최신 항목이 앞에 있어야 함
      expect(items.first.foodName, '커피');
      expect(items.last.foodName, '두부');
    });

    test('50건 초과 시 가장 오래된 항목 제거 (FIFO)', () async {
      final repo = VerdictHistoryRepositoryImpl();
      // 51건 추가
      for (var i = 0; i < 51; i++) {
        await repo.addItem(_item('food_$i', 'safe'));
      }
      final items = await repo.getHistory();
      expect(items.length, 50);
      // 가장 처음 추가한 food_0이 제거돼야 함
      expect(items.any((e) => e.foodName == 'food_0'), isFalse);
      // 마지막 추가한 food_50이 앞에 있어야 함
      expect(items.first.foodName, 'food_50');
    });

    test('clearHistory 후 getHistory는 빈 목록 반환', () async {
      final repo = VerdictHistoryRepositoryImpl();
      await repo.addItem(_item('두부', 'safe'));
      await repo.clearHistory();
      expect(await repo.getHistory(), isEmpty);
    });

    test('JSON 파싱 오류 시 빈 목록 반환', () async {
      // 손상된 JSON을 SharedPreferences에 직접 주입
      SharedPreferences.setMockInitialValues({
        'verdict_history_v1': 'INVALID_JSON',
      });
      final repo = VerdictHistoryRepositoryImpl();
      expect(await repo.getHistory(), isEmpty);
    });
  });
}
