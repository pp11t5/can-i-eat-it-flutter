import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// 카카오 SDK 얇은 래퍼 (ADR-0007 §3-1 (6-A)).
///
/// 테스트에서는 이 클래스를 override 해 실 SDK 호출을 차단한다.
/// 실기기 라이브 로그인은 이연(베타 이후 확인).
abstract interface class KakaoAuthService {
  /// 카카오 로그인을 수행하고 OIDC idToken 과 사용자 정보를 반환한다.
  ///
  /// 스코프: email, nickname (ADR-0007 §3-1 (6-A)).
  Future<KakaoAuthResult> signIn();

  /// 카카오 로그아웃 (SDK 세션 해제).
  Future<void> signOut();
}

/// [KakaoAuthService.signIn] 결과.
class KakaoAuthResult {
  const KakaoAuthResult({
    required this.idToken,
    required this.email,
    required this.nickname,
  });

  final String idToken;
  final String? email;
  final String? nickname;
}

/// 실 카카오 SDK 구현.
class KakaoAuthServiceImpl implements KakaoAuthService {
  @override
  Future<KakaoAuthResult> signIn() async {
    // 카카오 앱/웹 로그인 시도
    OAuthToken token;
    if (await isKakaoTalkInstalled()) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
      } catch (_) {
        // 카카오톡 설치돼 있어도 로그인 실패 시 웹으로 폴백
        token = await UserApi.instance.loginWithKakaoAccount();
      }
    } else {
      token = await UserApi.instance.loginWithKakaoAccount();
    }

    // OIDC idToken 확인
    final idToken = token.idToken;
    if (idToken == null) {
      throw StateError('kakao idToken 이 null 입니다. OIDC 스코프를 확인하세요.');
    }

    // 사용자 정보 조회 (email, nickname 스코프)
    final user = await UserApi.instance.me();
    final email = user.kakaoAccount?.email;
    final nickname = user.kakaoAccount?.profile?.nickname;

    return KakaoAuthResult(
      idToken: idToken,
      email: email,
      nickname: nickname,
    );
  }

  @override
  Future<void> signOut() async {
    await UserApi.instance.logout();
  }
}
