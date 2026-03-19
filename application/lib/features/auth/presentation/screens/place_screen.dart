import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/auth_config.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_widgets.dart';

/// Screen 6 – Place of birth search with suggestions.
class PlaceScreen extends StatefulWidget {
  const PlaceScreen({super.key});

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  final _searchController = TextEditingController();
  String? _selectedPlace;

  // Mock data – replace with API later
  static const List<Map<String, String>> _allPlaces = [
    {'city': 'New Delhi', 'country': 'India', 'flag': '🇮🇳'},
    {'city': 'Mumbai', 'country': 'India', 'flag': '🇮🇳'},
    {'city': 'Bangalore', 'country': 'India', 'flag': '🇮🇳'},
    {'city': 'Chennai', 'country': 'India', 'flag': '🇮🇳'},
    {'city': 'Hyderabad', 'country': 'India', 'flag': '🇮🇳'},
    {'city': 'Kolkata', 'country': 'India', 'flag': '🇮🇳'},
    {'city': 'Pune', 'country': 'India', 'flag': '🇮🇳'},
    {'city': 'Jaipur', 'country': 'India', 'flag': '🇮🇳'},
    {'city': 'New York', 'country': 'USA', 'flag': '🇺🇸'},
    {'city': 'London', 'country': 'UK', 'flag': '🇬🇧'},
  ];

  List<Map<String, String>> get _filteredPlaces {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _allPlaces;
    return _allPlaces
        .where((p) =>
            p['city']!.toLowerCase().contains(query) ||
            p['country']!.toLowerCase().contains(query))
        .toList();
  }

  String? _placeError;

  void _onNext() async {
    final error = Validators.place(_selectedPlace);
    setState(() => _placeError = error);
    if (error != null) return;

    // TODO: save to user profile via API
    await AppConfig.setOnboardingSeen(true);
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Title
            Center(
              child: Text(
                'Place of birth',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AuthConfig.primaryTextColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Place of birth helps clarify their intentions and\noverall attitude towards you',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AuthConfig.secondaryTextColor,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Search input
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AuthConfig.primaryTextColor,
              ),
              decoration: InputDecoration(
                hintText: 'Search city...',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AuthConfig.hintTextColor,
                ),
                filled: true,
                fillColor: AuthConfig.inputFillColor,
                prefixIcon: const Icon(Icons.search,
                    color: AuthConfig.hintTextColor, size: 22),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AuthConfig.inputRadius),
                  borderSide: BorderSide(color: AuthConfig.inputBorderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AuthConfig.inputRadius),
                  borderSide: BorderSide(color: AuthConfig.inputBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AuthConfig.inputRadius),
                  borderSide: const BorderSide(
                      color: AuthConfig.accentColor, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Results list
            Expanded(
              child: ListView.separated(
                itemCount: _filteredPlaces.length,
                separatorBuilder: (_, __) => const Divider(
                  color: AuthConfig.dividerColor,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final place = _filteredPlaces[index];
                  final label = '${place['city']}, ${place['country']}';
                  final isSelected = _selectedPlace == label;

                  return ListTile(
                    onTap: () => setState(() {
                      _selectedPlace = label;
                      _placeError = null;
                    }),
                    leading: Text(
                      place['flag']!,
                      style: const TextStyle(fontSize: 22),
                    ),
                    title: Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? AuthConfig.accentColor
                            : AuthConfig.primaryTextColor,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle,
                            color: AuthConfig.accentColor, size: 22)
                        : null,
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Error message
            if (_placeError != null) ...[
              Text(
                _placeError!,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Next button
            AuthPrimaryButton(
              label: 'Next',
              onPressed: _onNext,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
