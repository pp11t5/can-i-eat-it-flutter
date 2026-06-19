import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/favorite_item.dart';
import 'package:can_i_eat_it/features/food_check/domain/repositories/favorite_repository.dart';

/// [SharedPreferences] 기반 즐겨찾기 저장소 구현.
///
/// 저장 키: `'favorites'`
/// 포맷: JSON 배열 문자열 (foodName, level, savedAt, foodExternalId)
class LocalFavoriteRepository implements FavoriteRepository {
  static const _key = 'favorites';

  @override
  Future<List<FavoriteItem>> getAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => _fromJson(e as Map<String, dynamic>))
          .toList()
          .reversed
          .toList(); // 최신 먼저
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> save(FavoriteItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await _loadRaw(prefs);
    current.removeWhere((e) => e['foodName'] == item.foodName);
    current.add(_toJson(item));
    await prefs.setString(_key, jsonEncode(current));
  }

  @override
  Future<void> remove(String foodName) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await _loadRaw(prefs);
    current.removeWhere((e) => e['foodName'] == foodName);
    await prefs.setString(_key, jsonEncode(current));
  }

  @override
  Future<bool> isFavorite(String foodName) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await _loadRaw(prefs);
    return current.any((e) => e['foodName'] == foodName);
  }

  // ---------------------------------------------------------------------------
  // 내부 헬퍼
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> _loadRaw(SharedPreferences prefs) async {
    try {
      final raw = prefs.getString(_key);
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Map<String, dynamic> _toJson(FavoriteItem item) => {
        'foodName': item.foodName,
        'level': item.level.toServerGrade(),
        'savedAt': item.savedAt.toIso8601String(),
        if (item.foodExternalId != null)
          'foodExternalId': item.foodExternalId,
      };

  FavoriteItem _fromJson(Map<String, dynamic> json) => FavoriteItem(
        foodName: json['foodName'] as String,
        level: VerdictLevelGrade.fromGrade(json['level'] as String),
        savedAt: DateTime.parse(json['savedAt'] as String),
        foodExternalId: json['foodExternalId'] as String?,
      );
}
