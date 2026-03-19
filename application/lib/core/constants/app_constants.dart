/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'AstroNex';
  static const String appVersion = '1.0.0';

  // Assets
  static const String logo = 'assets/images/logo.png';
  static const String background = 'assets/images/background.png';
  static const String zodiacVector = 'assets/images/ZodiacVector.png';

  // API
  static const String baseUrl = 'https://api.astrology.example.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String userDataKey = 'user_data';
  static const String onboardingKey = 'onboarding_complete';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Pagination
  static const int defaultPageSize = 20;
}

/// API Endpoints
class ApiEndpoints {
  ApiEndpoints._();

  static const String horoscopes = '/horoscopes';
  static const String zodiacSigns = '/zodiac-signs';
  static const String birthChart = '/birth-chart';
  static const String dailyHoroscope = '/horoscopes/daily';
  static const String weeklyHoroscope = '/horoscopes/weekly';
  static const String monthlyHoroscope = '/horoscopes/monthly';
}
