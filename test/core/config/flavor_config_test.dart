import 'package:can_i_eat_it/core/config/flavor_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlavorConfig API base URLs', () {
    test('dev uses the staging API by default', () {
      expect(
        FlavorConfig.dev.apiBaseUrl,
        'https://staging.can-i-eat-it.com/api/v1',
      );
    });

    test('prod uses the production API by default', () {
      expect(
        FlavorConfig.prod.apiBaseUrl,
        'https://prod.can-i-eat-it.com/api/v1',
      );
    });
  });
}
