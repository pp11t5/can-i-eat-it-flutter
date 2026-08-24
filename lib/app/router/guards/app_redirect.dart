import 'package:can_i_eat_it/app/router/guards/auth_guard.dart';
import 'package:can_i_eat_it/features/auth/presentation/providers/session_providers.dart';
import 'package:can_i_eat_it/features/home_widget/domain/home_widget_deep_link.dart';

/// 위젯 딥링크를 앱 경로로 바꾼 뒤 세션 가드를 적용한다.
String? resolveAppRedirect({
  required SessionStatus status,
  required Uri uri,
  required String matchedLocation,
  bool allowTermsDuringConsentTransition = false,
}) {
  final fromWidget = HomeWidgetDeepLink.toLocation(uri);
  if (fromWidget != null && status == SessionStatus.loading) {
    return matchedLocation == '/splash' ? null : '/splash';
  }

  final location = fromWidget ?? matchedLocation;
  final auth = resolveRedirect(
    status: status,
    location: location,
    allowTermsDuringConsentTransition: allowTermsDuringConsentTransition,
  );
  if (auth != null) return auth;
  if (fromWidget != null && fromWidget != matchedLocation) return fromWidget;
  return null;
}
