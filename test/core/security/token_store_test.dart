import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_eat_it/core/security/token_store.dart';

void main() {
  group('InMemoryTokenStore — 계약 검증', () {
    late InMemoryTokenStore store;

    setUp(() => store = InMemoryTokenStore());

    test('초기 상태에서 readAccessToken 은 null 이다', () async {
      expect(await store.readAccessToken(), isNull);
    });

    test('초기 상태에서 readRefreshToken 은 null 이다', () async {
      expect(await store.readRefreshToken(), isNull);
    });

    test('writeTokens 후 readAccessToken 이 저장값을 반환한다', () async {
      await store.writeTokens(access: 'acc', refresh: 'ref');
      expect(await store.readAccessToken(), 'acc');
    });

    test('writeTokens 후 readRefreshToken 이 저장값을 반환한다', () async {
      await store.writeTokens(access: 'acc', refresh: 'ref');
      expect(await store.readRefreshToken(), 'ref');
    });

    test('clear 후 두 토큰 모두 null 이 된다', () async {
      await store.writeTokens(access: 'acc', refresh: 'ref');
      await store.clear();
      expect(await store.readAccessToken(), isNull);
      expect(await store.readRefreshToken(), isNull);
    });

    test('writeTokens 를 두 번 호출하면 최신 값으로 덮어쓴다', () async {
      await store.writeTokens(access: 'acc1', refresh: 'ref1');
      await store.writeTokens(access: 'acc2', refresh: 'ref2');
      expect(await store.readAccessToken(), 'acc2');
      expect(await store.readRefreshToken(), 'ref2');
    });
  });
}
