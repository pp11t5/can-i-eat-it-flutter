/// 앱 전역 설정. 환경(플레이버)별 값은 추후 --dart-define 또는 .env 로 주입.
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 10),
  });

  /// 서버 API 베이스 URL. 서버 API 확정 전까지 placeholder.
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  /// 기본(개발) 설정. 서버 주소 확정 시 교체.
  static const AppConfig dev = AppConfig(
    apiBaseUrl: 'https://api.example.com',
  );
}
