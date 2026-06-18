import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

void main() {
  // -------------------------------------------------------------------------
  // VerdictLevelGrade.fromGrade — 서버 문자열 → 도메인
  // -------------------------------------------------------------------------

  group('VerdictLevelGrade.fromGrade — 4값 정방향 매핑', () {
    test('"RECOMMEND" → VerdictLevel.recommend', () {
      expect(VerdictLevelGrade.fromGrade('RECOMMEND'), VerdictLevel.recommend);
    });

    test('"CAUTION" → VerdictLevel.caution', () {
      expect(VerdictLevelGrade.fromGrade('CAUTION'), VerdictLevel.caution);
    });

    test('"RISK" → VerdictLevel.risk (구 danger가 아닌 risk 정합)', () {
      expect(VerdictLevelGrade.fromGrade('RISK'), VerdictLevel.risk);
    });

    test('"UNKNOWN" → VerdictLevel.unknown', () {
      expect(VerdictLevelGrade.fromGrade('UNKNOWN'), VerdictLevel.unknown);
    });
  });

  group('VerdictLevelGrade.fromGrade — 미지 값 폴백', () {
    test('미지 grade는 VerdictLevel.unknown으로 폴백된다', () {
      expect(VerdictLevelGrade.fromGrade('DANGER'), VerdictLevel.unknown);
    });

    test('빈 문자열은 VerdictLevel.unknown으로 폴백된다', () {
      expect(VerdictLevelGrade.fromGrade(''), VerdictLevel.unknown);
    });

    test('소문자 "risk"는 폴백 (대소문자 구분 계약)', () {
      expect(VerdictLevelGrade.fromGrade('risk'), VerdictLevel.unknown);
    });

    test('신규 미래 grade는 unknown으로 폴백된다 (안전 기본값)', () {
      expect(
        VerdictLevelGrade.fromGrade('NEW_GRADE_2099'),
        VerdictLevel.unknown,
      );
    });
  });

  // -------------------------------------------------------------------------
  // VerdictLevel.toServerGrade — 도메인 → 서버 문자열
  // -------------------------------------------------------------------------

  group('VerdictLevel.toServerGrade — 4값 역방향 매핑', () {
    test('VerdictLevel.recommend → "RECOMMEND"', () {
      expect(VerdictLevel.recommend.toServerGrade(), 'RECOMMEND');
    });

    test('VerdictLevel.caution → "CAUTION"', () {
      expect(VerdictLevel.caution.toServerGrade(), 'CAUTION');
    });

    test('VerdictLevel.risk → "RISK" (구 "DANGER"가 아님을 명시 단언)', () {
      expect(VerdictLevel.risk.toServerGrade(), 'RISK');
    });

    test('VerdictLevel.unknown → "UNKNOWN"', () {
      expect(VerdictLevel.unknown.toServerGrade(), 'UNKNOWN');
    });
  });

  // -------------------------------------------------------------------------
  // 왕복(Round-trip) 단언 — fromGrade(toServerGrade()) == 원본
  // -------------------------------------------------------------------------

  group('Round-trip: fromGrade(toServerGrade()) == 원본', () {
    for (final level in VerdictLevel.values) {
      test('${level.name} 왕복', () {
        final roundTripped =
            VerdictLevelGrade.fromGrade(level.toServerGrade());
        expect(roundTripped, level);
      });
    }
  });

  // -------------------------------------------------------------------------
  // toServerGrade는 .name.toUpperCase() 우연일치에 의존하지 않는다
  // -------------------------------------------------------------------------

  group('toServerGrade — 명시 switch 계약 단언', () {
    test('risk의 .name은 "risk"이지만 toServerGrade()는 "RISK"를 반환한다', () {
      // .name.toUpperCase() == "RISK" 이므로 우연일치처럼 보이지만,
      // 구현이 명시 switch를 사용함을 확인한다.
      const level = VerdictLevel.risk;
      expect(level.name, 'risk'); // enum 이름 확인
      expect(level.toServerGrade(), 'RISK'); // 서버 계약값 확인
    });

    test('모든 grade의 toServerGrade()는 대문자 문자열이다', () {
      for (final level in VerdictLevel.values) {
        final grade = level.toServerGrade();
        expect(grade, grade.toUpperCase(), reason: '${level.name}: "$grade"');
      }
    });

    test('toServerGrade()와 fromGrade()의 상호 역함수 성질 (전체 도메인)', () {
      // toServerGrade로 나온 문자열을 fromGrade에 넣으면 반드시 원본이 돌아온다.
      for (final level in VerdictLevel.values) {
        expect(
          VerdictLevelGrade.fromGrade(level.toServerGrade()),
          level,
          reason: '${level.name} 왕복 실패',
        );
      }
    });
  });
}
