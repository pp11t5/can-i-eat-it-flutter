/// 푸시 payload의 외부 링크를 앱 내부 목적지로 해석한다.
///
/// 현재는 식후 증상 기록, 주간 리포트, 미기록 식사 목록만 허용한다. 외부
/// 유니버설 링크 수신은 별도 작업이며, 여기서는 FCM `data.link` 값만 이
/// resolver에 전달된다.
sealed class PushDestination {
  const PushDestination();

  String get location;
}

/// 특정 식사에 연결된 증상 기록 작성 목적지.
final class RecordSymptomPushDestination extends PushDestination {
  const RecordSymptomPushDestination({required this.mealRecordId});

  final String mealRecordId;

  @override
  String get location => Uri(
        path: '/symptom/record',
        queryParameters: {'mealRecordId': mealRecordId},
      ).toString();
}

/// 현재 주간 리포트를 여는 목적지.
final class WeeklyReportPushDestination extends PushDestination {
  const WeeklyReportPushDestination();

  @override
  String get location => '/weekly-report';
}

/// 증상 미기록 식사 목록을 여는 목적지.
final class UnrecordedMealsPushDestination extends PushDestination {
  const UnrecordedMealsPushDestination();

  @override
  String get location => '/unrecorded-meals';
}

/// FCM `data.link` 계약의 검증과 내부 라우트 변환을 담당한다.
abstract final class PushLinkResolver {
  static const _host = 'can-i-eat-it.com';
  static const _symptomRecordPath = '/app/symptoms/new';
  static const _weeklyReportPath = '/app/weekly-report';
  static const _unrecordedMealsPath = '/app/unrecorded-meals';

  /// 지원되는 URL이면 목적지를 반환하고, 아닌 경우 null을 반환한다.
  static PushDestination? parse(String? rawLink) {
    if (rawLink == null || rawLink.isEmpty) return null;

    final uri = Uri.tryParse(rawLink);
    if (uri == null || uri.scheme != 'https' || uri.host != _host) {
      return null;
    }

    if (uri.path == _weeklyReportPath) {
      // 현재 리포트만 제공한다. 특정 주를 지정하는 query는 지원하지 않는다.
      if (uri.queryParameters.isNotEmpty) return null;
      return const WeeklyReportPushDestination();
    }

    if (uri.path == _unrecordedMealsPath) {
      // 목록은 화면에서 최신 후보를 조회하므로, 식사 ID·묶음 건수를 받지 않는다.
      if (uri.queryParameters.isNotEmpty) return null;
      return const UnrecordedMealsPushDestination();
    }

    if (uri.path != _symptomRecordPath) return null;

    final mealRecordIds = uri.queryParametersAll['mealRecordId'];
    if (mealRecordIds == null ||
        mealRecordIds.length != 1 ||
        mealRecordIds.single.trim().isEmpty) {
      return null;
    }

    return RecordSymptomPushDestination(
      mealRecordId: mealRecordIds.single,
    );
  }

  static PushDestination? fromData(Map<String, dynamic> data) {
    return parse(data['link'] as String?);
  }
}
