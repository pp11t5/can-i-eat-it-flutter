/// 핵심 퍼널 이벤트 (PRD v1 US-SYS-2: 가입→온보딩완료→첫판정→첫기록→증상응답→리포트열람).
/// name 문자열은 분석 대시보드 키이므로 임의 변경 금지.
enum FunnelEvent {
  signUp('sign_up'),
  onboardingCompleted('onboarding_completed'),
  firstVerdictChecked('first_verdict_checked'),
  firstMealRecorded('first_meal_recorded'),
  symptomResponse('symptom_response'),
  reportViewed('report_viewed');

  const FunnelEvent(this.eventName);
  final String eventName;
}
