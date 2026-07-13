import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/features/weekly_report/data/repositories/mock_weekly_report_repository.dart';
import 'package:can_i_eat_it/features/weekly_report/data/weekly_report_providers.dart';
import 'package:can_i_eat_it/features/weekly_report/presentation/controllers/report_sharer.dart';
import 'package:can_i_eat_it/features/weekly_report/presentation/screens/weekly_report_screen.dart';

// ---------------------------------------------------------------------------
// _SpyReportSharer — 실제 플랫폼 채널(공유시트) 호출 없이 호출 기록만 남긴다.
// ---------------------------------------------------------------------------

class _SpyReportSharer implements ReportSharer {
  int callCount = 0;
  Uint8List? lastPngBytes;
  String? lastText;

  @override
  Future<void> shareReportImage(
    Uint8List pngBytes, {
    required String text,
  }) async {
    callCount++;
    lastPngBytes = pngBytes;
    lastText = text;
  }
}

Widget _wrap(_SpyReportSharer sharer) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      weeklyReportRepositoryProvider.overrideWithValue(
        MockWeeklyReportRepository.seeded(),
      ),
      // ignore: scoped_providers_should_specify_dependencies
      reportSharerProvider.overrideWithValue(sharer),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const WeeklyReportScreen(),
    ),
  );
}

void main() {
  group('WeeklyReportScreen — PNG 공유 (W6-7)', () {
    testWidgets(
        '다운로드 버튼 탭 → 리포트를 PNG로 캡처해 ReportSharer.shareReportImage를 '
        '1회 호출한다 (non-empty pngBytes + 의료 프레이밍 문구)', (tester) async {
      final sharer = _SpyReportSharer();

      await tester.runAsync(() async {
        await tester.pumpWidget(_wrap(sharer));
        await tester.pumpAndSettle();

        expect(sharer.callCount, 0);

        await tester.tap(find.byWidgetPredicate(
          (w) => w is AppIcon && w.asset == AppIcons.download,
        ));
        await tester.pump();
        // RepaintBoundary.toImage()는 실제 async 파이프라인(진짜 이벤트루프 tick)에서만
        // 완료된다 — runAsync 존 안에서 실제 시간을 흘려보내 캡처를 완결시킨다.
        await Future<void>.delayed(const Duration(milliseconds: 200));
      });

      await tester.pumpAndSettle();

      expect(sharer.callCount, 1);
      expect(sharer.lastPngBytes, isNotNull);
      expect(sharer.lastPngBytes!.isNotEmpty, isTrue);
      expect(sharer.lastText, isNotNull);
      expect(sharer.lastText, contains('의료진'));
      expect(
        sharer.lastText,
        '이번 주 식단 기록 리포트예요. 진료 시 의료진과 공유해 참고용으로 활용해 보세요. '
        '(의학적 진단·처방이 아닌 개인 기록 요약입니다.)',
      );
    });
  });

  group('WeeklyReportScreen — 인-이미지 면책 캡션 제거 (Figma 2523:14131 정합)', () {
    testWidgets(
        '화면(공유 캡처 대상 RepaintBoundary 포함)에는 인-이미지 면책 캡션이 더 이상 렌더되지 '
        '않는다 — 의료 면책은 공유 시트 첨부 텍스트(_kShareText, 위 테스트로 커버)로만 전달된다',
        (tester) async {
      await tester.pumpWidget(_wrap(_SpyReportSharer()));
      await tester.pumpAndSettle();

      expect(
        find.text('개인 식단 기록 요약이며 의학적 진단·처방이 아니에요 · 먹어도 돼?'),
        findsNothing,
      );
    });
  });
}
