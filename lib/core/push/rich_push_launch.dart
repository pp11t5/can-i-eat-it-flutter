import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Android 리치 푸시 「자세히」가 MainActivity extras로 전달한 payload.
const MethodChannel richPushLaunchChannel =
    MethodChannel('canieatit/rich_push_launch');

/// 네이티브가 보관한 대기 런치와 이후 onLaunch 이벤트를 [onData]로 전달한다.
///
/// 플러그인이 없는 플랫폼(iOS·테스트)은 조용히 skip.
Future<void> wireRichPushLaunch(
  void Function(Map<String, dynamic> data) onData,
) async {
  richPushLaunchChannel.setMethodCallHandler((call) async {
    if (call.method == 'onLaunch') {
      final data = stringKeyMap(call.arguments);
      if (data.isNotEmpty) onData(data);
    }
  });

  try {
    final pending =
        await richPushLaunchChannel.invokeMethod<dynamic>('takePendingLaunch');
    final data = stringKeyMap(pending);
    if (data.isNotEmpty) onData(data);
  } on MissingPluginException {
    // iOS / 채널 미등록 테스트
  } catch (e) {
    debugPrint('[RichPush] takePendingLaunch failed: $e');
  }
}

/// MethodChannel Map을 `Map<String, dynamic>`으로 정규화한다.
@visibleForTesting
Map<String, dynamic> stringKeyMap(dynamic raw) {
  if (raw is! Map) return {};
  return {
    for (final entry in raw.entries)
      if (entry.key != null && entry.value != null)
        entry.key.toString(): entry.value,
  };
}
