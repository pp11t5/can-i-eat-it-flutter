import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// FirebaseMessaging 래퍼 — 권한 요청·토큰 취득·갱신 스트림.
///
/// APNs 부재(iOS) 시 [currentToken]은 null 반환(graceful) — 크래시 금지.
class FcmTokenService {
  FirebaseMessaging get _fm => FirebaseMessaging.instance;

  /// 현재 플랫폼 문자열. "ios" | "android". 비모바일이면 null → 호출측에서 skip.
  String? get platform {
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return null;
  }

  /// 권한 요청. iOS APNs 추후라도 호출 자체는 안전.
  Future<void> requestPermission() async {
    try {
      await _fm.requestPermission();
    } catch (e) {
      debugPrint('[FCM] requestPermission failed (ignored): $e');
    }
  }

  /// 현재 FCM 토큰. APNs 부재(iOS) 등으로 실패하면 null 반환(graceful).
  Future<String?> currentToken() async {
    try {
      final token = await _fm.getToken();
      return (token != null && token.isNotEmpty) ? token : null;
    } catch (e) {
      // iOS APNs 미설정: "apns-token-not-set" 류. 크래시 금지, 등록 skip.
      debugPrint('[FCM] getToken failed (skip register): $e');
      return null;
    }
  }

  /// 토큰 갱신 스트림. 로그인 후 구독하여 서버 토큰을 최신 상태로 유지.
  Stream<String> get onTokenRefresh => _fm.onTokenRefresh;
}
