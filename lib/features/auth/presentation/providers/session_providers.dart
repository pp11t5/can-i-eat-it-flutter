import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_providers.g.dart';

/// 앱 세션/온보딩 상태. 이슈 #4에서 AuthRepository 기반 구현으로 교체된다(인터페이스 불변 전제).
enum SessionStatus { unauthenticated, needsOnboarding, ready }

@riverpod
SessionStatus sessionStatus(Ref ref) => SessionStatus.unauthenticated;
