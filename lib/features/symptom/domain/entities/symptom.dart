import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:can_i_eat_it/features/meal_log/domain/entities/symptom_state.dart';

part 'symptom.freezed.dart';

// ---------------------------------------------------------------------------
// SymptomType — 증상 유형 4종
// ---------------------------------------------------------------------------

/// 증상 유형 4종 (서버 소문자 문자열과 1:1 정합).
///
/// - [throatForeignBody]: 목 이물감
/// - [acidReflux]: 역류
/// - [cough]: 기침
/// - [chestTightness]: 가슴 답답함
enum SymptomType { throatForeignBody, acidReflux, cough, chestTightness }

/// [SymptomType] 서버 변환·표시 확장.
extension SymptomTypeMapper on SymptomType {
  /// 서버 [v] 문자열을 [SymptomType] 으로 변환한다.
  ///
  /// 미지값은 null 을 반환한다 — 호출부에서 whereType/where(!=null)로 필터링.
  static SymptomType? fromServerNullable(String v) => switch (v) {
        'throat_foreign_body' => SymptomType.throatForeignBody,
        'acid_reflux' => SymptomType.acidReflux,
        'cough' => SymptomType.cough,
        'chest_tightness' => SymptomType.chestTightness,
        _ => null,
      };

  /// 도메인 [SymptomType] 을 서버 문자열로 변환한다.
  String toServer() => switch (this) {
        SymptomType.throatForeignBody => 'throat_foreign_body',
        SymptomType.acidReflux => 'acid_reflux',
        SymptomType.cough => 'cough',
        SymptomType.chestTightness => 'chest_tightness',
      };

  /// 화면 표시용 한국어 라벨.
  String get label => switch (this) {
        SymptomType.throatForeignBody => '목 이물감',
        SymptomType.acidReflux => '역류',
        SymptomType.cough => '기침',
        SymptomType.chestTightness => '가슴 답답함',
      };
}

// ---------------------------------------------------------------------------
// SymptomAnalysisItem — cross-feature 의존 방지 전용 경량 모델
// ---------------------------------------------------------------------------

/// 증상 분석 항목 단건 (서버 {emphasis, body}).
///
/// food_check의 VerdictItem{emphasis,body}과 동형이지만 계약 드리프트 방지를 위해
/// symptom 전용 모델을 둔다 (W5-1 ADR 동일 철학).
@freezed
abstract class SymptomAnalysisItem with _$SymptomAnalysisItem {
  const factory SymptomAnalysisItem({
    /// 강조 문구.
    required String emphasis,

    /// 본문.
    required String body,
  }) = _SymptomAnalysisItem;
}

// ---------------------------------------------------------------------------
// SymptomLinkedFood / SymptomLinkedMeal — 연결 식사 정보
// ---------------------------------------------------------------------------

/// 연결 식사 내 음식 단건.
@freezed
abstract class SymptomLinkedFood with _$SymptomLinkedFood {
  const factory SymptomLinkedFood({
    /// 음식 식별자.
    required String mealFoodId,

    /// 음식 표시 이름.
    required String name,

    /// 음식 카테고리. 서버가 없으면 null.
    String? category,
  }) = _SymptomLinkedFood;
}

/// 연결 식사 정보.
@freezed
abstract class SymptomLinkedMeal with _$SymptomLinkedMeal {
  const factory SymptomLinkedMeal({
    /// 연결 식사 기록 식별자.
    required String mealRecordId,

    /// 연결 식사 내 음식 목록.
    @Default(<SymptomLinkedFood>[]) List<SymptomLinkedFood> foods,
  }) = _SymptomLinkedMeal;
}

// ---------------------------------------------------------------------------
// Symptom — 증상 단건 엔티티
// ---------------------------------------------------------------------------

/// 증상 기록 단건 엔티티 (GET /symptoms/{id} · POST /symptoms 응답 대응).
@freezed
abstract class Symptom with _$Symptom {
  const factory Symptom({
    /// 증상 기록 식별자 (UUID).
    required String symptomId,

    /// 증상 5단계 상태.
    required SymptomState symptomState,

    /// 서버 제공 상태 제목 문자열.
    required String stateTitle,

    /// 증상 유형 목록 (≤4 unique).
    @Default(<SymptomType>[]) List<SymptomType> symptomTypes,

    /// 발생 시각 (ISO-8601 문자열 그대로, 표시 전용).
    required String occurredAt,

    /// 연결 식사. 없으면 null.
    SymptomLinkedMeal? linkedMeal,

    /// 분석 항목 목록. 없으면 빈 목록.
    @Default(<SymptomAnalysisItem>[]) List<SymptomAnalysisItem> analysisItems,
  }) = _Symptom;
}

// ---------------------------------------------------------------------------
// SymptomDraft — create/update 공용 입력 모델
// ---------------------------------------------------------------------------

/// 증상 생성/수정 공용 입력 모델.
///
/// - create: occurredAt null 허용 (서버가 현재 시각 사용).
/// - update: 호출자가 occurredAt 비-null 을 보장해야 한다 (서버 계약 필수).
/// - mealRecordId: null 이면 누락(미전송, 식사 미연결).
/// - memo: null 이면 누락(미전송).
class SymptomDraft {
  const SymptomDraft({
    required this.symptomState,
    this.mealRecordId,
    this.symptomTypes = const [],
    this.occurredAt,
    this.memo,
  });

  /// 증상 5단계 상태 (필수).
  final SymptomState symptomState;

  /// 연결 식사 기록 ID. null 이면 식사 미연결(서버 계약상 nullable) —
  /// repository 에서 body 키 자체를 누락시켜 전달한다.
  final String? mealRecordId;

  /// 증상 유형 목록 (≤4 unique, 기본 빈 목록).
  final List<SymptomType> symptomTypes;

  /// 발생 시각. null 이면 서버 현재 시각 사용 (create 용).
  /// update 시 호출자가 비-null 을 보장한다.
  final DateTime? occurredAt;

  /// 메모 (≤200자). null 이면 미전송.
  final String? memo;
}
