/// 마케팅 정보 수신 동의 저장소 인터페이스.
///
/// 앱 알림(식후·식단 기록·주간 리포트)은 OS 알림 권한으로만 제어하므로
/// 여기서 다루지 않는다(#261).
abstract interface class NotificationRepository {
  /// GET /notifications/settings 의 `marketingEnabled`.
  Future<bool> fetchMarketingEnabled();

  /// PATCH /consent/marketing/toggle — 서버가 현재 값을 뒤집고(flip)
  /// 실제 저장된 동의 값을 돌려준다.
  Future<bool> toggleMarketingConsent();
}
