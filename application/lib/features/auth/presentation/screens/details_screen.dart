import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/auth_config.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_widgets.dart';

/// Screen 2 – Registration details.
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _tobController = TextEditingController();
  final _mobileController = TextEditingController();

  // Error states
  String? _nameError;
  String? _lastNameError;
  String? _dobError;
  String? _tobError;
  String? _mobileError;
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _tobController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  void _validateAll() {
    setState(() {
      _nameError = Validators.name(_nameController.text, field: 'First name');
      _lastNameError =
          Validators.name(_lastNameController.text, field: 'Last name');
      _dobError = Validators.dateOfBirth(_dobController.text);
      _tobError = Validators.timeOfBirth(_tobController.text);
      _mobileError = Validators.phone(_mobileController.text);
    });
  }

  bool get _isValid =>
      _nameError == null &&
      _lastNameError == null &&
      _dobError == null &&
      _tobError == null &&
      _mobileError == null;

  void _onGetOtp() {
    _submitted = true;
    _validateAll();
    if (!_isValid) return;

    // TODO: call registration API
    context.push(AppRoutes.authOtp);
  }

  void _onFieldChanged(String _) {
    if (_submitted) _validateAll();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Title
            Center(
              child: Text(
                'Enter Your Details',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AuthConfig.primaryTextColor,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Name row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AuthTextField(
                    label: 'Name',
                    hint: 'Name',
                    controller: _nameController,
                    onChanged: _onFieldChanged,
                    errorText: _submitted ? _nameError : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AuthTextField(
                    label: 'Last Name',
                    hint: 'Last Name',
                    controller: _lastNameController,
                    onChanged: _onFieldChanged,
                    errorText: _submitted ? _lastNameError : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Date of Birth
            AuthTextField(
              label: 'Date of Birth',
              hint: 'DD/MM/YYYY',
              controller: _dobController,
              keyboardType: TextInputType.datetime,
              onChanged: _onFieldChanged,
              errorText: _submitted ? _dobError : null,
              suffix: const Icon(
                Icons.calendar_today_outlined,
                color: AuthConfig.hintTextColor,
                size: 20,
              ),
            ),

            const SizedBox(height: 20),

            // Time of Birth
            AuthTextField(
              label: 'Time of Birth',
              hint: 'HH:MM (optional)',
              controller: _tobController,
              keyboardType: TextInputType.datetime,
              onChanged: _onFieldChanged,
              errorText: _submitted ? _tobError : null,
              suffix: const Icon(
                Icons.access_time_outlined,
                color: AuthConfig.hintTextColor,
                size: 20,
              ),
            ),

            const SizedBox(height: 20),

            // Mobile Number
            AuthTextField(
              label: 'Mobile Number',
              hint: 'Mobile Number',
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              onChanged: _onFieldChanged,
              errorText: _submitted ? _mobileError : null,
            ),

            const SizedBox(height: 36),

            // Get OTP button
            AuthPrimaryButton(
              label: 'Get OTP',
              onPressed: _onGetOtp,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
