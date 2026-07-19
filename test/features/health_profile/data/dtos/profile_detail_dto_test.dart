import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/health_profile/data/dtos/profile_detail_dto.dart';

void main() {
  // -------------------------------------------------------------------------
  // fromJson — 서버 응답 매핑
  // -------------------------------------------------------------------------
  group('ProfileDetailDto.fromJson', () {
    test('전체 필드가 채워진 응답을 올바르게 파싱한다', () {
      final dto = ProfileDetailDto.fromJson({
        'nickName': '테스트유저',
        'profileImage': 'https://example.com/a.png',
        'email': 'test@example.com',
        'provider': 'KAKAO',
        'diseaseType': 'gerd',
        'representativeInfo': '역류성 식도염 3년차',
        'etcCount': 2,
      });

      expect(dto.nickName, '테스트유저');
      expect(dto.profileImage, 'https://example.com/a.png');
      expect(dto.email, 'test@example.com');
      expect(dto.provider, 'KAKAO');
      expect(dto.diseaseType, 'gerd');
      expect(dto.representativeInfo, '역류성 식도염 3년차');
      expect(dto.etcCount, 2);
    });

    test('profileImage/representativeInfo가 null이어도 파싱된다', () {
      final dto = ProfileDetailDto.fromJson({
        'nickName': '테스트유저',
        'profileImage': null,
        'email': 'test@example.com',
        'provider': 'LOCAL',
        'diseaseType': 'ibs',
        'representativeInfo': null,
        'etcCount': 0,
      });

      expect(dto.profileImage, isNull);
      expect(dto.representativeInfo, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // provider → ProfileProvider 매핑
  // -------------------------------------------------------------------------
  group('ProfileDetailDto.providerType', () {
    test('LOCAL은 ProfileProvider.local로 매핑된다', () {
      final dto = ProfileDetailDto.fromJson({'provider': 'LOCAL'});
      expect(dto.providerType, ProfileProvider.local);
    });

    test('KAKAO는 ProfileProvider.kakao로 매핑된다', () {
      final dto = ProfileDetailDto.fromJson({'provider': 'KAKAO'});
      expect(dto.providerType, ProfileProvider.kakao);
    });

    test('APPLE은 ProfileProvider.apple로 매핑된다 (A6)', () {
      final dto = ProfileDetailDto.fromJson({'provider': 'APPLE'});
      expect(dto.providerType, ProfileProvider.apple);
    });

    test('미지 값은 ProfileProvider.unknown으로 폴백된다', () {
      final dto = ProfileDetailDto.fromJson({'provider': 'NAVER'});
      expect(dto.providerType, ProfileProvider.unknown);
    });
  });

  // -------------------------------------------------------------------------
  // diseaseType → ProfileDiseaseType 매핑 + conditionOptions 코드 변환
  // -------------------------------------------------------------------------
  group('ProfileDetailDto.disease — 서버 값 매핑', () {
    test('gerd는 ProfileDiseaseType.gerd로 매핑된다', () {
      final dto = ProfileDetailDto.fromJson({'diseaseType': 'gerd'});
      expect(dto.disease, ProfileDiseaseType.gerd);
    });

    test('gastritis_ulcer는 ProfileDiseaseType.gastritisUlcer로 매핑된다', () {
      final dto = ProfileDetailDto.fromJson({'diseaseType': 'gastritis_ulcer'});
      expect(dto.disease, ProfileDiseaseType.gastritisUlcer);
    });

    test('ibs는 ProfileDiseaseType.ibs로 매핑된다', () {
      final dto = ProfileDetailDto.fromJson({'diseaseType': 'ibs'});
      expect(dto.disease, ProfileDiseaseType.ibs);
    });

    test('functional_dyspepsia는 ProfileDiseaseType.functionalDyspepsia로 매핑된다', () {
      final dto = ProfileDetailDto.fromJson({'diseaseType': 'functional_dyspepsia'});
      expect(dto.disease, ProfileDiseaseType.functionalDyspepsia);
    });

    test('미지 값은 ProfileDiseaseType.unknown으로 폴백된다', () {
      final dto = ProfileDetailDto.fromJson({'diseaseType': 'unknown_disease'});
      expect(dto.disease, ProfileDiseaseType.unknown);
    });
  });

  group('ProfileDiseaseType.toConditionCode — conditionOptions 카탈로그 정합', () {
    test('gerd → GERD (대문자)', () {
      expect(ProfileDiseaseType.gerd.toConditionCode(), 'GERD');
    });

    test('gastritisUlcer → gastritis (conditionOptions 카탈로그 코드)', () {
      expect(ProfileDiseaseType.gastritisUlcer.toConditionCode(), 'gastritis');
    });

    test('ibs → ibs', () {
      expect(ProfileDiseaseType.ibs.toConditionCode(), 'ibs');
    });

    test('functionalDyspepsia → functional_dyspepsia', () {
      expect(
        ProfileDiseaseType.functionalDyspepsia.toConditionCode(),
        'functional_dyspepsia',
      );
    });
  });
}
