import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'report_sharer.g.dart';

// ---------------------------------------------------------------------------
// ReportSharer — 리포트 PNG 공유 seam (W6-7)
// ---------------------------------------------------------------------------

/// 주간 리포트 PNG를 OS 공유시트로 내보내는 seam.
///
/// [WeeklyReportScreen]이 캡처한 PNG 바이트를 이 인터페이스로 위임한다.
/// 테스트는 [reportSharerProvider]를 스파이/페이크로 override해 실제
/// 플랫폼 채널(공유시트) 호출 없이 흐름만 검증한다.
abstract class ReportSharer {
  Future<void> shareReportImage(Uint8List pngBytes, {required String text});
}

/// [ReportSharer] 기본 구현.
///
/// pngBytes를 임시 디렉터리(`path_provider`)에 파일로 저장한 뒤,
/// `share_plus`의 [Share.shareXFiles]로 OS 공유시트를 호출한다.
///
/// share_plus 버전 고정 메모(W6-7 후속): Android Kotlin 1.9.24 툴체인과의
/// 호환을 위해 share_plus를 `^10.1.4`로 고정한다(12.x는 Kotlin 2.2 요구 →
/// `flutter build apk` 실패). 10.1.4에는 신 `SharePlus.instance.share` API가
/// 없어 구 API인 [Share.shareXFiles]를 사용한다.
class SharePlusReportSharer implements ReportSharer {
  const SharePlusReportSharer();

  @override
  Future<void> shareReportImage(
    Uint8List pngBytes, {
    required String text,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/weekly_report_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(pngBytes, flush: true);

    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(file.path)], text: text);
  }
}

// ---------------------------------------------------------------------------
// reportSharerProvider
// ---------------------------------------------------------------------------

/// [ReportSharer] 공급자.
///
/// 테스트 override: `reportSharerProvider.overrideWithValue(spy)`.
@riverpod
ReportSharer reportSharer(Ref ref) => const SharePlusReportSharer();
