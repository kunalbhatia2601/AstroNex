import 'package:flutter/material.dart';
import '../../../../core/config/auth_config.dart';

/// Dark scaffold with background image used by every auth screen.
class AuthScaffold extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthConfig.scaffoldBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image (starry zodiac pattern)
          Opacity(
            opacity: 0.4,
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Optional back button
                if (showBackButton)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: onBack ?? () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AuthConfig.primaryTextColor,
                        size: 20,
                      ),
                    ),
                  ),

                // Screen content
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
