import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:can_i_eat_it/features/verdict_history/domain/entities/verdict_history_item.dart';
import 'package:can_i_eat_it/features/verdict_history/domain/repositories/verdict_history_repository.dart';

/// [SharedPreferences] 기반 판정 이력 저장소 구현.
///
/// 저장 키: `'verdict_history_v1'`
/// 저장 포맷: JSON 배열 문자열 (`jsonEncode` / `jsonDecode`)
/// 최대 보관: 50건 (초과 시 마지막 항목 제거 — FIFO)
class VerdictHistoryRepositoryImpl implements VerdictHistoryRepository {
  static const _key = 'verdict_history_v1';
  static const _maxItems = 50;

  @override
  Future<List<VerdictHistoryItem>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => VerdictHistoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // 파싱 오류 시 빈 목록 반환 (데이터 손상 방어).
      return [];
    }
  }

  @override
  Future<void> addItem(VerdictHistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getHistory();
    // 앞에 추가 (prepend) → 최신 순 유지.
    final updated = [item, ...current];
    // 50건 초과 시 마지막 제거.
    final trimmed =
        updated.length > _maxItems ? updated.sublist(0, _maxItems) : updated;
    await prefs.setString(
      _key,
      jsonEncode(trimmed.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
