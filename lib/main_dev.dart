import 'bootstrap.dart';
import 'core/config/flavor_config.dart';

/// 개발(dev) 진입점 — 개발 서버.
///
/// 빌드: `flutter run --flavor dev -t lib/main_dev.dart`
///
/// ⚠️ UI 검수용 목 repository override 는 여기에 커밋하지 않는다.
///    개발 서버가 아직 미완이면 로컬 미커밋 오버레이(bootstrap 의 extraOverrides)로만 주입.
/// TODO(flavor): dev 카카오 네이티브앱키·Firebase dev 앱 준비 시 연동 완료.
Future<void> main() => bootstrap(FlavorConfig.dev);
