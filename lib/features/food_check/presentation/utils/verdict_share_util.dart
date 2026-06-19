import 'package:share_plus/share_plus.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

/// 판정 결과 공유 유틸리티.
///
/// [buildShareText] 순수 함수로 공유 텍스트를 생성하고,
/// [shareVerdict] 로 OS 네이티브 공유 시트를 연다.
/// 등급 한글명 (공유용).
String _levelLabel(VerdictLevel level) => switch (level) {
      VerdictLevel.recommend => '권장',
      VerdictLevel.caution => '주의',
      VerdictLevel.risk => '위험',
      VerdictLevel.unknown => '확인 어려움',
    };

/// 공유 텍스트 생성.
///
/// 포맷:
/// ```
/// 🍽️ {foodName} 판정 결과
/// 등급: {levelLabel}
/// 근거: {items.first.body | "정보 없음"}
/// #먹어도돼 #건강식단
/// ```
String buildShareText(EatVerdict verdict) {
  final levelLabel = _levelLabel(verdict.level);
  final basis = verdict.items.isNotEmpty ? verdict.items.first.body : '정보 없음';

  final buffer = StringBuffer()
    ..writeln('🍽️ ${verdict.foodName} 판정 결과')
    ..writeln('등급: $levelLabel')
    ..writeln('근거: $basis')
    ..write('#먹어도돼 #건강식단');

  return buffer.toString();
}

/// OS 네이티브 공유 시트를 연다.
Future<void> shareVerdict(EatVerdict verdict) async {
  final text = buildShareText(verdict);
  await Share.share(text);
}
