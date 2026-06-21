@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/allergy_med_edit_screen.dart';

/// 골든 테스트 — 알레르기·복용약 편집 화면 (마스터 Figma 577-10291 대조용 PNG).
///
/// 생성된 PNG 경로:
/// - test/features/mypage/presentation/goldens/allergy_med_chip_selected.png
/// - test/features/mypage/presentation/goldens/allergy_med_with_medication.png
///
/// 재생성:
///   flutter test --update-goldens --tags golden \
///     test/features/mypage/presentation/allergy_med_edit_golden_test.dart

Widget _buildScreen({MockHealthProfileRepository? repo}) {
  final profileRepo = repo ?? MockHealthProfileRepository.completed();

  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      healthProfileRepositoryProvider.overrideWithValue(profileRepo),
      // ignore: scoped_providers_should_specify_dependencies
      profileCacheProvider.overrideWithValue(InMemoryProfileCache()),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const AllergyMedEditScreen(),
    ),
  );
}

void main() {
  group('AllergyMedEditScreen 골든 테스트', () {
    testWidgets('칩 선택 상태 — 갑각류(crustacean) 선택', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // sampleGerd의 allergies: ['shellfish']는 카탈로그 코드와 불일치.
      // 카탈로그 코드(crustacean)로 직접 프로필을 구성.
      final repo = MockHealthProfileRepository(
        initialProfile: const HealthProfile(
          conditions: ['GERD'],
          allergies: ['crustacean'],
          medications: ['omeprazole'],
        ),
      );

      await tester.pumpWidget(_buildScreen(repo: repo));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(AllergyMedEditScreen),
        matchesGoldenFile('goldens/allergy_med_chip_selected.png'),
      );
    });

    testWidgets('복용약 입력 상태 — 알레르기 선택 + 복용약 추가됨', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // 복수 알레르기 + 복용약이 있는 프로필
      final repo = MockHealthProfileRepository(
        initialProfile: const HealthProfile(
          conditions: ['GERD'],
          allergies: ['milk', 'egg', 'wheat'],
          medications: ['omeprazole', '란소프라졸'],
        ),
      );

      await tester.pumpWidget(_buildScreen(repo: repo));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(AllergyMedEditScreen),
        matchesGoldenFile('goldens/allergy_med_with_medication.png'),
      );
    });
  });
}
