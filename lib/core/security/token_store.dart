import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  /// 액세스·리프레시 토큰을 함께 저장한다.
  Future<void> writeTokens({
    required String access,
    required String refresh,
  });

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

  @override
  Future<String?> readAccessToken() => _storage.read(key: _keyAccess);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _keyRefresh);

  @override
  Future<void> writeTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _keyAccess, value: access);
    await _storage.write(key: _keyRefresh, value: refresh);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _keyAccess);
    await _storage.delete(key: _keyRefresh);
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

  @override
  Future<String?> readAccessToken() async => _access;

  @override
  Future<String?> readRefreshToken() async => _refresh;

  @override
  Future<void> writeTokens({
    required String access,
    required String refresh,
  }) async {
    _access = access;
    _refresh = refresh;
  }

  @override
  Future<void> clear() async {
    _access = null;
    _refresh = null;
  }
}

// ---------------------------------------------------------------------------
// Riverpod Provider
// ---------------------------------------------------------------------------

/// 앱 전역 [TokenStore] provider.
///
/// 테스트에서는 `ProviderContainer(overrides: [tokenStoreProvider.overrideWithValue(...)])` 로 교체한다.
@riverpod
TokenStore tokenStore(Ref ref) => FlutterSecureStorageTokenStore();
