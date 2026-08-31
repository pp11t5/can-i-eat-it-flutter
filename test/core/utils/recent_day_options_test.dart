import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/core/utils/recent_day_options.dart';

void main() {
  final now = DateTime(2026, 8, 26, 15, 30);

  group('recentDayOptions', () {
    test('하한 없으면 오늘 포함 최근 7일', () {
      final days = recentDayOptions(now: now);
      expect(days, hasLength(7));
      expect(days.first, DateTime(2026, 8, 20));
      expect(days.last, DateTime(2026, 8, 26));
    });

    test('가입일이 오늘이면 오늘만', () {
      final days = recentDayOptions(
        now: now,
        minDate: DateTime(2026, 8, 26, 9),
      );
      expect(days, [DateTime(2026, 8, 26)]);
    });

    test('가입일이 어제이면 어제와 오늘만', () {
      final days = recentDayOptions(
        now: now,
        minDate: DateTime(2026, 8, 25),
      );
      expect(days, [DateTime(2026, 8, 25), DateTime(2026, 8, 26)]);
    });

    test('가입일이 7일보다 이전이면 최근 7일 그대로', () {
      final days = recentDayOptions(
        now: now,
        minDate: DateTime(2026, 8, 1),
      );
      expect(days, hasLength(7));
      expect(days.first, DateTime(2026, 8, 20));
    });
  });
}
