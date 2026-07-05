import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/health_profile/data/dtos/medical_info_dto.dart';

void main() {
  // -------------------------------------------------------------------------
  // MedicalInfoDto.fromJson — GET /my-page/health-info 응답 매핑
  // -------------------------------------------------------------------------
  group('MedicalInfoDto.fromJson', () {
    test('allergies/medications를 그대로 파싱한다', () {
      final dto = MedicalInfoDto.fromJson({
        'allergies': ['milk', 'egg'],
        'medications': ['omeprazole'],
      });

      expect(dto.allergies, ['milk', 'egg']);
      expect(dto.medications, ['omeprazole']);
    });

    test('빈 응답은 빈 리스트로 파싱된다', () {
      final dto = MedicalInfoDto.fromJson(const {});

      expect(dto.allergies, isEmpty);
      expect(dto.medications, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // MedicalInfoUpdateRequestDto.toJson — PATCH 요청 바디 검증
  // -------------------------------------------------------------------------
  group('MedicalInfoUpdateRequestDto.toJson — 서버 스키마 키 검증', () {
    test('toJson 결과에 allergens/medications 키만 존재한다', () {
      const dto = MedicalInfoUpdateRequestDto(
        allergens: ['milk', 'egg'],
        medications: ['omeprazole'],
      );
      final json = dto.toJson();

      expect(json['allergens'], ['milk', 'egg']);
      expect(json['medications'], ['omeprazole']);
      expect(json.containsKey('allergies'), isFalse);
    });

    test('빈 DTO의 toJson은 빈 리스트를 반환한다', () {
      const dto = MedicalInfoUpdateRequestDto();
      final json = dto.toJson();

      expect(json['allergens'], <String>[]);
      expect(json['medications'], <String>[]);
    });
  });
}
