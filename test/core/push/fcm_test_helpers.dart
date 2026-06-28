import 'package:can_i_eat_it/core/push/fcm_providers.dart';
import 'package:can_i_eat_it/core/push/fcm_repository.dart';
import 'package:can_i_eat_it/core/push/fcm_token_service.dart';

// ---------------------------------------------------------------------------
// FCM noop 헬퍼 — 테스트에서 네이티브 플러그인 접근 차단용.
//
// 사용법:
//   fcmLifecycleProvider.overrideWithValue(noopFcmLifecycle())
// ---------------------------------------------------------------------------

/// 테스트용 noop FcmRepository — 서버 호출 없이 조용히 성공.
class NoopFcmRepository implements FcmRepository {
  @override
  Future<void> register({required String token, required String platform}) async {}

  @override
  Future<void> delete() async {}
}

/// 테스트용 noop FcmTokenService — Firebase 접근 없이 null 반환.
///
/// FcmTokenService는 concrete class이므로 extends로 정의.
/// super()는 호출하지 않아도 되나 Dart에서 default constructor가 없으면
/// 반드시 super를 명시해야 하므로, FcmTokenService에 기본 생성자가 있는 한 OK.
class NoopFcmTokenService extends FcmTokenService {
  @override
  String? get platform => null;

  @override
  Future<void> requestPermission() async {}

  @override
  Future<String?> currentToken() async => null;

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();
}

/// 테스트용 noop FcmLifecycle.
///
/// register/delete 모두 no-op이므로 네이티브 플러그인·Dio 접근이 없다.
FcmLifecycle noopFcmLifecycle() => _NoopFcmLifecycle();

class _NoopFcmLifecycle extends FcmLifecycle {
  _NoopFcmLifecycle()
      : super(
          repo: NoopFcmRepository(),
          tokenService: NoopFcmTokenService(),
        );

  @override
  Future<void> registerCurrentToken() async {}

  @override
  Future<void> deleteToken() async {}
}
