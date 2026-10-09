/// GA 키. [eventName] 문자열은 대시보드 키이므로 임의 변경 금지.
///
/// [firstVerdictChecked]는 판정 성공마다, [firstMealRecorded]는 신규 식사
/// 저장마다 보낸다.
/// 계정당 첫 횟수는 [accountFirstVerdictChecked], [accountFirstMealRecorded].
enum FunnelEvent {
  signUp('sign_up'),
  onboardingCompleted('onboarding_completed'),
  firstVerdictChecked('first_verdict_checked'),
  firstMealRecorded('first_meal_recorded'),
  accountFirstVerdictChecked('account_first_verdict_checked'),
  accountFirstMealRecorded('account_first_meal_recorded'),
  symptomResponse('symptom_response'),
  reportViewed('report_viewed');

  const FunnelEvent(this.eventName);
  final String eventName;
}

/// 퍼널 밖의 계측 키. 문자열은 대시보드 키이므로 임의 변경 금지.
enum AnalyticsEvent {
  searchScreenViewed('search_screen_viewed'),
  mealRecordFailed('meal_record_failed');

  const AnalyticsEvent(this.eventName);
  final String eventName;
}
