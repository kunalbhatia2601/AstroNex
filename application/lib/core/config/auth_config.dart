import 'package:flutter/material.dart';

/// Centralised configuration for the entire auth / registration flow.
///
/// Edit values here and every auth screen picks them up automatically.
class AuthConfig {
  AuthConfig._();

  // ─── Flow order ──────────────────────────────────────────────
  /// Set to `false` to skip a step entirely.
  static const bool enableLanguageSelection = true;
  static const bool enableDobScreen = true;
  static const bool enablePlaceOfBirth = true;

  // ─── OTP ─────────────────────────────────────────────────────
  static const int otpLength = 4;
  static const int otpTimerSeconds = 58;

  // ─── Languages ───────────────────────────────────────────────
  static const List<String> supportedLanguages = [
    'English',
    'Hindi',
    'Kannada',
    'Tamil',
    'Telugu',
    'Malayalam',
  ];
  static const String defaultLanguage = 'English';

  // ─── Colors (auth-specific) ──────────────────────────────────
  static const Color scaffoldBg = Color(0xFF0D0D1A);
  static const Color cardBg = Color(0xFF1A1A2E);
  static const Color inputFillColor = Color(0xFF1E1E32);
  static const Color inputBorderColor = Color(0xFF2E2E45);
  static const Color accentColor = Color(0xFFFFC107); // amber / yellow
  static const Color accentTextColor = Color(0xFF1A1A2E); // dark text on amber
  static const Color primaryTextColor = Colors.white;
  static const Color secondaryTextColor = Color(0xFFB0B0B0);
  static const Color hintTextColor = Color(0xFF6E6E8A);
  static const Color dividerColor = Color(0xFF2E2E45);
  static const Color linkColor = Color(0xFFFFC107);

  // ─── Border radius ───────────────────────────────────────────
  static const double inputRadius = 12.0;
  static const double buttonRadius = 30.0;
  static const double chipRadius = 20.0;
  static const double dialogRadius = 20.0;
}
