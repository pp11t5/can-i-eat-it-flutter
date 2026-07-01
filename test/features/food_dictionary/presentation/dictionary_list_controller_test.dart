import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_dictionary/data/food_dictionary_providers.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/entities/dictionary_food.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/repositories/dictionary_repository.dart';
import 'package:can_i_eat_it/features/food_dictionary/presentation/controllers/dictionary_list_controller.dart';

// ---------------------------------------------------------------------------
// 페이지를 제어하는 fake repository — 커서별 응답을 스크립팅한다.
// ---------------------------------------------------------------------------

/// 커서(null=첫 페이지) → 반환할 [DictionaryPage] 매핑으로 페이징을 스크립팅하는
/// fake repository. [throwOnCursor]와 일치하는 커서로 조회하면 예외를 던져
/// loadMore 에러 경로를 시뮬레이션한다. safe·caution-risk 양쪽에 동일 스크립트를
/// 재사용한다(양쪽 다 동일한 페이징 로직을 검증하는 것이 목적이므로 무해).
class _PagedFakeDictionaryRepository implements DictionaryRepository {
  _PagedFakeDictionaryRepository({
    required this.pages,
    this.countValue =
        const DictionaryCount(safeCount: 0, cautionRiskCount: 0),
    this.throwOnCursor,
  });

  final Map<int?, DictionaryPage> pages;
  final DictionaryCount countValue;
  final int? throwOnCursor;

  int getSafeCallCount = 0;
  int getCautionRiskCallCount = 0;

  @override
  Future<DictionaryPage> getSafe({int? cursor, int size = 20}) async {
    getSafeCallCount++;
    return _resolve(cursor);
  }

  @override
  Future<DictionaryPage> getCautionRisk({int? cursor, int size = 20}) async {
    getCautionRiskCallCount++;
    return _resolve(cursor);
  }

  @override
  Future<DictionaryCount> getCount() async => countValue;

  DictionaryPage _resolve(int? cursor) {
    if (throwOnCursor != null && cursor == throwOnCursor) {
      throw Exception('network error');
    }
    return pages[cursor] ?? const DictionaryPage();
  }
}

// ---------------------------------------------------------------------------
// 샘플 데이터
// ---------------------------------------------------------------------------

const _item1 = DictionaryFoodItem(
  foodId: 'food-1',
  name: '두부',
  categoryCode: 'BEAN',
  verdict: VerdictLevel.recommend,
);
const _item2 = DictionaryFoodItem(
  foodId: 'food-2',
  name: '흰쌀밥',
  categoryCode: 'GRAIN',
  verdict: VerdictLevel.recommend,
);
const _item3 = DictionaryFoodItem(
  foodId: 'food-3',
  name: '바나나',
  categoryCode: 'FRUIT',
  verdict: VerdictLevel.recommend,
);

const _kSecondPageCursor = 100;

/// 2페이지 시나리오: 첫 페이지 hasNext=true·nextCursor=100, 둘째 페이지
/// hasNext=false.
Map<int?, DictionaryPage> _twoPageScript() => {
      null: const DictionaryPage(
        items: [_item1, _item2],
        nextCursor: _kSecondPageCursor,
        hasNext: true,
      ),
      _kSecondPageCursor: const DictionaryPage(
        items: [_item3],
        nextCursor: null,
        hasNext: false,
      ),
    };

/// 단일 페이지 시나리오(처음부터 hasNext=false) — no-op 검증용.
Map<int?, DictionaryPage> _singlePageScript() => {
      null: const DictionaryPage(
        items: [_item1],
        nextCursor: null,
        hasNext: false,
      ),
    };

ProviderContainer _makeContainer(DictionaryRepository repo) {
  return ProviderContainer(
    overrides: [
      dictionaryRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

void main() {
  // ---------------------------------------------------------------------------
  group('SafeDictionaryController — 첫 페이지', () {
    test('build 후 첫 페이지 items·hasNext를 반환한다', () async {
      final repo = _PagedFakeDictionaryRepository(pages: _twoPageScript());
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final state =
          await container.read(safeDictionaryControllerProvider.future);

      expect(state.items, [_item1, _item2]);
      expect(state.hasNext, isTrue);
      expect(state.nextCursor, _kSecondPageCursor);
    });
  });

  group('SafeDictionaryController — loadMore 누적', () {
    test('loadMore 호출 후 items가 누적되고 hasNext·nextCursor가 갱신된다', () async {
      final repo = _PagedFakeDictionaryRepository(pages: _twoPageScript());
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(safeDictionaryControllerProvider.future);
      final notifier =
          container.read(safeDictionaryControllerProvider.notifier);

      await notifier.loadMore();

      final state = container.read(safeDictionaryControllerProvider).value!;
      expect(state.items, [_item1, _item2, _item3]);
      expect(state.hasNext, isFalse);
      expect(state.nextCursor, isNull);
      expect(state.isLoadingMore, isFalse);
    });
  });

  group('SafeDictionaryController — hasNext=false no-op', () {
    test('hasNext=false면 loadMore() 호출이 repository를 재조회하지 않는다', () async {
      final repo = _PagedFakeDictionaryRepository(pages: _singlePageScript());
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(safeDictionaryControllerProvider.future);
      expect(repo.getSafeCallCount, 1);

      final notifier =
          container.read(safeDictionaryControllerProvider.notifier);
      await notifier.loadMore();

      final state = container.read(safeDictionaryControllerProvider).value!;
      expect(state.items, [_item1]);
      expect(repo.getSafeCallCount, 1); // 추가 호출 없음.
    });
  });

  group('SafeDictionaryController — loadMore 에러', () {
    test('loadMore 중 예외가 발생하면 isLoadingMore가 리셋되고 기존 items가 보존된다',
        () async {
      final repo = _PagedFakeDictionaryRepository(
        pages: _twoPageScript(),
        throwOnCursor: _kSecondPageCursor,
      );
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      await container.read(safeDictionaryControllerProvider.future);
      final notifier =
          container.read(safeDictionaryControllerProvider.notifier);

      await notifier.loadMore();

      final state = container.read(safeDictionaryControllerProvider).value!;
      expect(state.items, [_item1, _item2]); // 첫 페이지 그대로 보존.
      expect(state.isLoadingMore, isFalse);
      // 상태 자체는 여전히 AsyncData — 컨트롤러가 catch해서 error를 삼킨다.
      expect(
        container.read(safeDictionaryControllerProvider),
        isA<AsyncData<DictionaryListState>>(),
      );
    });
  });

  // ---------------------------------------------------------------------------
  group('CautionRiskDictionaryController — loadMore 누적', () {
    test('build 후 첫 페이지, loadMore 후 items가 누적되고 hasNext=false로 갱신된다',
        () async {
      final repo = _PagedFakeDictionaryRepository(pages: _twoPageScript());
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final firstState = await container
          .read(cautionRiskDictionaryControllerProvider.future);
      expect(firstState.items, [_item1, _item2]);
      expect(firstState.hasNext, isTrue);

      final notifier =
          container.read(cautionRiskDictionaryControllerProvider.notifier);
      await notifier.loadMore();

      final state =
          container.read(cautionRiskDictionaryControllerProvider).value!;
      expect(state.items, [_item1, _item2, _item3]);
      expect(state.hasNext, isFalse);
      expect(state.nextCursor, isNull);
      // safe 쪽 repo 메서드는 호출되지 않아야 한다 — 탭 격리 확인.
      expect(repo.getSafeCallCount, 0);
    });
  });

  // ---------------------------------------------------------------------------
  group('dictionaryCountProvider', () {
    test('repository.getCount() 결과를 그대로 반환한다', () async {
      const expectedCount = DictionaryCount(safeCount: 3, cautionRiskCount: 2);
      final repo = _PagedFakeDictionaryRepository(
        pages: _singlePageScript(),
        countValue: expectedCount,
      );
      final container = _makeContainer(repo);
      addTearDown(container.dispose);

      final count = await container.read(dictionaryCountProvider.future);

      expect(count, expectedCount);
    });
  });
}
