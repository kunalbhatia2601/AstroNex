import 'package:flutter/material.dart';
import '../../../../core/config/auth_config.dart';
import '../../../../core/constants/app_constants.dart';

/// Dark scaffold with background image + half-visible, infinitely
/// rotating zodiac vector at the top. Used by every auth screen.
class AuthScaffold extends StatefulWidget {
  final Widget child;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AuthScaffold({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  State<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends State<AuthScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationCtrl;

  @override
  void initState() {
    super.initState();
    _rotationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60), // slow, continuous spin
    )..repeat(); // infinite loop
  }

  @override
  void dispose() {
    _rotationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Vector size — wider than the screen so it bleeds off edges
    final vectorSize = screenWidth * 1.15;

    return Scaffold(
      backgroundColor: AuthConfig.scaffoldBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background starry image ──────────────────────────
          Opacity(
            opacity: 0.4,
            child: Image.asset(
              AppConstants.background,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // ── Rotating zodiac vector (half visible at top) ─────
          Positioned(
            top: -(vectorSize * 0.50), // push ~50 % above screen edge
            left: (screenWidth - vectorSize) / 2, // centre horizontally
            child: RotationTransition(
              turns: _rotationCtrl,
              child: Opacity(
                opacity: 0.55,
                child: Image.asset(
                  AppConstants.zodiacVector,
                  width: vectorSize,
                  height: vectorSize,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                // Optional back button
                if (widget.showBackButton)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: widget.onBack ??
                          () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AuthConfig.primaryTextColor,
                        size: 20,
                      ),
                    ),
                  ),

                // Screen content
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
