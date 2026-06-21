import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';

import '../../repository_contract.dart';

// ---------------------------------------------------------------------------
// 공통 봉투 헬퍼
// ---------------------------------------------------------------------------

Map<String, dynamic> _envelope(Object? result, {bool isSuccess = true}) => {
      'isSuccess': isSuccess,
      'code': isSuccess ? 'SUCCESS' : 'UNKNOWN_ERROR',
      'message': isSuccess ? 'success' : 'error',
      'traceId': 'trace-test-001',
      'result': result,
    };

// ---------------------------------------------------------------------------
// 테스트
// ---------------------------------------------------------------------------

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late InMemoryProfileCache cache;
  late HealthProfileRepositoryImpl repo;

  setUp(() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://can-i-eat-it.com/api/v1',
        // dio_client.dart 와 동일 validateStatus 정책
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );
    dioAdapter = DioAdapter(dio: dio, matcher: const FullHttpRequestMatcher());
    cache = InMemoryProfileCache();
    repo = HealthProfileRepositoryImpl(dio: dio, cache: cache);
  });

  // -------------------------------------------------------------------------
  // onboardedStatus — GET /onboarding/status
  // -------------------------------------------------------------------------

  group('onboardedStatus — GET /onboarding/status', () {
    test('서버가 onboarded=true 를 반환하면 true 를 반환한다', () async {
      dioAdapter.onGet(
        ApiEndpoints.onboardingStatus,
        (server) => server.reply(200, _envelope({'onboarded': true})),
      );

      final result = await repo.onboardedStatus();
      expect(result, isTrue);
    });

    test('서버가 onboarded=false 를 반환하면 false 를 반환한다', () async {
      dioAdapter.onGet(
        ApiEndpoints.onboardingStatus,
        (server) => server.reply(200, _envelope({'onboarded': false})),
      );

      final result = await repo.onboardedStatus();
      expect(result, isFalse);
    });

    test('네트워크 오류 시 NetworkFailure 를 throw 한다', () async {
      dioAdapter.onGet(
        ApiEndpoints.onboardingStatus,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.onboardingStatus),
            type: DioExceptionType.connectionError,
          ),
        ),
      );

      await expectLater(
        repo.onboardedStatus(),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  // submitProfile — POST /onboarding (바디 매핑 검증)
  // -------------------------------------------------------------------------

  group('submitProfile — POST /onboarding 바디 매핑', () {
    test('HealthProfile 이 서버 스키마에 맞는 바디로 변환돼 POST 된다', () async {
      // 서버 스키마 정합 검증 (W3-4):
      // symptomFrequency → symptoms, triggerFoods → triggers,
      // allergies → allergens, customTriggers → customTriggerText.
      // conditions(GERD)/diagnosed/symptomFrequency 키는 전송하지 않는다.
      dioAdapter.onPost(
        ApiEndpoints.onboarding,
        (server) {
          return server.reply(200, _envelope(null));
        },
        data: {
          'symptoms': ['heartburn_reflux', 'post_meal_cough'],
          'triggers': ['spicy', 'caffeine'],
          'allergens': ['crustacean'],
          'medications': ['omeprazole'],
          'customTriggerText': '탄산음료',
        },
      );

      // sampleGerd: conditions=['GERD'], symptomFrequency=['heartburn_reflux','post_meal_cough'],
      // diagnosed=true, triggerFoods=['spicy','caffeine'], customTriggers='탄산음료',
      // medications=['omeprazole'], allergies=['crustacean']
      await repo.submitProfile(HealthProfile.sampleGerd());

      // 위 dioAdapter 가 정확한 바디로 매칭됐다면 예외 없이 통과함.
    });

    test('customTriggers 가 null 이면 customTriggerText 는 null 로 전송된다', () async {
      dioAdapter.onPost(
        ApiEndpoints.onboarding,
        (server) => server.reply(200, _envelope(null)),
        data: {
          'symptoms': <String>[],
          'triggers': ['spicy'],
          'allergens': <String>[],
          'medications': <String>[],
          'customTriggerText': null,
        },
      );

      await repo.submitProfile(
        const HealthProfile(
          triggerFoods: ['spicy'],
        ),
      );
    });

    test('빈 HealthProfile 도 올바른 빈 바디로 POST 된다', () async {
      dioAdapter.onPost(
        ApiEndpoints.onboarding,
        (server) => server.reply(200, _envelope(null)),
        data: {
          'symptoms': <String>[],
          'triggers': <String>[],
          'allergens': <String>[],
          'medications': <String>[],
          'customTriggerText': null,
        },
      );

      await repo.submitProfile(const HealthProfile());
    });

    test('서버 오류 시 NetworkFailure 를 throw 한다', () async {
      dioAdapter.onPost(
        ApiEndpoints.onboarding,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.onboarding),
            type: DioExceptionType.connectionError,
          ),
        ),
        data: Matchers.any,
      );

      await expectLater(
        repo.submitProfile(const HealthProfile()),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  // currentProfile — 캐시 기반 (서버 GET 엔드포인트 부재)
  // -------------------------------------------------------------------------

  group('currentProfile — 캐시 기반 반환', () {
    test('캐시가 비어있으면 null 을 반환한다', () async {
      final result = await repo.currentProfile();
      expect(result, isNull);
    });

    test('submitProfile 성공 후 currentProfile 이 해당 프로필을 반환한다', () async {
      dioAdapter.onPost(
        ApiEndpoints.onboarding,
        (server) => server.reply(200, _envelope(null)),
        data: Matchers.any,
      );

      final profile = HealthProfile.sampleGerd();
      await repo.submitProfile(profile);
      expect(await repo.currentProfile(), equals(profile));
    });

    test('서버 실패 시 캐시는 변경되지 않는다 (낙관적 갱신 금지)', () async {
      dioAdapter.onPost(
        ApiEndpoints.onboarding,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.onboarding),
            type: DioExceptionType.connectionError,
          ),
        ),
        data: Matchers.any,
      );

      await expectLater(
        repo.submitProfile(HealthProfile.sampleGerd()),
        throwsA(isA<NetworkFailure>()),
      );
      expect(await repo.currentProfile(), isNull);
    });
  });

  // -------------------------------------------------------------------------
  // 캐시 계약 — repository_contract.dart healthProfileRepositoryCacheContract
  // -------------------------------------------------------------------------
  //
  // submitProfile 은 HTTP POST 가 필요하므로, createRepo 팩토리 내부에서
  // 매 테스트마다 새 Dio + DioAdapter(성공 응답 고정) 를 구성한다.
  // -------------------------------------------------------------------------

  {
    late InMemoryProfileCache contractCache;

    healthProfileRepositoryCacheContract(
      createCache: () {
        contractCache = InMemoryProfileCache();
        return contractCache;
      },
      createRepo: () {
        final contractDio = Dio(
          BaseOptions(
            baseUrl: 'https://can-i-eat-it.com/api/v1',
            validateStatus: (status) =>
                status != null && status != 401 && status < 500,
          ),
        );
        // 계약 케이스의 submitProfile 은 항상 서버 성공을 전제한다.
        final contractAdapter =
            DioAdapter(dio: contractDio, matcher: const FullHttpRequestMatcher());
        contractAdapter.onPost(
          ApiEndpoints.onboarding,
          (server) => server.reply(200, _envelope(null)),
          data: Matchers.any,
        );
        return HealthProfileRepositoryImpl(
          dio: contractDio,
          cache: contractCache,
        );
      },
    );
  }
}
