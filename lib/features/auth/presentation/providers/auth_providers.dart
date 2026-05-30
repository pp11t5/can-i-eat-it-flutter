import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/domain/entities/terms_agreement.dart';
import 'package:can_i_eat_it/features/auth/domain/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

/// [AuthRepository] 공급자.
///
/// W1 데모 기본값: 카카오 탭 → 신규(약관 화면), Apple 탭 → 삭제유예(02a 다이얼로그).
/// 한 빌드에서 양쪽 플로우를 모두 시연 가능. 실 구현(카카오 SDK + 서버 JWT) 교체 시
/// ProviderScope override 로 주입한다.
@riverpod
AuthRepository authRepository(Ref ref) => MockAuthRepository.w1Demo();

/// 인증 상태 컨트롤러 (AsyncNotifier).
///
/// [build]: [AuthRepository.currentSession]을 호출해 초기 세션을 로드한다.
/// 공개 메서드로 로그인·약관 동의·계정 복구·로그아웃을 처리한다.
@riverpod
class AuthController extends _$AuthController {
  @override
  Future<AuthSession?> build() async {
    return ref.watch(authRepositoryProvider).currentSession();
  }

  /// 카카오 계정으로 로그인하고 세션 상태를 갱신한다.
  Future<void> signInWithKakao() async {
    final session =
        await ref.read(authRepositoryProvider).signInWithKakao();
    state = AsyncValue.data(session);
  }

  /// Apple 계정으로 로그인하고 세션 상태를 갱신한다.
  Future<void> signInWithApple() async {
    final session =
        await ref.read(authRepositoryProvider).signInWithApple();
    state = AsyncValue.data(session);
  }

  /// 약관 동의를 기록하고 세션 상태를 갱신한다.
  Future<void> agreeToTerms(TermsAgreement agreement) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.recordTermsAgreement(agreement);
    state = AsyncValue.data(await repo.currentSession());
  }

  /// 계정 삭제 유예 상태를 복구하고 세션 상태를 갱신한다.
  Future<void> recoverAccount() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.recoverAccount();
    state = AsyncValue.data(await repo.currentSession());
  }

  /// 로그아웃하고 세션을 null로 초기화한다.
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncValue.data(null);
  }
}
