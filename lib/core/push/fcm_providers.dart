import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';

import 'fcm_repository.dart';
import 'fcm_token_service.dart';

part 'fcm_providers.g.dart';

// ---------------------------------------------------------------------------
// Provider 배선
// ---------------------------------------------------------------------------

@riverpod
FcmRepository fcmRepository(Ref ref) =>
    FcmRepositoryImpl(dio: ref.watch(dioProvider));

@riverpod
FcmTokenService fcmTokenService(Ref ref) => FcmTokenService();

@riverpod
FcmLifecycle fcmLifecycle(Ref ref) {
  final instance = FcmLifecycle(
    repo: ref.watch(fcmRepositoryProvider),
    tokenService: ref.watch(fcmTokenServiceProvider),
  );
  ref.onDispose(instance.cancelRefreshSubscription);
  return instance;
}

// ---------------------------------------------------------------------------
// FcmLifecycle — 토큰 등록/삭제 + onTokenRefresh 구독
// ---------------------------------------------------------------------------

/// FCM 토큰 라이프사이클 관리.
///
/// - [registerCurrentToken]: 로그인 성공 후 호출 (권한 요청 + 토큰 등록 + onTokenRefresh 구독).
/// - [deleteToken]: 로그아웃/탈퇴 **전** 호출 (Bearer 유효 시점, 서버 삭제 + 구독 해제).
///
/// 모든 FCM 부수효과는 try/catch로 감싸 인증 흐름을 절대 막지 않는다(graceful 원칙).
class FcmLifecycle {
  FcmLifecycle({
    required FcmRepository repo,
    required FcmTokenService tokenService,
  })  : _repo = repo,
        _tokenService = tokenService;

  final FcmRepository _repo;
  final FcmTokenService _tokenService;
  StreamSubscription<String>? _refreshSub;

  /// 로그인 성공 후 호출.
  ///
  /// 1. 권한 요청
  /// 2. 토큰 취득 (iOS APNs 미설정 시 null → skip)
  /// 3. 서버 등록 (`POST /fcm/tokens`)
  /// 4. onTokenRefresh 구독 (중복 구독 방지)
  Future<void> registerCurrentToken() async {
    await _tokenService.requestPermission();

    final platform = _tokenService.platform;
    if (platform == null) return; // 비모바일 skip

    final String? token;
    try {
      token = await _tokenService.currentToken();
    } catch (e) {
      // iOS APNs 미설정 등 — graceful skip.
      debugPrint('[FCM] currentToken() failed (skip register): $e');
      return;
    }
    if (token == null) {
      // APNs 부재 등으로 null 반환 — graceful skip. 크래시 없음이 합격 기준.
      return;
    }

    try {
      await _repo.register(token: token, platform: platform);
    } catch (e) {
      // 등록 실패는 앱 흐름을 막지 않는다 (로그인은 이미 성공).
      debugPrint('[FCM] register failed (ignored): $e');
    }

    // 토큰 회전 대응 — 중복 구독 방지.
    _refreshSub ??= _tokenService.onTokenRefresh.listen((newToken) async {
      try {
        await _repo.register(token: newToken, platform: platform);
      } catch (e) {
        debugPrint('[FCM] onTokenRefresh register failed (ignored): $e');
      }
    });
  }

  /// 로그아웃/탈퇴 전 호출(Bearer 유효 시점).
  ///
  /// 서버 토큰 삭제 (`DELETE /fcm/tokens`) + onTokenRefresh 구독 해제.
  /// 실패해도 로그아웃 흐름은 계속된다.
  Future<void> deleteToken() async {
    await _refreshSub?.cancel();
    _refreshSub = null;
    try {
      await _repo.delete();
    } catch (e) {
      // 삭제 실패해도 로그아웃 흐름은 계속.
      debugPrint('[FCM] delete failed (ignored): $e');
    }
  }

  /// onTokenRefresh 구독만 해제 (서버 호출 없음).
  ///
  /// provider dispose 시 또는 오프라인 signOut(서버 호출 불가) 시 호출.
  /// [deleteToken]과 달리 서버 DELETE를 시도하지 않는다.
  void cancelRefreshSubscription() {
    _refreshSub?.cancel();
    _refreshSub = null;
  }
}
