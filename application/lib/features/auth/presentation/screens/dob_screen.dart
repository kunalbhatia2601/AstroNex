import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/auth_config.dart';
import '../../../../core/routes/app_router.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_widgets.dart';

/// Screen 5 – Date of birth scroll-wheel picker.
class DobScreen extends StatefulWidget {
  const DobScreen({super.key});

  @override
  State<DobScreen> createState() => _DobScreenState();
}

class _DobScreenState extends State<DobScreen> {
  late final FixedExtentScrollController _dayCtrl;
  late final FixedExtentScrollController _monthCtrl;
  late final FixedExtentScrollController _yearCtrl;

  int _selectedDay = 22; // 1-based, default matches Figma (23)
  int _selectedMonth = 1; // 0-based index (February)
  int _selectedYear = 30; // offset into _years list

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  late final List<int> _years;

  @override
  void initState() {
    super.initState();
    _years = List.generate(80, (i) => 1960 + i); // 1960–2039
    _dayCtrl = FixedExtentScrollController(initialItem: _selectedDay);
    _monthCtrl = FixedExtentScrollController(initialItem: _selectedMonth);
    _yearCtrl = FixedExtentScrollController(initialItem: _selectedYear);
  }

  @override
  void dispose() {
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  String? _error;

  int get _day => _selectedDay + 1;
  int get _month => _selectedMonth + 1;
  int get _year => _years[_selectedYear];

  void _onNext() {
    // Validate the selected date is real and not in the future
    try {
      final date = DateTime(_year, _month, _day);
      if (date.day != _day) {
        setState(() => _error = 'Invalid date for the selected month');
        return;
      }
      if (date.isAfter(DateTime.now())) {
        setState(() => _error = 'Date of birth cannot be in the future');
        return;
      }
    } catch (_) {
      setState(() => _error = 'Invalid date selected');
      return;
    }
    setState(() => _error = null);

    if (AuthConfig.enablePlaceOfBirth) {
      context.push(AppRoutes.authPlace);
    } else {
      context.go(AppRoutes.home);
    }
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int) labelBuilder,
    required ValueChanged<int> onChanged,
    double itemWidth = 100,
  }) {
    return SizedBox(
      width: itemWidth,
      height: 200,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 50,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.003,
        diameterRatio: 1.5,
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= itemCount) return null;
            final isSelected = controller.hasClients
                ? controller.selectedItem == index
                : false;
            return Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.poppins(
                  fontSize: isSelected ? 22 : 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected
                      ? AuthConfig.primaryTextColor
                      : AuthConfig.hintTextColor,
                ),
                child: Text(labelBuilder(index)),
              ),
            );
          },
          childCount: itemCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Title
            Text(
              "What's your date of birth?",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AuthConfig.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date is important for determining your Sun sign,\nnumerology and compatibility',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AuthConfig.secondaryTextColor,
              ),
            ),

            const Spacer(),

            // Scroll-wheel pickers
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Day
                _buildPicker(
                  controller: _dayCtrl,
                  itemCount: 31,
                  itemWidth: 60,
                  labelBuilder: (i) => '${i + 1}',
                  onChanged: (i) => setState(() => _selectedDay = i),
                ),

                const SizedBox(width: 12),

                // Month
                _buildPicker(
                  controller: _monthCtrl,
                  itemCount: 12,
                  itemWidth: 130,
                  labelBuilder: (i) => _months[i],
                  onChanged: (i) => setState(() => _selectedMonth = i),
                ),

                const SizedBox(width: 12),

                // Year
                _buildPicker(
                  controller: _yearCtrl,
                  itemCount: _years.length,
                  itemWidth: 80,
                  labelBuilder: (i) => '${_years[i]}',
                  onChanged: (i) => setState(() => _selectedYear = i),
                ),
              ],
            ),

            const Spacer(),

            // Error message
            if (_error != null) ...[
              Text(
                _error!,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Next button
            AuthPrimaryButton(
              label: 'Next',
              onPressed: _onNext,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
