import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/push/fcm_providers.dart';
import 'package:can_i_eat_it/core/push/fcm_repository.dart';
import 'package:can_i_eat_it/core/push/fcm_token_service.dart';

// ---------------------------------------------------------------------------
// Fake 구현체
// ---------------------------------------------------------------------------

/// [FcmRepository] fake — 호출 기록·에러 주입용.
class _FakeFcmRepository implements FcmRepository {
  final List<({String token, String platform})> registered = [];
  int deleteCount = 0;
  bool throwOnRegister = false;
  bool throwOnDelete = false;

  @override
  Future<void> register({
    required String token,
    required String platform,
  }) async {
    if (throwOnRegister) throw const NetworkFailure('register failed');
    registered.add((token: token, platform: platform));
  }

  @override
  Future<void> delete() async {
    if (throwOnDelete) throw const NetworkFailure('delete failed');
    deleteCount++;
  }
}

/// [FcmTokenService] fake — getToken 반환값·플랫폼·갱신 스트림 제어용.
class _FakeFcmTokenService implements FcmTokenService {
  String? tokenToReturn;
  bool throwOnGetToken = false;
  final String? platformOverride;
  final StreamController<String> _refreshCtrl =
      StreamController<String>.broadcast();

  _FakeFcmTokenService({this.platformOverride, this.tokenToReturn});

  @override
  String? get platform => platformOverride;

  @override
  Future<void> requestPermission() async {}

  @override
  Future<String?> currentToken() async {
    if (throwOnGetToken) throw Exception('apns-token-not-set');
    return tokenToReturn;
  }

  @override
  Stream<String> get onTokenRefresh => _refreshCtrl.stream;

  void emitRefresh(String token) => _refreshCtrl.add(token);

  Future<void> close() => _refreshCtrl.close();
}

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  // -------------------------------------------------------------------------
  // registerCurrentToken
  // -------------------------------------------------------------------------
  group('FcmLifecycle.registerCurrentToken', () {
    test('android — 토큰 취득 성공 시 POST /fcm/tokens 호출', () async {
      final repo = _FakeFcmRepository();
      final tokenSvc = _FakeFcmTokenService(
        platformOverride: 'android',
        tokenToReturn: 'fcm-token-android',
      );
      final lifecycle = FcmLifecycle(repo: repo, tokenService: tokenSvc);

      await lifecycle.registerCurrentToken();

      expect(repo.registered.length, 1);
      expect(repo.registered.first.token, 'fcm-token-android');
      expect(repo.registered.first.platform, 'android');

      await tokenSvc.close();
    });

    test('iOS — getToken null(APNs 미설정) 시 register skip, 크래시 없음', () async {
      final repo = _FakeFcmRepository();
      final tokenSvc = _FakeFcmTokenService(
        platformOverride: 'ios',
        tokenToReturn: null, // APNs 없으면 null
      );
      final lifecycle = FcmLifecycle(repo: repo, tokenService: tokenSvc);

      // 크래시 없음이 합격 기준
      await expectLater(lifecycle.registerCurrentToken(), completes);
      expect(repo.registered, isEmpty);

      await tokenSvc.close();
    });

    test('iOS — getToken exception(APNs 미설정) 시 graceful skip, 크래시 없음', () async {
      final repo = _FakeFcmRepository();
      final tokenSvc = _FakeFcmTokenService(platformOverride: 'ios');
      tokenSvc.throwOnGetToken = true;
      final lifecycle = FcmLifecycle(repo: repo, tokenService: tokenSvc);

      await expectLater(lifecycle.registerCurrentToken(), completes);
      expect(repo.registered, isEmpty);

      await tokenSvc.close();
    });

    test('platform null(비모바일) — register 호출 skip', () async {
      final repo = _FakeFcmRepository();
      final tokenSvc = _FakeFcmTokenService(
        platformOverride: null, // 비모바일
        tokenToReturn: 'some-token',
      );
      final lifecycle = FcmLifecycle(repo: repo, tokenService: tokenSvc);

      await lifecycle.registerCurrentToken();

      expect(repo.registered, isEmpty);

      await tokenSvc.close();
    });

    test('register 실패해도 crashing 없음 — 로그인 흐름 비차단(graceful)', () async {
      final repo = _FakeFcmRepository()..throwOnRegister = true;
      final tokenSvc = _FakeFcmTokenService(
        platformOverride: 'android',
        tokenToReturn: 'token',
      );
      final lifecycle = FcmLifecycle(repo: repo, tokenService: tokenSvc);

      // 예외 throw 없이 정상 완료해야 한다.
      await expectLater(lifecycle.registerCurrentToken(), completes);

      await tokenSvc.close();
    });

    test('onTokenRefresh 이벤트 시 서버 재등록 호출', () async {
      final repo = _FakeFcmRepository();
      final tokenSvc = _FakeFcmTokenService(
        platformOverride: 'android',
        tokenToReturn: 'token-v1',
      );
      final lifecycle = FcmLifecycle(repo: repo, tokenService: tokenSvc);

      await lifecycle.registerCurrentToken();
      expect(repo.registered.length, 1);

      tokenSvc.emitRefresh('token-v2');
      // Stream listener는 비동기 — 짧게 대기
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(repo.registered.length, 2);
      expect(repo.registered.last.token, 'token-v2');

      await tokenSvc.close();
    });

    test('중복 registerCurrentToken 호출 시 onTokenRefresh 구독은 1회만', () async {
      final repo = _FakeFcmRepository();
      final tokenSvc = _FakeFcmTokenService(
        platformOverride: 'android',
        tokenToReturn: 'token',
      );
      final lifecycle = FcmLifecycle(repo: repo, tokenService: tokenSvc);

      await lifecycle.registerCurrentToken();
      await lifecycle.registerCurrentToken(); // 두 번째 호출

      tokenSvc.emitRefresh('refreshed-token');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // onTokenRefresh로 인한 등록은 1회만 (구독 중복 방지)
      final refreshRegs = repo.registered
          .where((r) => r.token == 'refreshed-token')
          .toList();
      expect(refreshRegs.length, 1);

      await tokenSvc.close();
    });
  });

  // -------------------------------------------------------------------------
  // deleteToken
  // -------------------------------------------------------------------------
  group('FcmLifecycle.deleteToken', () {
    test('DELETE /fcm/tokens 호출', () async {
      final repo = _FakeFcmRepository();
      final tokenSvc = _FakeFcmTokenService(platformOverride: 'android');
      final lifecycle = FcmLifecycle(repo: repo, tokenService: tokenSvc);

      await lifecycle.deleteToken();

      expect(repo.deleteCount, 1);
      await tokenSvc.close();
    });

    test('delete 실패해도 crashing 없음 — 로그아웃 흐름 비차단(graceful)', () async {
      final repo = _FakeFcmRepository()..throwOnDelete = true;
      final tokenSvc = _FakeFcmTokenService(platformOverride: 'android');
      final lifecycle = FcmLifecycle(repo: repo, tokenService: tokenSvc);

      await expectLater(lifecycle.deleteToken(), completes);
      await tokenSvc.close();
    });

    test('deleteToken 후 onTokenRefresh 구독 해제 — 이후 이벤트 무시', () async {
      final repo = _FakeFcmRepository();
      final tokenSvc = _FakeFcmTokenService(
        platformOverride: 'android',
        tokenToReturn: 'token',
      );
      final lifecycle = FcmLifecycle(repo: repo, tokenService: tokenSvc);

      await lifecycle.registerCurrentToken();
      final registeredBefore = repo.registered.length;

      await lifecycle.deleteToken();
      tokenSvc.emitRefresh('should-not-register');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      // 구독 해제 후 refresh 이벤트는 처리 안 됨
      expect(repo.registered.length, registeredBefore);

      await tokenSvc.close();
    });
  });
}
