import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/food_check/data/favorite_providers.dart';
import 'package:can_i_eat_it/features/food_check/data/repositories/mock_favorite_repository.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_loading_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_result_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/screens/verdict_unknown_screen.dart';
import 'package:can_i_eat_it/features/food_check/presentation/widgets/verdict_detail_card.dart';

Widget _wrap(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: child,
    ),
  );
}

Widget _wrapWithFavorite(Widget child) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      favoriteRepositoryProvider.overrideWithValue(MockFavoriteRepository()),
    ],
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
    testWidgets('스피너와 로딩 텍스트를 렌더한다', (tester) async {
      await tester.pumpWidget(
        _wrap(const VerdictLoadingScreen()),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('내 몸에 맞는지\n확인하고 있어요'), findsOneWidget);
    });

    testWidgets('초기 상태에서 "AI가 분석 중이에요..." 메시지가 표시된다', (tester) async {
      await tester.pumpWidget(
        _wrap(const VerdictLoadingScreen()),
      );
      await tester.pump();

      expect(find.text('AI가 분석 중이에요...'), findsOneWidget);
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

      // Figma 재정합: VerdictDetailCard 존재 확인 (VerdictBadge는 새 HeroSection에서 제거됨)
      expect(find.byType(VerdictDetailCard), findsOneWidget);
    });

    testWidgets('음식명을 표시한다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.text('두부'), findsWidgets);
    });

    testWidgets('items[0] emphasis 텍스트를 표시한다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.text('트리거/증상 분석'), findsOneWidget);
    });

    testWidgets('등급 헤드라인 문구를 표시한다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      // Figma 재정합: personalTitle 대신 등급별 헤드라인 문구 표시
      expect(find.text('좋은 선택이에요!'), findsOneWidget);
    });

    testWidgets('CTA "다른 음식 검색하기" 버튼이 존재한다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.text('다른 음식 검색하기'), findsOneWidget);
    });

    testWidgets('CTA "내 식단에 추가" 버튼이 존재한다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.text('내 식단에 추가'), findsOneWidget);
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

    testWidgets('주의 상태에서 stateRecords 기록이 있으면 "모두 보기 >" 버튼 노출', (tester) async {
      final verdict = EatVerdict.caution(foodName: '된장찌개');
      // caution 샘플은 total=2
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      // Figma 재정합: "모두 보기 >" 텍스트로 변경
      expect(find.text('모두 보기 >'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // VerdictResultScreen — risk (구 danger)
  // ---------------------------------------------------------------------------

  group('VerdictResultScreen risk', () {
    testWidgets('위험 상태에서 대체 음식을 표시한다', (tester) async {
      final verdict = EatVerdict.risk(foodName: '커피');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.text('디카페인 커피'), findsOneWidget);
      expect(find.text('보리차'), findsOneWidget);
    });

    testWidgets('위험 상태에서 등급 헤드라인 문구를 표시한다', (tester) async {
      final verdict = EatVerdict.risk(foodName: '커피');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      // Figma 재정합: 위험 등급 헤드라인 문구
      expect(find.text('속이 많이 불편해질 수 있어요!'), findsOneWidget);
    });

    testWidgets('위험 상태에서 CTA 2개("다른 음식 검색하기" + "내 식단에 추가") 모두 존재', (tester) async {
      final verdict = EatVerdict.risk(foodName: '커피');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pump();

      expect(find.text('다른 음식 검색하기'), findsOneWidget);
      expect(find.text('내 식단에 추가'), findsOneWidget);
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
  // VerdictDetailCard — 신 구조
  // ---------------------------------------------------------------------------

  group('VerdictDetailCard 신 구조', () {
    testWidgets('items 2개의 emphasis가 렌더된다', (tester) async {
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

      expect(find.text('트리거/증상 분석'), findsOneWidget);
      expect(find.text('알레르기/복용약 분석'), findsOneWidget);
    });

    testWidgets('stateRecords total==0이면 기록 섹션 숨김', (tester) async {
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

      // Figma 재정합: 헤더 텍스트 "N개의 증상 기록" 형식으로 변경
      expect(find.textContaining('증상 기록'), findsNothing);
    });

    testWidgets('stateRecords total>0이면 기록 섹션 표시', (tester) async {
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

      // Figma 재정합: "N개의 증상 기록" 형식 (caution 샘플 total=2)
      expect(find.text('2개의 증상 기록'), findsOneWidget);
    });

    testWidgets('substitutes 빈배열이면 대체음식 섹션 숨김', (tester) async {
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

      // Figma 재정합: 헤더 텍스트 "대체 음식 추천"으로 변경
      expect(find.text('대체 음식 추천'), findsNothing);
    });

    testWidgets('substitutes 있으면 대체음식 섹션 표시', (tester) async {
      final verdict = EatVerdict.risk(foodName: '커피');
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

      // Figma 재정합: 헤더 텍스트 "대체 음식 추천"으로 변경
      expect(find.text('대체 음식 추천'), findsOneWidget);
      expect(find.text('디카페인 커피'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // _BookmarkButton — 토글 스낵바 피드백 (W10-F1)
  // ---------------------------------------------------------------------------

  group('VerdictResultScreen — 등급별 배경색', () {
    testWidgets('recommend 판정 시 연초록(0xFFE6F7EF) 배경 컨테이너가 표시된다',
        (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pumpAndSettle();

      final containers = tester.widgetList<Container>(find.byType(Container));
      final found = containers.any((c) {
        final decoration = c.decoration;
        if (decoration is BoxDecoration) {
          return decoration.color == const Color(0xFFE6F7EF);
        }
        return false;
      });
      expect(found, isTrue);
    });
  });

  group('_BookmarkButton 스낵바 피드백', () {
    testWidgets('북마크 토글 성공 시 "즐겨찾기에 추가됐어요" 스낵바를 표시한다',
        (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrapWithFavorite(
          VerdictResultScreen(verdict: verdict, onRetry: () {}),
        ),
      );
      await tester.pumpAndSettle();

      // 북마크 버튼 탭 (초기 상태: 즐겨찾기 아님 → 추가) — 저장 버튼과 구분하기 위해 first 사용
      await tester.tap(find.byIcon(Icons.bookmark_border).first);
      await tester.pumpAndSettle();

      expect(find.text('즐겨찾기에 추가됐어요'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 관련 음식 섹션', () {
    testWidgets('"관련 음식" 타이틀이 표시된다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pumpAndSettle();

      expect(find.text('관련 음식'), findsOneWidget);
    });

    testWidgets('ListTile으로 "두부"가 표시된다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '삼겹살');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pumpAndSettle();

      // '두부'는 목 관련 음식 목록의 첫 번째 항목
      expect(find.widgetWithText(ListTile, '두부'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 영양 정보 섹션', () {
    testWidgets('"영양 정보" 타이틀이 표시된다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pumpAndSettle();

      expect(find.text('영양 정보'), findsOneWidget);
    });

    testWidgets('"72 kcal" 값이 표시된다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pumpAndSettle();

      expect(find.text('72 kcal'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 판정 등급 아이콘', () {
    testWidgets('recommend 등급 시 Icons.check_circle 아이콘이 렌더된다', (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 저장 버튼', () {
    testWidgets("'저장하기' 텍스트가 렌더된다", (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pumpAndSettle();

      expect(find.text('저장하기'), findsOneWidget);
    });
  });

  group('VerdictResultScreen — 공유 버튼', () {
    testWidgets("'공유하기' 텍스트가 렌더된다", (tester) async {
      final verdict = EatVerdict.recommend(foodName: '두부');
      await tester.pumpWidget(
        _wrap(VerdictResultScreen(verdict: verdict, onRetry: () {})),
      );
      await tester.pumpAndSettle();

      expect(find.text('공유하기'), findsAtLeastNWidgets(1));
    });
  });
}
