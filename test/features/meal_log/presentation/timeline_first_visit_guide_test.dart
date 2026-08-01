import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/app/theme/app_icons.dart';
import 'package:can_i_eat_it/app/theme/app_theme.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/meal_log_providers.dart';
import 'package:can_i_eat_it/features/meal_log/data/repositories/mock_meal_repository.dart';
import 'package:can_i_eat_it/features/meal_log/data/sources/timeline_guide_store.dart';
import 'package:can_i_eat_it/features/meal_log/domain/entities/meal_entities.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/screens/timeline_screen.dart';
import 'package:can_i_eat_it/features/meal_log/presentation/widgets/timeline_first_visit_guide.dart';

/// 타임라인 최초 FAB 가이드 — empty + 미열람 계정에서 노출, FAB 탭 시에만 닫힘.

final _fixedToday = DateTime(2026, 6, 17);

class _FakeAuth extends AuthController {
  _FakeAuth(this.userId);
  final String userId;

  @override
  Future<AuthSession?> build() async {
    return AuthSession(
      userId: userId,
      provider: AuthProvider.kakao,
      hasAgreedTerms: true,
      createdAt: DateTime(2026, 1, 1),
    );
  }
}

/// timeline() 이 끝날 때까지 로딩을 유지하는 mock (가이드 즉시 표시 검증용).
class _SlowEmptyMealRepository extends MockMealRepository {
  _SlowEmptyMealRepository({required this.delay});

  final Duration delay;

  @override
  Future<List<TimelineItem>> timeline(DateTime date) async {
    await Future<void>.delayed(delay);
    return super.timeline(date);
  }
}

Widget _wrap({
  required TimelineGuideStore guideStore,
  required String userId,
  required bool seededMeals,
  Duration? timelineDelay,
}) {
  return ProviderScope(
    overrides: [
      // ignore: scoped_providers_should_specify_dependencies
      mealRepositoryProvider.overrideWithValue(
        timelineDelay != null
            ? _SlowEmptyMealRepository(delay: timelineDelay)
            : seededMeals
                ? MockMealRepository.seeded()
                : MockMealRepository.empty(),
      ),
      // ignore: scoped_providers_should_specify_dependencies
      authControllerProvider.overrideWith(() => _FakeAuth(userId)),
      // ignore: scoped_providers_should_specify_dependencies
      timelineGuideStoreProvider.overrideWithValue(guideStore),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: TimelineScreen(todayOverride: _fixedToday),
    ),
  );
}

void main() {
  group('TimelineFirstVisitGuide', () {
    testWidgets('empty + 미열람 계정이면 가이드 문구 노출', (tester) async {
      final store = InMemoryTimelineGuideStore();
      await tester.pumpWidget(
        _wrap(guideStore: store, userId: 'u-new', seededMeals: false),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineFirstVisitGuide), findsOneWidget);
      expect(
        find.image(const AssetImage(AppImages.timelineFabGuide)),
        findsOneWidget,
      );
      expect(find.text('기록이 없어요'), findsNothing);
    });

    testWidgets('미열람이면 타임라인 로딩 중에도 스피너 없이 가이드', (tester) async {
      final store = InMemoryTimelineGuideStore();
      const delay = Duration(seconds: 5);
      await tester.pumpWidget(
        _wrap(
          guideStore: store,
          userId: 'u-loading',
          seededMeals: false,
          timelineDelay: delay,
        ),
      );
      // auth + guide 플래그 완료, timeline 은 아직 로딩
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(TimelineFirstVisitGuide), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // pending timer 정리
      await tester.pump(delay);
      await tester.pumpAndSettle();
    });

    testWidgets('empty + 이미 본 계정이면 일반 empty', (tester) async {
      final store = InMemoryTimelineGuideStore(seenUserIds: {'u-old'});
      await tester.pumpWidget(
        _wrap(guideStore: store, userId: 'u-old', seededMeals: false),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineFirstVisitGuide), findsNothing);
      expect(find.text('기록이 없어요'), findsOneWidget);
    });

    testWidgets('empty 영역 아무 탭이어도 markSeen — 가이드 숨김', (tester) async {
      final store = InMemoryTimelineGuideStore();
      await tester.pumpWidget(
        _wrap(guideStore: store, userId: 'u-tap', seededMeals: false),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TimelineFirstVisitGuide), findsOneWidget);

      // 가이드 empty 영역(좌상단 근처) 탭
      await tester.tapAt(const Offset(40, 280));
      await tester.pumpAndSettle();

      expect(store.seenUserIds, contains('u-tap'));
      expect(find.byType(TimelineFirstVisitGuide), findsNothing);
      expect(find.text('기록이 없어요'), findsOneWidget);
    });

    testWidgets('FAB 탭해도 markSeen — 이후 가이드 숨김', (tester) async {
      final store = InMemoryTimelineGuideStore();
      await tester.pumpWidget(
        _wrap(guideStore: store, userId: 'u-fab', seededMeals: false),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TimelineFirstVisitGuide), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(store.seenUserIds, contains('u-fab'));
      expect(find.byType(TimelineFirstVisitGuide), findsNothing);
      // 액션시트 딤 닫기
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();
      expect(find.text('기록이 없어요'), findsOneWidget);
    });

    testWidgets('계정 A 닫아도 계정 B 는 가이드 유지', (tester) async {
      final store = InMemoryTimelineGuideStore(seenUserIds: {'user-a'});

      await tester.pumpWidget(
        _wrap(guideStore: store, userId: 'user-b', seededMeals: false),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineFirstVisitGuide), findsOneWidget);
      expect(await store.hasSeenFabGuide('user-a'), isTrue);
      expect(await store.hasSeenFabGuide('user-b'), isFalse);
    });
  });
}
