import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_dictionary/data/repositories/mock_dictionary_repository.dart';

import 'dictionary_repository_contract.dart';

void main() {
  // -------------------------------------------------------------------------
  group('MockDictionaryRepository.seeded — 저장소 계약', () {
    dictionaryRepositoryContract(
      MockDictionaryRepository.seeded,
      seeded: true,
    );
  });

  // -------------------------------------------------------------------------
  group('MockDictionaryRepository.empty — 저장소 계약', () {
    dictionaryRepositoryContract(
      MockDictionaryRepository.empty,
      seeded: false,
    );
  });
}
