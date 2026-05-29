import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_agreement.freezed.dart';

/// 약관 동의 이력 엔티티.
///
/// [allRequiredAgreed]: 필수 항목 3종(서비스 이용약관·개인정보·민감정보) 모두 동의 여부.
@freezed
abstract class TermsAgreement with _$TermsAgreement {
  const TermsAgreement._();

  const factory TermsAgreement({
    required String version,
    required DateTime agreedAt,
    required bool termsOfService,
    required bool privacy,
    required bool sensitiveInfo,
    @Default(false) bool marketing,
  }) = _TermsAgreement;

  /// 필수 항목(서비스 이용약관·개인정보 수집·민감정보 수집) 전체 동의 여부.
  bool get allRequiredAgreed => termsOfService && privacy && sensitiveInfo;
}
