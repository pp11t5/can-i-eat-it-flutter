import 'package:flutter_test/flutter_test.dart';

import 'package:can_i_eat_it/features/food_check/data/dtos/judgment_response_dto.dart';
import 'package:can_i_eat_it/features/food_check/domain/entities/eat_verdict.dart';

// ---------------------------------------------------------------------------
// 헬퍼 JSON
// ---------------------------------------------------------------------------

Map<String, dynamic> _stateRecordsJson({
  int total = 0,
  List<Map<String, dynamic>> records = const [],
}) =>
    {'total': total, 'records': records};

Map<String, dynamic> _stateRecordJson({
  String label = '속쓰림',
  String date = '2026-06-10',
  String timing = '식후 30분',
}) =>
    {'label': label, 'date': date, 'timing': timing};

Map<String, dynamic> _itemJson({
  String emphasis = '트리거/증상 분석',
  String body = '역류 트리거에 해당하지 않아요.',
}) =>
    {'emphasis': emphasis, 'body': body};

Map<String, dynamic> _substituteJson({
  String foodExternalId = 'sub-1',
  String name = '디카페인 커피',
}) =>
    {'foodExternalId': foodExternalId, 'name': name};

Map<String, dynamic> _idJudgmentJson({
  String foodExternalId = 'food-ext-1',
  String foodName = '커피',
  String? category = '음료',
  String grade = 'RISK',
  String personalTitle = '커피, 지금은 피하는 게 좋아요',
  List<Map<String, dynamic>>? items,
  Map<String, dynamic>? stateRecords,
  List<Map<String, dynamic>>? substitutes,
}) =>
    {
      'foodExternalId': foodExternalId,
      'foodName': foodName,
      'category': category,
      'grade': grade,
      'personalTitle': personalTitle,
      'items': items ??
          [
            _itemJson(emphasis: '트리거/증상 분석', body: '카페인이 위산 분비를 촉진해요.'),
            _itemJson(emphasis: '알레르기/복용약 분석', body: '복용약 충돌 없어요.'),
          ],
      'stateRecords': stateRecords ?? _stateRecordsJson(),
      'substitutes': substitutes ?? [_substituteJson()],
    };

Map<String, dynamic> _textJudgmentJson({
  String foodName = '두부',
  String grade = 'RECOMMEND',
  String personalTitle = '두부, 안심하고 드세요',
  List<Map<String, dynamic>>? items,
  Map<String, dynamic>? stateRecords,
}) =>
    {
      'foodName': foodName,
      'grade': grade,
      'personalTitle': personalTitle,
      'items': items ??
          [
            _itemJson(emphasis: '트리거/증상 분석', body: '역류 트리거 없어요.'),
            _itemJson(emphasis: '알레르기/복용약 분석', body: '알레르기 없어요.'),
          ],
      'stateRecords': stateRecords ?? _stateRecordsJson(),
    };

// ---------------------------------------------------------------------------
// JudgmentResponseDto (by-id) tests
// ---------------------------------------------------------------------------

void main() {
  group('JudgmentResponseDto.fromJson (by-id)', () {
    test('기본 필드 역직렬화', () {
      final dto = JudgmentResponseDto.fromJson(_idJudgmentJson());

      expect(dto.foodExternalId, 'food-ext-1');
      expect(dto.foodName, '커피');
      expect(dto.category, '음료');
      expect(dto.grade, 'RISK');
      expect(dto.personalTitle, '커피, 지금은 피하는 게 좋아요');
    });

    test('items 2개 역직렬화', () {
      final dto = JudgmentResponseDto.fromJson(_idJudgmentJson());
      expect(dto.items.length, 2);
      expect(dto.items[0].emphasis, '트리거/증상 분석');
      expect(dto.items[1].emphasis, '알레르기/복용약 분석');
    });

    test('stateRecords 역직렬화', () {
      final dto = JudgmentResponseDto.fromJson(
        _idJudgmentJson(
          stateRecords: _stateRecordsJson(
            total: 3,
            records: [_stateRecordJson()],
          ),
        ),
      );
      // stateRecords가 명시적으로 제공된 경우 — non-null 보장
      expect(dto.stateRecords!.total, 3);
      expect(dto.stateRecords!.records.length, 1);
      expect(dto.stateRecords!.records[0].label, '속쓰림');
      expect(dto.stateRecords!.records[0].date, '2026-06-10');
      expect(dto.stateRecords!.records[0].timing, '식후 30분');
    });

    test('substitutes 역직렬화', () {
      final dto = JudgmentResponseDto.fromJson(_idJudgmentJson());
      expect(dto.substitutes.length, 1);
      expect(dto.substitutes[0].foodExternalId, 'sub-1');
      expect(dto.substitutes[0].name, '디카페인 커피');
    });

    test('category null 허용', () {
      final dto = JudgmentResponseDto.fromJson(
        _idJudgmentJson(category: null),
      );
      expect(dto.category, isNull);
    });
  });

  group('JudgmentResponseDto.toEntity (by-id)', () {
    test('grade RISK → VerdictLevel.risk', () {
      final entity = JudgmentResponseDto.fromJson(
        _idJudgmentJson(grade: 'RISK'),
      ).toEntity();
      expect(entity.level, VerdictLevel.risk);
    });

    test('grade RECOMMEND → VerdictLevel.recommend', () {
      final entity = JudgmentResponseDto.fromJson(
        _idJudgmentJson(grade: 'RECOMMEND'),
      ).toEntity();
      expect(entity.level, VerdictLevel.recommend);
    });

    test('grade CAUTION → VerdictLevel.caution', () {
      final entity = JudgmentResponseDto.fromJson(
        _idJudgmentJson(grade: 'CAUTION'),
      ).toEntity();
      expect(entity.level, VerdictLevel.caution);
    });

    test('grade UNKNOWN → VerdictLevel.unknown (성공 응답 — D1, R3)', () {
      final entity = JudgmentResponseDto.fromJson(
        _idJudgmentJson(grade: 'UNKNOWN'),
      ).toEntity();
      // grade=UNKNOWN은 성공 응답(AsyncData 경로) — 절대 에러로 흘리면 안 됨
      expect(entity.level, VerdictLevel.unknown);
    });

    test('미지 grade → VerdictLevel.unknown 폴백 (안전 기본값)', () {
      final entity = JudgmentResponseDto.fromJson(
        _idJudgmentJson(grade: 'NEW_UNKNOWN_GRADE'),
      ).toEntity();
      expect(entity.level, VerdictLevel.unknown);
    });

    test('foodExternalId·category 엔티티에 전달', () {
      final entity = JudgmentResponseDto.fromJson(
        _idJudgmentJson(foodExternalId: 'food-ext-1', category: '음료'),
      ).toEntity();
      expect(entity.foodExternalId, 'food-ext-1');
      expect(entity.category, '음료');
    });

    test('items 2개 매핑', () {
      final entity = JudgmentResponseDto.fromJson(_idJudgmentJson()).toEntity();
      expect(entity.items.length, 2);
      expect(entity.items[0].emphasis, '트리거/증상 분석');
      expect(entity.items[1].emphasis, '알레르기/복용약 분석');
    });

    test('stateRecords total·records 매핑', () {
      final entity = JudgmentResponseDto.fromJson(
        _idJudgmentJson(
          stateRecords: _stateRecordsJson(
            total: 2,
            records: [_stateRecordJson(label: '속쓰림')],
          ),
        ),
      ).toEntity();
      expect(entity.stateRecords.total, 2);
      expect(entity.stateRecords.records.first.label, '속쓰림');
    });

    test('substitutes 매핑', () {
      final entity = JudgmentResponseDto.fromJson(_idJudgmentJson()).toEntity();
      expect(entity.substitutes.length, 1);
      expect(entity.substitutes[0].name, '디카페인 커피');
    });
  });

  // ---------------------------------------------------------------------------
  // TextJudgmentResponseDto (by-text) tests
  // ---------------------------------------------------------------------------

  group('TextJudgmentResponseDto.fromJson (by-text)', () {
    test('기본 필드 역직렬화', () {
      final dto = TextJudgmentResponseDto.fromJson(_textJudgmentJson());
      expect(dto.foodName, '두부');
      expect(dto.grade, 'RECOMMEND');
      expect(dto.personalTitle, '두부, 안심하고 드세요');
    });

    test('items 2개 역직렬화', () {
      final dto = TextJudgmentResponseDto.fromJson(_textJudgmentJson());
      expect(dto.items.length, 2);
    });
  });

  // ---------------------------------------------------------------------------
  // S1: stateRecords 누락/null 방어 (grade=UNKNOWN 오분류 차단)
  // ---------------------------------------------------------------------------

  group('S1 stateRecords 누락 방어 (by-id)', () {
    /// stateRecords 키 자체가 없는 UNKNOWN 응답 → TypeError 없이 성공해야 한다.
    test('stateRecords 키 없는 UNKNOWN → fromJson 예외 없음', () {
      final json = {
        'foodExternalId': 'food-ext-unknown',
        'foodName': '정체불명음식',
        'grade': 'UNKNOWN',
        'personalTitle': '정체불명음식, 확인이 어려워요',
        'items': <Map<String, dynamic>>[],
        'substitutes': <Map<String, dynamic>>[],
        // stateRecords 키 의도적 누락
      };
      expect(() => JudgmentResponseDto.fromJson(json), returnsNormally);
    });

    test('stateRecords 키 없는 UNKNOWN → toEntity level==unknown, stateRecords.total==0', () {
      final json = {
        'foodExternalId': 'food-ext-unknown',
        'foodName': '정체불명음식',
        'grade': 'UNKNOWN',
        'personalTitle': '정체불명음식, 확인이 어려워요',
        'items': <Map<String, dynamic>>[],
        'substitutes': <Map<String, dynamic>>[],
        // stateRecords 키 의도적 누락
      };
      final entity = JudgmentResponseDto.fromJson(json).toEntity();
      expect(entity.level, VerdictLevel.unknown);
      expect(entity.stateRecords.total, 0);
      expect(entity.stateRecords.records, isEmpty);
    });

    test('stateRecords null 값 → fromJson 예외 없음', () {
      final json = {
        'foodExternalId': 'food-ext-unknown',
        'foodName': '정체불명음식',
        'grade': 'UNKNOWN',
        'personalTitle': '정체불명음식, 확인이 어려워요',
        'items': <Map<String, dynamic>>[],
        'stateRecords': null,
        'substitutes': <Map<String, dynamic>>[],
      };
      expect(() => JudgmentResponseDto.fromJson(json), returnsNormally);
    });

    test('stateRecords null 값 → toEntity stateRecords 빈 폴백', () {
      final json = {
        'foodExternalId': 'food-ext-unknown',
        'foodName': '정체불명음식',
        'grade': 'UNKNOWN',
        'personalTitle': '정체불명음식, 확인이 어려워요',
        'items': <Map<String, dynamic>>[],
        'stateRecords': null,
        'substitutes': <Map<String, dynamic>>[],
      };
      final entity = JudgmentResponseDto.fromJson(json).toEntity();
      expect(entity.stateRecords.total, 0);
      expect(entity.stateRecords.records, isEmpty);
    });
  });

  group('S1 stateRecords 누락 방어 (by-text)', () {
    test('stateRecords 키 없는 UNKNOWN → fromJson 예외 없음', () {
      final json = {
        'foodName': '정체불명음식',
        'grade': 'UNKNOWN',
        'personalTitle': '정체불명음식, 확인이 어려워요',
        'items': <Map<String, dynamic>>[],
        // stateRecords 키 의도적 누락
      };
      expect(() => TextJudgmentResponseDto.fromJson(json), returnsNormally);
    });

    test('stateRecords 키 없는 UNKNOWN → toEntity level==unknown, stateRecords 빈 폴백', () {
      final json = {
        'foodName': '정체불명음식',
        'grade': 'UNKNOWN',
        'personalTitle': '정체불명음식, 확인이 어려워요',
        'items': <Map<String, dynamic>>[],
        // stateRecords 키 의도적 누락
      };
      final entity = TextJudgmentResponseDto.fromJson(json).toEntity();
      expect(entity.level, VerdictLevel.unknown);
      expect(entity.stateRecords.total, 0);
      expect(entity.stateRecords.records, isEmpty);
    });

    test('stateRecords null 값 → toEntity 빈 폴백', () {
      final json = {
        'foodName': '정체불명음식',
        'grade': 'UNKNOWN',
        'personalTitle': '정체불명음식, 확인이 어려워요',
        'items': <Map<String, dynamic>>[],
        'stateRecords': null,
      };
      final entity = TextJudgmentResponseDto.fromJson(json).toEntity();
      expect(entity.stateRecords.total, 0);
      expect(entity.stateRecords.records, isEmpty);
    });
  });

  group('TextJudgmentResponseDto.toEntity (by-text)', () {
    test('grade RECOMMEND → VerdictLevel.recommend', () {
      final entity =
          TextJudgmentResponseDto.fromJson(_textJudgmentJson()).toEntity();
      expect(entity.level, VerdictLevel.recommend);
    });

    test('by-text 규약: foodExternalId null', () {
      final entity =
          TextJudgmentResponseDto.fromJson(_textJudgmentJson()).toEntity();
      expect(entity.foodExternalId, isNull);
    });

    test('by-text 규약: category null', () {
      final entity =
          TextJudgmentResponseDto.fromJson(_textJudgmentJson()).toEntity();
      expect(entity.category, isNull);
    });

    test('by-text 규약: substitutes 항상 빈배열', () {
      final entity =
          TextJudgmentResponseDto.fromJson(_textJudgmentJson()).toEntity();
      // by-text 응답은 서버가 substitutes를 줘도 강제 빈배열 처리
      expect(entity.substitutes, isEmpty);
    });

    test('stateRecords total=0 이면 records 빈배열', () {
      final entity =
          TextJudgmentResponseDto.fromJson(_textJudgmentJson()).toEntity();
      expect(entity.stateRecords.total, 0);
      expect(entity.stateRecords.records, isEmpty);
    });

    test('grade UNKNOWN → VerdictLevel.unknown (성공 응답 — D1)', () {
      final entity = TextJudgmentResponseDto.fromJson(
        _textJudgmentJson(grade: 'UNKNOWN'),
      ).toEntity();
      expect(entity.level, VerdictLevel.unknown);
    });

    test('미지 grade → VerdictLevel.unknown 폴백', () {
      final entity = TextJudgmentResponseDto.fromJson(
        _textJudgmentJson(grade: 'FUTURE_GRADE'),
      ).toEntity();
      expect(entity.level, VerdictLevel.unknown);
    });
  });
}
