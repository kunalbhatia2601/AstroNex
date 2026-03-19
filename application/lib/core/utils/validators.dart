/// Centralised validation helpers.
///
/// Every rule lives here so it's easy to change regex / lengths
/// across the whole app in one place.
class Validators {
  Validators._();

  // ─── Phone ───────────────────────────────────────────────────
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  static final RegExp _phoneRegex = RegExp(r'^[0-9]+$');

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!_phoneRegex.hasMatch(cleaned)) {
      return 'Only digits are allowed';
    }
    if (cleaned.length < minPhoneLength) {
      return 'Must be at least $minPhoneLength digits';
    }
    if (cleaned.length > maxPhoneLength) {
      return 'Must be at most $maxPhoneLength digits';
    }
    return null;
  }

  // ─── Email ──────────────────────────────────────────────────
  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // ─── Name ────────────────────────────────────────────────────
  static String? name(String? value, {String field = 'Name'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    if (value.trim().length < 2) {
      return '$field must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return '$field can only contain letters';
    }
    return null;
  }

  // ─── Date of birth (DD/MM/YYYY string) ───────────────────────
  static String? dateOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }
    // Accept common formats: DD/MM/YYYY, DD-MM-YYYY, DD.MM.YYYY
    final parts = value.split(RegExp(r'[/\-.]'));
    if (parts.length != 3) {
      return 'Use format DD/MM/YYYY';
    }
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) {
      return 'Invalid date';
    }
    if (month < 1 || month > 12) return 'Invalid month';
    if (day < 1 || day > 31) return 'Invalid day';
    if (year < 1900 || year > DateTime.now().year) return 'Invalid year';

    try {
      final date = DateTime(year, month, day);
      if (date.isAfter(DateTime.now())) return 'Cannot be a future date';
    } catch (_) {
      return 'Invalid date';
    }
    return null;
  }

  // ─── Time of birth (HH:MM string) ───────────────────────────
  static String? timeOfBirth(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // optional field
    }
    final parts = value.split(':');
    if (parts.length != 2) return 'Use format HH:MM';
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return 'Invalid time';
    if (h < 0 || h > 23) return 'Hour must be 0-23';
    if (m < 0 || m > 59) return 'Minute must be 0-59';
    return null;
  }

  // ─── OTP ─────────────────────────────────────────────────────
  static String? otp(String value, int requiredLength) {
    if (value.length < requiredLength) {
      return 'Please enter all $requiredLength digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Only digits are allowed';
    }
    return null;
  }

  // ─── Place ───────────────────────────────────────────────────
  static String? place(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a place of birth';
    }
    return null;
  }

  // ─── Generic required ────────────────────────────────────────
  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    return null;
  }
}
