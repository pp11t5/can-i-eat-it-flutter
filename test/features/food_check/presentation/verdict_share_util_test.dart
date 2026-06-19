import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/utils/verdict_share_util.dart';

void main() {
  group('buildShareText', () {
    test('음식명이 포함된다', () {
      final verdict = EatVerdict.recommend(foodName: '두부');
      final text = buildShareText(verdict);

      expect(text, contains('두부 판정 결과'));
    });

    test('🍽️ 이모지가 포함된다', () {
      final verdict = EatVerdict.recommend(foodName: '두부');
      final text = buildShareText(verdict);

      expect(text, contains('🍽️'));
    });

    test('recommend 판정 — "등급: 권장" 포함', () {
      final verdict = EatVerdict.recommend(foodName: '두부');
      final text = buildShareText(verdict);

      expect(text, contains('등급: 권장'));
    });

    test('caution 판정 — "등급: 주의" 포함', () {
      final verdict = EatVerdict.caution(foodName: '된장찌개');
      final text = buildShareText(verdict);

      expect(text, contains('등급: 주의'));
    });

    test('risk 판정 — "등급: 위험" 포함', () {
      final verdict = EatVerdict.risk(foodName: '커피');
      final text = buildShareText(verdict);

      expect(text, contains('등급: 위험'));
    });

    test('unknown 판정 — "등급: 확인 어려움" 포함', () {
      final verdict = EatVerdict.unknown(foodName: '낯선음식');
      final text = buildShareText(verdict);

      expect(text, contains('등급: 확인 어려움'));
    });

    test('items 있으면 첫 번째 body가 근거로 포함된다', () {
      final verdict = EatVerdict.recommend(foodName: '두부');
      // EatVerdict.recommend 샘플의 items.first.body = '역류 트리거에 해당하지 않아요.'
      final text = buildShareText(verdict);

      expect(text, contains('근거: 역류 트리거에 해당하지 않아요.'));
    });

    test('items 없으면 "근거: 정보 없음" 포함된다', () {
      final verdict = EatVerdict(
        level: VerdictLevel.unknown,
        foodName: '낯선음식',
        items: const [],
      );
      final text = buildShareText(verdict);

      expect(text, contains('근거: 정보 없음'));
    });

    test('#먹어도돼 #건강식단 해시태그가 포함된다', () {
      final verdict = EatVerdict.recommend(foodName: '두부');
      final text = buildShareText(verdict);

      expect(text, contains('#먹어도돼'));
      expect(text, contains('#건강식단'));
    });

    // W33-F2 스펙 케이스
    test('recommend 판정 + analysisText "속 자극이 적어요" — 등급/근거/해시태그 포함', () {
      final verdict = EatVerdict(
        level: VerdictLevel.recommend,
        foodName: '두부',
        items: const [
          VerdictItem(emphasis: '분석', body: '속 자극이 적어요'),
        ],
      );
      final text = buildShareText(verdict);

      expect(text, contains('등급: 권장'));
      expect(text, contains('근거: 속 자극이 적어요'));
      expect(text, contains('#먹어도돼'));
    });
  });
}
