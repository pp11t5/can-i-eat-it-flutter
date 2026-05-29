import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'analytics_service.dart';
import 'debug_analytics_service.dart';

part 'analytics_providers.g.dart';

/// 계측 서비스 provider.
/// 기본값은 [DebugAnalyticsService] (디버그 로깅 스텁).
/// 실 분석 도구 도입 시 ProviderScope overrides로 교체.
@riverpod
AnalyticsService analyticsService(Ref ref) => const DebugAnalyticsService();
