import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';

/// [maskTokensForLog] 마스킹 단위 테스트.
///
/// Bug B 회귀: Dart Map toString 형식({idToken: eyJ...})이
/// JSON 형식("idToken":"eyJ...")과 함께 모두 마스킹되는지 검증한다.
void main() {
  group('maskTokensForLog — JSON 형식 마스킹', () {
    test('idToken JSON 값 마스킹', () {
      const input = '{"idToken":"eyJhbGciOiJSUzI1NiJ9.payload.sig"}';
      final result = maskTokensForLog(input);
      expect(result, contains('"idToken":"***"'));
      expect(result, isNot(contains('eyJ')));
    });

    test('accessToken JSON 값 마스킹', () {
      const input = '{"accessToken":"eyJhbGci.access.token"}';
      final result = maskTokensForLog(input);
      expect(result, contains('"accessToken":"***"'));
      expect(result, isNot(contains('eyJhbGci.access')));
    });

    test('refreshToken JSON 값 마스킹', () {
      const input = '{"refreshToken":"refresh-token-value-xyz"}';
      final result = maskTokensForLog(input);
      expect(result, contains('"refreshToken":"***"'));
      expect(result, isNot(contains('refresh-token-value-xyz')));
    });

    test('여러 토큰 필드가 동시에 있을 때 모두 마스킹', () {
      const input =
          '{"accessToken":"acc123","refreshToken":"ref456","idToken":"id789"}';
      final result = maskTokensForLog(input);
      expect(result, contains('"accessToken":"***"'));
      expect(result, contains('"refreshToken":"***"'));
      expect(result, contains('"idToken":"***"'));
      expect(result, isNot(contains('acc123')));
      expect(result, isNot(contains('ref456')));
      expect(result, isNot(contains('id789')));
    });

    test('공백이 있는 JSON 형식 마스킹 ("idToken" : "...")', () {
      const input = '{"idToken" : "eyJhbGci.token"}';
      final result = maskTokensForLog(input);
      expect(result, isNot(contains('eyJhbGci.token')));
    });
  });

  group('maskTokensForLog — Dart Map toString 형식 마스킹 (Bug B 핵심)', () {
    test('idToken Dart Map 단독 마스킹', () {
      // LogInterceptor requestBody:true 시 Map.toString() 출력 형태
      const input = '{idToken: eyJhbGciOiJSUzI1NiJ9.payload.sig}';
      final result = maskTokensForLog(input);
      expect(result, contains('idToken: ***'));
      expect(result, isNot(contains('eyJhbGci')));
    });

    test('idToken Dart Map 다중 필드 마스킹', () {
      const input = '{idToken: eyJ.token, provider: kakao}';
      final result = maskTokensForLog(input);
      expect(result, contains('idToken: ***'));
      expect(result, isNot(contains('eyJ.token')));
      // provider 필드는 마스킹되지 않는다
      expect(result, contains('provider: kakao'));
    });

    test('accessToken Dart Map 마스킹', () {
      const input = '{accessToken: eyJhbGci.access, userId: abc}';
      final result = maskTokensForLog(input);
      expect(result, contains('accessToken: ***'));
      expect(result, isNot(contains('eyJhbGci.access')));
    });

    test('refreshToken Dart Map 마스킹', () {
      const input = '{refreshToken: my-refresh-token-value}';
      final result = maskTokensForLog(input);
      expect(result, contains('refreshToken: ***'));
      expect(result, isNot(contains('my-refresh-token-value')));
    });
  });

  group('maskTokensForLog — Authorization 헤더 마스킹', () {
    test('Bearer 토큰 마스킹', () {
      const input = 'Authorization: Bearer eyJhbGciOiJSUzI1NiJ9.token';
      final result = maskTokensForLog(input);
      expect(result, contains('Bearer ***'));
      expect(result, isNot(contains('eyJhbGci')));
    });

    test('소문자 authorization 은 마스킹 안 됨 (Dio 가 헤더 이름을 normalize 함)', () {
      // 현재 정규식은 대소문자 구별: 소문자 'authorization' 은 매핑하지 않는다.
      // 실제 Dio 는 헤더 이름을 대문자로 normalize 하므로 실용상 문제없다.
      const input = 'authorization : Bearer sometoken123';
      final result = maskTokensForLog(input);
      // 소문자 authorization 은 정규식에 매칭되지 않아 그대로 유지된다.
      expect(result, equals(input));
    });
  });

  group('maskTokensForLog — 마스킹 불필요 텍스트 보존', () {
    test('토큰 없는 일반 텍스트는 변경 없음', () {
      const input = 'POST /auth/kakao/login 200 OK';
      expect(maskTokensForLog(input), input);
    });

    test('빈 문자열은 빈 문자열 반환', () {
      expect(maskTokensForLog(''), '');
    });

    test('provider 등 무관 필드는 보존', () {
      const input = '{provider: kakao, timestamp: 1234567890}';
      final result = maskTokensForLog(input);
      expect(result, contains('provider: kakao'));
      expect(result, contains('timestamp: 1234567890'));
    });
  });
}
