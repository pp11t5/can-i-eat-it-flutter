/// 앱 전역 설정. 환경(플레이버)별 값은 --dart-define 으로 주입.
///
/// `--dart-define=API_BASE_URL=https://…` 로 override 가능.
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 10),
  });

  /// 서버 API 베이스 URL.
  ///
  /// 빌드 시 `--dart-define=API_BASE_URL=<url>` 로 override 가능.
  /// 지정하지 않으면 `https://can-i-eat-it.com/api/v1` 사용.
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  /// 개발(기본) 설정.
  static const AppConfig dev = AppConfig(
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://can-i-eat-it.com/api/v1',
    ),
  );
}
