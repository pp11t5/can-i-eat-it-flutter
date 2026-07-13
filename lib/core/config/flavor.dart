/// 빌드 플레이버.
///
/// - [Flavor.dev]: 개발 서버 대상 빌드(카카오/Firebase dev 앱은 준비 중 → placeholder).
/// - [Flavor.prod]: 운영 서버 대상 빌드(현재 유일하게 완비된 실빌드).
///
/// 스테이징 없음 — dev/prod 2종만 운영한다.
enum Flavor { dev, prod }
