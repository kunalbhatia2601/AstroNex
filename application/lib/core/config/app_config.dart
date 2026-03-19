import 'package:shared_preferences/shared_preferences.dart';

/// Centralized application configuration.
///
/// Single source of truth for all feature flags, display settings,
/// and persistent preferences across the app. Easy to maintain —
/// just add a new field + getter/setter pair here and the whole
/// app picks it up.
class AppConfig {
  AppConfig._();

  static late SharedPreferences _prefs;

  // ─── Storage keys ────────────────────────────────────────────
  static const String _keyOnboardingSeen = 'onboarding_seen';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyReminderTime = 'reminder_time';
  static const String _keySelectedZodiac = 'selected_zodiac';
  static const String _keyLanguage = 'language';

  // ─── Feature flags (change these to tweak behaviour) ─────────
  /// When `true` the onboarding is shown **every** app launch.
  /// When `false` it is shown only the first time.
  static bool alwaysShowOnboarding = true;

  // ─── Initialisation ──────────────────────────────────────────
  /// Call once in `main()` before `runApp`.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  

  // ─── Onboarding ──────────────────────────────────────────────
  /// Whether the user has already completed onboarding.
  static bool get hasSeenOnboarding => _prefs.getBool(_keyOnboardingSeen) ?? false;

  static Future<void> setOnboardingSeen(bool value) =>
      _prefs.setBool(_keyOnboardingSeen, value);

  /// Convenience: should the onboarding screen be displayed right now?
  static bool get shouldShowOnboarding {
    if (alwaysShowOnboarding) return true;
    return !hasSeenOnboarding;
  }

  // ─── Theme ───────────────────────────────────────────────────
  /// Stored as index: 0 = system, 1 = light, 2 = dark.
  static int get themeModeIndex => _prefs.getInt(_keyThemeMode) ?? 0;

  static Future<void> setThemeModeIndex(int index) =>
      _prefs.setInt(_keyThemeMode, index);

  // ─── Notifications ───────────────────────────────────────────
  static bool get notificationsEnabled =>
      _prefs.getBool(_keyNotificationsEnabled) ?? true;

  static Future<void> setNotificationsEnabled(bool value) =>
      _prefs.setBool(_keyNotificationsEnabled, value);

  // ─── Reminder time (stored as "HH:mm") ──────────────────────
  static String get reminderTime => _prefs.getString(_keyReminderTime) ?? '08:00';

  static Future<void> setReminderTime(String value) =>
      _prefs.setString(_keyReminderTime, value);

  // ─── Selected Zodiac ─────────────────────────────────────────
  static String? get selectedZodiac => _prefs.getString(_keySelectedZodiac);

  static Future<void> setSelectedZodiac(String value) =>
      _prefs.setString(_keySelectedZodiac, value);

  // ─── Language ────────────────────────────────────────────────
  static String get language => _prefs.getString(_keyLanguage) ?? 'en';

  static Future<void> setLanguage(String value) =>
      _prefs.setString(_keyLanguage, value);

  // ─── Debug / Reset ───────────────────────────────────────────
  /// Wipe all saved preferences (useful during development).
  static Future<void> resetAll() => _prefs.clear();
}
