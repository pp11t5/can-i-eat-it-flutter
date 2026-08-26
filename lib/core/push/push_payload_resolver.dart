import 'dart:convert';

/// 푸시 payload를 앱 내부 목적지로 해석한다.
sealed class PushDestination {
  const PushDestination();

  String get location;
}

/// 특정 식사에 연결된 증상 기록 작성 목적지.
final class RecordSymptomPushDestination extends PushDestination {
  const RecordSymptomPushDestination({
    required this.mealRecordId,
    this.intensityIndex,
    this.symptomTypes = const [],
  });

  final String mealRecordId;
  final int? intensityIndex;
  final List<String> symptomTypes;

  @override
  String get location {
    final params = <String, String>{'mealRecordId': mealRecordId};
    final index = intensityIndex;
    if (index != null) params['intensityIndex'] = '$index';
    if (symptomTypes.isNotEmpty) {
      params['symptomTypes'] = symptomTypes.join(',');
    }
    return Uri(path: '/symptom/record', queryParameters: params).toString();
  }
}

/// 식사 기록 입력 목적지.
final class RecordMealPushDestination extends PushDestination {
  const RecordMealPushDestination();

  @override
  String get location => '/meal/record';
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

/// FCM `data.type`·`data.targetId` 계약의 검증과 내부 라우트 변환을 담당한다.
abstract final class PushPayloadResolver {
  /// Android 커스텀 리치 알림 대상 타입.
  ///
  /// 이 타입은 네이티브가 알림을 그리므로 Flutter 로컬 알림을 띄우지 않는다.
  static bool isAndroidRichPushType(Object? type) =>
      type == 'post_meal' || type == 'post_meal_delayed_single';

  /// 원격 FCM `data` payload를 지원되는 목적지로 변환한다.
  static PushDestination? fromData(Map<String, dynamic> data) {
    final type = data['type'];
    if (type is! String) return null;

    final targetId = data['targetId'];
    switch (type) {
      case 'post_meal':
      case 'post_meal_delayed_single':
        return _recordSymptomDestination(targetId, data);
      case 'post_meal_delayed_bulk':
        return targetId == null ? const UnrecordedMealsPushDestination() : null;
      case 'daily_record':
        return targetId == null ? const RecordMealPushDestination() : null;
      case 'weekly_report':
        return targetId == null ? const WeeklyReportPushDestination() : null;
      default:
        return null;
    }
  }

  /// Android 포그라운드 로컬 알림에 저장된 FCM data JSON을 해석한다.
  static PushDestination? fromLocalPayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) return null;
      return fromData(decoded);
    } on FormatException {
      return null;
    }
  }

  static PushDestination? _recordSymptomDestination(
    Object? targetId,
    Map<String, dynamic> data,
  ) {
    if (targetId is! String || targetId.trim().isEmpty) return null;
    return RecordSymptomPushDestination(
      mealRecordId: targetId.trim(),
      intensityIndex: _intensityIndex(data['intensityIndex']),
      symptomTypes: _symptomTypeCodes(data['symptomTypes']),
    );
  }

  static int? _intensityIndex(Object? value) {
    final parsed = switch (value) {
      final int n => n,
      final String text => int.tryParse(text.trim()),
      _ => null,
    };
    if (parsed == null || parsed < 0 || parsed > 4) return null;
    return parsed;
  }

  static List<String> _symptomTypeCodes(Object? value) {
    if (value is List) {
      return [
        for (final item in value)
          if (item != null && item.toString().trim().isNotEmpty)
            item.toString().trim(),
      ];
    }
    if (value is String && value.trim().isNotEmpty) {
      return [
        for (final part in value.split(','))
          if (part.trim().isNotEmpty) part.trim(),
      ];
    }
    return const [];
  }
}
