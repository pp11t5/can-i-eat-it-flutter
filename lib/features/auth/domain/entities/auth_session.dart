import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';

/// 소셜 로그인 제공자.
enum AuthProvider { kakao, apple }

/// 계정 상태.
///
/// - [active]: 정상 활성 계정.
/// - [deletionGrace]: 계정 삭제 유예 중(02a 플로우). 일정 기간 내 복구 가능.
enum AccountStatus { active, deletionGrace }

/// 인증 세션 엔티티.
///
/// [hasAgreedTerms]: 신규 사용자는 false, 기존 가입자는 true.
/// 온보딩 완료 여부는 health_profile 피처가 소유한다(ADR-0006).
/// [displayName]/[email]/[profileImageUrl]: GET /auth/me 로부터 채워지는 계정 식별정보.
/// 기존 생성처는 nullable 이므로 지정 없이 null 유지 가능.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String userId,
    required AuthProvider provider,
    @Default(false) bool hasAgreedTerms,
    @Default(AccountStatus.active) AccountStatus accountStatus,
    String? displayName,
    String? email,
    String? profileImageUrl,
  }) = _AuthSession;
}
