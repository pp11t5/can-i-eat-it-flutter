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
import 'package:can_i_eat_it/features/auth/data/dtos/consent_request_dto.dart';
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

class _NoOpAppleAuthService implements AppleAuthService {
  @override
  Future<AppleAuthResult> signIn() async => const AppleAuthResult(
        idToken: 'id',
        authorizationCode: 'code',
        email: 'e@e.com',
        fullName: 'Apple Tester',
      );
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

/// `GET /consent/terms` 응답 원소 헬퍼 — TermResponseDTO 목.
Map<String, dynamic> _termJson({
  required int id,
  required String code,
  bool required = true,
  String version = 'v1.0',
  String title = '약관',
  String content = '내용',
  String? effectiveDate,
}) =>
    {
      'id': id,
      'code': code,
      'version': version,
      'title': title,
      'content': content,
      'required': required,
      'effectiveDate': effectiveDate,
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
      appleAuthService: _NoOpAppleAuthService(),
    );
  });

  /// 세션 합성 헬퍼: recoverAccount → 내부 _session 설정.
  /// (recordTermsAgreement 는 활성 세션이 필요하므로 signIn 흐름 없이 합성한다.)
  Future<void> synthesizeSession() async {
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
  }

  group('recordTermsAgreement — GET /consent/terms → POST /consent (신 계약)', () {
    test('GET /consent/terms 목록을 termId 로 조인해 POST 바디를 {consents:[...]}로 구성한다',
        () async {
      await synthesizeSession();

      dioAdapter.onGet(
        ApiEndpoints.consentTerms,
        (server) => server.reply(
          200,
          _ok([
            _termJson(id: 1, code: TermsCatalogCodes.tos),
            _termJson(id: 2, code: TermsCatalogCodes.privacy),
            _termJson(id: 3, code: TermsCatalogCodes.healthSensitive),
            _termJson(id: 4, code: TermsCatalogCodes.marketing, required: false),
          ]),
        ),
      );

      dioAdapter.onPost(
        ApiEndpoints.consent,
        (server) => server.reply(200, _ok(null)),
        // NOTE: ConsentRequestDto/ConsentItemDto 는 json_serializable
        // 기본값(explicitToJson: false) 이라 dto.toJson() 이 반환하는
        // 'consents' 값은 List<Map> 이 아니라 List<ConsentItemDto> 그대로다
        // (실서버 전송 시엔 dart:convert 의 암묵적 toJson() 폴백으로 정상
        // 직렬화되지만, http_mock_adapter 의 매처는 그 이전 단계에서 값을
        // 비교한다). 매처 기대값도 동일 타입(ConsentItemDto)으로 맞춘다.
        data: {
          'consents': [
            const ConsentItemDto(termId: 1, agreed: true),
            const ConsentItemDto(termId: 2, agreed: true),
            const ConsentItemDto(termId: 3, agreed: true),
            const ConsentItemDto(termId: 4, agreed: false),
          ],
        },
      );

      await expectLater(
        repo.recordTermsAgreement(agreement),
        completes,
      );
    });

    test('marketing=true 일 때 termId 4(marketing) 의 agreed 도 true 로 전송된다',
        () async {
      await synthesizeSession();

      dioAdapter.onGet(
        ApiEndpoints.consentTerms,
        (server) => server.reply(
          200,
          _ok([
            _termJson(id: 1, code: TermsCatalogCodes.tos),
            _termJson(id: 2, code: TermsCatalogCodes.privacy),
            _termJson(id: 3, code: TermsCatalogCodes.healthSensitive),
            _termJson(id: 4, code: TermsCatalogCodes.marketing, required: false),
          ]),
        ),
      );

      dioAdapter.onPost(
        ApiEndpoints.consent,
        (server) => server.reply(200, _ok(null)),
        // NOTE: 위 테스트와 동일한 이유로 ConsentItemDto 인스턴스로 기대값 구성.
        data: {
          'consents': [
            const ConsentItemDto(termId: 1, agreed: true),
            const ConsentItemDto(termId: 2, agreed: true),
            const ConsentItemDto(termId: 3, agreed: true),
            const ConsentItemDto(termId: 4, agreed: true),
          ],
        },
      );

      await expectLater(
        repo.recordTermsAgreement(agreement.copyWith(marketing: true)),
        completes,
      );
    });

    test('GET /consent/terms 가 빈 배열이면(현재 dev 서버) POST 바디는 {consents:[]}이다',
        () async {
      await synthesizeSession();

      dioAdapter.onGet(
        ApiEndpoints.consentTerms,
        (server) => server.reply(200, _ok(<dynamic>[])),
      );

      dioAdapter.onPost(
        ApiEndpoints.consent,
        (server) => server.reply(200, _ok(null)),
        data: {'consents': <dynamic>[]},
      );

      await expectLater(
        repo.recordTermsAgreement(agreement),
        completes,
      );
    });

    test(
        '필수 약관(required=true)이 agreed=false 로 매핑되면 로컬 검증에서 '
        'NetworkFailure 를 throw 하고 POST /consent 는 호출되지 않는다', () async {
      await synthesizeSession();

      dioAdapter.onGet(
        ApiEndpoints.consentTerms,
        (server) => server.reply(
          200,
          _ok([
            _termJson(id: 1, code: TermsCatalogCodes.tos),
          ]),
        ),
      );

      final notAgreed = agreement.copyWith(termsOfService: false);

      await expectLater(
        repo.recordTermsAgreement(notAgreed),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test(
        '필수 약관(required=true)의 code 가 로컬 UI에 없는(미인식) 항목이면 '
        'NetworkFailure 를 throw 한다', () async {
      await synthesizeSession();

      dioAdapter.onGet(
        ApiEndpoints.consentTerms,
        (server) => server.reply(
          200,
          _ok([
            _termJson(id: 1, code: TermsCatalogCodes.tos),
            _termJson(id: 99, code: 'unknown_required_term'),
          ]),
        ),
      );

      await expectLater(
        repo.recordTermsAgreement(agreement),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('선택 약관(required=false)의 미인식 code 는 consents 에서 생략된다', () async {
      await synthesizeSession();

      dioAdapter.onGet(
        ApiEndpoints.consentTerms,
        (server) => server.reply(
          200,
          _ok([
            _termJson(id: 1, code: TermsCatalogCodes.tos),
            _termJson(id: 2, code: TermsCatalogCodes.privacy),
            _termJson(id: 3, code: TermsCatalogCodes.healthSensitive),
            _termJson(
              id: 5,
              code: 'unknown_optional_term',
              required: false,
            ),
          ]),
        ),
      );

      dioAdapter.onPost(
        ApiEndpoints.consent,
        (server) => server.reply(200, _ok(null)),
        // NOTE: 위 테스트와 동일한 이유로 ConsentItemDto 인스턴스로 기대값 구성.
        data: {
          'consents': [
            const ConsentItemDto(termId: 1, agreed: true),
            const ConsentItemDto(termId: 2, agreed: true),
            const ConsentItemDto(termId: 3, agreed: true),
          ],
        },
      );

      await expectLater(
        repo.recordTermsAgreement(agreement),
        completes,
      );
    });

    test('GET /consent/terms 실패 시 NetworkFailure 를 throw 하고 세션은 갱신되지 않는다(참조 불변)',
        () async {
      await synthesizeSession();
      // recoverAccount 직후 세션(hasAgreedTerms 등)을 스냅샷 — recordTermsAgreement 는
      // POST /consent 성공 시에만 _session 을 copyWith 로 교체한다. GET 단계 실패는
      // 그 이전이므로 세션이 값 동일성 그대로 유지돼야 한다.
      final sessionBefore = await repo.currentSession();

      dioAdapter.onGet(
        ApiEndpoints.consentTerms,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.consentTerms),
            type: DioExceptionType.connectionError,
          ),
        ),
      );

      await expectLater(
        repo.recordTermsAgreement(agreement),
        throwsA(isA<NetworkFailure>()),
      );

      final sessionAfter = await repo.currentSession();
      expect(sessionAfter, equals(sessionBefore));
    });

    test('POST /consent 서버 오류 시 NetworkFailure 를 throw 하고 세션 hasAgreedTerms 는 갱신되지 않는다',
        () async {
      await synthesizeSession();

      dioAdapter.onGet(
        ApiEndpoints.consentTerms,
        (server) => server.reply(
          200,
          _ok([
            _termJson(id: 1, code: TermsCatalogCodes.tos),
            _termJson(id: 2, code: TermsCatalogCodes.privacy),
            _termJson(id: 3, code: TermsCatalogCodes.healthSensitive),
          ]),
        ),
      );

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
