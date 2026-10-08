import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// 카카오 SDK 얇은 래퍼 (ADR-0007 §3-1 (6-A)).
///
/// 테스트에서는 이 클래스를 override 해 실 SDK 호출을 차단한다.
/// 실기기 라이브 로그인은 이연(베타 이후 확인).
abstract interface class KakaoAuthService {
  /// 카카오 로그인을 수행하고 OIDC idToken 과 사용자 정보를 반환한다.
  ///
  /// [useKakaoAccount]가 true면 카카오톡 대신 계정 재로그인을 요청한다.
  /// 스코프: email, nickname (ADR-0007 §3-1 (6-A)).
  Future<KakaoAuthResult> signIn({bool useKakaoAccount = false});

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
  KakaoAuthServiceImpl({
    UserApi? userApi,
    Future<bool> Function()? isTalkInstalled,
  })  : _userApi = userApi ?? UserApi.instance,
        _isTalkInstalled = isTalkInstalled ?? isKakaoTalkInstalled;

  final UserApi _userApi;
  final Future<bool> Function() _isTalkInstalled;

  Future<OAuthToken> _login({required bool useKakaoAccount}) async {
    if (useKakaoAccount) {
      return _userApi.loginWithKakaoAccount(prompts: [Prompt.login]);
    }
    if (await _isTalkInstalled()) {
      try {
        return await _userApi.loginWithKakaoTalk();
      } catch (error) {
        if (error is KakaoClientException &&
            error.reason == ClientErrorCause.cancelled) {
          rethrow;
        }
        _debugLog('카카오톡 인증 실패: 계정 로그인으로 전환');
      }
    }
    return _userApi.loginWithKakaoAccount();
  }

  @override
  Future<KakaoAuthResult> signIn({bool useKakaoAccount = false}) async {
    var stage = useKakaoAccount ? '계정 로그인 시작' : '카카오톡 로그인 시작';
    try {
      _debugLog(stage);

      final token = await _login(useKakaoAccount: useKakaoAccount);

      stage = 'SDK 토큰 수신';
      _debugLog('$stage (idToken=${token.idToken != null ? '있음' : '없음'})');

      // OIDC idToken 확인
      final idToken = token.idToken;
      if (idToken == null) {
        _debugLog('$stage 실패: OIDC idToken이 없습니다.');
        throw StateError('kakao idToken 이 null 입니다. OIDC 스코프를 확인하세요.');
      }

      stage = '사용자 정보 조회';
      _debugLog(stage);
      final user = await _userApi.me();
      final email = user.kakaoAccount?.email;
      final nickname = user.kakaoAccount?.profile?.nickname;
      _debugLog(
        '$stage 완료 (email=${email != null ? '있음' : '없음'}, '
        'nickname=${nickname != null ? '있음' : '없음'})',
      );

      return KakaoAuthResult(
        idToken: idToken,
        email: email,
        nickname: nickname,
      );
    } catch (error, stackTrace) {
      _debugLog(
        '$stage 실패: ${error.runtimeType}: ${_redactSensitiveValues(error.toString())}',
      );
      if (kDebugMode) debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _userApi.logout();
  }
}

/// 카카오 로그인 진단 로그. debug 빌드에서만 출력하며 토큰·인가 코드는 남기지 않는다.
void _debugLog(String message) {
  if (kDebugMode) debugPrint('[KakaoAuth] $message');
}

String _redactSensitiveValues(String value) {
  return value.replaceAllMapped(
    RegExp(
      r'\b(access[_-]?token|refresh[_-]?token|id[_-]?token|'
      r'authorization[_-]?code|code)\b([=:]\s*|%3D)[^,\s&}]+',
      caseSensitive: false,
    ),
    (match) => '${match.group(1)}=***',
  );
}
