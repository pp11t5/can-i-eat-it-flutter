import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/network/api_endpoints.dart';
import 'package:can_i_eat_it/core/push/fcm_repository.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

const _baseUrl = 'https://test.example.com';
const _urlMatcher = UrlRequestMatcher(matchMethod: true);

Map<String, dynamic> _successEnvelope(Object? result) => {
      'isSuccess': true,
      'code': 'SUCCESS',
      'message': 'ok',
      'traceId': 'trace-1',
      'result': result,
    };

Map<String, dynamic> _failureEnvelope(String code, String message) => {
      'isSuccess': false,
      'code': code,
      'message': message,
      'traceId': 'trace-1',
      'result': null,
    };

Dio _buildDio() => Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        validateStatus: (status) =>
            status != null && status != 401 && status < 500,
      ),
    );

// ---------------------------------------------------------------------------
// FcmRepositoryImpl 단위 테스트
// ---------------------------------------------------------------------------

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late FcmRepositoryImpl repo;

  setUp(() {
    dio = _buildDio();
    adapter = DioAdapter(dio: dio, matcher: _urlMatcher);
    repo = FcmRepositoryImpl(dio: dio);
  });

  // -------------------------------------------------------------------------
  // register — POST /fcm/tokens
  // -------------------------------------------------------------------------
  group('FcmRepositoryImpl.register — POST /fcm/tokens', () {
    test('성공 시 정상 반환 (void)', () async {
      adapter.onPost(
        ApiEndpoints.fcmTokens,
        (server) => server.reply(200, _successEnvelope(null)),
      );

      await expectLater(
        repo.register(token: 'fcm-token-abc', platform: 'android'),
        completes,
      );
    });

    test('iOS platform 값으로 register 호출 성공', () async {
      adapter.onPost(
        ApiEndpoints.fcmTokens,
        (server) => server.reply(200, _successEnvelope(null)),
      );

      await expectLater(
        repo.register(token: 'fcm-token-ios', platform: 'ios'),
        completes,
      );
    });

    test('서버 오류(isSuccess=false) 시 Failure throw', () async {
      adapter.onPost(
        ApiEndpoints.fcmTokens,
        (server) =>
            server.reply(200, _failureEnvelope('COMMON500_1', 'server error')),
      );

      await expectLater(
        repo.register(token: 'token', platform: 'android'),
        throwsA(isA<Failure>()),
      );
    });

    test('네트워크 오류(DioException) 시 Failure throw', () async {
      adapter.onPost(
        ApiEndpoints.fcmTokens,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.fcmTokens),
            type: DioExceptionType.connectionError,
          ),
        ),
      );

      await expectLater(
        repo.register(token: 'token', platform: 'android'),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });

  // -------------------------------------------------------------------------
  // delete — DELETE /fcm/tokens
  // -------------------------------------------------------------------------
  group('FcmRepositoryImpl.delete — DELETE /fcm/tokens', () {
    test('성공 시 정상 반환 (void)', () async {
      adapter.onDelete(
        ApiEndpoints.fcmTokens,
        (server) => server.reply(200, _successEnvelope(null)),
      );

      await expectLater(repo.delete(), completes);
    });

    test('서버 오류(isSuccess=false) 시 Failure throw', () async {
      adapter.onDelete(
        ApiEndpoints.fcmTokens,
        (server) =>
            server.reply(200, _failureEnvelope('COMMON404_1', 'not found')),
      );

      await expectLater(repo.delete(), throwsA(isA<Failure>()));
    });

    test('네트워크 오류(DioException) 시 Failure throw', () async {
      adapter.onDelete(
        ApiEndpoints.fcmTokens,
        (server) => server.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: ApiEndpoints.fcmTokens),
            type: DioExceptionType.connectionError,
          ),
        ),
      );

      await expectLater(repo.delete(), throwsA(isA<NetworkFailure>()));
    });
  });
}
