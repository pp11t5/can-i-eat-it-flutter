import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'native_auth_token_bridge.dart';

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
///
/// Android는 [androidBridge]가 있으면 EncryptedSharedPreferences를 단일 원천으로
/// 쓰고, 기존 FSS 값은 최초 읽기 때 1회 이전한다. 약관 pending은 FSS에 남긴다.
class FlutterSecureStorageTokenStore implements TokenStore {
  FlutterSecureStorageTokenStore({
    FlutterSecureStorage? storage,
    this.androidBridge,
  }) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Android 네이티브 토큰 저장소. null이면 FSS만 사용(iOS·테스트).
  final NativeAuthTokenBridge? androidBridge;

  static const _keyAccess = 'auth.access_token';
  static const _keyRefresh = 'auth.refresh_token';
  static const _keyPendingConsentUserId = 'auth.pending_consent_user_id';

  @override
  Future<String?> readAccessToken() async {
    final android = androidBridge;
    if (android != null) {
      try {
        await _migrateLegacyTokens(android);
        return await android.readAccessToken();
      } catch (e) {
        debugPrint('[AuthToken] android readAccess failed: $e');
      }
    }
    return _storage.read(key: _keyAccess);
  }

  @override
  Future<String?> readRefreshToken() async {
    final android = androidBridge;
    if (android != null) {
      try {
        await _migrateLegacyTokens(android);
        return await android.readRefreshToken();
      } catch (e) {
        debugPrint('[AuthToken] android readRefresh failed: $e');
      }
    }
    return _storage.read(key: _keyRefresh);
  }

  @override
  Future<String?> readPendingConsentUserId() =>
      _storage.read(key: _keyPendingConsentUserId);

  @override
  Future<void> writeTokens({
    required String access,
    required String refresh,
  }) async {
    final android = androidBridge;
    if (android != null) {
      try {
        await android.writeTokens(access: access, refresh: refresh);
        try {
          await _storage.delete(key: _keyAccess);
          await _storage.delete(key: _keyRefresh);
        } catch (_) {
          // 레거시 FSS가 없어도 네이티브 기록이 성공이면 충분하다.
        }
        return;
      } catch (e) {
        debugPrint('[AuthToken] android write failed, FSS fallback: $e');
      }
    }
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
    final android = androidBridge;
    if (android != null) {
      try {
        await android.clearTokens();
      } catch (e) {
        debugPrint('[AuthToken] android clear failed: $e');
      }
    }
    await _storage.delete(key: _keyAccess);
    await _storage.delete(key: _keyRefresh);
    await clearConsentPending();
  }

  Future<void> _migrateLegacyTokens(NativeAuthTokenBridge android) async {
    try {
      await migrateLegacyTokensIfNeeded(
        android: android,
        readLegacyAccess: () => _storage.read(key: _keyAccess),
        readLegacyRefresh: () => _storage.read(key: _keyRefresh),
        deleteLegacyTokens: () async {
          await _storage.delete(key: _keyAccess);
          await _storage.delete(key: _keyRefresh);
        },
      );
    } catch (e) {
      debugPrint('[AuthToken] migrate skipped: $e');
    }
  }
}

/// FSS에만 있던 세션을 Android 네이티브 저장소로 1회 복사한다.
///
/// 네이티브에 이미 access가 있으면 no-op.
@visibleForTesting
Future<void> migrateLegacyTokensIfNeeded({
  required NativeAuthTokenBridge android,
  required Future<String?> Function() readLegacyAccess,
  required Future<String?> Function() readLegacyRefresh,
  required Future<void> Function() deleteLegacyTokens,
}) async {
  final existing = await android.readAccessToken();
  if (existing != null && existing.isNotEmpty) return;

  final access = await readLegacyAccess();
  final refresh = await readLegacyRefresh();
  if (access == null || access.isEmpty || refresh == null || refresh.isEmpty) {
    return;
  }

  await android.writeTokens(access: access, refresh: refresh);
  await deleteLegacyTokens();
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
TokenStore tokenStore(Ref ref) => FlutterSecureStorageTokenStore(
      androidBridge: defaultTargetPlatform == TargetPlatform.android
          ? const MethodChannelAuthTokenBridge()
          : null,
    );
