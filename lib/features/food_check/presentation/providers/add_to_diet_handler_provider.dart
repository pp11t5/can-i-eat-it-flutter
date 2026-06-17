import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/presentation/models/verdict_args.dart';

/// 식단 추가 핸들러 타입.
///
/// food_check 내에 선언 — meal_log에서 구현, app 레이어에서 합성(override).
/// food_check→meal_log 직접 import 없이 의존성 역전.
typedef AddToDietHandler = Future<void> Function(
  BuildContext context,
  EatVerdict verdict,
  MealRecordContext ctx,
);

/// 식단 추가 핸들러 provider.
///
/// 기본값: null (단순 판정 흐름).
/// app 레이어에서 meal_log 핸들러로 override한다.
final addToDietHandlerProvider = Provider<AddToDietHandler?>((ref) => null);
