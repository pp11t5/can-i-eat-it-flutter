import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 사용자 흐름을 막지 않으려고 삼킨 오류를 운영에서 볼 수 있게 보고한다.
///
/// [reason]에 userId·이메일 같은 식별 정보를 넣지 않는다.
abstract interface class ErrorReporter {
  void recordNonFatal(Object error, StackTrace stack, {required String reason});
}

/// 콘솔 출력만 한다. 테스트·Firebase 미초기화 환경의 기본값.
class DebugErrorReporter implements ErrorReporter {
  const DebugErrorReporter();

  @override
  void recordNonFatal(
    Object error,
    StackTrace stack, {
    required String reason,
  }) {
    debugPrint('[Error] $reason: $error\n$stack');
  }
}

/// 콘솔 출력과 함께 Crashlytics에 non-fatal로 남긴다.
class CrashlyticsErrorReporter implements ErrorReporter {
  const CrashlyticsErrorReporter();

  @override
  void recordNonFatal(
    Object error,
    StackTrace stack, {
    required String reason,
  }) {
    const DebugErrorReporter().recordNonFatal(error, stack, reason: reason);
    // 보고 자체가 실패해도 호출부 흐름에 영향이 없어야 한다.
    unawaited(
      FirebaseCrashlytics.instance
          .recordError(error, stack, reason: reason)
          .catchError((Object e) => debugPrint('[Error] report failed: $e')),
    );
  }
}

/// Crashlytics를 켜고 미처리 오류 훅을 연결한다. Firebase init 성공 후에만 호출한다.
///
/// 디버그 빌드는 수집도, 훅 교체도 하지 않는다. 개발 중 오류가 운영 통계에 섞이지
/// 않고, 기본 Flutter 오류 출력(빨간 화면·콘솔)도 그대로 남는다.
Future<ErrorReporter> setUpCrashlytics() async {
  final crashlytics = FirebaseCrashlytics.instance;
  await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
  if (kDebugMode) return const CrashlyticsErrorReporter();
  FlutterError.onError = crashlytics.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    crashlytics.recordError(error, stack, fatal: true);
    return true;
  };
  return const CrashlyticsErrorReporter();
}

/// 기본값은 [DebugErrorReporter]. 실 앱은 bootstrap에서 override한다.
final errorReporterProvider = Provider<ErrorReporter>(
  (ref) => const DebugErrorReporter(),
);
