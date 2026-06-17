import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/utils/kst_time.dart';

void main() {
  // -------------------------------------------------------------------------
  // toServerDate — 'YYYY-MM-DD' 형식·KST 일자 경계
  // -------------------------------------------------------------------------

  group('toServerDate — 기본 형식', () {
    test('2026-06-17 UTC 기준 값을 KST 변환 후 "2026-06-17"을 반환한다', () {
      // UTC 2026-06-17T00:00:00 → KST 2026-06-17T09:00:00 → '2026-06-17'
      final dt = DateTime.utc(2026, 6, 17);
      expect(toServerDate(dt), '2026-06-17');
    });

    test('포맷은 YYYY-MM-DD (하이픈 구분자 10자)이다', () {
      final dt = DateTime.utc(2026, 6, 17);
      final result = toServerDate(dt);
      expect(result, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    });

    test('월·일이 2자리 패딩된다 — 1월 1일', () {
      // UTC 2026-01-01T00:00:00 → KST 2026-01-01T09:00:00 → '2026-01-01'
      final dt = DateTime.utc(2026, 1, 1);
      expect(toServerDate(dt), '2026-01-01');
    });
  });

  group('toServerDate — KST 일자 경계', () {
    test('UTC 15:00는 KST 00:00(다음날 자정) — 다음날 날짜를 반환한다', () {
      // UTC 2026-06-17T15:00:00 = KST 2026-06-18T00:00:00
      final dt = DateTime.utc(2026, 6, 17, 15, 0, 0);
      expect(toServerDate(dt), '2026-06-18');
    });

    test('UTC 14:59는 KST 23:59(당일) — 당일 날짜를 반환한다', () {
      // UTC 2026-06-17T14:59:00 = KST 2026-06-17T23:59:00
      final dt = DateTime.utc(2026, 6, 17, 14, 59, 0);
      expect(toServerDate(dt), '2026-06-17');
    });

    test('UTC 23:00는 KST 08:00(다음날) — 다음날 날짜를 반환한다', () {
      // UTC 2026-06-16T23:00:00 = KST 2026-06-17T08:00:00
      final dt = DateTime.utc(2026, 6, 16, 23, 0, 0);
      expect(toServerDate(dt), '2026-06-17');
    });

    test('월말 UTC 15:00는 KST 다음달 1일 00:00 — 월 경계를 올바르게 처리한다', () {
      // UTC 2026-06-30T15:00:00 = KST 2026-07-01T00:00:00
      final dt = DateTime.utc(2026, 6, 30, 15, 0, 0);
      expect(toServerDate(dt), '2026-07-01');
    });
  });

  // -------------------------------------------------------------------------
  // toServerOffset — ISO-8601 +09:00 포맷·자리수
  // -------------------------------------------------------------------------

  group('toServerOffset — 기본 형식', () {
    test('"YYYY-MM-DDTHH:MM:SS+09:00" 형식이다', () {
      final dt = DateTime.utc(2026, 6, 17, 0, 2, 0);
      final result = toServerOffset(dt);
      expect(
        result,
        matches(RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+09:00$')),
      );
    });

    test('오프셋 접미사는 정확히 "+09:00"이다', () {
      final dt = DateTime.utc(2026, 6, 17, 0, 0, 0);
      expect(toServerOffset(dt), endsWith('+09:00'));
    });

    test('UTC 00:02:00 → KST 09:02:00+09:00 (명세 fixture 값)', () {
      // 실서버 fixture: eatenAt = '2026-06-17T09:02:00+09:00'
      // UTC 2026-06-17T00:02:00 → KST 2026-06-17T09:02:00
      final dt = DateTime.utc(2026, 6, 17, 0, 2, 0);
      expect(toServerOffset(dt), '2026-06-17T09:02:00+09:00');
    });
  });

  group('toServerOffset — 2자리 패딩', () {
    test('시·분·초가 2자리로 패딩된다 — 00:00:05', () {
      // UTC 2026-06-17T00:00:05 → KST 2026-06-17T09:00:05
      final dt = DateTime.utc(2026, 6, 17, 0, 0, 5);
      expect(toServerOffset(dt), '2026-06-17T09:00:05+09:00');
    });

    test('시 패딩: UTC 01:02:03 → KST 10:02:03', () {
      final dt = DateTime.utc(2026, 6, 17, 1, 2, 3);
      expect(toServerOffset(dt), '2026-06-17T10:02:03+09:00');
    });

    test('자정 UTC → KST 09:00:00+09:00', () {
      final dt = DateTime.utc(2026, 6, 17);
      expect(toServerOffset(dt), '2026-06-17T09:00:00+09:00');
    });
  });

  group('toServerOffset — KST 일자 경계', () {
    test('UTC 15:00:00 → KST 다음날 00:00:00+09:00', () {
      // UTC 2026-06-17T15:00:00 = KST 2026-06-18T00:00:00
      final dt = DateTime.utc(2026, 6, 17, 15, 0, 0);
      expect(toServerOffset(dt), '2026-06-18T00:00:00+09:00');
    });

    test('toServerDate와 toServerOffset의 날짜 부분이 일치한다 (경계값)', () {
      final dt = DateTime.utc(2026, 6, 17, 15, 0, 0);
      final datePart = toServerDate(dt);
      final offsetDatePart = toServerOffset(dt).substring(0, 10);
      expect(offsetDatePart, datePart);
    });
  });
}
