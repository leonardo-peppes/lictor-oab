// lib/core/constants/app_constants.dart

class AppConstants {
  // App Info
  static const String appName = 'LICTOR';
  static const String tagline = 'PERFORMANCE JURÍDICA';
  static const String version = '1.0.0';

  // Free plan limits
  static const int dailyQuestionLimit = 10;

  // Animation durations
  static const Duration animShort = Duration(milliseconds: 150);
  static const Duration animMedium = Duration(milliseconds: 250);
  static const Duration animLong = Duration(milliseconds: 400);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border radius
  static const double radiusS = 6.0;
  static const double radiusM = 10.0;
  static const double radiusL = 14.0;
  static const double radiusXL = 20.0;

  // Premium pricing
  static const String priceMonthly = 'R\$ 49,90/mês';
  static const String priceYearly = 'R\$ 397/ano';
  static const String priceYearlyMonthly = '~R\$ 33/mês';

  // Routes
  static const String routeSplash = '/';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeSignup = '/signup';
  static const String routeDashboard = '/dashboard';
  static const String routeTraining = '/training';
  static const String routeExplanation = '/explanation';
  static const String routeSimulation = '/simulation';
  static const String routeSimulationResult = '/simulation/result';
  static const String routeStats = '/stats';
  static const String routePremium = '/premium';

  // SharedPreferences keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyIsSubscriber = 'is_subscriber';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyDailyQuestionCount = 'daily_question_count';
  static const String keyDailyQuestionDate = 'daily_question_date';
  static const String keyTotalAnswered = 'total_answered';
  static const String keyTotalCorrect = 'total_correct';
}
