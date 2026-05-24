import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';

part 'dio_client.g.dart';

/// 앱 전역에서 공유하는 Dio 인스턴스.
/// retrofit datasource 들은 이 provider 를 주입받아 사용한다.
@riverpod
Dio dio(Ref ref) {
  const config = AppConfig.dev;
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
    ),
  );
  // TODO(api): 인증 토큰/로깅 인터셉터는 서버 인증 방식 확정 시 추가.
  return dio;
}
