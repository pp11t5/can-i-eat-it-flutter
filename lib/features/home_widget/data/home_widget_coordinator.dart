import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';
import 'package:can_i_eat_it/features/home_widget/domain/home_widget_deep_link.dart';

/// 위젯 탭과 세션 게이트. `home_widget` 플러그인과 분리해 단위 테스트한다.
class HomeWidgetCoordinator {
  HomeWidgetCoordinator({
    required SessionStatus initialStatus,
    required void Function(String location) onNavigate,
    required void Function(String location) onGo,
    required void Function() onSync,
  })  : _status = initialStatus,
        _onNavigate = onNavigate,
        _onGo = onGo,
        _onSync = onSync;

  SessionStatus _status;
  final void Function(String location) _onNavigate;
  final void Function(String location) _onGo;
  final void Function() _onSync;
  String? _pending;

  void onAppResumed() => _onSync();

  void handleUri(Uri? uri) {
    final location = HomeWidgetDeepLink.toLocation(uri);
    if (location == null) return;

    if (_status == SessionStatus.ready) {
      _onNavigate(location);
      return;
    }

    _pending = location;
    if (_status == SessionStatus.unauthenticated) {
      _onGo('/login');
    }
  }

  void onSessionStatusChanged(SessionStatus next) {
    _status = next;
    if (next == SessionStatus.ready) {
      final pending = _pending;
      _pending = null;
      if (pending != null) {
        _onNavigate(pending);
      }
      _onSync();
    } else if (next == SessionStatus.unauthenticated) {
      _onSync();
    }
  }
}
