import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/mypage/data/repositories/my_page_repository_impl.dart';
import 'package:can_i_eat_it/features/mypage/domain/entities/my_page_summary.dart';
import 'package:can_i_eat_it/features/mypage/domain/repositories/my_page_repository.dart';

part 'my_page_providers.g.dart';

// ---------------------------------------------------------------------------
// MyPageRepository 공급자
// ---------------------------------------------------------------------------

/// [MyPageRepository] 공급자.
///
/// 기본값: [MyPageRepositoryImpl] — 실 서버 연동.
///
/// 테스트 / 오프라인 override:
///   ProviderScope overrides: [myPageRepositoryProvider.overrideWithValue(MockMyPageRepository.seeded())]
@riverpod
MyPageRepository myPageRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return MyPageRepositoryImpl(dio: dio);
}

// ---------------------------------------------------------------------------
// MyPageSummary 조회 (W7 홈·마이 실데이터)
// ---------------------------------------------------------------------------

/// 마이페이지 요약을 조회한다. 홈 화면(인사말 streak·미기록 배지)과
/// 마이페이지(음식 히스토리·주간 기록 카드)가 공유 구독.
@riverpod
Future<MyPageSummary> mySummary(Ref ref) =>
    ref.watch(myPageRepositoryProvider).getSummary();
