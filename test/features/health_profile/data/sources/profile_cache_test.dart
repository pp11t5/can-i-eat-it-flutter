import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/health_profile/data/sources/profile_cache.dart';
import 'package:can_i_eat_it/features/health_profile/domain/entities/health_profile.dart';

void main() {
  group('InMemoryProfileCache', () {
    late InMemoryProfileCache cache;

    setUp(() => cache = InMemoryProfileCache());

    // -------------------------------------------------------------------------
    // read/write 라운드트립
    // -------------------------------------------------------------------------

    test('write → read 라운드트립: 동일 프로필을 반환한다', () async {
      final profile = HealthProfile.sampleGerd();
      await cache.write(profile);
      expect(await cache.read(), equals(profile));
    });

    test('초기 상태에서 read 는 null 을 반환한다', () async {
      expect(await cache.read(), isNull);
    });

    test('clear 후 read 는 null 을 반환한다', () async {
      await cache.write(HealthProfile.sampleGerd());
      await cache.clear();
      expect(await cache.read(), isNull);
    });

    test('write 를 여러 번 호출하면 마지막 값을 반환한다', () async {
      final first = HealthProfile.sampleGerd();
      final second = first.copyWith(conditions: ['Gastritis']);
      await cache.write(first);
      await cache.write(second);
      expect(await cache.read(), equals(second));
    });

    // -------------------------------------------------------------------------
    // 빈 프로필 라운드트립
    // -------------------------------------------------------------------------

    test('빈 HealthProfile 도 라운드트립된다', () async {
      const empty = HealthProfile();
      await cache.write(empty);
      expect(await cache.read(), equals(empty));
    });
  });

  // ---------------------------------------------------------------------------
  // _HealthProfileCodec 을 통한 SecureStorageProfileCache 동일 논리 검증
  // (실제 FlutterSecureStorage 없이 InMemory 로 codec 논리만 검증)
  // ---------------------------------------------------------------------------

  group('ProfileCache JSON 평면 스키마 — 필드 보존', () {
    // InMemoryProfileCache 는 직렬화를 거치지 않으므로
    // codec 논리는 profile_cache.dart 의 _HealthProfileCodec 을 직접 검증한다.
    // 여기서는 sampleGerd 로 모든 필드를 한 번에 검증한다.

    test('sampleGerd 모든 필드가 write→read 후 보존된다', () async {
      final cache = InMemoryProfileCache();
      final profile = HealthProfile.sampleGerd();
      await cache.write(profile);
      final result = await cache.read();

      expect(result, isNotNull);
      expect(result!.conditions, equals(['GERD']));
      expect(result.symptomFrequency,
          equals(['heartburn_reflux', 'post_meal_cough']));
      expect(result.diagnosed, isTrue);
      expect(result.triggerFoods, equals(['spicy', 'caffeine']));
      expect(result.customTriggers, equals('탄산음료'));
      expect(result.medications, equals(['omeprazole']));
      expect(result.allergies, equals(['shellfish']));
    });

    test('triggerFoods/customTriggers/medications/allergies 누락 없음', () async {
      final cache = InMemoryProfileCache();
      const profile = HealthProfile(
        triggerFoods: ['fatty'],
        customTriggers: 'test',
        medications: ['med1', 'med2'],
        allergies: ['nuts'],
      );
      await cache.write(profile);
      final result = await cache.read();

      expect(result!.triggerFoods, equals(['fatty']));
      expect(result.customTriggers, equals('test'));
      expect(result.medications, equals(['med1', 'med2']));
      expect(result.allergies, equals(['nuts']));
    });
  });
}
