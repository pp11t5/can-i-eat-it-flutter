import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/auth/domain/entities/auth_session.dart';
import 'package:can_i_eat_it/features/health_profile/data/health_profile_providers.dart';
import 'auth_providers.dart';

part 'session_providers.g.dart';

/// 앱 세션/온보딩 상태 (ADR-0006).
///
/// [loading]       → 부팅 시 인증 또는 health_profile 로드 중(화면 깜빡임 차단용).
/// [unauthenticated] → 미인증(삭제유예 포함, 02a 다이얼로그 보호).
/// [needsTerms]    → 약관 미동의. 가드는 redirect 안 함(LoginScreen이 imperative push).
/// [needsOnboarding] → 약관 동의됐지만 health_profile 없음.
/// [ready]         → 모든 게이트 통과.
enum SessionStatus { loading, unauthenticated, needsTerms, needsOnboarding, ready }

/// [authSession]: null=미인증. [hasProfile]: null=로딩(아직 모름), false=프로필 없음, true=있음.
///
/// 순수 함수 — BuildContext/위젯 비의존, 단위 테스트 가능.
SessionStatus sessionStatusFrom({
  required AuthSession? authSession,
  required bool? hasProfile,
}) {
  if (authSession == null) return SessionStatus.unauthenticated;
  if (authSession.accountStatus == AccountStatus.deletionGrace) {
    return SessionStatus.unauthenticated;
  }
  if (!authSession.hasAgreedTerms) return SessionStatus.needsTerms;
  if (hasProfile == null) return SessionStatus.loading;
  return hasProfile ? SessionStatus.ready : SessionStatus.needsOnboarding;
}

/// [AuthController] + [HealthProfileController] 상태로부터 파생된 세션 상태.
///
/// 미인증/약관 미동의 단계에서는 health_profile을 watch하지 않는다(불필요 로딩 회피).
@riverpod
SessionStatus sessionStatus(Ref ref) {
  final auth = ref.watch(authControllerProvider);
  if (auth.isLoading && !auth.hasValue) return SessionStatus.loading;
  final session = auth.valueOrNull;

  // 게이트 이전 단계(미인증/약관)는 health_profile을 watch하지 않는다.
  // hasProfile: false 는 임시값 — unauthenticated/needsTerms 판정에만 쓰이며 hasProfile을 실제로 참조하기 전에 early-return 한다.
  final preGate = sessionStatusFrom(authSession: session, hasProfile: false);
  if (preGate == SessionStatus.unauthenticated ||
      preGate == SessionStatus.needsTerms) {
    return preGate;
  }

  final profile = ref.watch(healthProfileControllerProvider);
  if (profile.isLoading && !profile.hasValue) return SessionStatus.loading;
  final hasProfile = profile.valueOrNull != null;
  return sessionStatusFrom(authSession: session, hasProfile: hasProfile);
}
