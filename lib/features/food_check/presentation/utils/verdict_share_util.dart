import 'package:share_plus/share_plus.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

/// 판정 결과 공유 유틸리티.
///
/// [buildShareText] 순수 함수로 공유 텍스트를 생성하고,
/// [shareVerdict] 로 OS 네이티브 공유 시트를 연다.
const String _appLink = 'https://can-i-eat-it.app';

/// 공유 텍스트 생성.
///
/// 포맷:
/// ```
/// [먹어도 돼?] {foodName} 판정 결과
/// 판정: {level.label}
///
/// 내 건강에 맞는 음식을 확인해보세요.
/// https://can-i-eat-it.app
/// ```
String buildShareText(EatVerdict verdict) {
  final buffer = StringBuffer()
    ..writeln('[먹어도 돼?] ${verdict.foodName} 판정 결과')
    ..writeln('판정: ${verdict.level.label}')
    ..writeln()
    ..writeln('내 건강에 맞는 음식을 확인해보세요.')
    ..write(_appLink);

  return buffer.toString();
}

/// OS 네이티브 공유 시트를 연다.
Future<void> shareVerdict(EatVerdict verdict) async {
  final text = buildShareText(verdict);
  await Share.share(text);
}
