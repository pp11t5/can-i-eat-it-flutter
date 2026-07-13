// 기본 진입점 — `flutter run`(플레이버 미지정) 편의용.
//
// 명시 빌드는 플레이버 진입점을 직접 지정한다:
//   운영: flutter run --flavor prod -t lib/main_prod.dart
//   개발: flutter run --flavor dev  -t lib/main_dev.dart
//
// 플레이버 미지정 실행은 운영(prod) 설정에 위임한다(현행 동작 보존 — 운영 서버 대상).
import 'main_prod.dart' as prod;

Future<void> main() => prod.main();
