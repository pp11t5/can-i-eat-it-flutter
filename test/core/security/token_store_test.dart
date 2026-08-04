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

    test('markConsentPending과 clearConsentPending이 사용자 상태를 보존·해제한다', () async {
      await store.markConsentPending('user-1');
      expect(await store.readPendingConsentUserId(), 'user-1');

      await store.clearConsentPending();
      expect(await store.readPendingConsentUserId(), isNull);
    });

    test('clear는 토큰과 약관 pending을 함께 삭제한다', () async {
      await store.writeTokens(access: 'acc', refresh: 'ref');
      await store.markConsentPending('user-1');

      await store.clear();

      expect(await store.readAccessToken(), isNull);
      expect(await store.readRefreshToken(), isNull);
      expect(await store.readPendingConsentUserId(), isNull);
    });
  });
}
