import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/auth/data/dtos/auth_me_response_dto.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';

void main() {
  group('AuthMeResponseDto.toEntity — AuthSession 식별필드 매핑', () {
    const dto = AuthMeResponseDto(
      userId: 'user-123',
      nickname: '홍길동',
      email: 'hong@example.com',
      profileImage: 'https://example.com/avatar.png',
    );

    test('displayName 이 nickname 으로 매핑된다', () {
      final session = dto.toEntity(AuthProvider.kakao);
      expect(session.displayName, equals('홍길동'));
    });

    test('email 이 올바르게 매핑된다', () {
      final session = dto.toEntity(AuthProvider.kakao);
      expect(session.email, equals('hong@example.com'));
    });

    test('profileImageUrl 이 profileImage 로 매핑된다', () {
      final session = dto.toEntity(AuthProvider.kakao);
      expect(session.profileImageUrl, equals('https://example.com/avatar.png'));
    });

    test('userId 가 올바르게 매핑된다', () {
      final session = dto.toEntity(AuthProvider.kakao);
      expect(session.userId, equals('user-123'));
    });

    test('hasAgreedTerms 는 항상 true 이다', () {
      final session = dto.toEntity(AuthProvider.kakao);
      expect(session.hasAgreedTerms, isTrue);
    });

    test('accountStatus 는 active 이다', () {
      final session = dto.toEntity(AuthProvider.kakao);
      expect(session.accountStatus, equals(AccountStatus.active));
    });

    test('profileImage 가 null 이면 profileImageUrl 이 null 이다', () {
      const dtoNoImage = AuthMeResponseDto(
        userId: 'user-456',
        nickname: '이순신',
        email: 'lee@example.com',
      );
      final session = dtoNoImage.toEntity(AuthProvider.apple);
      expect(session.profileImageUrl, isNull);
    });

    test('provider 가 올바르게 전달된다', () {
      expect(dto.toEntity(AuthProvider.kakao).provider, AuthProvider.kakao);
      expect(dto.toEntity(AuthProvider.apple).provider, AuthProvider.apple);
    });
  });

  group('AuthSession — 기존 생성처 nullable 필드 기본값', () {
    test('displayName/email/profileImageUrl 미지정 시 모두 null 이다', () {
      const session = AuthSession(
        userId: 'u1',
        provider: AuthProvider.kakao,
      );
      expect(session.displayName, isNull);
      expect(session.email, isNull);
      expect(session.profileImageUrl, isNull);
    });
  });
}
