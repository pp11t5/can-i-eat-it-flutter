import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/utils/verdict_share_util.dart';

void main() {
  group('buildShareText', () {
    test('items 있는 케이스: 포맷 전체 검증', () {
      final verdict = EatVerdict.recommend(foodName: '두부');
      // recommend 팩토리는 기본 items를 포함한다
      final text = buildShareText(verdict);

      expect(text, contains('[먹어도 돼?] 두부 판정 결과'));
      expect(text, contains('판정: 권장'));
      expect(text, contains('앱에서 자세히 보기: https://can-i-eat-it.app'));

      // items가 있으면 첫 번째 항목의 emphasis와 body가 포함돼야 한다
      if (verdict.items.isNotEmpty) {
        expect(text, contains(verdict.items.first.emphasis));
        expect(text, contains(verdict.items.first.body));
      }
    });

    test('items 없는 케이스: items 섹션 생략 검증', () {
      final verdict = EatVerdict.recommend(foodName: '두부').copyWith(
        items: const [],
      );
      final text = buildShareText(verdict);

      expect(text, contains('[먹어도 돼?] 두부 판정 결과'));
      expect(text, contains('판정: 권장'));
      expect(text, contains('앱에서 자세히 보기: https://can-i-eat-it.app'));
      // items가 없으므로 emphasis/body가 없어야 한다
      expect(text, isNot(contains('트리거')));
    });

    test('caution 판정 — "판정: 주의" 포함', () {
      final verdict = EatVerdict.caution(foodName: '된장찌개');
      final text = buildShareText(verdict);

      expect(text, contains('[먹어도 돼?] 된장찌개 판정 결과'));
      expect(text, contains('판정: 주의'));
      expect(text, contains('앱에서 자세히 보기: https://can-i-eat-it.app'));
    });

    test('risk 판정 — "판정: 위험" 포함', () {
      final verdict = EatVerdict.risk(foodName: '커피');
      final text = buildShareText(verdict);

      expect(text, contains('[먹어도 돼?] 커피 판정 결과'));
      expect(text, contains('판정: 위험'));
      expect(text, contains('앱에서 자세히 보기: https://can-i-eat-it.app'));
    });

    test('앱 링크 앞에 빈 줄이 존재한다', () {
      final verdict = EatVerdict.recommend(foodName: '두부');
      final text = buildShareText(verdict);

      expect(text, contains('\n\n앱에서 자세히 보기:'));
    });
  });
}
