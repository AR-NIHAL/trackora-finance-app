import 'package:flutter/material.dart';

class AnalyticsFilterTabs extends StatelessWidget {
  const AnalyticsFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    const filters = ['Week', 'Month', 'Year'];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: List.generate(filters.length, (index) {
          final isSelected = index == 1;

          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
              ),
              child: Text(
                filters[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
