import 'package:expense_tracker/features/analytics/state/analytics_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsFilterTabs extends ConsumerWidget {
  const AnalyticsFilterTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(analyticsRangeProvider);

    final filters = <(AnalyticsRange, String)>[
      (AnalyticsRange.week, 'Week'),
      (AnalyticsRange.month, 'Month'),
      (AnalyticsRange.year, 'Year'),
    ];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: filters.map((entry) {
          final isSelected = selected == entry.$1;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(analyticsRangeProvider.notifier).setRange(entry.$1);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                ),
                child: Text(
                  entry.$2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
