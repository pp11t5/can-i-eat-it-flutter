import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';

part 'profile_cache.g.dart';

// ---------------------------------------------------------------------------
// 인터페이스
// ---------------------------------------------------------------------------

/// 건강 프로필 로컬 캐시 추상화.
///
/// 서버에 전체 프로필 GET/PATCH 엔드포인트가 없으므로 기기에 영속 캐시한다.
/// 테스트에서는 [InMemoryProfileCache] 를 주입한다.
abstract interface class ProfileCache {
  /// 캐시된 프로필을 읽는다. 없거나 파싱 실패 시 null 반환(크래시 금지).
  Future<HealthProfile?> read();

  /// 프로필을 캐시에 저장한다.
  Future<void> write(HealthProfile p);

  /// 캐시를 삭제한다 (로그아웃·탈퇴 시 이전 프로필 잔존 방지).
  Future<void> clear();
}

// ---------------------------------------------------------------------------
// 평면 JSON codec (서버 DTO와 독립 — health_profile_dto.dart 재사용 금지)
// ---------------------------------------------------------------------------

/// [HealthProfile] ↔ 평면 JSON 코덱.
///
/// 엔티티 필드명 그대로 사용(서버 snake_case 계약 변경이 캐시 포맷을 깨는 역의존 차단).
/// List<String> 필드 누락/null 안전.
class _HealthProfileCodec {
  const _HealthProfileCodec();

  Map<String, dynamic> encode(HealthProfile p) => {
        'conditions': p.conditions,
        'symptomFrequency': p.symptomFrequency,
        'diagnosed': p.diagnosed,
        'triggerFoods': p.triggerFoods,
        'customTriggers': p.customTriggers,
        'medications': p.medications,
        'allergies': p.allergies,
      };

  HealthProfile decode(Map<String, dynamic> json) {
    List<String> strList(dynamic v) {
      if (v == null) return const [];
      if (v is List) return v.whereType<String>().toList();
      return const [];
    }

    return HealthProfile(
      conditions: strList(json['conditions']),
      symptomFrequency: strList(json['symptomFrequency']),
      diagnosed: (json['diagnosed'] as bool?) ?? false,
      triggerFoods: strList(json['triggerFoods']),
      customTriggers: json['customTriggers'] as String?,
      medications: strList(json['medications']),
      allergies: strList(json['allergies']),
    );
  }
}

const _codec = _HealthProfileCodec();

// ---------------------------------------------------------------------------
// flutter_secure_storage 구현
// ---------------------------------------------------------------------------

/// [flutter_secure_storage] 기반 프로덕션 구현.
///
/// 키 접미사 `_v1` — 향후 포맷 마이그레이션 분기 대비.
class SecureStorageProfileCache implements ProfileCache {
  SecureStorageProfileCache({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _key = 'profile.health_profile_v1';

  @override
  Future<HealthProfile?> read() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return _codec.decode(json);
    } catch (_) {
      // 파싱 실패 시 null 반환 — 크래시 금지
      return null;
    }
  }

  @override
  Future<void> write(HealthProfile p) async {
    final encoded = jsonEncode(_codec.encode(p));
    await _storage.write(key: _key, value: encoded);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}

// ---------------------------------------------------------------------------
// 인메모리 Fake (테스트용)
// ---------------------------------------------------------------------------

/// 테스트·Mock 용 인메모리 [ProfileCache].
class InMemoryProfileCache implements ProfileCache {
  HealthProfile? _profile;

  @override
  Future<HealthProfile?> read() async => _profile;

  @override
  Future<void> write(HealthProfile p) async {
    _profile = p;
  }

  @override
  Future<void> clear() async {
    _profile = null;
  }
}

// ---------------------------------------------------------------------------
// Riverpod Provider
// ---------------------------------------------------------------------------

/// 앱 전역 [ProfileCache] provider.
///
/// 테스트에서는 `ProviderContainer(overrides: [profileCacheProvider.overrideWithValue(...)])` 로 교체한다.
@riverpod
ProfileCache profileCache(Ref ref) => SecureStorageProfileCache();
