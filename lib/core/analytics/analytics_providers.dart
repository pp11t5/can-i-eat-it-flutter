import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'analytics_service.dart';
import 'debug_analytics_service.dart';

part 'analytics_providers.g.dart';

/// 계측 서비스 provider.
/// 기본값은 [DebugAnalyticsService] (테스트·플러그인 없는 환경).
/// 실 앱은 bootstrap에서 FirebaseAnalyticsService로 override.
@riverpod
AnalyticsService analyticsService(Ref ref) => const DebugAnalyticsService();
