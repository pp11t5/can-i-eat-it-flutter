import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/mypage/data/repositories/mock_my_page_repository.dart';

import 'my_page_repository_contract.dart';

void main() {
  // -------------------------------------------------------------------------
  group('MockMyPageRepository.seeded — 저장소 계약', () {
    myPageRepositoryContract(
      MockMyPageRepository.seeded,
      seeded: true,
    );
  });

  // -------------------------------------------------------------------------
  group('MockMyPageRepository.empty — 저장소 계약', () {
    myPageRepositoryContract(
      MockMyPageRepository.empty,
      seeded: false,
    );
  });
}
