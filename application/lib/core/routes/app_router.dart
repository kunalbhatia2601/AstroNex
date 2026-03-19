import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/app_config.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/details_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/language_screen.dart';
import '../../features/auth/presentation/screens/dob_screen.dart';
import '../../features/auth/presentation/screens/place_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/horoscope/presentation/screens/horoscope_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/zodiac/presentation/screens/zodiac_list_screen.dart';
import '../../features/zodiac/presentation/screens/zodiac_detail_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../widgets/main_scaffold.dart';

/// ─── Route paths ──────────────────────────────────────────────
class AppRoutes {
  AppRoutes._();

  // Onboarding
  static const String onboarding = '/onboarding';

  // Auth flow
  static const String authLogin = '/auth/login';
  static const String authDetails = '/auth/details';
  static const String authOtp = '/auth/otp';
  static const String authLanguage = '/auth/language';
  static const String authDob = '/auth/dob';
  static const String authPlace = '/auth/place';

  // Main app
  static const String home = '/';
  static const String horoscope = '/horoscope';
  static const String zodiac = '/zodiac';
  static const String zodiacDetail = '/zodiac/:sign';
  static const String birthChart = '/birth-chart';
  static const String settings = '/settings';
}

/// ─── Initial route logic ──────────────────────────────────────
String _resolveInitialRoute() {
  if (AppConfig.shouldShowOnboarding) return AppRoutes.onboarding;
  // TODO: check if user is logged in → AppRoutes.home
  // For now, after onboarding always land on login
  return AppRoutes.authLogin;
}

/// ─── Router ───────────────────────────────────────────────────
final GoRouter appRouter = GoRouter(
  initialLocation: _resolveInitialRoute(),
  debugLogDiagnostics: true,
  routes: [
    // ── Onboarding ──────────────────────────────────────────
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // ── Auth flow ───────────────────────────────────────────
    GoRoute(
      path: AppRoutes.authLogin,
      name: 'authLogin',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.authDetails,
      name: 'authDetails',
      builder: (context, state) => const DetailsScreen(),
    ),
    GoRoute(
      path: AppRoutes.authOtp,
      name: 'authOtp',
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: AppRoutes.authLanguage,
      name: 'authLanguage',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: AppRoutes.authDob,
      name: 'authDob',
      builder: (context, state) => const DobScreen(),
    ),
    GoRoute(
      path: AppRoutes.authPlace,
      name: 'authPlace',
      builder: (context, state) => const PlaceScreen(),
    ),

    // ── Main app (bottom navigation shell) ──────────────────
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.horoscope,
              name: 'horoscope',
              builder: (context, state) => const HoroscopeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.zodiac,
              name: 'zodiac',
              builder: (context, state) => const ZodiacListScreen(),
              routes: [
                GoRoute(
                  path: ':sign',
                  name: 'zodiacDetail',
                  builder: (context, state) {
                    final sign = state.pathParameters['sign'] ?? '';
                    return ZodiacDetailScreen(sign: sign);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              name: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),

    // ── Birth Chart (full screen) ───────────────────────────
    GoRoute(
      path: AppRoutes.birthChart,
      name: 'birthChart',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Birth Chart Screen')),
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Page not found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(state.uri.toString()),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);
