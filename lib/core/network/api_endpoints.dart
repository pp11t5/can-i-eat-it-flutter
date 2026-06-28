/// 서버 API 엔드포인트 경로 상수 (ADR-0007 §3-1 (5)).
///
/// placeholder 를 제거하고 실 경로로 교체했다.
/// provider 치환이 필요한 경로는 정적 메서드로 제공한다.
class ApiEndpoints {
  const ApiEndpoints._();

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  /// 소셜 로그인. `{provider}` 는 [authLogin] 으로 치환.
  static const String _authLoginTemplate = '/auth/{provider}/login';

  /// `POST /auth/{provider}/login`
  static String authLogin(String provider) =>
      _authLoginTemplate.replaceFirst('{provider}', provider);

  /// `POST /auth/refresh`
  static const String authRefresh = '/auth/refresh';

  /// `GET /auth/me`
  static const String authMe = '/auth/me';

  /// `POST /auth/logout`
  static const String authLogout = '/auth/logout';

  /// `DELETE /auth/withdraw`
  static const String authWithdraw = '/auth/withdraw';

  /// 소셜 계정 복구. `{provider}` 는 [authRecover] 로 치환.
  static const String _authRecoverTemplate = '/auth/{provider}/recover';

  /// `POST /auth/{provider}/recover`
  static String authRecover(String provider) =>
      _authRecoverTemplate.replaceFirst('{provider}', provider);

  // ---------------------------------------------------------------------------
  // Gate (온보딩 · 약관)
  // ---------------------------------------------------------------------------

  /// `GET/POST /consent`
  static const String consent = '/consent';

  /// `POST /onboarding`
  static const String onboarding = '/onboarding';

  /// `GET /onboarding/status`
  static const String onboardingStatus = '/onboarding/status';

  // ---------------------------------------------------------------------------
  // Food
  // ---------------------------------------------------------------------------

  /// `GET /foods/search`
  static const String foodsSearch = '/foods/search';

  /// `GET /foods/recent`
  static const String foodsRecent = '/foods/recent';

  /// 최근 검색 항목 삭제. `{foodExternalId}` 는 [foodsRecentItem] 으로 치환.
  static const String _foodsRecentItemTemplate =
      '/foods/recent/{foodExternalId}';

  /// `DELETE /foods/recent/{foodExternalId}`
  static String foodsRecentItem(String foodExternalId) =>
      _foodsRecentItemTemplate.replaceFirst('{foodExternalId}', foodExternalId);

  // ---------------------------------------------------------------------------
  // Food — 판정 (W3-3, judgment 2엔드포인트)
  // ---------------------------------------------------------------------------

  /// `GET /foods/judgment?foodTextInput=`
  ///
  /// baseUrl = https://…/api/v1 이므로 prefix 없이 `/foods/judgment` 사용.
  /// (기존 search/recent와 동일 prefix 규칙 — R1 정합)
  static const String foodsJudgmentByText = '/foods/judgment';

  /// by-id 판정 경로 템플릿. [foodsJudgmentById] 로 치환.
  static const String _foodsJudgmentByIdTemplate =
      '/foods/{foodExternalId}/judgment';

  /// `GET /foods/{foodExternalId}/judgment`
  static String foodsJudgmentById(String foodExternalId) =>
      _foodsJudgmentByIdTemplate.replaceFirst(
          '{foodExternalId}', foodExternalId);

  // ---------------------------------------------------------------------------
  // Meal (신 계약: /meal-records + /timeline)
  // ---------------------------------------------------------------------------

  /// `POST /meal-records` (음식 추가)
  static const String mealRecords = '/meal-records';

  /// `GET /meal-records/{id}` · `DELETE /meal-records/{id}`
  static String mealRecordItem(String id) => '/meal-records/$id';

  /// `GET /meal-records/foods/{foodId}` · `DELETE /meal-records/foods/{foodId}`
  static String mealRecordFood(String foodId) => '/meal-records/foods/$foodId';

  /// `GET /meal-records/candidates`
  static const String mealRecordCandidates = '/meal-records/candidates';

  /// `GET /timeline?date=YYYY-MM-DD`
  static const String timeline = '/timeline';

  /// `GET /timeline/weekly?date=YYYY-MM-DD`
  static const String timelineWeekly = '/timeline/weekly';

  // ---------------------------------------------------------------------------
  // Symptoms
  // ---------------------------------------------------------------------------

  /// `POST /symptoms`
  static const String symptoms = '/symptoms';

  /// `GET /symptoms/{id}` · `PUT /symptoms/{id}` · `DELETE /symptoms/{id}`
  static String symptomItem(String id) => '/symptoms/$id';

  /// `PATCH /symptoms/{id}/memo`
  static String symptomMemo(String id) => '/symptoms/$id/memo';

  // ---------------------------------------------------------------------------
  // Health
  // ---------------------------------------------------------------------------

  /// `GET/POST /health`
  static const String health = '/health';

  // ---------------------------------------------------------------------------
  // FCM (W5 푸시)
  // ---------------------------------------------------------------------------

  /// `POST /fcm/tokens` · `DELETE /fcm/tokens`
  ///
  /// baseUrl = https://…/api/v1 이므로 prefix 없이 `/fcm/tokens` 사용.
  static const String fcmTokens = '/fcm/tokens';

  // ---------------------------------------------------------------------------
  // Notifications (W5-6)
  // ---------------------------------------------------------------------------

  /// `GET /notifications/settings`
  static const String notificationSettings = '/notifications/settings';

  /// `PATCH /notifications/settings/toggle`
  static const String notificationSettingsToggle =
      '/notifications/settings/toggle';

  /// `PATCH /notifications/settings/daily-time`
  static const String notificationSettingsDailyTime =
      '/notifications/settings/daily-time';
}
