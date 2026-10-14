import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'package:can_i_eat_it/features/auth/data/services/kakao_auth_service.dart';

class _FakeUserApi extends UserApi {
  _FakeUserApi() : super(Dio());

  final calls = <String>[];
  List<Prompt>? accountPrompts;
  Object? talkError;
  Object? accountError;
  String? idToken = 'test-id-token';

  OAuthToken get token => OAuthToken(
        'access-token',
        DateTime(2030),
        null,
        null,
        null,
        idToken: idToken,
      );

  @override
  Future<OAuthToken> loginWithKakaoTalk({
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? nonce,
  }) async {
    calls.add('talk');
    if (talkError != null) throw talkError!;
    return token;
  }

  @override
  Future<OAuthToken> loginWithKakaoAccount({
    List<Prompt>? prompts,
    List<String>? channelPublicIds,
    List<String>? serviceTerms,
    String? loginHint,
    String? nonce,
  }) async {
    calls.add('account');
    accountPrompts = prompts;
    if (accountError != null) throw accountError!;
    return token;
  }

  @override
  Future<User> me(
      {List<String>? properties, bool secureResource = true}) async {
    calls.add('me');
    return User.fromJson({
      'id': 1,
      'kakao_account': {
        'email': 'test@example.com',
        'profile': {'nickname': 'tester'},
      },
    });
  }
}

void main() {
  late _FakeUserApi api;
  late KakaoAuthServiceImpl service;
  late bool installed;
  late int installationChecks;

  setUp(() {
    api = _FakeUserApi();
    installed = true;
    installationChecks = 0;
    service = KakaoAuthServiceImpl(
      userApi: api,
      isTalkInstalled: () async {
        installationChecks++;
        return installed;
      },
    );
  });

  test('installed: uses Talk and returns OIDC credentials', () async {
    final result = await service.signIn();
    expect(api.calls, ['talk', 'me']);
    expect(result.idToken, 'test-id-token');
    expect(result.email, 'test@example.com');
    expect(result.nickname, 'tester');
  });

  test('not installed: falls back to Account without forced login', () async {
    installed = false;
    await service.signIn();
    expect(api.calls, ['account', 'me']);
    expect(api.accountPrompts, isNull);
  });

  test('Talk error: falls back to Account', () async {
    api.talkError = StateError('Talk failed');
    await service.signIn();
    expect(api.calls, ['talk', 'account', 'me']);
  });

  test('explicit Account: forces login and skips Talk installation check',
      () async {
    await service.signIn(useKakaoAccount: true);
    expect(api.calls, ['account', 'me']);
    expect(api.accountPrompts, [Prompt.login]);
    expect(installationChecks, 0);
  });

  final cancellations = <String, Object>{
    'SDK cancelled':
        KakaoClientException(ClientErrorCause.cancelled, 'cancelled'),
    'native CANCELED': PlatformException(code: 'CANCELED'),
    'consent denied':
        KakaoAuthException(AuthErrorCause.accessDenied, 'User denied access'),
  };
  for (final entry in cancellations.entries) {
    test('Talk ${entry.key}: propagates without Account fallback', () async {
      api.talkError = entry.value;
      await expectLater(service.signIn(), throwsA(same(entry.value)));
      expect(api.calls, ['talk']);
    });

    for (final useAccount in [false, true]) {
      test('Account ${entry.key}: propagates, explicit=$useAccount', () async {
        installed = false;
        api.accountError = entry.value;
        await expectLater(
          service.signIn(useKakaoAccount: useAccount),
          throwsA(same(entry.value)),
        );
        expect(api.calls, ['account']);
      });
    }
  }

  test('non-cancellation SDK errors remain failures', () {
    expect(isKakaoSignInCancelled(PlatformException(code: 'FAILED')), isFalse);
    expect(
        isKakaoSignInCancelled(
          KakaoAuthException(AuthErrorCause.serverError, 'server error'),
        ),
        isFalse);
  });

  test('missing OIDC token fails before user lookup, without fallback',
      () async {
    api.idToken = null;
    await expectLater(service.signIn(), throwsStateError);
    expect(api.calls, ['talk']);
  });
}
