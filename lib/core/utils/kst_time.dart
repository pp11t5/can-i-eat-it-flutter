/// KST(Asia/Seoul, UTC+09:00) 시간 직렬화·파싱 헬퍼.
///
/// tz 패키지 없이 KST wall-clock 계약으로 동작한다.
///
/// ## 계약
/// - 호출자는 **KST wall-clock**(isUtc=false, 컴포넌트=KST 시각)을 넘긴다.
/// - 직렬화는 컴포넌트를 그대로 +09:00 오프셋으로 포맷한다. **시간 연산 없음.**
/// - 서버 API 계약: date 파라미터는 'YYYY-MM-DD', eatenAt은 ISO-8601 +09:00 오프셋.
/// - [parseKst]:
///   - 오프셋/`Z` 있음 → UTC instant 환산 후 +9h로 KST 컴포넌트 복원.
///   - 오프셋 없음 (타임라인 `LocalDateTime.toString()` 등) → 이미 KST wall-clock
///     이므로 컴포넌트 그대로 사용 (+9h 하지 않음). 00:00 → 09:00 회귀 방지.
///   머신 TZ 무관(`.toLocal()` 사용 안 함). 표시·시간대 분기용.
library;

/// ISO 문자열 끝에 명시적 타임존(Z / ±HH:MM / ±HHMM)이 있는지.
bool _hasExplicitOffset(String iso) {
  // 예: ...Z, ...+09:00, ...-0500, ...+09:00.000 은 아님 — 오프셋은 맨 끝.
  return RegExp(r'(Z|[+-]\d{2}:?\d{2})$', caseSensitive: false)
      .hasMatch(iso.trim());
}

/// 서버 ISO-8601 문자열을 KST wall-clock [DateTime]으로 파싱한다.
///
/// - **오프셋 있음** (`+09:00`, `Z` 등): instant → +9h 로 KST 컴포넌트 복원.
/// - **오프셋 없음** (타임라인 mealRecordDateTime 등): 서버 KST wall-clock 가정,
///   시·분 컴포넌트를 그대로 쓴다. (기존 무조건 +9h 는 00:00→09:00 버그)
///
/// 반환값은 isUtc=false이며 컴포넌트가 KST 시각과 일치한다.
/// 머신 TZ에 무관하다(`.toLocal()` 사용 안 함). 표시·시간대 분기용.
DateTime parseKst(String iso) {
  if (!_hasExplicitOffset(iso)) {
    // LocalDateTime.toString() 등 — 숫자 컴포넌트만 KST wall-clock.
    final p = DateTime.parse(iso);
    return DateTime(p.year, p.month, p.day, p.hour, p.minute, p.second);
  }
  final u = DateTime.parse(iso).toUtc();
  final k = u.add(const Duration(hours: 9));
  return DateTime(k.year, k.month, k.day, k.hour, k.minute, k.second);
}

/// 현재 KST wall-clock을 **local-flag** [DateTime]으로 반환한다.
///
/// 머신 TZ에 무관하게 UTC+9 오프셋을 고정 적용한다.
/// 반환값은 isUtc=false이며, 컴포넌트가 KST 시각과 일치한다.
DateTime nowKst() {
  final u = DateTime.now().toUtc();
  final k = u.add(const Duration(hours: 9));
  return DateTime(k.year, k.month, k.day, k.hour, k.minute, k.second);
}

/// [DateTime] 의 컴포넌트를 그대로 'YYYY-MM-DD' 형식으로 반환한다.
///
/// [dt] 는 KST wall-clock이어야 한다. 시간 연산을 하지 않으므로
/// 호출자가 KST 컴포넌트를 보장해야 한다.
String toServerDate(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// [DateTime] 의 컴포넌트를 그대로 ISO-8601 +09:00 오프셋 문자열로 반환한다.
///
/// 예: DateTime(2026,6,17,9,2,0) → '2026-06-17T09:02:00+09:00'
///
/// [dt] 는 KST wall-clock이어야 한다. 시간 연산을 하지 않으므로
/// 호출자가 KST 컴포넌트를 보장해야 한다. 서버 eatenAt 필드 직렬화에 사용한다.
String toServerOffset(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final mo = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  final h = dt.hour.toString().padLeft(2, '0');
  final mi = dt.minute.toString().padLeft(2, '0');
  final s = dt.second.toString().padLeft(2, '0');
  return '$y-$mo-${d}T$h:$mi:$s+09:00';
}
