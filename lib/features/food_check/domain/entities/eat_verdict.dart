import 'package:freezed_annotation/freezed_annotation.dart';

part 'eat_verdict.freezed.dart';

// ---------------------------------------------------------------------------
// VerdictLevel enum — 신호등 판정 4상태
// ---------------------------------------------------------------------------

/// 신호등 판정 4상태. 서버 grade(RECOMMEND|CAUTION|RISK|UNKNOWN)와 1:1 정합.
///
/// - [recommend]: 권장 — 섭취해도 무방한 식품.
/// - [caution]: 주의 — 조건부 섭취 또는 소량 섭취 권장.
/// - [risk]: 위험 — 섭취를 피해야 하는 식품. (서버 RISK 정합, 구 danger 리네이밍)
/// - [unknown]: 확인어려움 — 근거 부족·DB 미매칭. 단정 금지.
///
/// ⚠️ 색상 토큰 [AppColors.verdictDanger] 는 유지(무관 화면 회귀 차단 — ADR-0003).
enum VerdictLevel { recommend, caution, risk, unknown }

/// [VerdictLevel] 한국어 라벨 확장.
extension VerdictLevelLabel on VerdictLevel {
  /// 화면 표시용 한국어 라벨.
  String get label => switch (this) {
        VerdictLevel.recommend => '권장',
        VerdictLevel.caution => '주의',
        VerdictLevel.risk => '위험',
        VerdictLevel.unknown => '확인어려움',
      };
}

/// 서버 grade 문자열 ↔ [VerdictLevel] 변환. DTO·테스트 공용.
extension VerdictLevelGrade on VerdictLevel {
  /// 서버 [grade] 문자열을 [VerdictLevel] 로 변환한다.
  ///
  /// 미지 grade 는 [VerdictLevel.unknown] 으로 폴백 — 신규 grade 추가 시
  /// 앱이 위험을 "권장"으로 오판하지 않도록 하는 안전 기본값.
  static VerdictLevel fromGrade(String grade) => switch (grade) {
        'RECOMMEND' => VerdictLevel.recommend,
        'CAUTION' => VerdictLevel.caution,
        'RISK' => VerdictLevel.risk,
        'UNKNOWN' => VerdictLevel.unknown,
        _ => VerdictLevel.unknown,
      };

  /// 도메인 [VerdictLevel] 을 서버 grade 문자열로 변환한다 (POST /meals 등).
  ///
  /// 서버 계약 고정값: RECOMMEND | CAUTION | RISK | UNKNOWN.
  /// `.name.toUpperCase()` 대신 명시 switch 사용 — 계약 드리프트 방지.
  String toServerGrade() => switch (this) {
        VerdictLevel.recommend => 'RECOMMEND',
        VerdictLevel.caution => 'CAUTION',
        VerdictLevel.risk => 'RISK',
        VerdictLevel.unknown => 'UNKNOWN',
      };
}

// ---------------------------------------------------------------------------
// 서브 엔티티
// ---------------------------------------------------------------------------

/// 분석 항목 (JudgmentItemDTO 대응).
///
/// [emphasis]: 강조 문구 (예: "트리거/증상 분석")
/// [body]: 본문 설명
@freezed
abstract class VerdictItem with _$VerdictItem {
  const factory VerdictItem({
    required String emphasis,
    required String body,
  }) = _VerdictItem;
}

/// 섭취 기록 단건 (StateRecordDTO 대응).
@freezed
abstract class VerdictStateRecord with _$VerdictStateRecord {
  const factory VerdictStateRecord({
    required String label,
    required String date,    // "YYYY-MM-DD" 문자열 그대로 (표시 전용)
    required String timing,
  }) = _VerdictStateRecord;
}

/// 연관 섭취 기록 요약 (stateRecords 대응).
///
/// 기록 없으면 [total]=0, [records]=빈배열.
/// const 생성자를 통해 기본값으로 사용 가능: `const VerdictStateRecords()`.
@freezed
abstract class VerdictStateRecords with _$VerdictStateRecords {
  const factory VerdictStateRecords({
    @Default(0) int total,
    @Default(<VerdictStateRecord>[]) List<VerdictStateRecord> records,
  }) = _VerdictStateRecords;
}

/// 대체 음식 (substitutes 대응).
///
/// RECOMMEND·UNKNOWN·by-text 에서는 빈배열.
@freezed
abstract class VerdictSubstitute with _$VerdictSubstitute {
  const factory VerdictSubstitute({
    required String foodExternalId,
    required String name,
  }) = _VerdictSubstitute;
}

// ---------------------------------------------------------------------------
// EatVerdict 엔티티 (W3-3, ADR-0003)
// ---------------------------------------------------------------------------

/// 신호등 판정 결과 엔티티.
///
/// 서버 judgment 계약(JudgmentResponseDTO·TextJudgmentResponseDTO)에 충실 정합.
///
/// 화면 구조:
/// - HeroSection: [personalTitle] + 신호등 배지 ([level])
/// - PersonalAnalysis: [items] 2개 (트리거/증상, 알레르기/복용약)
/// - Substitutes: [substitutes] (RECOMMEND·UNKNOWN·by-text 에서 빈배열)
/// - StateRecords: [stateRecords] (기록 없으면 total=0)
///
/// [unknown] 상태는 분석실패가 아닌 **성공 응답** (AsyncData) → VerdictUnknownScreen.
/// 에러(FOOD400_1·FOOD404_1·통신오류)는 AsyncError → 분석실패 화면.
@freezed
abstract class EatVerdict with _$EatVerdict {
  const factory EatVerdict({
    /// 판정 신호 (grade 매핑).
    required VerdictLevel level,

    /// 음식명 (foodName).
    required String foodName,

    /// 개인화 헤드라인 (personalTitle) — HeroSection 텍스트.
    @Default('') String personalTitle,

    /// 분석 항목 2종.
    /// [0] = 트리거/증상 분석, [1] = 알레르기/복용약 분석.
    @Default(<VerdictItem>[]) List<VerdictItem> items,

    /// 연관 섭취 기록 요약. 기록 없으면 VerdictStateRecords(total:0).
    @Default(VerdictStateRecords()) VerdictStateRecords stateRecords,

    /// 대체 음식. RECOMMEND·UNKNOWN·by-text 에서 빈배열.
    @Default(<VerdictSubstitute>[]) List<VerdictSubstitute> substitutes,

    /// 서버 음식 식별자. by-text 판정이면 null.
    String? foodExternalId,

    /// 음식 분류. by-text 판정이면 null.
    String? category,
  }) = _EatVerdict;

  // ---------------------------------------------------------------------------
  // 4상태 대표 샘플 named factory (Mock·테스트·골든 테스트용)
  // ---------------------------------------------------------------------------

  /// 권장 판정 샘플.
  ///
  /// substitutes 빈배열 (RECOMMEND 규약).
  factory EatVerdict.recommend({String foodName = '두부'}) => EatVerdict(
        level: VerdictLevel.recommend,
        foodName: foodName,
        personalTitle: '$foodName, 안심하고 드세요',
        items: const [
          VerdictItem(
            emphasis: '트리거/증상 분석',
            body: '역류 트리거에 해당하지 않아요.',
          ),
          VerdictItem(
            emphasis: '알레르기/복용약 분석',
            body: '알레르기·복용약 충돌이 없어요.',
          ),
        ],
        substitutes: const [],
        stateRecords: const VerdictStateRecords(),
      );

  /// 주의 판정 샘플.
  ///
  /// substitutes 포함.
  factory EatVerdict.caution({String foodName = '된장찌개'}) => EatVerdict(
        level: VerdictLevel.caution,
        foodName: foodName,
        personalTitle: '$foodName, 소량만 드세요',
        items: const [
          VerdictItem(
            emphasis: '트리거/증상 분석',
            body: '나트륨 함량이 높아 위산 역류를 악화할 수 있어요.',
          ),
          VerdictItem(
            emphasis: '알레르기/복용약 분석',
            body: '알레르기·복용약 충돌은 없어요.',
          ),
        ],
        substitutes: const [
          VerdictSubstitute(foodExternalId: 'sub-1', name: '저염 된장찌개'),
          VerdictSubstitute(foodExternalId: 'sub-2', name: '두부국'),
        ],
        stateRecords: const VerdictStateRecords(
          total: 2,
          records: [
            VerdictStateRecord(
              label: '속쓰림',
              date: '2026-06-10',
              timing: '식후 30분',
            ),
          ],
        ),
      );

  /// 위험 판정 샘플 (구 danger → risk 리네이밍).
  ///
  /// substitutes 포함.
  factory EatVerdict.risk({String foodName = '커피'}) => EatVerdict(
        level: VerdictLevel.risk,
        foodName: foodName,
        personalTitle: '$foodName, 지금은 피하는 게 좋아요',
        items: const [
          VerdictItem(
            emphasis: '트리거/증상 분석',
            body: '카페인이 위산 분비를 촉진해 증상을 악화시켜요.',
          ),
          VerdictItem(
            emphasis: '알레르기/복용약 분석',
            body: '복용약과의 직접 충돌은 없어요.',
          ),
        ],
        substitutes: const [
          VerdictSubstitute(foodExternalId: 'sub-1', name: '디카페인 커피'),
          VerdictSubstitute(foodExternalId: 'sub-2', name: '보리차'),
        ],
        stateRecords: const VerdictStateRecords(
          total: 5,
          records: [
            VerdictStateRecord(
              label: '속쓰림',
              date: '2026-06-10',
              timing: '식후 30분',
            ),
          ],
        ),
      );

  /// 확인어려움 판정 샘플.
  ///
  /// items·substitutes 빈배열, personalTitle 안내 톤.
  /// ⚠️ 이것은 성공 응답 (AsyncData) 이다 — 분석실패(AsyncError)와 구별.
  factory EatVerdict.unknown({String foodName = '정체불명음식'}) => EatVerdict(
        level: VerdictLevel.unknown,
        foodName: foodName,
        personalTitle: '$foodName, 확인이 어려워요',
        items: const [],
        substitutes: const [],
        stateRecords: const VerdictStateRecords(),
      );
}
