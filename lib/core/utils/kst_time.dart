/// KST(Asia/Seoul, UTC+09:00) 시간 직렬화 헬퍼.
///
/// tz 패키지 없이 +09:00 오프셋을 고정 적용한다.
/// 서버 API 계약: date 파라미터는 'YYYY-MM-DD', eatenAt 은 ISO-8601 +09:00 오프셋.
library;

/// [DateTime] 을 서버 date 쿼리 파라미터 형식('YYYY-MM-DD', KST)으로 변환한다.
///
/// [dt] 는 로컬 또는 UTC 무관하게 +09:00 오프셋을 적용해 날짜를 계산한다.
String toServerDate(DateTime dt) {
  final kst = dt.toUtc().add(const Duration(hours: 9));
  final y = kst.year.toString().padLeft(4, '0');
  final m = kst.month.toString().padLeft(2, '0');
  final d = kst.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// [DateTime] 을 ISO-8601 +09:00 오프셋 문자열로 변환한다.
///
/// 예: '2026-06-17T12:30:00+09:00'
/// 서버 eatenAt 필드 직렬화에 사용한다.
String toServerOffset(DateTime dt) {
  final kst = dt.toUtc().add(const Duration(hours: 9));
  final y = kst.year.toString().padLeft(4, '0');
  final mo = kst.month.toString().padLeft(2, '0');
  final d = kst.day.toString().padLeft(2, '0');
  final h = kst.hour.toString().padLeft(2, '0');
  final mi = kst.minute.toString().padLeft(2, '0');
  final s = kst.second.toString().padLeft(2, '0');
  return '$y-$mo-${d}T$h:$mi:$s+09:00';
}
