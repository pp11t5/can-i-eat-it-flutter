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
  // currentProfile — GET /my-page/health-info + GET /my-page/profile 병합 (W7 마이그레이션)
  // -------------------------------------------------------------------------

  group('currentProfile — 서버 GET 병합 (W7)', () {
    test('두 GET이 모두 성공하면 allergies/medications/conditions가 병합된다', () async {
      dioAdapter.onGet(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.reply(
          200,
          _envelope({
            'allergies': ['milk', 'egg'],
            'medications': ['omeprazole'],
          }),
        ),
      );
      dioAdapter.onGet(
        ApiEndpoints.myPageProfile,
        (server) => server.reply(
          200,
          _envelope({
            'nickName': '테스트유저',
            'profileImage': null,
            'email': 'test@example.com',
            'provider': 'KAKAO',
            'diseaseType': 'gerd',
            'representativeInfo': null,
            'etcCount': 0,
          }),
        ),
      );

      final profile = await repo.currentProfile();

      expect(profile, isNotNull);
      expect(profile!.allergies, equals(['milk', 'egg']));
      expect(profile.medications, equals(['omeprazole']));
      expect(profile.conditions, equals(['GERD']));
    });

    test('diseaseType이 gastritis_ulcer면 conditions가 카탈로그 코드(gastritis)로 매핑된다',
        () async {
      dioAdapter.onGet(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.reply(200, _envelope({'allergies': [], 'medications': []})),
      );
      dioAdapter.onGet(
        ApiEndpoints.myPageProfile,
        (server) => server.reply(
          200,
          _envelope({'diseaseType': 'gastritis_ulcer', 'provider': 'LOCAL'}),
        ),
      );

      final profile = await repo.currentProfile();
      expect(profile!.conditions, equals(['gastritis']));
    });

    test('두 GET 모두 result:null이면 온보딩 미완료로 간주해 null을 반환한다', () async {
      dioAdapter.onGet(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.reply(200, _envelope(null)),
      );
      dioAdapter.onGet(
        ApiEndpoints.myPageProfile,
        (server) => server.reply(200, _envelope(null)),
      );

      expect(await repo.currentProfile(), isNull);
    });

    test('GET 성공 후 캐시가 최신 값으로 갱신된다 (오프라인 폴백 대비)', () async {
      dioAdapter.onGet(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.reply(
          200,
          _envelope({'allergies': ['peanut'], 'medications': <String>[]}),
        ),
      );
      dioAdapter.onGet(
        ApiEndpoints.myPageProfile,
        (server) => server.reply(200, _envelope({'diseaseType': 'gerd'})),
      );

      await repo.currentProfile();

      final cached = await cache.read();
      expect(cached!.allergies, equals(['peanut']));
    });

    test(
        'health-info만 실패하면 allergies/medications는 캐시로 폴백하되 conditions는 '
        '라이브 profile 값으로 병합된다 (독립 처리, pr-review 의료안전 플래그#2)', () async {
      // 사전에 캐시를 채워 둔다 (직전 성공 시 저장된 것으로 가정) — conditions는 이전 값(ibs).
      await cache.write(
        const HealthProfile(allergies: ['fish_shellfish'], conditions: ['ibs']),
      );

      dioAdapter.onGet(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.myPageHealthInfo),
            type: DioExceptionType.connectionError,
          ),
        ),
      );
      // profile은 성공 — health-info 실패가 profile의 성공분까지 폐기해서는 안 된다.
      dioAdapter.onGet(
        ApiEndpoints.myPageProfile,
        (server) => server.reply(200, _envelope({'diseaseType': 'gerd'})),
      );

      final profile = await repo.currentProfile();
      expect(profile, isNotNull);
      // health-info 실패 → 캐시값 유지
      expect(profile!.allergies, equals(['fish_shellfish']));
      // profile 성공 → 라이브 값으로 갱신
      expect(profile.conditions, equals(['GERD']));
    });

    test(
        'profile만 실패하면 conditions는 캐시로 폴백하되 allergies/medications는 '
        '라이브 health-info 값으로 병합된다 (독립 처리)', () async {
      await cache.write(
        const HealthProfile(allergies: ['fish_shellfish'], conditions: ['ibs']),
      );

      dioAdapter.onGet(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.reply(
          200,
          _envelope({'allergies': ['peanut'], 'medications': <String>[]}),
        ),
      );
      dioAdapter.onGet(
        ApiEndpoints.myPageProfile,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.myPageProfile),
            type: DioExceptionType.connectionError,
          ),
        ),
      );

      final profile = await repo.currentProfile();
      expect(profile, isNotNull);
      // health-info 성공 → 라이브 값으로 갱신
      expect(profile!.allergies, equals(['peanut']));
      // profile 실패 → 캐시값 유지
      expect(profile.conditions, equals(['ibs']));
    });

    test('둘 다 실패하면 캐시 전체로 폴백한다 (크래시 금지)', () async {
      await cache.write(HealthProfile.sampleGerd());

      dioAdapter.onGet(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.myPageHealthInfo),
            type: DioExceptionType.connectionError,
          ),
        ),
      );
      dioAdapter.onGet(
        ApiEndpoints.myPageProfile,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.myPageProfile),
            type: DioExceptionType.connectionError,
          ),
        ),
      );

      final profile = await repo.currentProfile();
      expect(profile, equals(HealthProfile.sampleGerd()));
    });

    test('둘 다 실패 + 캐시도 비어있으면 null을 반환한다 (throw 하지 않음)', () async {
      dioAdapter.onGet(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.myPageHealthInfo),
            type: DioExceptionType.connectionError,
          ),
        ),
      );
      dioAdapter.onGet(
        ApiEndpoints.myPageProfile,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.myPageProfile),
            type: DioExceptionType.connectionError,
          ),
        ),
      );

      await expectLater(repo.currentProfile(), completion(isNull));
    });
  });

  // -------------------------------------------------------------------------
  // fetchMedicalInfoStrict — GET /my-page/health-info (편집 화면 전용, 캐시 폴백 없음)
  // -------------------------------------------------------------------------

  group('fetchMedicalInfoStrict — 편집 화면 전용 strict 조회 (pr-review 의료안전 ②-1)', () {
    test('성공 시 allergies/medications를 반환한다', () async {
      dioAdapter.onGet(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.reply(
          200,
          _envelope({
            'allergies': ['milk', 'egg'],
            'medications': ['omeprazole'],
          }),
        ),
      );

      final result = await repo.fetchMedicalInfoStrict();
      expect(result.allergies, equals(['milk', 'egg']));
      expect(result.medications, equals(['omeprazole']));
    });

    test('네트워크 오류 시 캐시 폴백 없이 NetworkFailure를 throw한다', () async {
      // 캐시에 이전 값이 있어도 절대 사용하지 않는다 — stale 데이터로 편집 진입 금지.
      await cache.write(
        const HealthProfile(allergies: ['fish_shellfish'], medications: ['stale-med']),
      );

      dioAdapter.onGet(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.myPageHealthInfo),
            type: DioExceptionType.connectionError,
          ),
        ),
      );

      await expectLater(
        repo.fetchMedicalInfoStrict(),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('result:null(온보딩 미완료 등)이면 UnexpectedFailure를 throw한다', () async {
      dioAdapter.onGet(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.reply(200, _envelope(null)),
      );

      await expectLater(
        repo.fetchMedicalInfoStrict(),
        throwsA(isA<UnexpectedFailure>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  // updateHealthInfo — PATCH /my-page/health-info (W7 마이그레이션)
  // -------------------------------------------------------------------------

  group('updateHealthInfo — PATCH /my-page/health-info', () {
    test('allergens/medications 바디로 PATCH 되고 성공 시 캐시가 갱신된다', () async {
      dioAdapter.onPatch(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.reply(200, _envelope(null)),
        data: {
          'allergens': ['milk', 'egg'],
          'medications': ['omeprazole'],
        },
      );

      await repo.updateHealthInfo(
        allergies: ['milk', 'egg'],
        medications: ['omeprazole'],
      );

      final cached = await cache.read();
      expect(cached!.allergies, equals(['milk', 'egg']));
      expect(cached.medications, equals(['omeprazole']));
    });

    test('기존 캐시가 있으면 allergies/medications만 교체하고 나머지는 보존한다', () async {
      await cache.write(HealthProfile.sampleGerd());

      dioAdapter.onPatch(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.reply(200, _envelope(null)),
        data: Matchers.any,
      );

      await repo.updateHealthInfo(allergies: ['soy'], medications: []);

      final cached = await cache.read();
      expect(cached!.allergies, equals(['soy']));
      expect(cached.conditions, equals(HealthProfile.sampleGerd().conditions));
      expect(cached.diagnosed, equals(HealthProfile.sampleGerd().diagnosed));
    });

    test('서버 오류 시 NetworkFailure를 throw하고 캐시는 변경되지 않는다', () async {
      dioAdapter.onPatch(
        ApiEndpoints.myPageHealthInfo,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.myPageHealthInfo),
            type: DioExceptionType.connectionError,
          ),
        ),
        data: Matchers.any,
      );

      await expectLater(
        repo.updateHealthInfo(allergies: ['milk'], medications: []),
        throwsA(isA<NetworkFailure>()),
      );
      expect(await cache.read(), isNull);
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
