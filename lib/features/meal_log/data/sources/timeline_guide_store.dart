import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timeline_guide_store.g.dart';

// ---------------------------------------------------------------------------
// 인터페이스
// ---------------------------------------------------------------------------

/// 타임라인 FAB 최초 가이드 노출 여부 저장소 (계정 단위).
///
/// [userId] 별로 플래그를 분리한다. 테스트는 [InMemoryTimelineGuideStore] 주입.
abstract interface class TimelineGuideStore {
  /// 해당 계정이 FAB 가이드를 이미 본(닫은) 적이 있으면 true.
  Future<bool> hasSeenFabGuide(String userId);

  /// FAB 탭으로 가이드를 닫았을 때 호출 — 이후 동일 계정에서는 미노출.
  Future<void> markFabGuideSeen(String userId);

  /// 계정 탈퇴 시 호출 — 해당 [userId] 플래그 삭제 후 재가입 시 가이드 재노출.
  Future<void> clearFabGuideSeen(String userId);
}

// ---------------------------------------------------------------------------
// flutter_secure_storage 구현
// ---------------------------------------------------------------------------

/// [flutter_secure_storage] 기반 프로덕션 구현.
///
/// 키: `timeline.fab_guide_seen_v1.<userId>` — 계정 단위 스코프.
class SecureStorageTimelineGuideStore implements TimelineGuideStore {
  SecureStorageTimelineGuideStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static String _key(String userId) => 'timeline.fab_guide_seen_v1.$userId';

  @override
  Future<bool> hasSeenFabGuide(String userId) async {
    if (userId.isEmpty) return true;
    final raw = await _storage.read(key: _key(userId));
    return raw == '1' || raw == 'true';
  }

  @override
  Future<void> markFabGuideSeen(String userId) async {
    if (userId.isEmpty) return;
    await _storage.write(key: _key(userId), value: '1');
  }

  @override
  Future<void> clearFabGuideSeen(String userId) async {
    if (userId.isEmpty) return;
    await _storage.delete(key: _key(userId));
  }
}

// ---------------------------------------------------------------------------
// 인메모리 Fake (테스트용)
// ---------------------------------------------------------------------------

/// 테스트·Mock 용 인메모리 [TimelineGuideStore].
class InMemoryTimelineGuideStore implements TimelineGuideStore {
  InMemoryTimelineGuideStore({Set<String>? seenUserIds})
      : _seen = {...?seenUserIds};

  final Set<String> _seen;

  /// 테스트 검증용 — 현재 본 계정 id 집합.
  Set<String> get seenUserIds => Set.unmodifiable(_seen);

  @override
  Future<bool> hasSeenFabGuide(String userId) async {
    if (userId.isEmpty) return true;
    return _seen.contains(userId);
  }

  @override
  Future<void> markFabGuideSeen(String userId) async {
    if (userId.isEmpty) return;
    _seen.add(userId);
  }

  @override
  Future<void> clearFabGuideSeen(String userId) async {
    if (userId.isEmpty) return;
    _seen.remove(userId);
  }
}

// ---------------------------------------------------------------------------
// Riverpod Provider
// ---------------------------------------------------------------------------

/// 앱 전역 [TimelineGuideStore] provider.
///
/// 테스트: `timelineGuideStoreProvider.overrideWithValue(InMemoryTimelineGuideStore())`.
@riverpod
TimelineGuideStore timelineGuideStore(Ref ref) =>
    SecureStorageTimelineGuideStore();
