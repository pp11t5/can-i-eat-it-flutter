import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Apple SDK 얇은 래퍼 (ADR-0007 §3-1 (6-A)). [KakaoAuthService] 를 미러한다.
///
/// 테스트에서는 이 클래스를 override 해 실 SDK 호출을 차단한다.
///
/// ⚠️ Android 는 네이티브 Apple ID 가 없어 web flow(WebAuthenticationOptions:
/// serviceId/redirectUri)가 별도로 필요하다. 서버 콜백 엔드포인트 준비 후
/// 별도로 배선한다 — 현재는 iOS 네이티브 경로만 지원한다.
abstract interface class AppleAuthService {
  /// Apple 로그인을 수행하고 OIDC identityToken 과 사용자 정보를 반환한다.
  ///
  /// 스코프: email, fullName (ADR-0007 §3-1 (6-A)).
  Future<AppleAuthResult> signIn();
}

/// [AppleAuthService.signIn] 결과.
class AppleAuthResult {
  const AppleAuthResult({
    required this.idToken,
    required this.authorizationCode,
    required this.email,
    required this.fullName,
  });

  /// Apple identityToken (OIDC JWT) — 서버 `POST /auth/apple/login {idToken}` 로 전송.
  final String idToken;

  /// Apple authorizationCode — 서버가 추후 필요 시 확장 용도로 보관(현재 미전송).
  final String? authorizationCode;

  /// 최초 인가 시에만 제공되는 이메일.
  final String? email;

  /// 최초 인가 시에만 제공되는 전체 이름(givenName + familyName 조합).
  final String? fullName;
}

/// 실 Apple SDK 구현.
class AppleAuthServiceImpl implements AppleAuthService {
  @override
  Future<AppleAuthResult> signIn() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // OIDC identityToken 확인
    final idToken = credential.identityToken;
    if (idToken == null) {
      throw StateError('apple identityToken 이 null 입니다.');
    }

    final fullName = [credential.givenName, credential.familyName]
        .where((name) => name != null && name.isNotEmpty)
        .join(' ');

    return AppleAuthResult(
      idToken: idToken,
      authorizationCode: credential.authorizationCode,
      email: credential.email,
      fullName: fullName.isEmpty ? null : fullName,
    );
  }
}
