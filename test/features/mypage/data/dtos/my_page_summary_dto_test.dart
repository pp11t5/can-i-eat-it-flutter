import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/mypage/data/dtos/my_page_summary_dto.dart';
import 'package:can_i_eat_it/features/mypage/domain/entities/my_page_summary.dart';

void main() {
  // -------------------------------------------------------------------------
  // MyPageProfileSummaryDto — GET /my-page/summary result.profile
  // -------------------------------------------------------------------------
  group('MyPageProfileSummaryDto', () {
    test('nickName·profileImage·disease를 파싱하고 toEntity에 반영한다', () {
      final dto = MyPageProfileSummaryDto.fromJson(const {
        'nickName': '홍길동',
        'profileImage': 'https://example.com/a.png',
        'disease': 'gerd',
      });
      expect(dto.nickName, '홍길동');
      expect(dto.profileImage, 'https://example.com/a.png');
      expect(dto.disease, 'gerd');

      final entity = dto.toEntity();
      expect(entity, isA<MyPageProfileSummary>());
      expect(entity.nickName, '홍길동');
      expect(entity.profileImage, 'https://example.com/a.png');
      expect(entity.disease, MyPageDisease.gerd);
    });

    test('disease 서버 4종 문자열이 각각 정확히 매핑된다', () {
      expect(
        MyPageProfileSummaryDto.fromJson(const {'disease': 'gerd'})
            .toEntity()
            .disease,
        MyPageDisease.gerd,
      );
      expect(
        MyPageProfileSummaryDto.fromJson(const {'disease': 'gastritis_ulcer'})
            .toEntity()
            .disease,
        MyPageDisease.gastritisUlcer,
      );
      expect(
        MyPageProfileSummaryDto.fromJson(const {'disease': 'ibs'})
            .toEntity()
            .disease,
        MyPageDisease.ibs,
      );
      expect(
        MyPageProfileSummaryDto.fromJson(
          const {'disease': 'functional_dyspepsia'},
        ).toEntity().disease,
        MyPageDisease.functionalDyspepsia,
      );
    });

    test('미지 disease 값은 unknown으로 폴백된다', () {
      final entity =
          MyPageProfileSummaryDto.fromJson(const {'disease': 'new_disease'})
              .toEntity();
      expect(entity.disease, MyPageDisease.unknown);
    });

    test('profileImage 누락 시 null이다', () {
      final dto = MyPageProfileSummaryDto.fromJson(const {
        'nickName': '홍길동',
        'disease': 'gerd',
      });
      expect(dto.profileImage, isNull);
    });

    test('키 전체 누락 시 nickName·disease는 빈 문자열로 폴백된다', () {
      final dto = MyPageProfileSummaryDto.fromJson(const {});
      expect(dto.nickName, '');
      expect(dto.disease, '');
      expect(dto.toEntity().disease, MyPageDisease.unknown);
    });
  });

  // -------------------------------------------------------------------------
  // FoodHistorySummaryDto — GET /my-page/summary result.foodHistory
  // -------------------------------------------------------------------------
  group('FoodHistorySummaryDto', () {
    test('safeCount·cautionCount를 파싱하고 toEntity에 반영한다', () {
      final dto = FoodHistorySummaryDto.fromJson(const {
        'safeCount': 12,
        'cautionCount': 4,
      });
      expect(dto.safeCount, 12);
      expect(dto.cautionCount, 4);

      final entity = dto.toEntity();
      expect(entity, isA<FoodHistorySummary>());
      expect(entity.safeCount, 12);
      expect(entity.cautionCount, 4);
    });

    test('키 전체 누락 시 각 카운트는 0으로 폴백된다', () {
      final entity = FoodHistorySummaryDto.fromJson(const {}).toEntity();
      expect(entity.safeCount, 0);
      expect(entity.cautionCount, 0);
    });
  });

  // -------------------------------------------------------------------------
  // WeeklySummaryDto — GET /my-page/summary result.weeklySummary
  // -------------------------------------------------------------------------
  group('WeeklySummaryDto', () {
    test('mealRecordCount·recentSymptomCount·streakCount·mealCount를 파싱하고 toEntity에 반영한다',
        () {
      final dto = WeeklySummaryDto.fromJson(const {
        'mealRecordCount': 9,
        'recentSymptomCount': 2,
        'streakCount': 4,
        'mealCount': {
          'recommendCount': 9,
          'cautionCount': 3,
          'riskCount': 1,
          'unknownCount': 1,
        },
      });
      expect(dto.mealRecordCount, 9);
      expect(dto.recentSymptomCount, 2);
      expect(dto.streakCount, 4);

      final entity = dto.toEntity();
      expect(entity.mealRecordCount, 9);
      expect(entity.recentSymptomCount, 2);
      expect(entity.streakCount, 4);
      expect(entity.mealCount.recommendCount, 9);
      expect(entity.mealCount.cautionCount, 3);
      expect(entity.mealCount.riskCount, 1);
      expect(entity.mealCount.unknownCount, 1);
    });

    test('mealCount 객체 자체 누락 시 전체 0 폴백으로 처리된다', () {
      final entity = WeeklySummaryDto.fromJson(const {
        'mealRecordCount': 9,
      }).toEntity();
      expect(entity.mealCount.recommendCount, 0);
      expect(entity.mealCount.cautionCount, 0);
      expect(entity.mealCount.riskCount, 0);
      expect(entity.mealCount.unknownCount, 0);
    });

    test('키 전체 누락 시 각 카운트는 0으로 폴백된다', () {
      final entity = WeeklySummaryDto.fromJson(const {}).toEntity();
      expect(entity.mealRecordCount, 0);
      expect(entity.recentSymptomCount, 0);
      expect(entity.streakCount, 0);
    });
  });

  // -------------------------------------------------------------------------
  // MyPageSummaryDto — GET /my-page/summary
  // -------------------------------------------------------------------------
  group('MyPageSummaryDto', () {
    test('profile·foodHistory·weeklySummary를 파싱하고 toEntity에 반영한다', () {
      final dto = MyPageSummaryDto.fromJson(const {
        'profile': {
          'nickName': '홍길동',
          'profileImage': null,
          'disease': 'gerd',
        },
        'foodHistory': {
          'safeCount': 12,
          'cautionCount': 4,
        },
        'weeklySummary': {
          'mealRecordCount': 9,
          'recentSymptomCount': 2,
          'streakCount': 4,
          'mealCount': {
            'recommendCount': 9,
            'cautionCount': 3,
            'riskCount': 1,
            'unknownCount': 0,
          },
        },
      });

      final entity = dto.toEntity();
      expect(entity, isA<MyPageSummary>());
      expect(entity.profile.nickName, '홍길동');
      expect(entity.profile.disease, MyPageDisease.gerd);
      expect(entity.foodHistory.safeCount, 12);
      expect(entity.foodHistory.cautionCount, 4);
      expect(entity.weeklySummary.mealRecordCount, 9);
      expect(entity.weeklySummary.streakCount, 4);
      expect(entity.weeklySummary.mealCount.recommendCount, 9);
    });
  });
}
