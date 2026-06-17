import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/health_profile_repository_impl.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';

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
    repo = HealthProfileRepositoryImpl(dio: dio);
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
          'symptoms': ['weekly_heartburn', 'post_meal_cough'],
          'triggers': ['spicy', 'caffeine'],
          'allergens': ['shellfish'],
          'medications': ['omeprazole'],
          'customTriggerText': '탄산음료',
        },
      );

      // sampleGerd: conditions=['GERD'], symptomFrequency=['weekly_heartburn','post_meal_cough'],
      // diagnosed=true, triggerFoods=['spicy','caffeine'], customTriggers='탄산음료',
      // medications=['omeprazole'], allergies=['shellfish']
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
  // currentProfile — W3 Mock 유지 (항상 null)
  // -------------------------------------------------------------------------

  group('currentProfile — W3 에서 null 반환', () {
    test('currentProfile 은 항상 null 을 반환한다 (실서버 GET 엔드포인트 부재)', () async {
      final result = await repo.currentProfile();
      expect(result, isNull);
    });
  });
}
