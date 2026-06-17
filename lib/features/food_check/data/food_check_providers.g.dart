// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_check_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$foodRepositoryHash() => r'e664a8ae03fdc1a3d465d915680ac8021c06d376';

/// [FoodRepository] 공급자.
///
/// 기본값: [FoodRepositoryImpl] — 실 서버 연동 (ADR-0007 §3-1 (5), W3-3).
/// - search / recent CRUD: 실 `/foods/*` 엔드포인트.
/// - judgeByText / judgeById: 실 `/foods/judgment` 엔드포인트 (W3-3 충실 정합).
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [foodRepositoryProvider.overrideWithValue(MockFoodRepository.empty())]
///
/// Copied from [foodRepository].
@ProviderFor(foodRepository)
final foodRepositoryProvider = AutoDisposeProvider<FoodRepository>.internal(
  foodRepository,
  name: r'foodRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$foodRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FoodRepositoryRef = AutoDisposeProviderRef<FoodRepository>;
String _$verdictControllerHash() => r'0252b6ae4b9ac259cde9945f41401c1038c26e7e';

/// 판정 컨트롤러.
///
/// 진입 경로에 따라 2메서드를 선택한다:
/// - [judgeByText]: 자유 텍스트 진입 (검색 결과 없음 → raw text 직접 분석).
/// - [judgeById]: 등록 음식 진입 (검색 결과 셀 탭, externalId 보유).
///
/// 상태 분기:
/// - 로딩 중: [AsyncLoading] → VerdictLoadingScreen.
/// - grade=UNKNOWN (성공): [AsyncData(EatVerdict(level:unknown))] → VerdictUnknownScreen.
/// - recommend/caution/risk: [AsyncData(EatVerdict)] → VerdictResultScreen.
/// - FOOD400_1/FOOD404_1/통신오류: [AsyncError(Failure)] → 분석실패 에러화면.
///
/// ⚠️ grade=UNKNOWN 은 성공(AsyncData) — 분석실패(AsyncError)와 절대 혼동 금지(D1, R3).
///
/// Copied from [VerdictController].
@ProviderFor(VerdictController)
final verdictControllerProvider = AutoDisposeNotifierProvider<VerdictController,
    AsyncValue<EatVerdict>>.internal(
  VerdictController.new,
  name: r'verdictControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$verdictControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VerdictController = AutoDisposeNotifier<AsyncValue<EatVerdict>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
