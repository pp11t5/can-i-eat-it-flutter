import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/security/native_auth_token_bridge.dart';
import 'package:can_i_eat_it/core/security/token_store.dart';

class _FakeAndroidBridge implements NativeAuthTokenBridge {
  String? access;
  String? refresh;
  int writeCount = 0;

  @override
  Future<String?> readAccessToken() async => access;

  @override
  Future<String?> readRefreshToken() async => refresh;

  @override
  Future<void> writeTokens({
    required String access,
    required String refresh,
  }) async {
    writeCount++;
    this.access = access;
    this.refresh = refresh;
  }

  @override
  Future<void> clearTokens() async {
    access = null;
    refresh = null;
  }
}

void main() {
  group('migrateLegacyTokensIfNeeded', () {
    test('네이티브가 비어 있으면 FSS 값을 복사하고 레거시를 지운다', () async {
      final android = _FakeAndroidBridge();
      var legacyAccess = 'acc';
      var legacyRefresh = 'ref';
      var deleted = false;

      await migrateLegacyTokensIfNeeded(
        android: android,
        readLegacyAccess: () async => legacyAccess,
        readLegacyRefresh: () async => legacyRefresh,
        deleteLegacyTokens: () async {
          deleted = true;
          legacyAccess = '';
          legacyRefresh = '';
        },
      );

      expect(android.access, 'acc');
      expect(android.refresh, 'ref');
      expect(android.writeCount, 1);
      expect(deleted, isTrue);
    });

    test('네이티브에 이미 access가 있으면 레거시를 건드리지 않는다', () async {
      final android = _FakeAndroidBridge()
        ..access = 'native-acc'
        ..refresh = 'native-ref';
      var deleted = false;

      await migrateLegacyTokensIfNeeded(
        android: android,
        readLegacyAccess: () async => 'old-acc',
        readLegacyRefresh: () async => 'old-ref',
        deleteLegacyTokens: () async => deleted = true,
      );

      expect(android.access, 'native-acc');
      expect(android.writeCount, 0);
      expect(deleted, isFalse);
    });

    test('레거시 쌍이 불완전하면 복사하지 않는다', () async {
      final android = _FakeAndroidBridge();

      await migrateLegacyTokensIfNeeded(
        android: android,
        readLegacyAccess: () async => 'acc',
        readLegacyRefresh: () async => null,
        deleteLegacyTokens: () async {},
      );

      expect(android.access, isNull);
      expect(android.writeCount, 0);
    });
  });

  group('MethodChannelAuthTokenBridge', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    const channel = MethodChannel('canieatit/auth_tokens');
    String? access;
    String? refresh;

    setUp(() {
      access = null;
      refresh = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        switch (call.method) {
          case 'readAccessToken':
            return access;
          case 'readRefreshToken':
            return refresh;
          case 'writeTokens':
            final args = Map<String, dynamic>.from(call.arguments as Map);
            access = args['access'] as String?;
            refresh = args['refresh'] as String?;
            return null;
          case 'clearTokens':
            access = null;
            refresh = null;
            return null;
        }
        return null;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('writeTokens 후 read가 저장값을 반환한다', () async {
      const bridge = MethodChannelAuthTokenBridge();
      await bridge.writeTokens(access: 'a1', refresh: 'r1');
      expect(await bridge.readAccessToken(), 'a1');
      expect(await bridge.readRefreshToken(), 'r1');
    });

    test('clearTokens 후 둘 다 null이다', () async {
      const bridge = MethodChannelAuthTokenBridge();
      await bridge.writeTokens(access: 'a1', refresh: 'r1');
      await bridge.clearTokens();
      expect(await bridge.readAccessToken(), isNull);
      expect(await bridge.readRefreshToken(), isNull);
    });
  });
}
