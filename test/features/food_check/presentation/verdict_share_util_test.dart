import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/utils/verdict_share_util.dart';

void main() {
  group('buildShareText', () {
    test('recommend — 등급 ✅ 추천, reason 있음', () {
      final verdict = EatVerdict.recommend(foodName: '두부').copyWith(
        personalTitle: '역류성 식도염에 좋은 식품이에요.',
      );

      final text = buildShareText(verdict);

      expect(text, contains('[먹어도 돼?] 두부 판정 결과'));
      expect(text, contains('등급: ✅ 추천'));
      expect(text, contains('역류성 식도염에 좋은 식품이에요.'));
      expect(text, contains('앱에서 확인하기: https://can-i-eat-it.app'));
    });

    test('caution — 등급 ⚠️ 주의, reason 있음', () {
      final verdict = EatVerdict.caution(foodName: '된장찌개').copyWith(
        personalTitle: '자극적일 수 있어요. 소량 섭취를 권장합니다.',
      );

      final text = buildShareText(verdict);

      expect(text, contains('[먹어도 돼?] 된장찌개 판정 결과'));
      expect(text, contains('등급: ⚠️ 주의'));
      expect(text, contains('자극적일 수 있어요. 소량 섭취를 권장합니다.'));
      expect(text, contains('앱에서 확인하기: https://can-i-eat-it.app'));
    });

    test('risk — 등급 🚫 위험, reason 있음', () {
      final verdict = EatVerdict.risk(foodName: '커피').copyWith(
        personalTitle: '위산 분비를 촉진해 역류 위험이 높습니다.',
      );

      final text = buildShareText(verdict);

      expect(text, contains('[먹어도 돼?] 커피 판정 결과'));
      expect(text, contains('등급: 🚫 위험'));
      expect(text, contains('위산 분비를 촉진해 역류 위험이 높습니다.'));
      expect(text, contains('앱에서 확인하기: https://can-i-eat-it.app'));
    });

    test('reason 없음(personalTitle 빈 문자열) — reason 줄 생략', () {
      // EatVerdict.recommend의 기본 personalTitle은 비어있지 않을 수 있으므로
      // copyWith으로 명시적으로 빈 문자열 지정
      final verdict = EatVerdict.recommend(foodName: '두부').copyWith(
        personalTitle: '',
      );

      final text = buildShareText(verdict);

      expect(text, contains('[먹어도 돼?] 두부 판정 결과'));
      expect(text, contains('등급: ✅ 추천'));
      // reason 줄이 없어야 함 — 등급 다음 줄은 빈 줄이어야 함
      expect(text, isNot(contains('역류')));
      expect(text, contains('앱에서 확인하기: https://can-i-eat-it.app'));
    });

    test('reason 있음 — 앱 링크 앞에 빈 줄이 존재한다', () {
      final verdict = EatVerdict.caution(foodName: '라면').copyWith(
        personalTitle: '주의가 필요해요.',
      );

      final text = buildShareText(verdict);

      // 빈 줄(\n\n) 뒤에 앱 링크가 온다
      expect(text, contains('\n\n앱에서 확인하기:'));
    });
  });
}
