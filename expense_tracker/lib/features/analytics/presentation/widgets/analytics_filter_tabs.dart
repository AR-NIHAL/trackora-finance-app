import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:expense_tracker/features/analytics/state/analytics_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsFilterTabs extends ConsumerWidget {
  const AnalyticsFilterTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selected = ref.watch(analyticsRangeProvider);

    final filters = <(AnalyticsRange, String)>[
      (AnalyticsRange.week, 'Week'),
      (AnalyticsRange.month, 'Month'),
      (AnalyticsRange.year, 'Year'),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border.all(
          color: AppColors.cardBorder(context),
          width: 1.2,
        ),
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
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  entry.$2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textMuted(context),
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
