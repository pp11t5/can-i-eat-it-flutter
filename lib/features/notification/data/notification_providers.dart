import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/core/network/dio_client.dart';
import 'package:can_i_eat_it/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:can_i_eat_it/features/notification/domain/repositories/notification_repository.dart';

part 'notification_providers.g.dart';

// ---------------------------------------------------------------------------
// NotificationRepository 공급자
// ---------------------------------------------------------------------------

/// [NotificationRepository] 공급자.
///
/// 기본값: [NotificationRepositoryImpl] — 실 서버 연동 (dioProvider 주입).
/// 테스트 override:
///   ProviderScope overrides: [notificationRepositoryProvider.overrideWithValue(mock)]
@riverpod
NotificationRepository notificationRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return NotificationRepositoryImpl(dio: dio);
}

// ---------------------------------------------------------------------------
// NotificationSettingsController — AsyncNotifier
// ---------------------------------------------------------------------------

/// 알림 설정 화면 상태 = 마케팅 정보 수신 동의 여부.
///
/// 앱 알림은 OS 권한으로만 제어하므로 이 컨트롤러는 마케팅 동의만 다룬다(#261).
@riverpod
class NotificationSettingsController extends _$NotificationSettingsController {
  @override
  Future<bool> build() =>
      ref.watch(notificationRepositoryProvider).fetchMarketingEnabled();

  /// 마케팅 동의를 낙관적으로 뒤집고 서버 응답 값(실제 저장값)으로 맞춘다.
  Future<void> toggleMarketing() async {
    final previous = state;
    final agreed = previous.valueOrNull;
    if (agreed == null) return;

    state = AsyncData(!agreed);

    // 요청 중 화면을 나가도 dispose되지 않게 붙잡는다 — 재진입 시 build()가
    // 진행 중인 쓰기와 경쟁해 이전 값을 읽어 오는 것을 막는다.
    final link = ref.keepAlive();
    try {
      state = AsyncData(
        await ref.read(notificationRepositoryProvider).toggleMarketingConsent(),
      );
    } catch (_) {
      state = previous;
      rethrow;
    } finally {
      link.close();
    }
  }
}
