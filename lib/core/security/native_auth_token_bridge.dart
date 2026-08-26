import 'package:flutter/services.dart';

/// Android EncryptedSharedPreferences 토큰 저장소에 대한 Dart 브릿지.
///
/// iOS는 사용하지 않는다. 알림 프로세스의 네이티브 POST가 같은 저장소를 읽는다.
abstract interface class NativeAuthTokenBridge {
  Future<String?> readAccessToken();

  Future<String?> readRefreshToken();

  Future<void> writeTokens({required String access, required String refresh});

  Future<void> clearTokens();
}

/// [MethodChannel] `canieatit/auth_tokens` 구현.
class MethodChannelAuthTokenBridge implements NativeAuthTokenBridge {
  const MethodChannelAuthTokenBridge({
    MethodChannel channel = const MethodChannel('canieatit/auth_tokens'),
  }) : _channel = channel;

  final MethodChannel _channel;

  @override
  Future<String?> readAccessToken() =>
      _channel.invokeMethod<String>('readAccessToken');

  @override
  Future<String?> readRefreshToken() =>
      _channel.invokeMethod<String>('readRefreshToken');

  @override
  Future<void> writeTokens({
    required String access,
    required String refresh,
  }) async {
    await _channel.invokeMethod<void>('writeTokens', {
      'access': access,
      'refresh': refresh,
    });
  }

  @override
  Future<void> clearTokens() async {
    await _channel.invokeMethod<void>('clearTokens');
  }
}
