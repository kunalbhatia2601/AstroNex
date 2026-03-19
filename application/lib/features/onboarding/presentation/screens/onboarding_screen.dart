import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/onboarding_config.dart';
import '../../../../core/routes/app_router.dart';
import '../widgets/onboarding_page.dart';

/// Full-screen onboarding flow.
///
/// Swipeable pages driven entirely by [OnboardingConfig.pages].
/// On the last page the button says "Get Started" and navigates
/// to the home screen, marking onboarding as complete in [AppConfig].
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Ensure status bar icons are light on the dark backgrounds
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < OnboardingConfig.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    await AppConfig.setOnboardingSeen(true);
    if (mounted) {
      context.go(AppRoutes.authLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = OnboardingConfig.pages;

    return Scaffold(
      body: Stack(
        children: [
          // Swipeable pages
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return OnboardingPage(
                data: pages[index],
                currentIndex: _currentPage,
                totalPages: pages.length,
                onNext: _onNext,
              );
            },
          ),

          // Skip button (top-right) — hidden on last page
          if (_currentPage < pages.length - 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 20,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white.withAlpha(180),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
