import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/auth_config.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_widgets.dart';

/// Screen 3 – OTP verification.
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  int _secondsLeft = AuthConfig.otpTimerSeconds;
  Timer? _timer;
  bool _canResend = false;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(AuthConfig.otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(AuthConfig.otpLength, (_) => FocusNode());
    _startTimer();
    // Auto-focus first box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _secondsLeft = AuthConfig.otpTimerSeconds;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _formattedTime {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _otpValue => _controllers.map((c) => c.text).join();

  void _onVerify() {
    final error = Validators.otp(_otpValue, AuthConfig.otpLength);
    setState(() => _otpError = error);
    if (error != null) return;

    // TODO: verify OTP via API
    if (AuthConfig.enableLanguageSelection) {
      context.push(AppRoutes.authLanguage);
    } else if (AuthConfig.enableDobScreen) {
      context.push(AppRoutes.authDob);
    } else {
      context.go(AppRoutes.home);
    }
  }

  void _onResend() {
    // Clear boxes
    for (final c in _controllers) {
      c.clear();
    }
    setState(() => _otpError = null);
    _focusNodes[0].requestFocus();
    _startTimer();
  }

  void _onChangeMobile() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Title
            Text(
              'OTP Verification',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AuthConfig.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'An ${AuthConfig.otpLength} digit code has been sent to your number',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AuthConfig.secondaryTextColor,
              ),
            ),

            const SizedBox(height: 24),

            // Timer
            Text(
              _formattedTime,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AuthConfig.primaryTextColor,
              ),
            ),

            const SizedBox(height: 24),

            // OTP fields — dark text on white boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(AuthConfig.otpLength, (i) {
                return Container(
                  width: 56,
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: TextField(
                    controller: _controllers[i],
                    focusNode: _focusNodes[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AuthConfig.accentTextColor, // dark text
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AuthConfig.inputRadius),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AuthConfig.inputRadius),
                        borderSide: const BorderSide(
                            color: AuthConfig.accentColor, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AuthConfig.inputRadius),
                        borderSide:
                            const BorderSide(color: Color(0xFFFF6B6B)),
                      ),
                    ),
                    onChanged: (val) {
                      // Clear error on edit
                      if (_otpError != null) {
                        setState(() => _otpError = null);
                      }
                      if (val.isNotEmpty && i < AuthConfig.otpLength - 1) {
                        _focusNodes[i + 1].requestFocus();
                      } else if (val.isEmpty && i > 0) {
                        _focusNodes[i - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),

            // Error message
            if (_otpError != null) ...[
              const SizedBox(height: 10),
              Text(
                _otpError!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFFFF6B6B),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Verify button
            AuthPrimaryButton(
              label: 'Verify OTP',
              onPressed: _onVerify,
            ),

            const SizedBox(height: 20),

            // Resend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "If you didn't receive a code! ",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AuthConfig.secondaryTextColor,
                  ),
                ),
                GestureDetector(
                  onTap: _canResend ? _onResend : null,
                  child: Text(
                    'Resend',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _canResend
                          ? AuthConfig.linkColor
                          : AuthConfig.hintTextColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Change mobile number
            AuthSecondaryButton(
              label: 'Change Mobile Number',
              icon: Icons.phone_android_outlined,
              onPressed: _onChangeMobile,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
