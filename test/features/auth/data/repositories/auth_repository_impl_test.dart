import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/security/token_store.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:can_i_eat_it/features/auth/data/services/kakao_auth_service.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/sign_in_outcome.dart';

// ---------------------------------------------------------------------------
// 테스트용 KakaoAuthService stub
// ---------------------------------------------------------------------------

class _StubKakaoAuthService implements KakaoAuthService {
  _StubKakaoAuthService({required this.idToken});

  final String idToken;

  @override
  Future<KakaoAuthResult> signIn() async => KakaoAuthResult(
        idToken: idToken,
        email: 'test@example.com',
        nickname: 'testuser',
      );

  @override
  Future<void> signOut() async {}
}

// ---------------------------------------------------------------------------
// 공통 봉투 헬퍼
// ---------------------------------------------------------------------------

Map<String, dynamic> _envelope(Object? result, {bool isSuccess = true}) => {
      'isSuccess': isSuccess,
      'code': isSuccess ? 'SUCCESS' : 'AUTH400_1',
      'message': isSuccess ? 'success' : 'terms required',
      'traceId': 'trace-test-001',
      'result': result,
    };

Map<String, dynamic> _errorEnvelope(String code, {String? message}) => {
      'isSuccess': false,
      'code': code,
      'message': message ?? 'error',
      'traceId': 'trace-test-001',
      'result': null,
    };

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late InMemoryTokenStore tokenStore;
  late AuthRepositoryImpl repo;

  setUp(() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://can-i-eat-it.com/api/v1',
      // 400/403 은 throw 하지 않고 datasource 에 전달 (dio_client.dart 와 동일 정책)
      validateStatus: (status) => status != null && status != 401 && status < 500,
    ));
    dioAdapter = DioAdapter(dio: dio, matcher: const FullHttpRequestMatcher());
    tokenStore = InMemoryTokenStore();
    repo = AuthRepositoryImpl(
      dio: dio,
      tokenStore: tokenStore,
      kakaoAuthService: _StubKakaoAuthService(idToken: 'test-id-token'),
    );
  });

  group('signInWithKakao — HTTP 200 → Authenticated', () {
    test('200 성공 + onboarding/status → Authenticated(onboarded=true)', () async {
      dioAdapter
        ..onPost(
          '/auth/kakao/login',
          (server) => server.reply(200, _envelope({
            'accessToken': 'access-123',
            'refreshToken': 'refresh-456',
            'userId': 'user-1',
            'email': 'test@example.com',
            'role': 'USER',
          })),
          data: {'idToken': 'test-id-token'},
        )
        ..onGet(
          '/onboarding/status',
          (server) => server.reply(200, _envelope({'onboarded': true})),
        );

      final outcome = await repo.signInWithKakao();

      expect(outcome, isA<Authenticated>());
      final auth = outcome as Authenticated;
      expect(auth.onboarded, isTrue);
      expect(auth.session.userId, 'user-1');
      expect(auth.session.hasAgreedTerms, isTrue);
    });

    test('200 성공 + onboarding/status → Authenticated(onboarded=false)', () async {
      dioAdapter
        ..onPost(
          '/auth/kakao/login',
          (server) => server.reply(200, _envelope({
            'accessToken': 'access-123',
            'refreshToken': 'refresh-456',
            'userId': 'user-2',
            'email': 'test@example.com',
            'role': 'USER',
          })),
          data: {'idToken': 'test-id-token'},
        )
        ..onGet(
          '/onboarding/status',
          (server) => server.reply(200, _envelope({'onboarded': false})),
        );

      final outcome = await repo.signInWithKakao();

      expect(outcome, isA<Authenticated>());
      final auth = outcome as Authenticated;
      expect(auth.onboarded, isFalse);
    });

    test('200 성공 시 tokenStore 에 토큰이 저장된다', () async {
      dioAdapter
        ..onPost(
          '/auth/kakao/login',
          (server) => server.reply(200, _envelope({
            'accessToken': 'access-abc',
            'refreshToken': 'refresh-xyz',
            'userId': 'user-3',
            'email': 'test@example.com',
            'role': 'USER',
          })),
          data: {'idToken': 'test-id-token'},
        )
        ..onGet(
          '/onboarding/status',
          (server) => server.reply(200, _envelope({'onboarded': false})),
        );

      await repo.signInWithKakao();

      expect(await tokenStore.readAccessToken(), 'access-abc');
      expect(await tokenStore.readRefreshToken(), 'refresh-xyz');
    });
  });

  group('signInWithKakao — HTTP 400 → NeedsTerms', () {
    test('400 AUTH400_1 → NeedsTerms(email)', () async {
      dioAdapter.onPost(
        '/auth/kakao/login',
        (server) => server.reply(400, _errorEnvelope('AUTH400_1')),
        data: {'idToken': 'test-id-token'},
      );

      final outcome = await repo.signInWithKakao();

      expect(outcome, isA<NeedsTerms>());
      final needs = outcome as NeedsTerms;
      expect(needs.requirements, contains(TermsRequirement.email));
    });

    test('400 AUTH400_3 → NeedsTerms(nickname)', () async {
      dioAdapter.onPost(
        '/auth/kakao/login',
        (server) => server.reply(400, _errorEnvelope('AUTH400_3')),
        data: {'idToken': 'test-id-token'},
      );

      final outcome = await repo.signInWithKakao();

      expect(outcome, isA<NeedsTerms>());
      final needs = outcome as NeedsTerms;
      expect(needs.requirements, contains(TermsRequirement.nickname));
    });

    test('400 시 tokenStore 에 토큰이 저장되지 않는다', () async {
      dioAdapter.onPost(
        '/auth/kakao/login',
        (server) => server.reply(400, _errorEnvelope('AUTH400_1')),
        data: {'idToken': 'test-id-token'},
      );

      await repo.signInWithKakao();

      expect(await tokenStore.readAccessToken(), isNull);
    });
  });

  group('signInWithKakao — HTTP 403 → Recoverable', () {
    test('403 AUTH403_5 → Recoverable(deletionInProgress)', () async {
      dioAdapter.onPost(
        '/auth/kakao/login',
        (server) => server.reply(403, _errorEnvelope('AUTH403_5')),
        data: {'idToken': 'test-id-token'},
      );

      final outcome = await repo.signInWithKakao();

      expect(outcome, isA<Recoverable>());
      final rec = outcome as Recoverable;
      expect(rec.reason, RecoverReason.deletionInProgress);
    });

    test('403 AUTH403_2 → Recoverable(inactive)', () async {
      dioAdapter.onPost(
        '/auth/kakao/login',
        (server) => server.reply(403, _errorEnvelope('AUTH403_2')),
        data: {'idToken': 'test-id-token'},
      );

      final outcome = await repo.signInWithKakao();

      expect(outcome, isA<Recoverable>());
      final rec = outcome as Recoverable;
      expect(rec.reason, RecoverReason.inactive);
    });
  });

  group('logout', () {
    test('logout 후 tokenStore 가 클리어된다', () async {
      await tokenStore.writeTokens(access: 'acc', refresh: 'ref');

      dioAdapter.onDelete(
        ApiEndpoints.authLogout,
        (server) => server.reply(200, _envelope(null)),
      );

      await repo.logout();

      expect(await tokenStore.readAccessToken(), isNull);
      expect(await tokenStore.readRefreshToken(), isNull);
    });

    test('logout 서버 실패해도 tokenStore 는 클리어된다', () async {
      await tokenStore.writeTokens(access: 'acc', refresh: 'ref');

      dioAdapter.onDelete(
        ApiEndpoints.authLogout,
        (server) => server.throws(500, DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.authLogout),
        )),
      );

      // 서버 실패해도 예외 없이 완료
      await expectLater(repo.logout(), completes);
      expect(await tokenStore.readAccessToken(), isNull);
    });
  });

  group('signOut', () {
    test('signOut 후 tokenStore 가 클리어된다', () async {
      await tokenStore.writeTokens(access: 'acc', refresh: 'ref');
      await repo.signOut();
      expect(await tokenStore.readAccessToken(), isNull);
    });
  });

  group('recoverAccount — HTTP 200', () {
    // 이 그룹의 테스트는 수정 전에는 StateError 로 실패해야 하고,
    // recoverAccount(AuthProvider) 재작성 후 통과해야 한다.

    test('recoverAccount 200 → 새 idToken 전송 + 토큰 저장 + active 세션 반환', () async {
      // 403 경로는 _session=null · 토큰 없음 상태에서 호출됨.
      // StubKakaoAuthService 가 'test-id-token' 을 반환하므로
      // POST /auth/kakao/recover 에 {idToken: 'test-id-token'} 이 전송돼야 한다.
      dioAdapter.onPost(
        '/auth/kakao/recover',
        (server) => server.reply(200, _envelope({
          'accessToken': 'recover-access',
          'refreshToken': 'recover-refresh',
          'userId': 'user-recovered',
          'email': 'test@example.com',
          'role': 'USER',
        })),
        data: {'idToken': 'test-id-token'},
      );

      final session = await repo.recoverAccount(AuthProvider.kakao);

      expect(session.userId, 'user-recovered');
      expect(session.accountStatus, AccountStatus.active);
    });

    test('recoverAccount 200 후 tokenStore 에 새 토큰이 저장된다', () async {
      dioAdapter.onPost(
        '/auth/kakao/recover',
        (server) => server.reply(200, _envelope({
          'accessToken': 'recover-access-2',
          'refreshToken': 'recover-refresh-2',
          'userId': 'user-recovered-2',
          'email': 'test@example.com',
          'role': 'USER',
        })),
        data: {'idToken': 'test-id-token'},
      );

      await repo.recoverAccount(AuthProvider.kakao);

      expect(await tokenStore.readAccessToken(), 'recover-access-2');
      expect(await tokenStore.readRefreshToken(), 'recover-refresh-2');
    });

    test('recoverAccount 는 _session=null 상태에서도 StateError 를 던지지 않는다', () async {
      // _session=null 이 전제 — 403 경로에서 토큰 미발급.
      dioAdapter.onPost(
        '/auth/kakao/recover',
        (server) => server.reply(200, _envelope({
          'accessToken': 'recover-access-3',
          'refreshToken': 'recover-refresh-3',
          'userId': 'user-recovered-3',
          'email': 'test@example.com',
          'role': 'USER',
        })),
        data: {'idToken': 'test-id-token'},
      );

      // StateError 없이 완료돼야 한다.
      await expectLater(repo.recoverAccount(AuthProvider.kakao), completes);
    });
  });

  group('withdraw', () {
    test('withdraw 서버 성공 후 tokenStore 가 클리어된다', () async {
      await tokenStore.writeTokens(access: 'acc', refresh: 'ref');

      dioAdapter.onDelete(
        ApiEndpoints.authWithdraw,
        (server) => server.reply(200, _envelope(null)),
      );

      await repo.withdraw();

      expect(await tokenStore.readAccessToken(), isNull);
      expect(await tokenStore.readRefreshToken(), isNull);
    });

    test('withdraw 서버 실패해도 tokenStore 는 클리어된다', () async {
      await tokenStore.writeTokens(access: 'acc', refresh: 'ref');

      dioAdapter.onDelete(
        ApiEndpoints.authWithdraw,
        (server) => server.throws(500, DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.authWithdraw),
        )),
      );

      await expectLater(repo.withdraw(), completes);
      expect(await tokenStore.readAccessToken(), isNull);
      expect(await tokenStore.readRefreshToken(), isNull);
    });
  });
}
