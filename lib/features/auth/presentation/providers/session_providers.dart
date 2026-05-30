import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'auth_providers.dart';

part 'session_providers.g.dart';

/// 앱 세션/온보딩 상태 (ADR-0002).
enum SessionStatus { unauthenticated, needsTerms, needsOnboarding, ready }

/// [AuthSession?]으로부터 [SessionStatus]를 파생하는 순수 함수.
///
/// 로딩/세션없음 → unauthenticated
/// **삭제유예(02a)** → unauthenticated 으로 취급(라우팅 미진입 — LoginScreen 이
///   다이얼로그로 처리. 가드가 ready 로 보고 / 로 redirect 해서 다이얼로그가
///   가려지는 버그 방지.)
/// 약관 미동의 → needsTerms / 온보딩 미완료 → needsOnboarding / 그 외 → ready.
SessionStatus sessionStatusFromSession(AuthSession? session) {
  if (session == null) return SessionStatus.unauthenticated;
  if (session.accountStatus == AccountStatus.deletionGrace) {
    return SessionStatus.unauthenticated;
  }
  if (!session.hasAgreedTerms) return SessionStatus.needsTerms;
  if (!session.hasCompletedOnboarding) return SessionStatus.needsOnboarding;
  return SessionStatus.ready;
}

/// [AuthController] 상태에서 파생된 세션 상태.
/// 로딩 중 valueOrNull == null → unauthenticated(W1 mock은 즉시 resolve).
@riverpod
SessionStatus sessionStatus(Ref ref) =>
    sessionStatusFromSession(ref.watch(authControllerProvider).valueOrNull);
