/// GA 파라미터 정제. 건강·식별 값은 보내지 않고, SDK가 받는 String/num만 남긴다.
const _blockedParamKeys = {
  'food_name',
  'foodName',
  'memo',
  'email',
};

/// Firebase Analytics 파라미터 이름: 영문 시작, 영숫자·밑줄, 최대 40자.
final _paramNamePattern = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{0,39}$');

const _maxStringValueLength = 100;

Map<String, Object> sanitizeAnalyticsParameters(Map<String, Object?> params) {
  final sanitized = <String, Object>{};
  for (final entry in params.entries) {
    final key = entry.key;
    if (_blockedParamKeys.contains(key)) continue;
    if (key.startsWith('firebase_') ||
        key.startsWith('google_') ||
        key.startsWith('ga_')) {
      continue;
    }
    if (!_paramNamePattern.hasMatch(key)) continue;

    final value = _coerceParamValue(entry.value);
    if (value != null) {
      sanitized[key] = value;
    }
  }
  return sanitized;
}

Object? _coerceParamValue(Object? value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is bool) return value ? 1 : 0;
  final text = value is String ? value : value.toString();
  if (text.isEmpty) return null;
  return text.length <= _maxStringValueLength
      ? text
      : text.substring(0, _maxStringValueLength);
}
