import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/zodiac_sign.dart';
import '../providers/zodiac_providers.dart';

class ZodiacDetailScreen extends ConsumerWidget {
  final String sign;

  const ZodiacDetailScreen({
    super.key,
    required this.sign,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(zodiacSignsProvider);
    final zodiacSign = state.signs.where((s) => s.id == sign).firstOrNull;

    if (zodiacSign == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Zodiac Sign')),
        body: const Center(child: Text('Sign not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with symbol
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(zodiacSign.name),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getElementColor(zodiacSign.element),
                      _getElementColor(zodiacSign.element).withOpacity(0.5),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    zodiacSign.symbol,
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick info cards
                  Row(
                    children: [
                      _InfoCard(
                        title: 'Element',
                        value: zodiacSign.element.displayName,
                        color: _getElementColor(zodiacSign.element),
                      ),
                      const SizedBox(width: 12),
                      _InfoCard(
                        title: 'Ruling Planet',
                        value: zodiacSign.rulingPlanet,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    zodiacSign.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  // Date range
                  _DetailRow(
                    icon: Icons.calendar_today,
                    title: 'Date Range',
                    value: zodiacSign.dateRange,
                  ),
                  const SizedBox(height: 16),
                  // Traits
                  Text(
                    'Personality Traits',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    zodiacSign.traits,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getElementColor(ZodiacElement element) {
    switch (element) {
      case ZodiacElement.fire:
        return AppColors.fire;
      case ZodiacElement.earth:
        return AppColors.earth;
      case ZodiacElement.air:
        return AppColors.air;
      case ZodiacElement.water:
        return AppColors.water;
    }
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
