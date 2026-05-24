import 'package:can_i_eat_this/features/condition_profile/domain/entities/health_condition.dart';
import 'package:can_i_eat_this/features/food_check/data/repositories/food_repository_impl.dart';
import 'package:can_i_eat_this/features/food_check/domain/entities/eat_verdict.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const repo = FoodRepositoryImpl();
  const gerd = HealthCondition(id: 'gerd', name: '역류성 식도염');

  test('질환 보유자가 트리거 음식을 조회하면 avoid 로 판별한다', () async {
    final verdict = await repo.checkFood(
      foodQuery: '아메리카노 커피',
      conditions: const [gerd],
    );
    expect(verdict.level, VerdictLevel.avoid);
    expect(verdict.sources, isNotEmpty);
  });

  test('질환을 선택하지 않으면 트리거 음식이어도 safe 로 판별한다', () async {
    final verdict = await repo.checkFood(
      foodQuery: '커피',
      conditions: const [],
    );
    expect(verdict.level, VerdictLevel.safe);
  });

  test('질환 보유자가 트리거가 아닌 음식을 조회하면 caution 으로 판별한다', () async {
    final verdict = await repo.checkFood(
      foodQuery: '바나나',
      conditions: const [gerd],
    );
    expect(verdict.level, VerdictLevel.caution);
  });
}
