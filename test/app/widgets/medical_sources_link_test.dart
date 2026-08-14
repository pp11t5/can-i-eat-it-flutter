import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/app/widgets/app_icon.dart';
import 'package:can_i_eat_it/app/widgets/medical_sources_link.dart';

void main() {
  testWidgets('문구·SVG·접근성 레이블을 표시하고 의료 근거 경로로 이동한다', (tester) async {
    final semantics = tester.ensureSemantics();
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: MedicalSourcesLink()),
        ),
        GoRoute(
          path: MedicalSourcesLink.routePath,
          builder: (_, __) => const Scaffold(body: Text('의료 근거 화면')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );

    expect(find.text('왜 이런 결과가 나왔나요?'), findsOneWidget);
    expect(find.text('근거 확인'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppIcon && widget.asset == AppIcons.medicalSources,
      ),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('의료 근거 확인'), findsOneWidget);

    await tester.tap(find.byType(MedicalSourcesLink));
    await tester.pumpAndSettle();

    expect(find.text('의료 근거 화면'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('guideline 변형은 한 줄 문구만 보이고 지정 URL 콜백을 호출한다', (tester) async {
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: MedicalSourcesLink.guideline(
            sourceUrl: 'https://pubmed.ncbi.nlm.nih.gov/34807007/',
            onOpen: () => opened = true,
          ),
        ),
      ),
    );

    expect(find.text('ACG 2022 가이드라인을 바탕으로 한 정보예요'), findsOneWidget);
    expect(find.text('근거 확인'), findsNothing);
    expect(find.text('왜 이런 결과가 나왔나요?'), findsNothing);

    await tester.tap(find.byType(MedicalSourcesLink));
    await tester.pump();

    expect(opened, isTrue);
  });
}
