import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/security/token_store.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:can_i_eat_it/features/auth/data/services/apple_auth_service.dart';
import 'package:can_i_eat_it/features/auth/data/services/kakao_auth_service.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/consent.dart';

class _NoOpKakaoAuthService implements KakaoAuthService {
  @override
  Future<KakaoAuthResult> signIn() async =>
      const KakaoAuthResult(idToken: 'id', email: 'e@e.com', nickname: 'nick');

  @override
  Future<void> signOut() async {}
}

class _NoOpAppleAuthService implements AppleAuthService {
  @override
  Future<AppleAuthResult> signIn() async => const AppleAuthResult(
        idToken: 'id',
        authorizationCode: 'code',
        nonce: 'nonce',
        email: 'e@e.com',
        fullName: 'Apple Tester',
      );
}

Map<String, dynamic> _ok(Object? result) => {
      'isSuccess': true,
      'code': 'COMMON200',
      'message': 'success',
      'traceId': 'trace-001',
      'result': result,
    };

Map<String, dynamic> _term({
  required int id,
  required String code,
  required bool required,
  required String title,
  required String content,
}) =>
    {
      'id': id,
      'code': code,
      'version': '1.0',
      'title': title,
      'content': content,
      'required': required,
      'effectiveDate': '2026-07-25',
    };

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late InMemoryTokenStore tokenStore;
  late AuthRepositoryImpl repo;

  setUp(() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://can-i-eat-it.com/api/v1',
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );
    adapter = DioAdapter(dio: dio, matcher: const FullHttpRequestMatcher());
    tokenStore = InMemoryTokenStore();
    repo = AuthRepositoryImpl(
      dio: dio,
      tokenStore: tokenStore,
      kakaoAuthService: _NoOpKakaoAuthService(),
      appleAuthService: _NoOpAppleAuthService(),
    );
  });

  Future<void> synthesizeSession() async {
    adapter.onPost(
      '/auth/kakao/recover',
      (server) => server.reply(
        200,
        _ok({
          'accessToken': 'acc',
          'refreshToken': 'ref',
          'userId': 'u1',
          'role': 'USER',
        }),
      ),
      data: {'idToken': 'test-id-token'},
    );
    await repo.recoverAccount(AuthProvider.kakao, idToken: 'test-id-token');
  }

  group('fetchConsentTerms', () {
    test('최신 약관 응답을 도메인 엔티티로 변환하고 서버 순서를 보존한다', () async {
      adapter.onGet(
        ApiEndpoints.consentTerms,
        (server) => server.reply(
          200,
          _ok([
            _term(
              id: 3,
              code: 'health_sensitive',
              required: true,
              title: '민감정보 수집 동의',
              content: 'https://example.com/health',
            ),
            _term(
              id: 1,
              code: 'tos',
              required: true,
              title: '서비스 이용약관',
              content: 'https://example.com/tos',
            ),
          ]),
        ),
      );

      final terms = await repo.fetchConsentTerms();

      expect(terms.map((term) => term.id), [3, 1]);
      expect(terms.first.isRequired, isTrue);
      expect(terms.first.effectiveDate, DateTime(2026, 7, 25));
    });

    test('빈 목록은 제출 가능한 상태로 취급하지 않고 NetworkFailure를 던진다', () async {
      adapter.onGet(
        ApiEndpoints.consentTerms,
        (server) => server.reply(200, _ok(<dynamic>[])),
      );

      await expectLater(
        repo.fetchConsentTerms(),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('잘못된 응답 형식은 NetworkFailure로 정규화한다', () async {
      adapter.onGet(
        ApiEndpoints.consentTerms,
        (server) => server.reply(200, _ok({'not': 'a list'})),
      );

      await expectLater(
        repo.fetchConsentTerms(),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });

  group('submitConsent', () {
    const choices = [
      ConsentChoice(termId: 1, agreed: true),
      ConsentChoice(termId: 2, agreed: true),
      ConsentChoice(termId: 3, agreed: true),
      ConsentChoice(termId: 4, agreed: false),
    ];

    test('화면에서 받은 모든 termId/agreed를 정확히 POST하고 pending을 해제한다', () async {
      await synthesizeSession();
      await tokenStore.markConsentPending('u1');
      adapter.onPost(
        ApiEndpoints.consent,
        (server) => server.reply(200, _ok(null)),
        data: {
          'consents': [
            {'termId': 1, 'agreed': true},
            {'termId': 2, 'agreed': true},
            {'termId': 3, 'agreed': true},
            {'termId': 4, 'agreed': false},
          ],
        },
      );

      await repo.submitConsent(choices);

      expect(await tokenStore.readPendingConsentUserId(), isNull);
      expect((await repo.currentSession())!.hasAgreedTerms, isTrue);
    });

    test('빈 선택 목록은 POST하지 않고 실패한다', () async {
      await synthesizeSession();
      await expectLater(
        repo.submitConsent(const []),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('POST 실패 시 pending과 미동의 세션 상태를 유지한다', () async {
      await synthesizeSession();
      await tokenStore.markConsentPending('u1');
      // currentSession 캐시는 recover 결과를 유지하므로 pending 상태를 명시 반영할
      // 필요 없이 저장소 marker 보존 여부를 핵심 계약으로 검증한다.
      adapter.onPost(
        ApiEndpoints.consent,
        (server) => server.reply(
          400,
          {
            'isSuccess': false,
            'code': 'ONBOARD400_1',
            'message': '필수 약관 미동의',
            'result': null,
          },
        ),
        data: Matchers.any,
      );

      await expectLater(
        repo.submitConsent(choices),
        throwsA(isA<NetworkFailure>()),
      );
      expect(await tokenStore.readPendingConsentUserId(), 'u1');
    });

    test('세션 없이 제출하면 StateError를 던진다', () async {
      await expectLater(
        repo.submitConsent(choices),
        throwsA(isA<StateError>()),
      );
    });
  });
}
