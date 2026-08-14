import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:can_i_eat_it/core/config/flavor_config.dart';

/// Google Sign-In 얇은 래퍼. [KakaoAuthService] 를 미러한다.
///
/// 테스트에서는 이 클래스를 override 해 실 SDK 호출을 차단한다.
abstract interface class GoogleAuthService {
  /// Google 로그인을 수행하고 서버 검증용 OIDC idToken 을 반환한다.
  Future<GoogleAuthResult> signIn();

  /// Google SDK 세션 해제.
  Future<void> signOut();
}

/// [GoogleAuthService.signIn] 결과.
class GoogleAuthResult {
  const GoogleAuthResult({required this.idToken});

  final String idToken;
}

/// 사용자가 Google 계정 선택 UI 를 닫거나 취소한 경우.
class GoogleSignInCancelledException implements Exception {
  const GoogleSignInCancelledException();
}

/// 실 Google Sign-In SDK 구현.
class GoogleAuthServiceImpl implements GoogleAuthService {
  GoogleAuthServiceImpl({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: const ['email', 'openid'],
              serverClientId: _serverClientIdOrNull,
            );

  final GoogleSignIn _googleSignIn;

  static String? get _serverClientIdOrNull {
    final id = FlavorConfig.current.googleServerClientId;
    return id.isEmpty ? null : id;
  }

  @override
  Future<GoogleAuthResult> signIn() async {
    var stage = 'Google 로그인 시작';
    try {
      if (FlavorConfig.current.googleServerClientId.isEmpty) {
        throw StateError(
          'google serverClientId 가 비어 있습니다. '
          '--dart-define=GOOGLE_SERVER_CLIENT_ID 를 확인하세요.',
        );
      }

      _debugLog(stage);
      final account = await _googleSignIn.signIn();
      if (account == null) {
        throw const GoogleSignInCancelledException();
      }

      stage = 'SDK 토큰 수신';
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        _debugLog('$stage 실패: OIDC idToken이 없습니다.');
        throw StateError(
          'google idToken 이 null 입니다. serverClientId(Web 클라이언트 ID)를 확인하세요.',
        );
      }

      return GoogleAuthResult(idToken: idToken);
    } on GoogleSignInCancelledException {
      rethrow;
    } catch (error, stackTrace) {
      _debugLog('$stage 실패: ${error.runtimeType}');
      if (kDebugMode) debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // 로컬 세션 해제가 우선. SDK 실패는 삼킨다.
    }
  }
}

void _debugLog(String message) {
  if (kDebugMode) debugPrint('[GoogleAuth] $message');
}
