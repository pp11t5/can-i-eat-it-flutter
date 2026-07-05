import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'package:can_i_eat_it/features/health_profile/data/repositories/mock_health_profile_repository.dart';
import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';
import 'package:can_i_eat_it/features/health_profile/domain/repositories/health_profile_repository.dart';
import 'package:can_i_eat_it/features/mypage/presentation/screens/allergy_med_edit_screen.dart';

// ---------------------------------------------------------------------------
// 헬퍼
// ---------------------------------------------------------------------------

Widget _buildScreen({HealthProfileRepository? repo}) {
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

// ---------------------------------------------------------------------------
// 테스트용 캡처 레포지토리
// ---------------------------------------------------------------------------

class _CaptureMockRepo extends MockHealthProfileRepository {
  _CaptureMockRepo({required HealthProfile initialProfile})
      : super(initialProfile: initialProfile);
}

/// [fetchMedicalInfoStrict] 최초 1회만 실패하고 이후 성공하는 fake — 재시도 UX 검증용.
///
/// (pr-review 의료안전 ②-1) 편집 화면이 strict 조회 실패 시 에러+재시도를 보이고,
/// 재시도 성공 시 폼으로 정상 전환되는지 확인한다.
class _FlakyHealthProfileRepository implements HealthProfileRepository {
  _FlakyHealthProfileRepository(this._profile);

  final HealthProfile _profile;
  int fetchAttempts = 0;

  @override
  Future<HealthProfile> fetchMedicalInfoStrict() async {
    fetchAttempts++;
    if (fetchAttempts == 1) {
      throw Exception('일시적 네트워크 오류');
    }
    return _profile;
  }

  @override
  Future<HealthProfile?> currentProfile() async => _profile;

  @override
  Future<bool> onboardedStatus() async => true;

  @override
  Future<void> submitProfile(HealthProfile profile) async {}

  @override
  Future<void> updateHealthInfo({
    required List<String> allergies,
    required List<String> medications,
  }) async {}
}

void main() {
  // ---------------------------------------------------------------------------
  // 1. 보존 회귀 테스트 (TDD 핵심 — 순수 로직, 위젯 불필요)
  // ---------------------------------------------------------------------------
  group('보존 회귀 테스트', () {
    test('allergies·medications만 교체하고 나머지 필드는 base와 동일해야 한다', () async {
      const base = HealthProfile(
        conditions: ['GERD'],
        symptomFrequency: ['heartburn_reflux', 'post_meal_cough'],
        diagnosed: true,
        triggerFoods: ['spicy', 'caffeine'],
        customTriggers: '탄산음료',
        medications: ['omeprazole'],
        allergies: ['crustacean'],
      );

      final repo = _CaptureMockRepo(initialProfile: base);

      // copyWith로 allergies/medications만 교체한 결과 단언
      final next = base.copyWith(
        allergies: ['milk', 'egg'],
        medications: ['란소프라졸'],
      );

      // 보존 검증: 나머지 필드는 base와 동일
      expect(next.conditions, equals(base.conditions));
      expect(next.symptomFrequency, equals(base.symptomFrequency));
      expect(next.diagnosed, equals(base.diagnosed));
      expect(next.triggerFoods, equals(base.triggerFoods));
      expect(next.customTriggers, equals(base.customTriggers));

      // 변경 검증
      expect(next.allergies, equals(['milk', 'egg']));
      expect(next.medications, equals(['란소프라졸']));

      // repo에 submit — lastSubmittedProfile 캡처 확인
      await repo.submitProfile(next);
      final submitted = repo.lastSubmittedProfile!;

      expect(submitted.conditions, equals(base.conditions));
      expect(submitted.symptomFrequency, equals(base.symptomFrequency));
      expect(submitted.diagnosed, equals(base.diagnosed));
      expect(submitted.triggerFoods, equals(base.triggerFoods));
      expect(submitted.customTriggers, equals(base.customTriggers));
      expect(submitted.allergies, equals(['milk', 'egg']));
      expect(submitted.medications, equals(['란소프라졸']));
    });
  });

  // ---------------------------------------------------------------------------
  // 2. 화면 위젯 테스트
  // ---------------------------------------------------------------------------
  group('AllergyMedEditScreen 위젯 테스트', () {
    testWidgets('앱바에 "알레르기" 타이틀이 표시된다', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      // "알레르기"는 앱바 타이틀과 섹션 헤더 두 곳에 등장하므로 findsWidgets 사용
      expect(find.text('알레르기'), findsWidgets);
    });

    testWidgets('헤더 "알레르기와 복용 중인 약을 알려주세요"가 표시된다', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('알레르기와 복용 중인 약을 알려주세요'), findsOneWidget);
    });

    testWidgets('allergyOptions 8종 칩이 모두 표시된다', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('우유·유제품'), findsOneWidget);
      expect(find.text('계란'), findsOneWidget);
      expect(find.text('밀'), findsOneWidget);
      expect(find.text('콩(대두)'), findsOneWidget);
      expect(find.text('땅콩'), findsOneWidget);
      expect(find.text('갑각류'), findsOneWidget);
      expect(find.text('견과류'), findsOneWidget);
      expect(find.text('생선·조개류'), findsOneWidget);
    });

    testWidgets('초기값 — 프로필 medications로 복용약 리스트 초기화된다', (tester) async {
      // sampleGerd: medications: ['omeprazole']
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('omeprazole'), findsOneWidget);
    });

    testWidgets('알레르기 칩 탭 → 토글 (미선택 → 선택 → 미선택)', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      // 우유·유제품: sampleGerd에 없음 → 미선택
      expect(find.text('우유·유제품'), findsOneWidget);

      // 탭 (선택)
      await tester.tap(find.text('우유·유제품'));
      await tester.pump();

      // 탭 (해제)
      await tester.tap(find.text('우유·유제품'));
      await tester.pump();

      // 크래시 없이 토글 완료
      expect(find.text('우유·유제품'), findsOneWidget);
    });

    testWidgets('복용약 추가 — 텍스트필드 입력 후 버튼 탭 → 목록 표시', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '란소프라졸');
      await tester.tap(find.text('＋ 복용약 추가'));
      await tester.pump();

      expect(find.text('란소프라졸'), findsOneWidget);
    });

    testWidgets('복용약 제거 — × 탭 → 목록에서 제거됨', (tester) async {
      // sampleGerd: medications: ['omeprazole'] 초기값 있음
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      // omeprazole 옆 × 아이콘 탭
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();

      expect(find.text('omeprazole'), findsNothing);
    });

    testWidgets('저장하기 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('저장하기'), findsOneWidget);
    });

    testWidgets('저장하기 탭 → HealthProfileController.updateHealthInfo 호출됨', (tester) async {
      final repo = _CaptureMockRepo(
        initialProfile: const HealthProfile(
          conditions: ['GERD'],
          symptomFrequency: ['heartburn_reflux'],
          diagnosed: true,
          triggerFoods: ['spicy'],
          customTriggers: '탄산음료',
          medications: [],
          allergies: [],
        ),
      );

      await tester.pumpWidget(_buildScreen(repo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('저장하기'));
      // pump만 사용 — showAppToast의 2.5s 타이머가 pumpAndSettle을 블록함
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // updateHealthInfo가 호출되어 lastSubmittedProfile이 세팅됨
      expect(repo.lastSubmittedProfile, isNotNull);

      // toast 생명주기 전체 소진 (등장 250ms + 표시 2500ms + 퇴장 250ms + 여유)
      await tester.pump(const Duration(milliseconds: 300));  // forward anim
      await tester.pump(const Duration(milliseconds: 2600)); // show duration
      await tester.pump(const Duration(milliseconds: 300));  // reverse anim
    });

    testWidgets('저장 시 allergies·medications만 변경되고 나머지 필드 보존됨', (tester) async {
      const base = HealthProfile(
        conditions: ['GERD'],
        symptomFrequency: ['heartburn_reflux'],
        diagnosed: true,
        triggerFoods: ['spicy'],
        customTriggers: '탄산음료',
        medications: [],
        allergies: [],
      );

      final repo = _CaptureMockRepo(initialProfile: base);

      await tester.pumpWidget(_buildScreen(repo: repo));
      await tester.pumpAndSettle();

      // 알레르기 칩 하나 선택
      await tester.tap(find.text('우유·유제품'));
      await tester.pump();

      // 복용약 추가
      await tester.enterText(find.byType(TextField), '란소프라졸');
      await tester.tap(find.text('＋ 복용약 추가'));
      await tester.pump();

      // 저장
      await tester.tap(find.text('저장하기'));
      // pump만 사용 — showAppToast의 2.5s 타이머가 pumpAndSettle을 블록함
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final submitted = repo.lastSubmittedProfile!;

      // 보존 검증
      expect(submitted.conditions, equals(base.conditions));
      expect(submitted.symptomFrequency, equals(base.symptomFrequency));
      expect(submitted.diagnosed, equals(base.diagnosed));
      expect(submitted.triggerFoods, equals(base.triggerFoods));
      expect(submitted.customTriggers, equals(base.customTriggers));

      // 변경 검증
      expect(submitted.allergies, contains('milk'));
      expect(submitted.medications, contains('란소프라졸'));

      // toast 생명주기 전체 소진
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 2600));
      await tester.pump(const Duration(milliseconds: 300));
    });
  });

  // ---------------------------------------------------------------------------
  // 3. medicalInfoStrictProvider 조회 실패 — 에러+재시도 UI, 저장 자체 불가
  //    (의료안전, pr-review ②-1: stale 데이터 위에서 편집·PATCH 금지)
  // ---------------------------------------------------------------------------
  group('medicalInfoStrictProvider 조회 실패 — 에러+재시도', () {
    testWidgets('조회 실패 시 폼 대신 에러+재시도 UI가 표시되고 저장 버튼이 없다',
        (tester) async {
      // noProfile: fetchMedicalInfoStrict가 StateError를 throw(캐시 폴백 없음).
      final repo = MockHealthProfileRepository.noProfile();

      await tester.pumpWidget(_buildScreen(repo: repo));
      await tester.pumpAndSettle();

      expect(find.text('건강 정보를 불러오지 못했어요.\n다시 시도해 주세요.'), findsOneWidget);
      expect(find.text('다시 시도'), findsOneWidget);
      // 폼 자체가 렌더되지 않으므로 저장 버튼·입력 필드가 아예 없다(비활성이 아니라 부재).
      expect(find.text('저장하기'), findsNothing);
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('조회 지연 중에는 로딩 인디케이터가 표시되고 폼은 아직 없다', (tester) async {
      final repo = MockHealthProfileRepository.completed(
        delay: const Duration(milliseconds: 500),
      );

      await tester.pumpWidget(_buildScreen(repo: repo));
      await tester.pump(); // 1프레임 — 아직 로딩 중

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('저장하기'), findsNothing);

      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('저장하기'), findsOneWidget);
    });

    testWidgets('재시도 탭 → 조회 성공 시 폼이 정상 표시된다', (tester) async {
      final repo = _FlakyHealthProfileRepository(HealthProfile.sampleGerd());

      await tester.pumpWidget(_buildScreen(repo: repo));
      await tester.pumpAndSettle();

      // 최초 조회 실패 → 에러 UI
      expect(find.text('다시 시도'), findsOneWidget);
      expect(find.text('저장하기'), findsNothing);

      await tester.tap(find.text('다시 시도'));
      await tester.pumpAndSettle();

      // 재시도 성공 → 폼 표시(sampleGerd의 medications 초기값도 확인)
      expect(find.text('저장하기'), findsOneWidget);
      expect(find.text('omeprazole'), findsOneWidget);
      expect(repo.fetchAttempts, 2);
    });
  });
}
