import 'package:flutter/material.dart';

class AnalyticsChartPlaceholder extends StatelessWidget {
  const AnalyticsChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Trend',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: theme.colorScheme.secondaryContainer.withValues(
                alpha: 0.5,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) => Container(
                          height: 1,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.08,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.insert_chart_outlined_rounded,
                  size: 48,
                  color: theme.colorScheme.onSecondaryContainer.withValues(
                    alpha: 0.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
