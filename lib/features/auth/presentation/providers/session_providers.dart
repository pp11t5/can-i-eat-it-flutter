import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'auth_providers.dart';

part 'session_providers.g.dart';

/// 앱 세션/온보딩 상태 (ADR-0002).
enum SessionStatus { unauthenticated, needsTerms, needsOnboarding, ready }

/// [AuthSession?]으로부터 [SessionStatus]를 파생하는 순수 함수.
///
/// 로딩 중(null)이면 unauthenticated, 약관 미동의면 needsTerms,
/// 온보딩 미완료면 needsOnboarding, 그 외 ready.
/// accountStatus(deletionGrace)는 로그인 UI 다이얼로그에서 처리하므로 여기선 무시.
SessionStatus sessionStatusFromSession(AuthSession? session) {
  if (session == null) return SessionStatus.unauthenticated;
  if (!session.hasAgreedTerms) return SessionStatus.needsTerms;
  if (!session.hasCompletedOnboarding) return SessionStatus.needsOnboarding;
  return SessionStatus.ready;
}

/// [AuthController] 상태에서 파생된 세션 상태.
/// 로딩 중 valueOrNull == null → unauthenticated(W1 mock은 즉시 resolve).
@riverpod
SessionStatus sessionStatus(Ref ref) =>
    sessionStatusFromSession(ref.watch(authControllerProvider).valueOrNull);
