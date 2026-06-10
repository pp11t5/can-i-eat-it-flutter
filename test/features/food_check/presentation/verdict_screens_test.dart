import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_loading_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_result_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_unknown_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_detail_card.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_badge.dart';

Widget _wrap(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

void main() {
  // ---------------------------------------------------------------------------
  // VerdictLoadingScreen
  // ---------------------------------------------------------------------------

  group('VerdictLoadingScreen', () {
    testWidgets('스피너와 닉네임 텍스트를 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(const VerdictLoadingScreen(nickname: '철수')),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('철수님에게 맞는 음식 분석 중이에요'), findsOneWidget);
    });

    testWidgets('닉네임 없을 때 기본값 "회원"을 사용한다', (tester) async {
      await tester.pumpWidget(_wrap(const VerdictLoadingScreen()));
      await tester.pump();

      expect(find.text('회원님에게 맞는 음식 분석 중이에요'), findsOneWidget);
    });

    testWidgets('빈 닉네임일 때 기본값 "회원"을 사용한다', (tester) async {
      await tester.pumpWidget(_wrap(const VerdictLoadingScreen(nickname: '')));
      await tester.pump();

      expect(find.text('회원님에게 맞는 음식 분석 중이에요'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // VerdictUnknownScreen
  // ---------------------------------------------------------------------------

  group('VerdictUnknownScreen', () {
    testWidgets('제목·팁·다시검색 버튼을 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictUnknownScreen(onRetry: () {})),
      );
      await tester.pump();

      expect(find.text('확인할 수 없어요'), findsOneWidget);
      expect(find.text('짧게 핵심 재료만 검색해보세요'), findsOneWidget);
      expect(find.text('영문이 아닌 한글로 검색해보세요'), findsOneWidget);
      expect(find.text('등록되지 않은 음식은 직접 추가해보세요'), findsOneWidget);
      expect(find.text('다시 검색'), findsOneWidget);
    });

    testWidgets('"다시 검색" 버튼 탭 시 onRetry 콜백 호출', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        _wrap(VerdictUnknownScreen(onRetry: () => tapped = true)),
      );
      await tester.pump();

      await tester.tap(find.text('다시 검색'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('MedicalDisclaimer를 포함한다', (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictUnknownScreen(onRetry: () {})),
      );
      await tester.pump();

      // MedicalDisclaimer에는 Icons.info_outline 아이콘이 있다
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('오타 교정: "집접"이 아닌 "직접"을 표시한다', (tester) async {
      await tester.pumpWidget(
        _wrap(VerdictUnknownScreen(onRetry: () {})),
      );
      await tester.pump();

      expect(find.textContaining('직접'), findsWidgets);
      expect(find.textContaining('집접'), findsNothing);
    });
  });

  // ---------------------------------------------------------------------------
  // VerdictResultScreen — recommend
  // ---------------------------------------------------------------------------

  group('VerdictResultScreen recommend', () {
    testWidgets('권장 상태에서 VerdictDetailCard를 렌더한다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.byType(VerdictDetailCard), findsOneWidget);
      expect(find.byType(VerdictBadge), findsOneWidget);
    });

    testWidgets('음식명을 표시한다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.text('두부'), findsWidgets);
    });

    testWidgets('일반 분석 텍스트를 표시한다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.textContaining('단백질'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // VerdictResultScreen — caution
  // ---------------------------------------------------------------------------

  group('VerdictResultScreen caution', () {
    testWidgets('주의 상태에서 대체 음식을 표시한다', (tester) async {
      final verdict = EatVerdict.caution(foodName: '된장찌개');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.text('저염 된장찌개'), findsOneWidget);
      expect(find.text('두부국'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // VerdictResultScreen — danger
  // ---------------------------------------------------------------------------

  group('VerdictResultScreen danger', () {
    testWidgets('위험 상태에서 대체 음식을 표시한다', (tester) async {
      final verdict = EatVerdict.danger(foodName: '커피');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.text('디카페인 커피'), findsOneWidget);
      expect(find.text('보리차'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // VerdictResultScreen — unknown은 VerdictUnknownScreen으로 위임
  // ---------------------------------------------------------------------------

  group('VerdictResultScreen unknown 위임', () {
    testWidgets('unknown 상태에서 VerdictUnknownScreen을 렌더한다', (tester) async {
      final verdict = EatVerdict.unknown(foodName: '정체불명');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.byType(VerdictUnknownScreen), findsOneWidget);
      expect(find.text('확인할 수 없어요'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // VerdictDetailCard — 3섹션
  // ---------------------------------------------------------------------------

  group('VerdictDetailCard 3섹션', () {
    testWidgets('섭취 기록 없으면 기록 섹션 숨김', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(
          Scaffold(
            body: SizedBox(
              width: 343,
              child: VerdictDetailCard(verdict: verdict),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('이전 섭취 기록'), findsNothing);
    });

    testWidgets('섭취 기록 있으면 기록 섹션 표시', (tester) async {
      final verdict = EatVerdict.caution(foodName: '된장찌개');
      await tester.pumpWidget(
        _wrap(
          Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: 343,
                child: VerdictDetailCard(verdict: verdict),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('이전 섭취 기록'), findsOneWidget);
      expect(find.textContaining('2회'), findsOneWidget);
    });
  });
}
