/// 오늘을 포함한 최근 [dayCount]일. [minDate](가입일) 이전은 제외한다.
///
/// 반환은 오름차순(과거 → 오늘). 날짜만 의미 있는 wall-clock [DateTime].
List<DateTime> recentDayOptions({
  required DateTime now,
  DateTime? minDate,
  int dayCount = 7,
}) {
  final today = DateTime(now.year, now.month, now.day);
  var start = today.subtract(Duration(days: dayCount - 1));
  if (minDate != null) {
    final min = DateTime(minDate.year, minDate.month, minDate.day);
    if (min.isAfter(start)) start = min;
  }
  if (start.isAfter(today)) return [today];
  final n = today.difference(start).inDays + 1;
  return List.generate(n, (i) => DateTime(start.year, start.month, start.day + i));
}
