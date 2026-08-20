import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../symptom_outbox/symptom_outbox_bridge.dart';

part 'token_store.g.dart';

// ---------------------------------------------------------------------------
// 인터페이스
// ---------------------------------------------------------------------------

/// 인증 토큰 저장소 추상화 (ADR-0007 §3-1 (3)).
///
/// 만료 타임스탬프는 저장하지 않는다 — 401 반응형 refresh 만 사용.
/// 테스트에서는 [InMemoryTokenStore] 를 주입한다.
abstract interface class TokenStore {
  /// 저장된 액세스 토큰을 읽는다. 없으면 null.
  Future<String?> readAccessToken();

  /// 저장된 리프레시 토큰을 읽는다. 없으면 null.
  Future<String?> readRefreshToken();

  /// 약관 제출 전 앱이 종료된 사용자의 ID. 없으면 약관 pending 상태가 아니다.
  Future<String?> readPendingConsentUserId();

  /// 액세스·리프레시 토큰을 함께 저장한다.
  Future<void> writeTokens({
    required String access,
    required String refresh,
  });

  /// 현재 사용자가 온보딩 전에 약관을 제출해야 함을 저장한다.
  Future<void> markConsentPending(String userId);

  /// 약관 제출 완료 또는 완료된 사용자 로그인 시 pending 상태를 삭제한다.
  Future<void> clearConsentPending();

  /// 저장된 모든 토큰을 삭제한다 (로그아웃·세션만료).
  Future<void> clear();
}

// ---------------------------------------------------------------------------
// flutter_secure_storage 구현
// ---------------------------------------------------------------------------

/// [flutter_secure_storage] 기반 프로덕션 구현.
class FlutterSecureStorageTokenStore implements TokenStore {
  FlutterSecureStorageTokenStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _keyAccess = 'auth.access_token';
  static const _keyRefresh = 'auth.refresh_token';
  static const _keyPendingConsentUserId = 'auth.pending_consent_user_id';

  @override
  Future<String?> readAccessToken() => _storage.read(key: _keyAccess);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _keyRefresh);

  @override
  Future<String?> readPendingConsentUserId() =>
      _storage.read(key: _keyPendingConsentUserId);

  @override
  Future<void> writeTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _keyAccess, value: access);
    await _storage.write(key: _keyRefresh, value: refresh);
  }

  @override
  Future<void> markConsentPending(String userId) =>
      _storage.write(key: _keyPendingConsentUserId, value: userId);

  @override
  Future<void> clearConsentPending() =>
      _storage.delete(key: _keyPendingConsentUserId);

  @override
  Future<void> clear() async {
    await _storage.delete(key: _keyAccess);
    await _storage.delete(key: _keyRefresh);
    await clearConsentPending();
  }
}

/// Primary 토큰 저장소를 정본으로 유지하면서 iOS Extension용 access token만
/// best-effort로 동기화한다. refresh token은 절대 공유하지 않는다.
class MirroringTokenStore implements TokenStore {
  MirroringTokenStore(this._primary, this._bridge);

  final TokenStore _primary;
  final SymptomOutboxBridge _bridge;

  @override
  Future<String?> readAccessToken() => _primary.readAccessToken();

  @override
  Future<String?> readRefreshToken() => _primary.readRefreshToken();

  @override
  Future<String?> readPendingConsentUserId() =>
      _primary.readPendingConsentUserId();

  @override
  Future<void> writeTokens(
      {required String access, required String refresh}) async {
    await _primary.writeTokens(access: access, refresh: refresh);
    try {
      await _bridge.updateSharedAccessToken(access);
    } catch (_) {
      // token 정본 저장 성공을 native mirror 오류로 rollback하지 않는다.
    }
  }

  @override
  Future<void> markConsentPending(String userId) =>
      _primary.markConsentPending(userId);

  @override
  Future<void> clearConsentPending() => _primary.clearConsentPending();

  @override
  Future<void> clear() async {
    await _primary.clear();
    try {
      await _bridge.clearSharedSession();
    } catch (_) {
      // logout/session-expiry의 full purge는 AuthController가 별도로 재시도한다.
    }
  }
}

// ---------------------------------------------------------------------------
// 인메모리 Fake (테스트용)
// ---------------------------------------------------------------------------

/// 테스트·Mock 용 인메모리 [TokenStore].
///
/// 계약 검증 및 인터셉터 단위 테스트에서 사용한다.
class InMemoryTokenStore implements TokenStore {
  String? _access;
  String? _refresh;
  String? _pendingConsentUserId;

  @override
  Future<String?> readAccessToken() async => _access;

  @override
  Future<String?> readRefreshToken() async => _refresh;

  @override
  Future<String?> readPendingConsentUserId() async => _pendingConsentUserId;

  @override
  Future<void> writeTokens({
    required String access,
    required String refresh,
  }) async {
    _access = access;
    _refresh = refresh;
  }

  @override
  Future<void> markConsentPending(String userId) async {
    _pendingConsentUserId = userId;
  }

  @override
  Future<void> clearConsentPending() async {
    _pendingConsentUserId = null;
  }

  @override
  Future<void> clear() async {
    _access = null;
    _refresh = null;
    _pendingConsentUserId = null;
  }
}

// ---------------------------------------------------------------------------
// Riverpod Provider
// ---------------------------------------------------------------------------

/// 앱 전역 [TokenStore] provider.
///
/// 테스트에서는 `ProviderContainer(overrides: [tokenStoreProvider.overrideWithValue(...)])` 로 교체한다.
@riverpod
TokenStore tokenStore(Ref ref) => MirroringTokenStore(
      FlutterSecureStorageTokenStore(),
      ref.watch(symptomOutboxBridgeProvider),
    );
