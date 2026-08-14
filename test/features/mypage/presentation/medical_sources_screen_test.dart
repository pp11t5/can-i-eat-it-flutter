import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_colors.dart';
import 'package:can_i_eat_it/app/theme/app_text_styles.dart';
import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/app/widgets/medical_disclaimer.dart';
import 'package:can_i_eat_it/features/mypage/domain/medical_sources_catalog.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/medical_sources_screen.dart';

void main() {
  test('PO 확정 출처 URL 4개를 가리킨다', () {
    expect(
      MedicalSourcesCatalog.acg2022Url,
      'https://pubmed.ncbi.nlm.nih.gov/34807007/',
    );
    expect(
      MedicalSourcesCatalog.allergenLabelingUrl,
      'https://www.foodsafetykorea.go.kr/portal/board/boardDetail.do?'
      'menu_no=3120&menu_grp=MENU_NEW01&bbs_no=bbs001&ntctxt_no=1091412',
    );
    expect(
      MedicalSourcesCatalog.gerdPortalUrl,
      'https://health.kdca.go.kr/healthinfo/biz/health/gnrlzHealthInfo/'
      'gnrlzHealthInfo/gnrlzHealthInfoView.do?cntnts_sn=2057',
    );
    expect(
      MedicalSourcesCatalog.foodCompositionUrl,
      'https://various.foodsafetykorea.go.kr/nutrient/',
    );
    expect(
      MedicalSourcesCatalog.sections
          .expand((s) => s.items)
          .where((i) => i.url == MedicalSourcesCatalog.acg2022Url)
          .every((i) => i.webTitle == MedicalSourcesCatalog.acg2022PageTitle),
      isTrue,
    );
    expect(
      MedicalSourcesCatalog.sections
          .expand((s) => s.items)
          .firstWhere((i) => i.url == MedicalSourcesCatalog.allergenLabelingUrl)
          .webTitle,
      MedicalSourcesCatalog.allergenPageTitle,
    );
    expect(
      MedicalSourcesCatalog.sections
          .expand((s) => s.items)
          .firstWhere((i) => i.url == MedicalSourcesCatalog.gerdPortalUrl)
          .webTitle,
      MedicalSourcesCatalog.gerdPageTitle,
    );
    expect(
      MedicalSourcesCatalog.sections
          .expand((s) => s.items)
          .firstWhere((i) => i.url == MedicalSourcesCatalog.foodCompositionUrl)
          .webTitle,
      MedicalSourcesCatalog.foodCompositionPageTitle,
    );
  });

  Widget subject({void Function(MedicalSourceItem item)? onOpenSource}) {
    return MaterialApp(
      theme: AppTheme.light,
      home: MedicalSourcesScreen(onOpenSource: onOpenSource),
    );
  }

  testWidgets('인트로·섹션·행·각주 카피를 표시한다', (tester) async {
    tester.view.physicalSize = const Size(375, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(subject());

    expect(find.text('의학 정보 출처'), findsOneWidget);
    expect(find.text(MedicalSourcesCatalog.intro), findsOneWidget);
    expect(find.text('트리거 음식'), findsOneWidget);
    expect(find.text('탄산음료'), findsOneWidget);
    expect(find.text('ACG 2022 · 근거 보통'), findsOneWidget);
    expect(find.text('커피·카페인'), findsOneWidget);
    expect(find.text('감귤류'), findsOneWidget);
    expect(find.text('양파·마늘 · 정제 밀가루'), findsOneWidget);
    expect(find.text('내 기록 기반 · 연구 근거 없음'), findsOneWidget);
    expect(find.text('알레르기'), findsOneWidget);
    expect(find.text('알레르기 유발물질 표시 기준'), findsOneWidget);
    expect(find.text('질환 정보'), findsOneWidget);
    expect(find.text('위식도역류질환이란'), findsOneWidget);
    expect(find.text('음식 데이터'), findsOneWidget);
    expect(find.text('음식 성분·분류 데이터'), findsOneWidget);
    expect(find.textContaining('Katz PO'), findsOneWidget);
    expect(find.textContaining(MedicalSourcesCatalog.lastReviewed),
        findsOneWidget);
    expect(find.byType(MedicalDisclaimer), findsNothing);
    expect(find.text('공개 진료지침'), findsNothing);

    final intro = tester.widget<Text>(find.text(MedicalSourcesCatalog.intro));
    expect(intro.style?.fontSize, AppTextStyles.body2Medium.fontSize);
    expect(intro.style?.fontWeight, AppTextStyles.body2Medium.fontWeight);
    expect(intro.style?.color, AppColors.textSecondary);

    final title = tester.widget<Text>(find.text('탄산음료'));
    expect(title.style?.fontSize, AppTextStyles.body2Bold.fontSize);
    expect(title.style?.fontWeight, AppTextStyles.body2Bold.fontWeight);
    expect(title.style?.color, AppColors.textPrimary);

    final subtitle = tester.widget<Text>(find.text('ACG 2022 · 근거 보통'));
    expect(subtitle.style?.fontSize, AppTextStyles.body2Medium.fontSize);
    expect(subtitle.style?.color, AppColors.textSecondary);
  });

  testWidgets('출처가 있는 행을 탭하면 콜백이 호출된다', (tester) async {
    MedicalSourceItem? opened;
    await tester.pumpWidget(subject(onOpenSource: (item) => opened = item));

    await tester.tap(find.text('탄산음료'));
    await tester.pump();

    expect(opened?.title, '탄산음료');
    expect(opened?.url, MedicalSourcesCatalog.acg2022Url);
    expect(opened?.url, 'https://pubmed.ncbi.nlm.nih.gov/34807007/');
  });

  testWidgets('연구 근거 없는 행은 탭해도 열리지 않는다', (tester) async {
    var calls = 0;
    await tester.pumpWidget(subject(onOpenSource: (_) => calls++));

    await tester.tap(find.text('양파·마늘 · 정제 밀가루'));
    await tester.pump();

    expect(calls, 0);
  });
}
