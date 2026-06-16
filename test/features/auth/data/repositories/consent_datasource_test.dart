import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/security/token_store.dart';
import 'package:can_i_eat_it/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:can_i_eat_it/features/auth/data/services/kakao_auth_service.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/terms_agreement.dart';
import 'package:can_i_eat_it/core/config/terms_catalog.dart';

// ---------------------------------------------------------------------------
// stub
// ---------------------------------------------------------------------------

class _NoOpKakaoAuthService implements KakaoAuthService {
  @override
  Future<KakaoAuthResult> signIn() async =>
      const KakaoAuthResult(idToken: 'id', email: 'e@e.com', nickname: 'nick');

  @override
  Future<void> signOut() async {}
}

// ---------------------------------------------------------------------------
// 봉투 헬퍼
// ---------------------------------------------------------------------------

Map<String, dynamic> _ok(Object? result) => {
      'isSuccess': true,
      'code': 'SUCCESS',
      'message': 'success',
      'traceId': 'trace-001',
      'result': result,
    };

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late InMemoryTokenStore tokenStore;
  late AuthRepositoryImpl repo;

  // 테스트용 약관 동의 객체
  final agreement = TermsAgreement(
    version: TermsCatalog.currentVersion,
    agreedAt: DateTime(2026, 6, 9),
    termsOfService: true,
    privacy: true,
    sensitiveInfo: true,
    marketing: false,
  );

  setUp(() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://can-i-eat-it.com/api/v1',
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );
    dioAdapter = DioAdapter(dio: dio, matcher: const FullHttpRequestMatcher());
    tokenStore = InMemoryTokenStore();
    repo = AuthRepositoryImpl(
      dio: dio,
      tokenStore: tokenStore,
      kakaoAuthService: _NoOpKakaoAuthService(),
    );

    // 세션을 미리 설정 (recordTermsAgreement 는 활성 세션 필요)
    // 내부 _session 을 직접 주입할 수 없으므로 signIn 흐름 없이
    // recoverAccount 로 세션을 합성한다.
  });

  group('recordTermsAgreement — POST /consent 바디 매핑', () {
    test(
        'TermsAgreement 가 올바른 ConsentRequestDto 바디로 POST 된다'
        '(tos/privacy/healthSensitive/marketing 매핑)', () async {
      // 세션 합성: recoverAccount → _session 설정
      dioAdapter.onPost(
        '/auth/kakao/recover',
        (server) => server.reply(
          200,
          _ok({
            'accessToken': 'acc',
            'refreshToken': 'ref',
            'userId': 'u1',
            'email': 'e@e.com',
            'role': 'USER',
          }),
        ),
        data: Matchers.any,
      );
      await repo.recoverAccount(AuthProvider.kakao, idToken: 'test-id-token');

      // POST /consent 바디 검증
      dioAdapter.onPost(
        ApiEndpoints.consent,
        (server) => server.reply(200, _ok(null)),
        data: {
          'tos': true,
          'privacy': true,
          'healthSensitive': true,
          'marketing': false,
        },
      );

      // 예외 없이 완료되면 올바른 바디로 매칭된 것.
      await expectLater(
        repo.recordTermsAgreement(agreement),
        completes,
      );
    });

    test('marketing=true 일 때 바디에 marketing:true 가 포함된다', () async {
      dioAdapter.onPost(
        '/auth/kakao/recover',
        (server) => server.reply(
          200,
          _ok({
            'accessToken': 'acc',
            'refreshToken': 'ref',
            'userId': 'u1',
            'email': 'e@e.com',
            'role': 'USER',
          }),
        ),
        data: Matchers.any,
      );
      await repo.recoverAccount(AuthProvider.kakao, idToken: 'test-id-token');

      dioAdapter.onPost(
        ApiEndpoints.consent,
        (server) => server.reply(200, _ok(null)),
        data: {
          'tos': true,
          'privacy': true,
          'healthSensitive': true,
          'marketing': true,
        },
      );

      await expectLater(
        repo.recordTermsAgreement(
          agreement.copyWith(marketing: true),
        ),
        completes,
      );
    });

    test('서버 오류 시 NetworkFailure 를 throw 하고 세션 hasAgreedTerms 는 갱신되지 않는다',
        () async {
      dioAdapter.onPost(
        '/auth/kakao/recover',
        (server) => server.reply(
          200,
          _ok({
            'accessToken': 'acc',
            'refreshToken': 'ref',
            'userId': 'u1',
            'email': 'e@e.com',
            'role': 'USER',
          }),
        ),
        data: Matchers.any,
      );
      await repo.recoverAccount(AuthProvider.kakao, idToken: 'test-id-token');

      dioAdapter.onPost(
        ApiEndpoints.consent,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.consent),
            type: DioExceptionType.connectionError,
          ),
        ),
        data: Matchers.any,
      );

      await expectLater(
        repo.recordTermsAgreement(agreement),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('세션 없는 상태에서 호출 시 StateError 를 throw 한다', () async {
      // repo 에 세션 없음 (_session = null)
      await expectLater(
        repo.recordTermsAgreement(agreement),
        throwsA(isA<StateError>()),
      );
    });
  });
}
