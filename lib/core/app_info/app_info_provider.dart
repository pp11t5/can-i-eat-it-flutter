import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_info_provider.g.dart';

/// 앱 패키지 정보 provider.
///
/// [PackageInfo.fromPlatform]으로 버전·빌드번호를 가져온다.
/// keepAlive: true — 앱 생명주기 동안 1회만 로드.
@Riverpod(keepAlive: true)
Future<PackageInfo> appInfo(Ref ref) => PackageInfo.fromPlatform();
