import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/auth_config.dart';

// ═══════════════════════════════════════════════════════════════
//  Amber primary button (Continue, Get OTP, Verify, Next …)
// ═══════════════════════════════════════════════════════════════
class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthConfig.accentColor,
          foregroundColor: AuthConfig.accentTextColor,
          disabledBackgroundColor: AuthConfig.accentColor.withAlpha(120),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthConfig.buttonRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AuthConfig.accentTextColor,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Outlined / secondary button (Continue with Email Id …)
// ═══════════════════════════════════════════════════════════════
class AuthSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AuthSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AuthConfig.primaryTextColor,
          side: BorderSide(color: AuthConfig.accentColor.withAlpha(150)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthConfig.buttonRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: AuthConfig.accentColor),
              const SizedBox(width: 10),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  Dark themed text field
// ═══════════════════════════════════════════════════════════════
class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String? errorText;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onTap,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AuthConfig.secondaryTextColor,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          onChanged: onChanged,
          onTap: onTap,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: AuthConfig.primaryTextColor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 15,
              color: AuthConfig.hintTextColor,
            ),
            filled: true,
            fillColor: AuthConfig.inputFillColor,
            prefixIcon: prefix,
            suffixIcon: suffix,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            errorText: errorText,
            errorStyle: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFFFF6B6B),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AuthConfig.inputRadius),
              borderSide: BorderSide(color: AuthConfig.inputBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AuthConfig.inputRadius),
              borderSide: BorderSide(
                color: errorText != null
                    ? const Color(0xFFFF6B6B)
                    : AuthConfig.inputBorderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AuthConfig.inputRadius),
              borderSide:
                  const BorderSide(color: AuthConfig.accentColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AuthConfig.inputRadius),
              borderSide: const BorderSide(color: Color(0xFFFF6B6B)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AuthConfig.inputRadius),
              borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  "Or" divider line
// ═══════════════════════════════════════════════════════════════
class AuthDivider extends StatelessWidget {
  final String text;

  const AuthDivider({super.key, this.text = 'Or'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AuthConfig.dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AuthConfig.secondaryTextColor,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AuthConfig.dividerColor)),
      ],
    );
  }
}
