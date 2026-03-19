import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/onboarding_config.dart';

/// A single page inside the onboarding PageView.
///
/// Renders a full-bleed background image overlaid with a dark-to-
/// magenta gradient, large title, subtitle, and an animated dot
/// indicator + "Next" button at the bottom.
class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Background image ──────────────────────────────────
        if (data.backgroundImage != null)
          Image.asset(
            data.backgroundImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

        // ── Gradient overlay (driven by config per page) ─────
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: data.gradientColors,
              stops: data.gradientStops,
            ),
          ),
        ),

        // ── Content ───────────────────────────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 4),

                // Title — Poppins Bold 50px (from Figma spec)
                Text(
                  data.title,
                  style: GoogleFonts.poppins(
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 14),

                // Subtitle
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withAlpha(200),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 20),

                // Dot indicators
                _DotIndicator(
                  currentIndex: currentIndex,
                  totalPages: totalPages,
                ),

                const Spacer(flex: 2),

                // "Next" / "Get Started" button
                Center(
                  child: SizedBox(
                    width: size.width * 0.45,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withAlpha(50),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: Colors.white.withAlpha(60),
                          ),
                        ),
                      ),
                      child: Text(
                        currentIndex == totalPages - 1 ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated row of small dots showing the current page.
class _DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalPages;

  const _DotIndicator({
    required this.currentIndex,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalPages, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(right: 6),
          width: isActive ? 24 : 8,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? const Color(0xFFFFC107) // amber/gold active dot
                : Colors.white.withAlpha(120),
          ),
        );
      }),
    );
  }
}
