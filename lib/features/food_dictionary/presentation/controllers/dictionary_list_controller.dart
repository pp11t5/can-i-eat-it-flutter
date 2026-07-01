import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/food_dictionary/data/food_dictionary_providers.dart';
import 'package:can_i_eat_it/features/food_dictionary/domain/entities/dictionary_food.dart';

part 'dictionary_list_controller.g.dart';

// ---------------------------------------------------------------------------
// DictionaryListState — 누적 페이지 상태 (plain, freezed 미사용)
// ---------------------------------------------------------------------------

/// 도감 목록 화면(safe·caution-risk 공용) 누적 페이지 상태.
///
/// freezed 대신 plain immutable class + [copyWith] — 코드젠 최소화.
class DictionaryListState {
  const DictionaryListState({
    this.items = const <DictionaryFoodItem>[],
    this.nextCursor,
    this.hasNext = false,
    this.isLoadingMore = false,
  });

  /// 지금까지 누적된 항목.
  final List<DictionaryFoodItem> items;

  /// 다음 페이지 커서. null이면 더 없음.
  final int? nextCursor;

  /// 다음 페이지 존재 여부.
  final bool hasNext;

  /// loadMore 진행 중 여부 — 하단 로딩 인디케이터·중복 호출 방지 용.
  final bool isLoadingMore;

  /// [nextCursor]는 값이 정상적으로 null일 수 있어 `??` 폴백이 부정확하다.
  /// 명시적으로 비우려면 [clearNextCursor]를 true로 전달한다.
  DictionaryListState copyWith({
    List<DictionaryFoodItem>? items,
    int? nextCursor,
    bool clearNextCursor = false,
    bool? hasNext,
    bool? isLoadingMore,
  }) {
    return DictionaryListState(
      items: items ?? this.items,
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
      hasNext: hasNext ?? this.hasNext,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// 커서 페이지 크기 — safe·caution-risk 목록 공용.
const _pageSize = 20;

// ---------------------------------------------------------------------------
// SafeDictionaryController — 권장(safe) 목록
// ---------------------------------------------------------------------------

/// 권장(safe) 음식 도감 목록 컨트롤러.
///
/// build()에서 첫 페이지를 로드하고, [loadMore]로 다음 페이지를 누적한다.
/// 대응 API: GET /dictionary/safe?cursor&size.
@riverpod
class SafeDictionaryController extends _$SafeDictionaryController {
  @override
  Future<DictionaryListState> build() async {
    final repo = ref.watch(dictionaryRepositoryProvider);
    final page = await repo.getSafe(size: _pageSize);
    return DictionaryListState(
      items: page.items,
      nextCursor: page.nextCursor,
      hasNext: page.hasNext,
    );
  }

  /// 다음 페이지를 로드해 누적한다.
  ///
  /// hasNext=false 이거나 이미 로딩 중이면 무시(중복 호출 가드).
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasNext || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final repo = ref.read(dictionaryRepositoryProvider);
      final page =
          await repo.getSafe(cursor: current.nextCursor, size: _pageSize);
      final latest = state.valueOrNull ?? current;
      state = AsyncData(
        latest.copyWith(
          items: [...latest.items, ...page.items],
          nextCursor: page.nextCursor,
          clearNextCursor: page.nextCursor == null,
          hasNext: page.hasNext,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      final latest = state.valueOrNull ?? current;
      state = AsyncData(latest.copyWith(isLoadingMore: false));
    }
  }
}

// ---------------------------------------------------------------------------
// CautionRiskDictionaryController — 주의·위험 목록
// ---------------------------------------------------------------------------

/// 주의·위험(caution-risk) 음식 도감 목록 컨트롤러.
///
/// build()에서 첫 페이지를 로드하고, [loadMore]로 다음 페이지를 누적한다.
/// 대응 API: GET /dictionary/caution-risk?cursor&size.
@riverpod
class CautionRiskDictionaryController
    extends _$CautionRiskDictionaryController {
  @override
  Future<DictionaryListState> build() async {
    final repo = ref.watch(dictionaryRepositoryProvider);
    final page = await repo.getCautionRisk(size: _pageSize);
    return DictionaryListState(
      items: page.items,
      nextCursor: page.nextCursor,
      hasNext: page.hasNext,
    );
  }

  /// 다음 페이지를 로드해 누적한다.
  ///
  /// hasNext=false 이거나 이미 로딩 중이면 무시(중복 호출 가드).
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasNext || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final repo = ref.read(dictionaryRepositoryProvider);
      final page = await repo.getCautionRisk(
        cursor: current.nextCursor,
        size: _pageSize,
      );
      final latest = state.valueOrNull ?? current;
      state = AsyncData(
        latest.copyWith(
          items: [...latest.items, ...page.items],
          nextCursor: page.nextCursor,
          clearNextCursor: page.nextCursor == null,
          hasNext: page.hasNext,
          isLoadingMore: false,
        ),
      );
    } catch (_) {
      final latest = state.valueOrNull ?? current;
      state = AsyncData(latest.copyWith(isLoadingMore: false));
    }
  }
}

// ---------------------------------------------------------------------------
// dictionaryCount — 탭 카운트
// ---------------------------------------------------------------------------

/// 도감 탭 카운트 조회. 대응 API: GET /dictionary/count.
@riverpod
Future<DictionaryCount> dictionaryCount(Ref ref) async {
  final repo = ref.watch(dictionaryRepositoryProvider);
  return repo.getCount();
}
