import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../zodiac/presentation/providers/zodiac_providers.dart';
import '../../domain/entities/horoscope.dart';

// Provider for selected horoscope type
final selectedHoroscopeTypeProvider = StateProvider<HoroscopeType>((ref) {
  return HoroscopeType.daily;
});

class HoroscopeScreen extends ConsumerWidget {
  const HoroscopeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zodiacState = ref.watch(zodiacSignsProvider);
    final selectedType = ref.watch(selectedHoroscopeTypeProvider);
    final selectedSign = ref.watch(selectedZodiacSignProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Horoscope'),
      ),
      body: Column(
        children: [
          // Horoscope type selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: HoroscopeType.values.map((type) {
                final isSelected = type == selectedType;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(selectedHoroscopeTypeProvider.notifier).state = type;
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        type.displayName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Zodiac sign selector
          if (zodiacState.signs.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: zodiacState.signs.length,
                itemBuilder: (context, index) {
                  final sign = zodiacState.signs[index];
                  final isSelected = selectedSign?.id == sign.id;
                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedZodiacSignProvider.notifier).state = sign;
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(sign.symbol, style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 4),
                          Text(
                            sign.name.substring(0, 3),
                            style: Theme.of(context).textTheme.labelSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          // Horoscope content
          Expanded(
            child: selectedSign == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_outline,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Select your zodiac sign',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  )
                : _HoroscopeContent(
                    sign: selectedSign,
                    type: selectedType,
                  ),
          ),
        ],
      ),
    );
  }
}

class _HoroscopeContent extends StatelessWidget {
  final dynamic sign;
  final HoroscopeType type;

  const _HoroscopeContent({
    required this.sign,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    // Mock horoscope content
    final content = _getHoroscopeContent(type);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                sign.symbol,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${sign.name} ${type.displayName} Horoscope',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Today',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Main content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content['title']!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  content['prediction']!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Lucky elements
          Row(
            children: [
              _LuckyItem(
                icon: Icons.numbers,
                label: 'Lucky Numbers',
                value: content['luckyNumbers']!,
              ),
              const SizedBox(width: 12),
              _LuckyItem(
                icon: Icons.palette,
                label: 'Lucky Color',
                value: content['luckyColor']!,
              ),
              const SizedBox(width: 12),
              _LuckyItem(
                icon: Icons.mood,
                label: 'Mood',
                value: content['mood']!,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Rating
          Text(
            'Today\'s Rating',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < 4 ? Icons.star : Icons.star_border,
                color: AppColors.warning,
                size: 28,
              );
            }),
          ),
        ],
      ),
    );
  }

  Map<String, String> _getHoroscopeContent(HoroscopeType type) {
    switch (type) {
      case HoroscopeType.daily:
        return {
          'title': 'A Day of New Beginnings',
          'prediction':
              'Today brings exciting opportunities for personal growth. The stars align to help you make important decisions. Trust your intuition and don\'t be afraid to take that leap of faith you\'ve been considering.',
          'luckyNumbers': '7, 14, 23',
          'luckyColor': 'Purple',
          'mood': 'Optimistic',
        };
      case HoroscopeType.weekly:
        return {
          'title': 'Week of Transformation',
          'prediction':
              'This week promises significant changes in your personal and professional life. Relationships may deepen, and new connections could lead to exciting possibilities. Stay open to unexpected opportunities.',
          'luckyNumbers': '3, 11, 27',
          'luckyColor': 'Blue',
          'mood': 'Adventurous',
        };
      case HoroscopeType.monthly:
        return {
          'title': 'Month of Achievements',
          'prediction':
              'This month is favorable for career advancement and personal projects. Your hard work will finally pay off, and recognition is coming your way. Focus on your goals and maintain your determination.',
          'luckyNumbers': '5, 18, 29',
          'luckyColor': 'Gold',
          'mood': 'Confident',
        };
    }
  }
}

class _LuckyItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _LuckyItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
