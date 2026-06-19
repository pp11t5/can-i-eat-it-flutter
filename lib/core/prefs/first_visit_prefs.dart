import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'first_visit_prefs.g.dart';

// ---------------------------------------------------------------------------
// 인터페이스
// ---------------------------------------------------------------------------

/// 첫 방문 관련 로컬 플래그 저장소.
///
/// 프로필 완성 유도 토스트 표시 여부를 관리한다.
/// 테스트에서는 [InMemoryFirstVisitPrefs] 를 주입한다.
abstract interface class FirstVisitPrefs {
  /// 토스트가 이미 표시됐는지 여부.
  Future<bool> isToastShown();

  /// 토스트 표시 완료를 기록한다.
  Future<void> markToastShown();
}

// ---------------------------------------------------------------------------
// SharedPreferences 구현
// ---------------------------------------------------------------------------

/// [SharedPreferences] 기반 프로덕션 구현.
class SharedPrefsFirstVisitPrefs implements FirstVisitPrefs {
  static const _keyToastShown = 'first_visit.profile_toast_shown';

  @override
  Future<bool> isToastShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyToastShown) ?? false;
  }

  @override
  Future<void> markToastShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyToastShown, true);
  }
}

// ---------------------------------------------------------------------------
// 인메모리 Fake (테스트용)
// ---------------------------------------------------------------------------

/// 테스트용 인메모리 [FirstVisitPrefs].
class InMemoryFirstVisitPrefs implements FirstVisitPrefs {
  bool _shown = false;

  @override
  Future<bool> isToastShown() async => _shown;

  @override
  Future<void> markToastShown() async => _shown = true;
}

// ---------------------------------------------------------------------------
// Riverpod Provider
// ---------------------------------------------------------------------------

/// 앱 전역 [FirstVisitPrefs] provider.
///
/// 테스트에서는 `ProviderContainer(overrides: [firstVisitPrefsProvider.overrideWithValue(...)])` 로 교체한다.
@riverpod
FirstVisitPrefs firstVisitPrefs(Ref ref) => SharedPrefsFirstVisitPrefs();
