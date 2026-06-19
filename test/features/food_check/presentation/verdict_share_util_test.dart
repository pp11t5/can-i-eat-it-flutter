import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/utils/verdict_share_util.dart';

void main() {
  group('buildShareText', () {
    test('[먹어도 돼?] 앱 태그가 포함된다', () {
      final verdict = EatVerdict.recommend(foodName: '두부');
      final text = buildShareText(verdict);

      expect(text, contains('[먹어도 돼?]'));
    });

    test('앱 다운로드 링크가 포함된다', () {
      final verdict = EatVerdict.recommend(foodName: '두부');
      final text = buildShareText(verdict);

      expect(text, contains('https://can-i-eat-it.app'));
    });

    test('foodName과 판정 레벨이 포함된다', () {
      final verdict = EatVerdict.recommend(foodName: '두부');
      final text = buildShareText(verdict);

      expect(text, contains('[먹어도 돼?] 두부 판정 결과'));
      expect(text, contains('판정: 권장'));
    });

    test('안내 문구가 포함된다', () {
      final verdict = EatVerdict.recommend(foodName: '두부');
      final text = buildShareText(verdict);

      expect(text, contains('내 건강에 맞는 음식을 확인해보세요.'));
    });

    test('caution 판정 — "판정: 주의" 포함', () {
      final verdict = EatVerdict.caution(foodName: '된장찌개');
      final text = buildShareText(verdict);

      expect(text, contains('[먹어도 돼?] 된장찌개 판정 결과'));
      expect(text, contains('판정: 주의'));
      expect(text, contains('https://can-i-eat-it.app'));
    });

    test('risk 판정 — "판정: 위험" 포함', () {
      final verdict = EatVerdict.risk(foodName: '커피');
      final text = buildShareText(verdict);

      expect(text, contains('[먹어도 돼?] 커피 판정 결과'));
      expect(text, contains('판정: 위험'));
      expect(text, contains('https://can-i-eat-it.app'));
    });
  });
}
