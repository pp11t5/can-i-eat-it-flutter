import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/error/failure.dart';
import 'package:can_i_eat_it/core/network/failure_mapper.dart';

Response<dynamic> _response(Map<String, dynamic> body) => Response<dynamic>(
      requestOptions: RequestOptions(path: '/test'),
      data: body,
      statusCode: 200,
    );

Map<String, dynamic> _envelope({
  required bool isSuccess,
  dynamic result,
  String code = 'SUCCESS',
  String message = 'ok',
}) =>
    {
      'isSuccess': isSuccess,
      'code': code,
      'message': message,
      'traceId': null,
      'result': result,
    };

void main() {
  // -------------------------------------------------------------------------
  // COMMON 코드 매핑
  // -------------------------------------------------------------------------
  group('FailureMapper.fromCode — COMMON 코드', () {
    test('COMMON400_1 → NetworkFailure (필수 파라미터 누락)', () {
      final failure = FailureMapper.fromCode('COMMON400_1');
      expect(failure, isA<NetworkFailure>());
    });

    test('COMMON400_2 → NetworkFailure (요청 형식 오류)', () {
      final failure = FailureMapper.fromCode('COMMON400_2');
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, contains('요청 형식'));
    });

    test('COMMON401_1 → InvalidTokenFailure', () {
      final failure = FailureMapper.fromCode('COMMON401_1');
      expect(failure, isA<InvalidTokenFailure>());
    });

    test('COMMON403_1 → UnexpectedFailure (접근 권한 없음)', () {
      final failure = FailureMapper.fromCode('COMMON403_1');
      expect(failure, isA<UnexpectedFailure>());
    });

    test('COMMON404_1 → NetworkFailure (리소스 없음)', () {
      final failure = FailureMapper.fromCode('COMMON404_1');
      expect(failure, isA<NetworkFailure>());
    });

    test('COMMON500_1 → UnexpectedFailure (서버 오류)', () {
      final failure = FailureMapper.fromCode('COMMON500_1');
      expect(failure, isA<UnexpectedFailure>());
    });
  });

  // -------------------------------------------------------------------------
  // 기존 AUTH / FOOD 코드 매핑 회귀
  // -------------------------------------------------------------------------
  group('FailureMapper.fromCode — AUTH / FOOD 코드 회귀', () {
    test('AUTH400_1 → TermsRequiredFailure(email)', () {
      final failure = FailureMapper.fromCode('AUTH400_1');
      expect(failure, isA<TermsRequiredFailure>());
      expect(
        (failure as TermsRequiredFailure).requirements,
        contains(TermsRequirement.email),
      );
    });

    test('AUTH400_3 → TermsRequiredFailure(nickname)', () {
      final failure = FailureMapper.fromCode('AUTH400_3');
      expect(failure, isA<TermsRequiredFailure>());
      expect(
        (failure as TermsRequiredFailure).requirements,
        contains(TermsRequirement.nickname),
      );
    });

    test('AUTH403_2 → RecoverableAccountFailure(inactive)', () {
      final failure = FailureMapper.fromCode('AUTH403_2');
      expect(failure, isA<RecoverableAccountFailure>());
      expect(
        (failure as RecoverableAccountFailure).reason,
        RecoverReason.inactive,
      );
    });

    test('AUTH403_5 → RecoverableAccountFailure(deletionInProgress)', () {
      final failure = FailureMapper.fromCode('AUTH403_5');
      expect(failure, isA<RecoverableAccountFailure>());
      expect(
        (failure as RecoverableAccountFailure).reason,
        RecoverReason.deletionInProgress,
      );
    });

    test('AUTH401 → InvalidTokenFailure', () {
      final failure = FailureMapper.fromCode('AUTH401');
      expect(failure, isA<InvalidTokenFailure>());
    });

    test('FOOD400_1 → InvalidFoodQueryFailure', () {
      final failure = FailureMapper.fromCode('FOOD400_1');
      expect(failure, isA<InvalidFoodQueryFailure>());
    });

    test('FOOD404_1 → FoodNotFoundFailure', () {
      final failure = FailureMapper.fromCode('FOOD404_1');
      expect(failure, isA<FoodNotFoundFailure>());
    });
  });

  // -------------------------------------------------------------------------
  // 미매핑 코드 폴백
  // -------------------------------------------------------------------------
  group('FailureMapper.fromCode — 미매핑 코드 폴백', () {
    test('알 수 없는 코드는 NetworkFailure 로 폴백된다', () {
      final failure = FailureMapper.fromCode('UNKNOWN_CODE_999');
      expect(failure, isA<NetworkFailure>());
    });

    test('미매핑 코드에 message 가 있으면 그 메시지를 사용한다', () {
      final failure = FailureMapper.fromCode(
        'UNKNOWN_CODE_999',
        message: '커스텀 메시지',
      );
      expect(failure.message, '커스텀 메시지');
    });
  });

  // -------------------------------------------------------------------------
  // fromDioException — Dio 영문 raw message UI 비노출
  // -------------------------------------------------------------------------
  group('FailureMapper.fromDioException', () {
    DioException dioEx(DioExceptionType type, {String? message}) =>
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: type,
          message: message,
        );

    test('connectionError + Failed host lookup → 한글 NetworkFailure 치환', () {
      final failure = FailureMapper.fromDioException(
        dioEx(
          DioExceptionType.connectionError,
          message:
              "The connection errored: Failed host lookup: 'can-i-eat-it.com' "
              'This indicates an error which most likely cannot be solved by the library.',
        ),
      );
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, '네트워크 연결을 확인해 주세요.');
      expect(failure.message, isNot(contains('Failed host lookup')));
    });

    test('connectionTimeout → Dio 영문 대신 한글 고정 문구', () {
      final failure = FailureMapper.fromDioException(
        dioEx(
          DioExceptionType.connectionTimeout,
          message: 'The request connection took longer than 0:00:10.000000...',
        ),
      );
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, '네트워크 연결을 확인해 주세요.');
    });

    test('sendTimeout / receiveTimeout 도 동일 한글 문구', () {
      for (final type in [
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        final failure = FailureMapper.fromDioException(
          dioEx(type, message: 'English timeout noise'),
        );
        expect(failure, isA<NetworkFailure>());
        expect(failure.message, '네트워크 연결을 확인해 주세요.');
      }
    });

    test('message 가 null 이어도 한글 고정 문구', () {
      final failure = FailureMapper.fromDioException(
        dioEx(DioExceptionType.connectionError),
      );
      expect(failure.message, '네트워크 연결을 확인해 주세요.');
    });
  });

  // -------------------------------------------------------------------------
  // unwrapOrNull — result:null 관용 언랩 (W7)
  // -------------------------------------------------------------------------
  group('unwrapOrNull', () {
    test('성공 + result 있음 → fromJson으로 파싱한 값을 반환한다', () {
      final response = _response(
        _envelope(isSuccess: true, result: {'value': 'ok'}),
      );
      final result = unwrapOrNull<String>(
        response,
        (j) => (j as Map<String, dynamic>)['value'] as String,
      );
      expect(result, 'ok');
    });

    test('성공 + result:null → 예외 없이 null을 반환한다', () {
      final response = _response(_envelope(isSuccess: true, result: null));
      final result = unwrapOrNull<String>(
        response,
        (j) => (j as Map<String, dynamic>)['value'] as String,
      );
      expect(result, isNull);
    });

    test('실패 응답이면 unwrap과 동일하게 Failure를 throw한다', () {
      final response = _response(
        _envelope(isSuccess: false, code: 'COMMON500_1'),
      );
      expect(
        () => unwrapOrNull<String>(
          response,
          (j) => (j as Map<String, dynamic>)['value'] as String,
        ),
        throwsA(isA<UnexpectedFailure>()),
      );
    });
  });
}
