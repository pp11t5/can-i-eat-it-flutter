import 'bootstrap.dart';
import 'core/config/flavor_config.dart';

/// 운영(prod) 진입점 — 운영 서버.
///
/// 빌드: `flutter build ios --flavor prod -t lib/main_prod.dart`
///      `flutter build apk --flavor prod -t lib/main_prod.dart`
///
/// 운영 빌드에는 개발용 목 repository override 가 포함되지 않는다.
Future<void> main() => bootstrap(FlavorConfig.prod);
