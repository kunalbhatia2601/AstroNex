import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/auth_config.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_widgets.dart';

/// Whether the login form is showing the phone or email input.
enum _LoginMode { phone, email }

/// Screen 1 – Login via phone OR email (toggleable).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final String _countryCode = '+91';

  _LoginMode _mode = _LoginMode.phone;
  String? _inputError;
  bool _submitted = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ── Validation ────────────────────────────────────────────────
  void _validate() {
    setState(() {
      _inputError = _mode == _LoginMode.phone
          ? Validators.phone(_phoneController.text)
          : Validators.email(_emailController.text);
    });
  }

  // ── Actions ───────────────────────────────────────────────────
  void _onContinue() {
    _submitted = true;
    _validate();
    if (_inputError != null) return;

    // TODO: call login API → then navigate to OTP
    context.push(AppRoutes.authOtp);
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == _LoginMode.phone ? _LoginMode.email : _LoginMode.phone;
      _inputError = null;
      _submitted = false;
    });
  }

  void _goToRegister() {
    context.push(AppRoutes.authDetails);
  }

  // ── Build ─────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isPhone = _mode == _LoginMode.phone;

    return AuthScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            // Title
            Text(
              'Hi Welcome!',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AuthConfig.primaryTextColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isPhone
                  ? 'Submit your Mobile number'
                  : 'Submit your Email address',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AuthConfig.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 4),

            // ── "Log in or Sign up" divider ────────────────────
            Row(
              children: [
                const Expanded(
                    child: Divider(color: AuthConfig.dividerColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Log in or Sign up',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AuthConfig.hintTextColor,
                    ),
                  ),
                ),
                const Expanded(
                    child: Divider(color: AuthConfig.dividerColor)),
              ],
            ),

            const SizedBox(height: 30),

            // ── Phone OR Email input ───────────────────────────
            if (isPhone) _buildPhoneInput() else _buildEmailInput(),

            const SizedBox(height: 24),

            // Continue button
            AuthPrimaryButton(
              label: 'Continue',
              onPressed: _onContinue,
            ),

            const SizedBox(height: 24),

            // Or divider
            const AuthDivider(),

            const SizedBox(height: 24),

            // Toggle: Continue with Email / Phone
            AuthSecondaryButton(
              label: isPhone
                  ? 'Continue with Email Id'
                  : 'Continue with Phone',
              icon: isPhone ? Icons.email_outlined : Icons.phone_android,
              onPressed: _toggleMode,
            ),

            const SizedBox(height: 28),

            // ── "Not having account? Register" ─────────────────
            Center(
              child: GestureDetector(
                onTap: _goToRegister,
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AuthConfig.secondaryTextColor,
                    ),
                    children: const [
                      TextSpan(text: "Not having account? "),
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          color: AuthConfig.linkColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Terms & privacy
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AuthConfig.secondaryTextColor,
                  ),
                  children: const [
                    TextSpan(text: 'By signing up, you agree to our '),
                    TextSpan(
                      text: 'Terms of Use',
                      style: TextStyle(color: AuthConfig.linkColor),
                    ),
                    TextSpan(text: ' and\n'),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(color: AuthConfig.linkColor),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  //  Phone input (with country code prefix)
  // ═════════════════════════════════════════════════════════════
  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AuthConfig.inputFillColor,
            borderRadius: BorderRadius.circular(AuthConfig.inputRadius),
            border: Border.all(
              color: _inputError != null && _submitted
                  ? const Color(0xFFFF6B6B)
                  : AuthConfig.inputBorderColor,
            ),
          ),
          child: Row(
            children: [
              // Country code
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 16),
                child: Row(
                  children: [
                    const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    Text(
                      _countryCode,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: AuthConfig.primaryTextColor,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down,
                        color: AuthConfig.secondaryTextColor, size: 20),
                  ],
                ),
              ),
              Container(
                  width: 1, height: 28, color: AuthConfig.inputBorderColor),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                        Validators.maxPhoneLength),
                  ],
                  onChanged: (_) {
                    if (_submitted) _validate();
                  },
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: AuthConfig.primaryTextColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter Mobile number',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AuthConfig.hintTextColor,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildErrorLabel(),
      ],
    );
  }

  // ═════════════════════════════════════════════════════════════
  //  Email input
  // ═════════════════════════════════════════════════════════════
  Widget _buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AuthConfig.inputFillColor,
            borderRadius: BorderRadius.circular(AuthConfig.inputRadius),
            border: Border.all(
              color: _inputError != null && _submitted
                  ? const Color(0xFFFF6B6B)
                  : AuthConfig.inputBorderColor,
            ),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) {
              if (_submitted) _validate();
            },
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: AuthConfig.primaryTextColor,
            ),
            decoration: InputDecoration(
              hintText: 'Enter Email address',
              hintStyle: GoogleFonts.poppins(
                fontSize: 15,
                color: AuthConfig.hintTextColor,
              ),
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AuthConfig.hintTextColor,
                size: 22,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        _buildErrorLabel(),
      ],
    );
  }

  // ── Shared error label ────────────────────────────────────────
  Widget _buildErrorLabel() {
    if (_inputError == null || !_submitted) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 6),
      child: Text(
        _inputError!,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFFFF6B6B),
        ),
      ),
    );
  }
}
