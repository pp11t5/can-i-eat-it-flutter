import 'package:can_i_eat_it/features/home_widget/domain/home_widget_snapshot.dart';

/// 위젯 탭 → 앱 목적지. 유니버설링크가 아니라 커스텀 스킴.
abstract final class HomeWidgetDeepLink {
  static const scheme = 'canieatit';
  static const host = 'widget';

  static Uri mealRecord() =>
      Uri(scheme: scheme, host: host, path: '/meal-record');

  static Uri foodHistory() =>
      Uri(scheme: scheme, host: host, path: '/food-history');

  static Uri home() => Uri(scheme: scheme, host: host, path: '/home');

  static Uri symptomRecord(String mealRecordId) => Uri(
        scheme: scheme,
        host: host,
        path: '/symptom-record',
        queryParameters: {'mealRecordId': mealRecordId},
      );

  static Uri fromKind(HomeWidgetKind kind, {String? mealRecordId}) {
    switch (kind) {
      case HomeWidgetKind.promptSymptom:
        final id = mealRecordId;
        if (id == null || id.isEmpty) {
          return Uri(scheme: scheme, host: host, path: '/symptom-record');
        }
        return symptomRecord(id);
      case HomeWidgetKind.allRecordedComfortable:
      case HomeWidgetKind.allRecordedUncomfortable:
        return foodHistory();
      case HomeWidgetKind.recordMeal:
        return mealRecord();
      case HomeWidgetKind.loggedOut:
        return home();
    }
  }

  /// 지원하지 않으면 null. 세션 가드가 로그인/온보딩을 처리한다.
  ///
  /// Flutter 딥링크가 스킴을 떼고 `/meal-record`만 넘기는 경우도 같은 앱 경로로 바꾼다.
  static String? toLocation(Uri? uri) {
    if (uri == null) return null;
    final widgetLink = uri.scheme == scheme && uri.host == host;
    if (uri.scheme.isNotEmpty && !widgetLink) return null;

    switch (uri.path) {
      case '/meal-record':
        return '/meal/record';
      case '/food-history':
        return widgetLink ? '/food-history' : null;
      case '/home':
        return '/';
      case '/symptom-record':
        final id = uri.queryParameters['mealRecordId']?.trim();
        if (id == null || id.isEmpty) return '/unrecorded-meals';
        return Uri(
          path: '/symptom/record',
          queryParameters: {'mealRecordId': id},
        ).toString();
      default:
        return null;
    }
  }
}
