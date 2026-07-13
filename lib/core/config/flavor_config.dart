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
    this.receiveTimeout = Duration.zero,
  });

  final Flavor flavor;

  /// 서버 API 베이스 URL.
  final String apiBaseUrl;

  /// 앱 표시명(참조용 — 실제 홈스크린 라벨은 native 플레이버 설정이 소유).
  final String appDisplayName;

  /// 카카오 네이티브 앱키. **빈 문자열이면 Kakao SDK init 을 생략**한다(dev 미설정 대비).
  /// 키 리터럴은 커밋하지 않고 `--dart-define=KAKAO_NATIVE_APP_KEY` 로 주입한다.
  final String kakaoNativeAppKey;

  /// 연결 수립 타임아웃(진짜 오프라인/서버 도달불가 감지). 응답 본문 대기와 무관.
  final Duration connectTimeout;

  /// 응답 수신 타임아웃. **[Duration.zero] = 무제한(비활성)**.
  /// AI(LLM) 분석 API 는 응답이 10초 이상 걸릴 수 있어, 짧은 receive timeout 이
  /// receiveTimeout→NetworkFailure→판정 에러화면("분석 중 오류…")을 유발했다.
  /// 응답 지연으로 인한 오탐 에러를 없애기 위해 receive timeout 을 제거한다
  /// (연결 자체 실패는 [connectTimeout] 이 계속 감지).
  final Duration receiveTimeout;

  bool get isDev => flavor == Flavor.dev;
  bool get isProd => flavor == Flavor.prod;

  /// 현재 활성 플레이버 설정. 기본값 [prod] — 테스트가 [bootstrap] 없이 참조해도 안전.
  /// [bootstrap] 이 실제 플레이버로 교체한다.
  static FlavorConfig current = prod;

  /// 운영(prod) — 운영 서버.
  ///
  /// TODO(flavor): 현재 운영 서버 도메인은 dev 와 동일하다(운영 백엔드 추후 제공).
  ///   운영 서버 확정 시 [apiBaseUrl] 기본값을 교체한다.
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
  /// 현재 라이브 서버(`can-i-eat-it.com`)가 dev 서버다(운영 서버 추후 제공).
  /// dev 카카오 앱·Firebase dev 앱 설정 완료 — native 플레이버(iOS 스킴 dev /
  /// Android dev flavor)가 dev GoogleService-Info·Kakao scheme 을 소유한다.
  /// 카카오 키는 dev 빌드 시 `--dart-define=KAKAO_NATIVE_APP_KEY=<dev키>` 로 주입.
  static const FlavorConfig dev = FlavorConfig(
    flavor: Flavor.dev,
    apiBaseUrl: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://can-i-eat-it.com/api/v1',
    ),
    appDisplayName: '먹어도돼? Dev',
    kakaoNativeAppKey: String.fromEnvironment('KAKAO_NATIVE_APP_KEY'),
  );
}
