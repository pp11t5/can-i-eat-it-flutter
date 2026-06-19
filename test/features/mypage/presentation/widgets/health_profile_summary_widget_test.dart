import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/mypage/presentation/widgets/health_profile_summary_widget.dart';

Widget _wrap(HealthProfile? profile) => MaterialApp(
      home: Scaffold(
        body: HealthProfileSummaryWidget(profile: profile),
      ),
    );

void main() {
  group('HealthProfileSummaryWidget', () {
    testWidgets('질환 목록에 "역류성 식도염"이 있을 때 해당 텍스트를 가진 칩이 표시된다',
        (tester) async {
      final profile = HealthProfile.sampleGerd().copyWith(
        conditions: ['역류성 식도염'],
        triggerFoods: ['커피'],
      );
      await tester.pumpWidget(_wrap(profile));
      await tester.pump();

      expect(find.text('역류성 식도염'), findsOneWidget);
    });

    testWidgets('트리거 음식 목록이 비어있을 때 "없음" 텍스트가 표시된다', (tester) async {
      final profile = HealthProfile.sampleGerd().copyWith(
        conditions: ['GERD'],
        triggerFoods: [],
      );
      await tester.pumpWidget(_wrap(profile));
      await tester.pump();

      expect(find.text('없음'), findsOneWidget);
    });

    testWidgets('profile이 null이면 "아직 건강 프로필이 없어요." 표시', (tester) async {
      await tester.pumpWidget(_wrap(null));
      await tester.pump();

      expect(find.text('아직 건강 프로필이 없어요.'), findsOneWidget);
    });
  });
}
