import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/weekly_report/data/dtos/weekly_report_dto.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';

void main() {
  // -------------------------------------------------------------------------
  // ComfortableStateDto — GET /my-page/reports result.comfortableState
  // -------------------------------------------------------------------------
  group('ComfortableStateDto', () {
    test('streakCount·recommendedMealCount·percentage를 파싱하고 toEntity에 반영한다', () {
      final dto = ComfortableStateDto.fromJson(const {
        'streakCount': 3,
        'recommendedMealCount': 6,
        'percentage': 84.3,
      });
      expect(dto.streakCount, 3);
      expect(dto.recommendedMealCount, 6);
      expect(dto.percentage, 84.3);

      final entity = dto.toEntity();
      expect(entity, isA<ComfortableState>());
      expect(entity.streakCount, 3);
      expect(entity.recommendedMealCount, 6);
      expect(entity.percentage, 84.3);
    });

    test('percentage는 double로 파싱된다 (정수 리터럴 입력 포함)', () {
      final dto = ComfortableStateDto.fromJson(const {
        'streakCount': 1,
        'recommendedMealCount': 2,
        'percentage': 50,
      });
      expect(dto.percentage, isA<double>());
      expect(dto.percentage, 50.0);
    });

    test('키 전체 누락 시 각 필드는 0으로 폴백된다', () {
      final entity = ComfortableStateDto.fromJson(const {}).toEntity();
      expect(entity.streakCount, 0);
      expect(entity.recommendedMealCount, 0);
      expect(entity.percentage, 0.0);
    });

    test('percentage만 누락돼도 0.0으로 폴백된다', () {
      final dto = ComfortableStateDto.fromJson(const {
        'streakCount': 3,
        'recommendedMealCount': 6,
      });
      expect(dto.percentage, 0.0);
    });
  });

  // -------------------------------------------------------------------------
  // MealCountDto — GET /my-page/reports result.mealCount
  // -------------------------------------------------------------------------
  group('MealCountDto', () {
    test('recommendCount·cautionCount·riskCount를 파싱하고 toEntity에 반영한다', () {
      final dto = MealCountDto.fromJson(const {
        'recommendCount': 6,
        'cautionCount': 3,
        'riskCount': 2,
      });
      expect(dto.recommendCount, 6);
      expect(dto.cautionCount, 3);
      expect(dto.riskCount, 2);

      final entity = dto.toEntity();
      expect(entity, isA<MealCount>());
      expect(entity.recommendCount, 6);
      expect(entity.cautionCount, 3);
      expect(entity.riskCount, 2);
    });

    test('키 전체 누락 시 각 카운트는 0으로 폴백된다', () {
      final entity = MealCountDto.fromJson(const {}).toEntity();
      expect(entity.recommendCount, 0);
      expect(entity.cautionCount, 0);
      expect(entity.riskCount, 0);
    });

    test('일부 키만 누락돼도 해당 카운트만 0으로 폴백된다', () {
      final dto = MealCountDto.fromJson(const {'recommendCount': 6});
      expect(dto.recommendCount, 6);
      expect(dto.cautionCount, 0);
      expect(dto.riskCount, 0);
    });
  });

  // -------------------------------------------------------------------------
  // WeeklyReportDto — GET /my-page/reports result
  // -------------------------------------------------------------------------
  group('WeeklyReportDto', () {
    test('startDate·endDate·weekLabel·중첩 DTO를 파싱하고 toEntity에 반영한다', () {
      final dto = WeeklyReportDto.fromJson(const {
        'startDate': '2026-05-10',
        'endDate': '2026-05-16',
        'weekLabel': '2026년 5월 둘째주',
        'comfortableState': {
          'streakCount': 3,
          'recommendedMealCount': 6,
          'percentage': 84.3,
        },
        'mealCount': {
          'recommendCount': 6,
          'cautionCount': 3,
          'riskCount': 2,
        },
      });
      expect(dto.startDate, '2026-05-10');
      expect(dto.endDate, '2026-05-16');
      expect(dto.weekLabel, '2026년 5월 둘째주');
      expect(dto.comfortableState, isA<ComfortableStateDto>());
      expect(dto.mealCount, isA<MealCountDto>());

      final entity = dto.toEntity();
      expect(entity, isA<WeeklyReport>());
      expect(entity.startDate, '2026-05-10');
      expect(entity.endDate, '2026-05-16');
      expect(entity.weekLabel, '2026년 5월 둘째주');
      expect(entity.comfortableState.streakCount, 3);
      expect(entity.comfortableState.recommendedMealCount, 6);
      expect(entity.comfortableState.percentage, 84.3);
      expect(entity.mealCount.recommendCount, 6);
      expect(entity.mealCount.cautionCount, 3);
      expect(entity.mealCount.riskCount, 2);
    });

    test('comfortableState 내부 필드 일부 누락 시 해당 필드만 0으로 폴백된다', () {
      final entity = WeeklyReportDto.fromJson(const {
        'startDate': '2026-05-10',
        'endDate': '2026-05-16',
        'weekLabel': '2026년 5월 둘째주',
        'comfortableState': {'streakCount': 3},
        'mealCount': {
          'recommendCount': 6,
          'cautionCount': 3,
          'riskCount': 2,
        },
      }).toEntity();
      expect(entity.comfortableState.streakCount, 3);
      expect(entity.comfortableState.recommendedMealCount, 0);
      expect(entity.comfortableState.percentage, 0.0);
    });

    test('mealCount 객체 자체 누락 시 전체 0 폴백으로 처리된다', () {
      final entity = WeeklyReportDto.fromJson(const {
        'startDate': '2026-05-10',
        'endDate': '2026-05-16',
        'weekLabel': '2026년 5월 둘째주',
        'comfortableState': {
          'streakCount': 3,
          'recommendedMealCount': 6,
          'percentage': 84.3,
        },
        'mealCount': <String, dynamic>{},
      }).toEntity();
      expect(entity.mealCount.recommendCount, 0);
      expect(entity.mealCount.cautionCount, 0);
      expect(entity.mealCount.riskCount, 0);
    });
  });
}
