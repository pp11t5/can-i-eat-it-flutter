import 'package:flutter/material.dart';

/// 앱 전역 [RouteObserver] 싱글턴.
///
/// [GoRouter] `observers` 파라미터에 등록하고,
/// [RouteAware] mixin을 사용하는 위젯에서 `subscribe`/`unsubscribe`한다.
///
/// 사용 예:
/// ```dart
/// routeObserver.subscribe(this, ModalRoute.of(context)!);
/// ```
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
