import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_toast.dart';
import 'package:can_i_eat_it/features/weekly_report/data/weekly_report_providers.dart';
import 'package:can_i_eat_it/features/weekly_report/domain/entities/weekly_report.dart';
import 'package:can_i_eat_it/features/weekly_report/presentation/controllers/report_sharer.dart';

// ---------------------------------------------------------------------------
// 카드 스타일 (Figma 1718-7885 실측, 디자인 토큰 미정 — const 유지)
// ---------------------------------------------------------------------------

const _kCardBg = Color(0xFFFCFCFC);
const _kCardBorder = Color(0xFFEAEAEA);
const _kCardRadius = 14.0;

// ---------------------------------------------------------------------------
// 공유 문구 (W6-7 — 의료 프레이밍: 진단/치료/판정 단정 표현 금지, 개인 기록 공유 보조로만)
// ---------------------------------------------------------------------------

/// 리포트 PNG 공유 시 첨부하는 문구. 의학적 진단/처방이 아님을 명시한다.
///
/// 리뷰로 확정 예정 — 이후 문구 변경 시 이 상수만 수정한다.
const _kShareText = '이번 주 식단 기록 리포트예요. 진료 시 의료진과 공유해 참고용으로 활용해 보세요. '
    '(의학적 진단·처방이 아닌 개인 기록 요약입니다.)';

/// 공유 PNG(캡처 대상) 하단에 함께 노출되는 인-이미지 면책 캡션.
///
/// pr-reviewer should-fix(W6-7 후속): "위험 음식 N끼" 등 판정 라벨이 면책 없이
/// 이미지 단독으로 유통될 수 있어, 캡처 대상 내부에 작은 캡션으로 동봉한다.
/// RepaintBoundary 내부에 위치하므로 화면에도 자연히 함께 노출된다.
const _kInImageDisclaimerText = '개인 식단 기록 요약이며 의학적 진단·처방이 아니에요 · 먹어도 돼?';

// ---------------------------------------------------------------------------
// WeeklyReportScreen
// ---------------------------------------------------------------------------

/// 주간 리포트 화면 (Figma 1718-7885, present(X) 진입).
///
/// 라우트: /weekly-report (fullscreenDialog).
///
/// 데이터: [weeklyReportProvider] → [WeeklyReportRepository.getWeeklyReport()].
/// - 카드1: 연속 편안 스트릭 + 권장 식사 수 + 편안 비율.
/// - 카드2: 도넛 차트(권장/주의/위험 식사 분포) + 범례.
/// - "시간별 평균 증상기록" 카드는 백엔드 데이터 확정 전까지 미구현.
class WeeklyReportScreen extends ConsumerStatefulWidget {
  const WeeklyReportScreen({super.key});

  @override
  ConsumerState<WeeklyReportScreen> createState() =>
      _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends ConsumerState<WeeklyReportScreen> {
  /// 공유 PNG 캡처 대상([_Body] 내부 RepaintBoundary).
  final GlobalKey _shareKey = GlobalKey();

  /// [_shareKey]가 가리키는 RepaintBoundary를 PNG 바이트로 캡처한다.
  ///
  /// 아직 레이아웃되지 않았거나 boundary를 찾지 못하면 null 반환.
  Future<Uint8List?> _captureReportPng() async {
    final boundary =
        _shareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  /// 다운로드 버튼 탭 핸들러 — 캡처 후 [ReportSharer]로 위임한다.
  Future<void> _handleDownload() async {
    final pngBytes = await _captureReportPng();
    if (pngBytes == null) {
      if (mounted) await showAppToast(context, '공유 이미지를 만들지 못했어요');
      return;
    }

    try {
      await ref
          .read(reportSharerProvider)
          .shareReportImage(pngBytes, text: _kShareText);
    } catch (_) {
      if (mounted) await showAppToast(context, '공유 이미지를 만들지 못했어요');
    }
  }

  @override
  Widget build(BuildContext context) {
    final weeklyReportAsync = ref.watch(weeklyReportProvider);
    final report = weeklyReportAsync.valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 64,
        leading: IconButton(
          iconSize: 32,
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            'assets/figma_extracted/icon_close.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '주간 리포트',
          style: AppTextStyles.body1Bold.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            color: AppColors.textPrimary,
            // 데이터 로드 상태에서만 활성 — 로딩/에러 시 캡처 대상이 없다.
            onPressed: report == null ? null : _handleDownload,
          ),
        ],
        shape: const Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      body: weeklyReportAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
        ),
        error: (err, _) => Center(
          child: Text(
            '리포트를 불러오지 못했어요.',
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        data: (report) => _Body(report: report, shareKey: _shareKey),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _Body
// ---------------------------------------------------------------------------

class _Body extends StatelessWidget {
  const _Body({required this.report, required this.shareKey});

  final WeeklyReport report;

  /// PNG 공유 캡처 대상 RepaintBoundary의 key.
  final GlobalKey shareKey;

  /// "YYYY-MM-DD" → "M월 D일". 파싱 실패 시 원문 반환.
  static String _formatDate(String iso) {
    final parts = iso.split('-');
    if (parts.length != 3) return iso;
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (month == null || day == null) return iso;
    return '$month월 $day일';
  }

  static String _formatDateRange(String start, String end) =>
      '${_formatDate(start)} ~ ${_formatDate(end)}';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sectionGap,
      ),
      // W6-7: PNG 공유 캡처 대상 (AppBar 제외, 기간/주차 라벨 + 카드1 + 카드2).
      // 배경색을 명시해 투명 배경으로 캡처되는 것을 방지한다.
      child: RepaintBoundary(
        key: shareKey,
        child: Container(
          color: AppColors.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------------
              // 기간 + 주차 라벨
              // -------------------------------------------------------------
              Text(
                _formatDateRange(report.startDate, report.endDate),
                style: AppTextStyles.caption1Medium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                report.weekLabel,
                style: AppTextStyles.header2Bold.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              // -------------------------------------------------------------
              // 카드1 — 속 편한 음식 현황
              // -------------------------------------------------------------
              _ComfortableStateCard(
                comfortableState: report.comfortableState,
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              // -------------------------------------------------------------
              // 카드2 — 내 식단 분포 (도넛)
              // -------------------------------------------------------------
              _MealDistributionCard(mealCount: report.mealCount),

              // TODO(backend): 시간별 증상 분포 데이터 확정 시 추가

              // -------------------------------------------------------------
              // 인-이미지 면책 캡션 (W6-7 후속) — 공유 PNG 안에 함께 캡처된다.
              // -------------------------------------------------------------
              const SizedBox(height: AppSpacing.sectionGap),
              SizedBox(
                width: double.infinity,
                child: Text(
                  _kInImageDisclaimerText,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ReportCard — 공통 카드 컨테이너
// ---------------------------------------------------------------------------

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: _kCardBg,
        border: Border.all(color: _kCardBorder, width: 1),
        borderRadius: BorderRadius.circular(_kCardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body1Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.cardPadding),
          child,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ComfortableStateCard — 카드1
// ---------------------------------------------------------------------------

class _ComfortableStateCard extends StatelessWidget {
  const _ComfortableStateCard({required this.comfortableState});

  final ComfortableState comfortableState;

  @override
  Widget build(BuildContext context) {
    return _ReportCard(
      title: '속 편한 음식을 먹은 현황이에요',
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              label: '연속 일수',
              icon: Image.asset(
                'assets/illustrations/icon_fire.png',
                width: 32,
                height: 32,
              ),
              value: '${comfortableState.streakCount}일',
            ),
          ),
          Expanded(
            child: _StatColumn(
              label: '권장 음식',
              icon: const Icon(
                Icons.check_circle,
                color: AppColors.verdictRecommend,
                size: 28,
              ),
              value: '${comfortableState.recommendedMealCount}끼',
            ),
          ),
          Expanded(
            child: _StatColumn(
              label: '전체 비율',
              icon: const Icon(
                Icons.sentiment_satisfied_rounded,
                color: AppColors.verdictRecommend,
                size: 28,
              ),
              value: '${comfortableState.percentage.toStringAsFixed(1)}%',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.icon,
    required this.value,
  });

  final String label;
  final Widget icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.caption1Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        icon,
        const SizedBox(height: AppSpacing.itemGap),
        Text(
          value,
          style: AppTextStyles.body1Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _MealDistributionCard — 카드2 (도넛)
// ---------------------------------------------------------------------------

class _MealDistributionCard extends StatelessWidget {
  const _MealDistributionCard({required this.mealCount});

  final MealCount mealCount;

  @override
  Widget build(BuildContext context) {
    final total =
        mealCount.recommendCount + mealCount.cautionCount + mealCount.riskCount;

    return _ReportCard(
      title: '내 식단 분포',
      child: total == 0
          ? Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sectionGap,
              ),
              child: Center(
                child: Text(
                  '기록이 없어요',
                  style: AppTextStyles.body2Regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          : Row(
              children: [
                _Donut(mealCount: mealCount, total: total),
                const SizedBox(width: AppSpacing.contentGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendRow(
                        icon: Icons.check_circle,
                        color: AppColors.verdictRecommend,
                        label: '권장음식 ${mealCount.recommendCount}끼',
                      ),
                      const SizedBox(height: AppSpacing.itemGap),
                      _LegendRow(
                        icon: Icons.error,
                        color: AppColors.verdictCaution,
                        label: '주의 음식 ${mealCount.cautionCount}끼',
                      ),
                      const SizedBox(height: AppSpacing.itemGap),
                      _LegendRow(
                        icon: Icons.cancel,
                        color: AppColors.verdictDanger,
                        label: '위험 음식 ${mealCount.riskCount}끼',
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _Donut extends StatelessWidget {
  const _Donut({required this.mealCount, required this.total});

  final MealCount mealCount;
  final int total;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: mealCount.recommendCount.toDouble(),
                  color: AppColors.verdictRecommend,
                  showTitle: false,
                  radius: 20,
                ),
                PieChartSectionData(
                  value: mealCount.cautionCount.toDouble(),
                  color: AppColors.verdictCaution,
                  showTitle: false,
                  radius: 20,
                ),
                PieChartSectionData(
                  value: mealCount.riskCount.toDouble(),
                  color: AppColors.verdictDanger,
                  showTitle: false,
                  radius: 20,
                ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 45,
            ),
          ),
          Text(
            '$total끼',
            style: AppTextStyles.body1Bold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: AppSpacing.iconTextGap),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body2Regular.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
