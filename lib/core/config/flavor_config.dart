import 'flavor.dart';

/// 플레이버별 런타임 설정(코어 공유). [bootstrap] 이 진입점에서 [current] 에 1회 주입한다.
///
/// 값은 모두 컴파일타임 상수이며, `--dart-define` 으로 override 가능하다.
/// 카카오/Firebase 등 외부 연동은 이 config 의 값(및 native 설정파일)로 분리되므로,
/// 새 플레이버 값만 바꾸면 연동 대상이 갈린다.
class FlavorConfig {
  const FlavorConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.appDisplayName,
    required this.kakaoNativeAppKey,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 10),
  });

  final Flavor flavor;

  /// 서버 API 베이스 URL.
  final String apiBaseUrl;

  /// 앱 표시명(참조용 — 실제 홈스크린 라벨은 native 플레이버 설정이 소유).
  final String appDisplayName;

  /// 카카오 네이티브 앱키. **빈 문자열이면 Kakao SDK init 을 생략**한다(dev 미설정 대비).
  /// 키 리터럴은 커밋하지 않고 `--dart-define=KAKAO_NATIVE_APP_KEY` 로 주입한다.
  final String kakaoNativeAppKey;

  final Duration connectTimeout;
  final Duration receiveTimeout;

  bool get isDev => flavor == Flavor.dev;
  bool get isProd => flavor == Flavor.prod;

  /// 현재 활성 플레이버 설정. 기본값 [prod] — 테스트가 [bootstrap] 없이 참조해도 안전.
  /// [bootstrap] 이 실제 플레이버로 교체한다.
  static FlavorConfig current = prod;

  /// 운영(prod) — 운영 서버.
  static const FlavorConfig prod = FlavorConfig(
    flavor: Flavor.prod,
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://can-i-eat-it.com/api/v1',
    ),
    appDisplayName: '먹어도돼?',
    kakaoNativeAppKey: String.fromEnvironment('KAKAO_NATIVE_APP_KEY'),
  );

  /// 개발(dev) — 개발 서버.
  ///
  /// TODO(flavor): 실제 dev 서버 도메인 확정 시 [apiBaseUrl] 기본값 교체.
  /// TODO(flavor): dev 카카오 네이티브앱키·Firebase dev 앱 준비 시 연동
  ///   (현재는 키 미주입 → Kakao init 생략, prod GoogleService-Info 재사용은 native placeholder).
  static const FlavorConfig dev = FlavorConfig(
    flavor: Flavor.dev,
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://dev.can-i-eat-it.com/api/v1',
    ),
    appDisplayName: '먹어도돼? Dev',
    kakaoNativeAppKey: String.fromEnvironment('KAKAO_NATIVE_APP_KEY'),
  );
}
