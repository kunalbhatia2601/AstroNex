import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/horoscope/presentation/screens/horoscope_screen.dart';
import '../../features/zodiac/presentation/screens/zodiac_list_screen.dart';
import '../../features/zodiac/presentation/screens/zodiac_detail_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../widgets/main_scaffold.dart';

/// Route paths
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String horoscope = '/horoscope';
  static const String zodiac = '/zodiac';
  static const String zodiacDetail = '/zodiac/:sign';
  static const String birthChart = '/birth-chart';
  static const String settings = '/settings';
}

/// Router configuration
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    // Shell route for bottom navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Home branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Horoscope branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.horoscope,
              name: 'horoscope',
              builder: (context, state) => const HoroscopeScreen(),
            ),
          ],
        ),
        // Zodiac branch
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
        // Settings branch
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
    // Birth Chart route (full screen)
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
