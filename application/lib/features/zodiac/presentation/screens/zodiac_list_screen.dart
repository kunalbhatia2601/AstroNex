import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/zodiac_sign.dart';
import '../providers/zodiac_providers.dart';

class ZodiacListScreen extends ConsumerStatefulWidget {
  const ZodiacListScreen({super.key});

  @override
  ConsumerState<ZodiacListScreen> createState() => _ZodiacListScreenState();
}

class _ZodiacListScreenState extends ConsumerState<ZodiacListScreen> {
  @override
  void initState() {
    super.initState();
    // Load zodiac signs when screen initializes
    Future.microtask(() {
      ref.read(zodiacSignsProvider.notifier).loadZodiacSigns();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(zodiacSignsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zodiac Signs'),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(ZodiacSignsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(state.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(zodiacSignsProvider.notifier).loadZodiacSigns();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.signs.length,
      itemBuilder: (context, index) {
        final sign = state.signs[index];
        return _ZodiacCard(sign: sign);
      },
    );
  }
}

class _ZodiacCard extends StatelessWidget {
  final ZodiacSign sign;

  const _ZodiacCard({required this.sign});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.go('/zodiac/${sign.id}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Symbol
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _getElementColor(sign.element).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    sign.symbol,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sign.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sign.dateRange,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getElementColor(sign.element).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        sign.element.displayName,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: _getElementColor(sign.element),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
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
