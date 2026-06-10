import 'package:freezed_annotation/freezed_annotation.dart';

import 'verdict_history_summary.dart';

part 'eat_verdict.freezed.dart';

/// 신호등 판정 4상태 (ADR-0003).
///
/// - [recommend]: 권장 — 섭취해도 무방한 식품.
/// - [caution]: 주의 — 조건부 섭취 또는 소량 섭취 권장.
/// - [danger]: 위험 — 섭취를 피해야 하는 식품.
/// - [unknown]: 확인어려움 — LLM 신뢰도 미달·DB 미매칭 폴백. 단정 금지.
///
/// 전체 EatVerdict 엔티티(reason, alternatives 등)는 W3에서 추가.
enum VerdictLevel { recommend, caution, danger, unknown }

/// [VerdictLevel] 한국어 라벨 확장.
extension VerdictLevelLabel on VerdictLevel {
  /// 화면 표시용 한국어 라벨.
  String get label {
    return switch (this) {
      VerdictLevel.recommend => '권장',
      VerdictLevel.caution => '주의',
      VerdictLevel.danger => '위험',
      VerdictLevel.unknown => '확인어려움',
    };
  }
}

// ---------------------------------------------------------------------------
// EatVerdict 엔티티 (W3 #5, ADR-0003 §4 VerdictCard 3섹션 구조)
// ---------------------------------------------------------------------------

/// 신호등 판정 결과 엔티티.
///
/// VerdictCard 3섹션 구조:
/// - Section 1 — 일반 분석: [reasonGeneral]
/// - Section 2 — 개인화 맞춤 분석: [reasonPersonal]
/// - Section 3 — 섭취 후 기록: [historySummary]
///
/// [alternatives] 는 [caution]·[danger] 상태에서만 채워진다.
/// [unknown] 상태는 Section 1·2 대신 면책 고지만 노출한다(섹션 비움 허용).
@freezed
abstract class EatVerdict with _$EatVerdict {
  const factory EatVerdict({
    /// 판정 신호.
    required VerdictLevel level,

    /// 분석 대상 음식명.
    required String foodName,

    /// Section 1 — 일반 분석. [unknown]에서는 비어 있을 수 있다.
    @Default('') String reasonGeneral,

    /// Section 2 — 개인화 맞춤 분석. [unknown]에서는 비어 있을 수 있다.
    @Default('') String reasonPersonal,

    /// 대체 음식 목록 (Section 2 하단).
    ///
    /// [recommend]·[unknown] 에서는 비어 있어야 한다(ADR-0003 §4).
    /// [caution]·[danger] 에서는 서버가 1~3개를 채울 수 있다.
    @Default(<String>[]) List<String> alternatives,

    /// Section 3 — 이 음식 섭취 후 기록 요약. 기록 없으면 [VerdictHistorySummary.empty].
    @Default(VerdictHistorySummary()) VerdictHistorySummary historySummary,
  }) = _EatVerdict;

  // ---------------------------------------------------------------------------
  // 4상태 대표 샘플 named factory (Mock·테스트·골든 테스트용)
  // ---------------------------------------------------------------------------

  /// 권장 판정 샘플.
  ///
  /// [alternatives] 는 비어 있다(ADR-0003 §4 규약).
  factory EatVerdict.recommend({String foodName = '두부'}) => EatVerdict(
        level: VerdictLevel.recommend,
        foodName: foodName,
        reasonGeneral: '단백질이 풍부하고 소화가 잘 되는 식품입니다.',
        reasonPersonal: '트리거 음식 매치: 없음. 알레르기 해당: 없음.',
        alternatives: const [],
        historySummary: VerdictHistorySummary.empty(),
      );

  /// 주의 판정 샘플.
  ///
  /// [alternatives] 에 대체 음식 예시가 포함된다.
  factory EatVerdict.caution({String foodName = '된장찌개'}) => EatVerdict(
        level: VerdictLevel.caution,
        foodName: foodName,
        reasonGeneral: '나트륨 함량이 높아 위산 역류를 악화할 수 있습니다.',
        reasonPersonal: '트리거 음식 매치: 없음. 알레르기 해당: 없음.',
        alternatives: const ['저염 된장찌개', '두부국'],
        historySummary: const VerdictHistorySummary(
          count: 2,
          averageSeverity: '보통',
        ),
      );

  /// 위험 판정 샘플.
  ///
  /// [alternatives] 에 대체 음식 예시가 포함된다.
  factory EatVerdict.danger({String foodName = '커피'}) => EatVerdict(
        level: VerdictLevel.danger,
        foodName: foodName,
        reasonGeneral: '카페인이 위산 분비를 촉진해 역류성 식도염 증상을 심화합니다.',
        reasonPersonal: '트리거 음식 매치: caffeine. 주의가 필요합니다.',
        alternatives: const ['디카페인 커피', '보리차'],
        historySummary: const VerdictHistorySummary(
          count: 5,
          averageSeverity: '심함',
        ),
      );

  /// 확인어려움 판정 샘플.
  ///
  /// [reasonGeneral]·[reasonPersonal]·[alternatives] 가 모두 비어 있다(ADR-0003 §4 규약).
  factory EatVerdict.unknown({String foodName = '정체불명음식'}) => EatVerdict(
        level: VerdictLevel.unknown,
        foodName: foodName,
        reasonGeneral: '',
        reasonPersonal: '',
        alternatives: const [],
        historySummary: VerdictHistorySummary.empty(),
      );
}
