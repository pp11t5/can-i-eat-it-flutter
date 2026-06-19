import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/auth_providers.dart';

part 'mypage_providers.g.dart';

/// 마이페이지에서 사용하는 현재 [AuthSession]을 re-export 한다.
///
/// UI는 이 provider를 watch해 계정 식별정보(displayName·email·profileImageUrl)를 표시한다.
/// 실질적으로 [authControllerProvider]를 위임하므로 상태는 항상 동기화된다.
@riverpod
AsyncValue<AuthSession?> mypageSession(Ref ref) {
  return ref.watch(authControllerProvider);
}
