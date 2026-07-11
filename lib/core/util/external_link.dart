import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:can_i_eat_it/app/widgets/app_toast.dart';

/// 외부 브라우저로 URL을 여는 공용 헬퍼.
///
/// 약관·정책 등 외부 웹페이지 링크(Notion 등)를 시스템 기본 브라우저로 연다.
/// URL을 열 수 없거나 실패하면 토스트로 안내한다.
///
/// 사용 예:
/// ```dart
/// onTap: () => openExternalUrl(context, TermsCatalog.tosUrl),
/// ```
Future<void> openExternalUrl(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  var success = false;
  if (uri != null) {
    try {
      success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      success = false;
    }
  }

  if (!success && context.mounted) {
    await showAppToast(context, '링크를 열 수 없어요.');
  }
}
