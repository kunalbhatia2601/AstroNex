import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/auth_config.dart';
import '../../../../core/routes/app_router.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_widgets.dart';

/// Screen 4 – Choose language (shown as a centred card / dialog style).
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selected = AuthConfig.defaultLanguage;

  void _onApply() async {
    await AppConfig.setLanguage(_selected);
    if (!mounted) return;
    if (AuthConfig.enableDobScreen) {
      context.push(AppRoutes.authDob);
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AuthConfig.dialogRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.close, size: 22, color: Colors.black54),
                  ),
                ),

                Text(
                  'Choose Language',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You can change language later',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),

                const SizedBox(height: 20),

                // Language chips
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: AuthConfig.supportedLanguages.map((lang) {
                    final isActive = _selected == lang;
                    return GestureDetector(
                      onTap: () => setState(() => _selected = lang),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AuthConfig.accentColor
                              : Colors.grey.shade100,
                          borderRadius:
                              BorderRadius.circular(AuthConfig.chipRadius),
                          border: Border.all(
                            color: isActive
                                ? AuthConfig.accentColor
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          lang,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w400,
                            color: isActive
                                ? AuthConfig.accentTextColor
                                : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 28),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _onApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AuthConfig.accentColor,
                      foregroundColor: AuthConfig.accentTextColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AuthConfig.buttonRadius),
                      ),
                    ),
                    child: Text(
                      'Apply',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
