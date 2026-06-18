import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/food_summary.dart';

part 'meal_entities.freezed.dart';

// ---------------------------------------------------------------------------
// StateRecord 엔티티 (읽기전용 — /meals/{id} stateRecords 대응)
// ---------------------------------------------------------------------------

/// 증상 섭취 기록 단건 (StateRecordDto 대응).
///
/// 읽기전용: 생성·수정 없음. [MealDetail.stateRecords] 에서만 표시.
@freezed
abstract class StateRecord with _$StateRecord {
  const factory StateRecord({
    /// 증상 라벨 (예: '속쓰림').
    required String label,

    /// 기록 날짜 ('YYYY-MM-DD' 문자열 그대로).
    required String date,

    /// 섭취 시점 (예: '식후 30분').
    required String timing,
  }) = _StateRecord;
}

// ---------------------------------------------------------------------------
// MealFood 엔티티 (MealFoodDetailDto 대응)
// ---------------------------------------------------------------------------

/// 식사 기록 내 음식 상세 (MealFoodDetailDto 대응).
///
/// [FoodSummary] 와 달리 [description] 필드를 추가로 보유한다.
@freezed
abstract class MealFood with _$MealFood {
  const factory MealFood({
    /// 서버측 음식 식별자.
    required String externalId,

    /// 음식 표시 이름.
    required String name,

    /// 음식 카테고리. 서버가 없으면 null.
    String? category,

    /// 음식 설명. 서버가 없으면 null.
    String? description,
  }) = _MealFood;
}

// ---------------------------------------------------------------------------
// MealRecord 엔티티 (MealRecordSummaryDto 대응)
// ---------------------------------------------------------------------------

/// 식사 기록 요약 엔티티 (타임라인 목록·POST 응답 대응).
@freezed
abstract class MealRecord with _$MealRecord {
  const factory MealRecord({
    /// 식사 기록 식별자.
    required String mealId,

    /// 소속 끼니 그룹 식별자.
    required String mealGroupId,

    /// 섭취 시각 (ISO-8601 문자열 그대로).
    required String eatenAt,

    /// 음식 요약 정보.
    required FoodSummary food,

    /// 판정 등급. 미판정이면 null.
    VerdictLevel? judgedGrade,
  }) = _MealRecord;
}

// ---------------------------------------------------------------------------
// MealDetail 엔티티 (MealRecordDetailDto 대응)
// ---------------------------------------------------------------------------

/// 식사 기록 상세 엔티티 (GET /meals/{id} · PATCH 응답 대응).
@freezed
abstract class MealDetail with _$MealDetail {
  const factory MealDetail({
    /// 식사 기록 식별자.
    required String mealId,

    /// 소속 끼니 그룹 식별자.
    required String mealGroupId,

    /// 섭취 시각 (ISO-8601 문자열 그대로).
    required String eatenAt,

    /// 메모. null 또는 빈 문자열이면 미작성 상태.
    String? memo,

    /// 판정 등급. 미판정이면 null.
    VerdictLevel? judgedGrade,

    /// 음식 상세 정보.
    required MealFood food,

    /// 연관 증상 기록 목록 (읽기전용).
    @Default(<StateRecord>[]) List<StateRecord> stateRecords,
  }) = _MealDetail;
}

// ---------------------------------------------------------------------------
// MealGroup 엔티티 (MealGroupDto 대응)
// ---------------------------------------------------------------------------

/// 끼니 그룹 엔티티 — 같은 시간대 식사 묶음 (타임라인 단위).
@freezed
abstract class MealGroup with _$MealGroup {
  const factory MealGroup({
    /// 끼니 그룹 식별자.
    required String mealGroupId,

    /// 섭취 시각 (ISO-8601 문자열 그대로).
    required String eatenAt,

    /// 그룹 내 식사 기록 목록.
    @Default(<MealRecord>[]) List<MealRecord> records,
  }) = _MealGroup;
}
