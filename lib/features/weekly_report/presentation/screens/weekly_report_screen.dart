import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_icon_sizes.dart';
import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_spacing.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
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
// 기록된 증상 카드 스타일 (Figma node 2523:14131 실측, 디자인 토큰 미정 — const 유지)
// ---------------------------------------------------------------------------

/// 카드3 자체 radius/padding — 다른 카드(_ReportCard, radius 14/padding 16)와 달리
/// Figma가 radius 20/padding 24로 별도 지정.
const _kSymptomCardRadius = 20.0;
const _kSymptomCardPadding = 24.0;

/// 평균 시간 pill 배경 (회색).
const _kSymptomPillGrayBg = Color(0xFFD3D3D3);

/// 평균 강도 pill 배경 (보라).
const _kSymptomPillPurpleBg = Color(0xFF9747FF);

/// 증상 종류별 막대 채움색 (초록 계열 4단계, 서버 코드 → 색 매핑).
const _kSymptomBarColors = <String, Color>{
  'throat_foreign_body': Color(0xFFD9F5EA), // 이물감
  'acid_reflux': Color(0xFFB1EBD3), // 신물
  'cough': Color(0xFF00BF72), // 기침
  'chest_tightness': Color(0xFF02995B), // 답답함
};

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
/// - 카드3: 기록된 증상(횟수 + 평균 시간/강도 pill + 종류별 막대). 서버 응답에
///   [WeeklyReport.symptomReport]가 없으면 빈상태로 렌더(seam, 필드 추가 시 자동 점등).
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
            icon: const AppIcon(
              AppIcons.download,
              size: AppIconSizes.s24,
              color: AppColors.textPrimary,
            ),
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
      // Figma 2523:14131 — Content L/R 16, T/B 16.
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.cardPadding,
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
              // Figma — 헤더 → 카드 간격 32.
              const SizedBox(height: AppSpacing.contentGap),

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
              const SizedBox(height: AppSpacing.sectionGap),

              // -------------------------------------------------------------
              // 카드3 — 기록된 증상 (Figma node 2523:14131)
              // -------------------------------------------------------------
              _SymptomRecordCard(symptomReport: report.symptomReport),

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
      // Figma 2523:14131 — 카드 padding 24(전 카드 공통).
      padding: const EdgeInsets.all(AppSpacing.sectionGap),
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
              icon: SvgPicture.asset(
                AppIcons.verdictRecommend,
                width: 32,
                height: 32,
              ),
              value: '${comfortableState.recommendedMealCount}끼',
            ),
          ),
          Expanded(
            child: _StatColumn(
              label: '전체 비율',
              icon: Image.asset(
                AppImages.moodGood,
                width: 32,
                height: 32,
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
    // Figma 2523:14131 — 라벨 14/#737380, 숫자 16(M)/#1A1A1F, 컬럼 내부 gap 16.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.body2Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.cardPadding),
        icon,
        const SizedBox(height: AppSpacing.cardPadding),
        Text(
          value,
          style: AppTextStyles.body1Medium.copyWith(
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
    final total = mealCount.recommendCount +
        mealCount.cautionCount +
        mealCount.riskCount +
        mealCount.unknownCount;

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
                        icon: SvgPicture.asset(
                          AppIcons.verdictRecommend,
                          width: 16,
                          height: 16,
                        ),
                        label: '권장음식 ${mealCount.recommendCount}끼',
                      ),
                      const SizedBox(height: AppSpacing.itemGap),
                      _LegendRow(
                        icon: SvgPicture.asset(
                          AppIcons.verdictCaution,
                          width: 16,
                          height: 16,
                        ),
                        label: '주의 음식 ${mealCount.cautionCount}끼',
                      ),
                      const SizedBox(height: AppSpacing.itemGap),
                      _LegendRow(
                        icon: SvgPicture.asset(
                          AppIcons.verdictRisk,
                          width: 16,
                          height: 16,
                        ),
                        label: '위험 음식 ${mealCount.riskCount}끼',
                      ),
                      const SizedBox(height: AppSpacing.itemGap),
                      _LegendRow(
                        icon: SvgPicture.asset(
                          AppIcons.verdictUnknown,
                          width: 16,
                          height: 16,
                        ),
                        label: '확인 어려움 ${mealCount.unknownCount}끼',
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
                PieChartSectionData(
                  value: mealCount.unknownCount.toDouble(),
                  color: AppColors.verdictUnknown,
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
    required this.label,
  });

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
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

// ---------------------------------------------------------------------------
// _SymptomRecordCard — 카드3 (Figma node 2523:14131)
// ---------------------------------------------------------------------------

/// 기록된 증상 카드. [symptomReport]가 null이거나 recordedCount가 0이면 빈상태.
///
/// [_ReportCard]와 달리 자체 컨테이너(radius 20/padding 24, Figma 실측)를 쓴다 —
/// 헤더가 단순 타이틀이 아니라 카운트+pill 2개를 담는 커스텀 Row라서.
class _SymptomRecordCard extends StatelessWidget {
  const _SymptomRecordCard({required this.symptomReport});

  final SymptomReport? symptomReport;

  @override
  Widget build(BuildContext context) {
    final report = symptomReport;
    final isEmpty = report == null || report.recordedCount == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(_kSymptomCardPadding),
      decoration: BoxDecoration(
        color: _kCardBg,
        border: Border.all(color: _kCardBorder, width: 1),
        borderRadius: BorderRadius.circular(_kSymptomCardRadius),
      ),
      child: isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sectionGap,
              ),
              child: Center(
                child: Text(
                  '이번 주 증상 기록이 없어요',
                  style: AppTextStyles.body2Regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SymptomRecordHeader(report: report),
                const SizedBox(height: AppSpacing.sectionGap),
                _SymptomTypeBars(typeCounts: report.typeCounts),
              ],
            ),
    );
  }
}

/// 헤더 Row(space-between) — 왼쪽 기록 횟수, 오른쪽 평균 시간/강도 pill.
class _SymptomRecordHeader extends StatelessWidget {
  const _SymptomRecordHeader({required this.report});

  final SymptomReport report;

  @override
  Widget build(BuildContext context) {
    final averageTimeLabel = report.averageTimeLabel;
    final averageIntensity = report.averageIntensity;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '기록된 증상',
              style: AppTextStyles.caption1Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${report.recordedCount}',
                  style: AppTextStyles.header2Bold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '번',
                  style: AppTextStyles.caption1Medium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (averageTimeLabel != null) ...[
              _SymptomPill(
                backgroundColor: _kSymptomPillGrayBg,
                contentColor: AppColors.textPrimary,
                icon: const AppIcon(
                  AppIcons.clock,
                  size: 14,
                  color: AppColors.textPrimary,
                ),
                label: '평균 시간 $averageTimeLabel',
              ),
              if (averageIntensity != null)
                const SizedBox(width: AppSpacing.itemGap),
            ],
            if (averageIntensity != null)
              _SymptomPill(
                backgroundColor: _kSymptomPillPurpleBg,
                contentColor: Colors.white,
                label: '평균 강도 $averageIntensity',
              ),
          ],
        ),
      ],
    );
  }
}

/// pill 1개 — 회색(평균 시간, 시계 아이콘 앞) / 보라(평균 강도, 흰 글씨).
class _SymptomPill extends StatelessWidget {
  const _SymptomPill({
    required this.backgroundColor,
    required this.contentColor,
    required this.label,
    this.icon,
  });

  final Color backgroundColor;
  final Color contentColor;
  final String label;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.chipPaddingH,
        vertical: AppSpacing.chipPaddingV,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: AppSpacing.iconTextGap),
          ],
          Text(
            label,
            style: AppTextStyles.caption1Medium.copyWith(color: contentColor),
          ),
        ],
      ),
    );
  }
}

/// 증상 종류별 막대 Row — 각 컬럼 폭이 횟수 비례(flex=count), 막대 사이 gap 8.
/// (Figma 2523:14131 실측: 이물감 fixed33/답답함50/신물·기침 fill 구조 → flex(count)로 근사.
/// 세로 높이가 아니라 가로 폭이 비율, 컬럼이 폭을 나눠 가지므로 막대 사이 여백 없음.)
class _SymptomTypeBars extends StatelessWidget {
  const _SymptomTypeBars({required this.typeCounts});

  final List<SymptomTypeCount> typeCounts;

  @override
  Widget build(BuildContext context) {
    if (typeCounts.isEmpty) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < typeCounts.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.itemGap),
          // Figma 실측 폭(이물감 33/답답함 50/count4 fill≈94) 근사: width≈16+17×count.
          // base 16으로 작은 count도 라벨("이물감") 한 줄이 들어가는 폭 확보.
          Expanded(
            flex: 16 + 17 * (typeCounts[i].count < 0 ? 0 : typeCounts[i].count),
            child: _SymptomBarColumn(
              typeCount: typeCounts[i],
              color: _kSymptomBarColors[typeCounts[i].type] ??
                  AppColors.verdictUnknown,
            ),
          ),
        ],
      ],
    );
  }
}

/// 막대 1열 — 가로 막대(높이 46, 폭=컬럼 채움, radius 10) + 라벨.
/// Figma 2523:14131 실측: 막대 46×radius10, 라벨 왼쪽 정렬, 증상명 #737380 / "N 번" #1A1A1F.
class _SymptomBarColumn extends StatelessWidget {
  const _SymptomBarColumn({
    required this.typeCount,
    required this.color,
  });

  final SymptomTypeCount typeCount;
  final Color color;

  /// 막대 고정 높이 (Figma 실측 46pt).
  static const double _kBarHeight = 46.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: _kBarHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: AppSpacing.itemGap),
        Text(
          typeCount.label,
          style: AppTextStyles.caption1Medium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '${typeCount.count} 번',
          style: AppTextStyles.caption1Medium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
