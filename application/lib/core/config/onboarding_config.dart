import 'package:flutter/material.dart';

/// Data class for a single onboarding page.
class OnboardingPageData {
  final String title;
  final String subtitle;
  final String? backgroundImage;
  final List<Color> gradientColors;
  final List<double> gradientStops;

  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    this.backgroundImage,
    this.gradientColors = _defaultGradientColors,
    this.gradientStops = _defaultGradientStops,
  });

  // ─── Default gradient (shared across pages) ──────────────────
  static const List<Color> _defaultGradientColors = [
    Colors.transparent,
    Color(0xCC000000),  // 80% black
    Color(0xDD1A0020),  // deep purple-black
    Color(0xFF3D0842),  // magenta-dark
    Color(0xFF6B1058),  // magenta
  ];

  static const List<double> _defaultGradientStops = [
    0.0,
    0.35,
    0.55,
    0.75,
    1.0,
  ];
}

/// ─── All onboarding content lives here ─────────────────────────
/// Edit this list to add / remove / reorder pages — the UI adapts
/// automatically (dots, swipe count, etc.).
///
/// To customise a single page's gradient, just pass `gradientColors`
/// and `gradientStops` — otherwise it uses the shared defaults above.
class OnboardingConfig {
  OnboardingConfig._();

  static const List<OnboardingPageData> pages = [
    OnboardingPageData(
      title: 'Instant\nAstrology\nGuidance',
      subtitle: 'Clarity for everyday life',
      backgroundImage: 'assets/images/background.png',
      gradientColors: [
        Colors.transparent, 
        Colors.transparent,
      ],
      gradientStops: [0.0, 1.0],
    ),
    OnboardingPageData(
      title: 'Book Pooja\nin Minutes',
      subtitle: 'Sacred rituals performed by verified pandits, booked instantly from your phone',
      backgroundImage: 'assets/images/onboarding/screen2.png',
      gradientColors: [
        Colors.transparent,
        Color(0xCC000000),  // 80% black
      ],
      gradientStops: [0.0, 1.0],
    ),
    OnboardingPageData(
      title: 'Talk to\nVerified\nExperts',
      subtitle: 'Elite training programs and personalized coaching.',
      backgroundImage: 'assets/images/onboarding/screen3.png',
      gradientColors: [
        Colors.transparent,
        Color(0xCC000000),  // 80% black
      ],
      gradientStops: [0.0, 1.0],
    ),
  ];
}
