import 'package:share_plus/share_plus.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

/// 판정 결과 공유 유틸리티.
///
/// [buildShareText] 순수 함수로 공유 텍스트를 생성하고,
/// [shareVerdict] 로 OS 네이티브 공유 시트를 연다.
const String _appLink = 'https://can-i-eat-it.app';

/// [VerdictLevel] → 이모지+한국어 등급 문자열.
String _gradeLabel(VerdictLevel level) => switch (level) {
      VerdictLevel.recommend => '✅ 추천',
      VerdictLevel.caution => '⚠️ 주의',
      VerdictLevel.risk => '🚫 위험',
      VerdictLevel.unknown => '❓ 확인어려움',
    };

/// 공유 텍스트 생성.
///
/// 포맷:
/// ```
/// [먹어도 돼?] {foodName} 판정 결과
/// 등급: {gradeLabel}
/// {reason}          ← personalTitle이 비어 있으면 이 줄 생략
///
/// 앱에서 확인하기: https://can-i-eat-it.app
/// ```
String buildShareText(EatVerdict verdict) {
  final label = _gradeLabel(verdict.level);
  final reason = verdict.personalTitle.trim();

  final buffer = StringBuffer()
    ..writeln('[먹어도 돼?] ${verdict.foodName} 판정 결과')
    ..writeln('등급: $label');

  if (reason.isNotEmpty) {
    buffer.writeln(reason);
  }

  buffer
    ..writeln()
    ..write('앱에서 확인하기: $_appLink');

  return buffer.toString();
}

/// OS 네이티브 공유 시트를 연다.
Future<void> shareVerdict(EatVerdict verdict) async {
  final text = buildShareText(verdict);
  await Share.share(text);
}
