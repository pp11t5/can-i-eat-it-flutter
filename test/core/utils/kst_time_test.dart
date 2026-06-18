import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/utils/kst_time.dart';

void main() {
  // -------------------------------------------------------------------------
  // toServerDate — 컴포넌트 verbatim, 시간 연산 없음
  // 새 계약: dt의 year/month/day 컴포넌트를 그대로 YYYY-MM-DD로 포맷.
  // -------------------------------------------------------------------------

  group('toServerDate — 컴포넌트 verbatim (새 계약)', () {
    test('KST wall-clock 9시 02분 → "2026-06-17" (시간 연산 없음)', () {
      // 호출자는 KST wall-clock(isUtc=false)을 넘긴다.
      final dt = DateTime(2026, 6, 17, 9, 2, 0);
      expect(toServerDate(dt), '2026-06-17');
    });

    test('포맷은 YYYY-MM-DD (하이픈 구분자 10자)이다', () {
      final dt = DateTime(2026, 6, 17, 9, 2, 0);
      final result = toServerDate(dt);
      expect(result, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    });

    test('월·일 2자리 패딩 — 1월 1일', () {
      final dt = DateTime(2026, 1, 1, 8, 0, 0);
      expect(toServerDate(dt), '2026-01-01');
    });

    test('컴포넌트 verbatim — +9 가산 없음: DateTime(2026,6,17) → "2026-06-17"', () {
      // 구버전이면 .toUtc().add(9h)로 인해 날짜가 달라질 수 있다.
      final dt = DateTime(2026, 6, 17, 0, 0, 0); // local 자정
      // 새 계약: 컴포넌트 그대로 → 2026-06-17
      expect(toServerDate(dt), '2026-06-17');
    });
  });

  // -------------------------------------------------------------------------
  // toServerOffset — 컴포넌트 verbatim, 시간 연산 없음
  // 새 계약: dt의 각 컴포넌트를 그대로 YYYY-MM-DDTHH:MM:SS+09:00으로 포맷.
  // -------------------------------------------------------------------------

  group('toServerOffset — 컴포넌트 verbatim (새 계약)', () {
    test('KST wall-clock 9시 02분 → "2026-06-17T09:02:00+09:00" (명세 fixture 값)', () {
      // 실서버 fixture: eatenAt = '2026-06-17T09:02:00+09:00'
      // 호출자가 KST wall-clock DateTime(2026,6,17,9,2,0)을 넘기면
      // 컴포넌트를 그대로 포맷해야 한다. 시간 연산 없음.
      final dt = DateTime(2026, 6, 17, 9, 2, 0);
      expect(toServerOffset(dt), '2026-06-17T09:02:00+09:00');
    });

    test('"YYYY-MM-DDTHH:MM:SS+09:00" 형식이다', () {
      final dt = DateTime(2026, 6, 17, 9, 2, 0);
      final result = toServerOffset(dt);
      expect(
        result,
        matches(RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\+09:00$')),
      );
    });

    test('오프셋 접미사는 정확히 "+09:00"이다', () {
      final dt = DateTime(2026, 6, 17, 9, 0, 0);
      expect(toServerOffset(dt), endsWith('+09:00'));
    });

    test('이중 변환 회귀 가드 — hour가 입력 hour와 동일(+9 가산 없음)', () {
      // 구버전에서는 .toUtc().add(9h) → local-flag 입력에 +9가 추가된다.
      // 새 계약: 컴포넌트 그대로 → hour 불변.
      final dt = DateTime(2026, 6, 17, 9, 2, 0);
      final result = toServerOffset(dt);
      // 결과의 시(HH) 부분 추출: "T09:02:00+09:00" → "09"
      final hourStr = result.substring(11, 13);
      expect(hourStr, '09'); // 입력 hour=9 → 출력 hour=09 (가산 없음)
    });

    test('2자리 패딩 — 시·분·초', () {
      final dt = DateTime(2026, 6, 17, 0, 0, 5);
      expect(toServerOffset(dt), '2026-06-17T00:00:05+09:00');
    });

    test('시 패딩: 시=1, 분=2, 초=3 → T01:02:03', () {
      final dt = DateTime(2026, 6, 17, 1, 2, 3);
      expect(toServerOffset(dt), '2026-06-17T01:02:03+09:00');
    });

    test('자정 wall-clock → "T00:00:00+09:00"', () {
      final dt = DateTime(2026, 6, 17, 0, 0, 0);
      expect(toServerOffset(dt), '2026-06-17T00:00:00+09:00');
    });

    test('isUtc=true인 DateTime도 컴포넌트 그대로 포맷 (연산 없음)', () {
      // 입력이 isUtc=true여도 컴포넌트 verbatim 계약: hour=9 → 출력 hour=09.
      final dt = DateTime.utc(2026, 6, 17, 9, 2, 0);
      expect(toServerOffset(dt), '2026-06-17T09:02:00+09:00');
    });
  });

  // -------------------------------------------------------------------------
  // toServerDate + toServerOffset 정합성
  // -------------------------------------------------------------------------

  group('toServerDate·toServerOffset 날짜 부분 정합성', () {
    test('같은 wall-clock DateTime에 대해 날짜 부분이 일치한다', () {
      final dt = DateTime(2026, 6, 17, 9, 2, 0);
      expect(toServerOffset(dt).substring(0, 10), toServerDate(dt));
    });
  });

  // -------------------------------------------------------------------------
  // nowKst — local-flag KST wall-clock 반환
  // -------------------------------------------------------------------------

  group('nowKst — local-flag KST wall-clock', () {
    test('isUtc == false 반환 (local-flag)', () {
      final result = nowKst();
      expect(result.isUtc, isFalse);
    });

    test('이중 변환 회귀 가드 — nowKst()를 toServerOffset에 넣어도 hour 불변', () {
      // nowKst()가 반환한 hour를 toServerOffset이 다시 +9하면 안 된다.
      final kst = nowKst();
      final result = toServerOffset(kst);
      final hourStr = result.substring(11, 13);
      final expectedHour = kst.hour.toString().padLeft(2, '0');
      expect(hourStr, expectedHour);
    });

    test('nowKst()의 toServerDate 결과와 toServerOffset 날짜 부분이 일치', () {
      final kst = nowKst();
      expect(toServerOffset(kst).substring(0, 10), toServerDate(kst));
    });
  });
}
