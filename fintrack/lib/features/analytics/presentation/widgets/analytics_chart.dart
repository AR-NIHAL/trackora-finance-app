import 'package:flutter/material.dart';

class AnalyticsChart extends StatelessWidget {
  final Map<String, double> categoryTotals;

  const AnalyticsChart({super.key, required this.categoryTotals});

  String _formatAmount(double value) {
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Text(
            'No expense data available for chart',
            style: TextStyle(fontSize: 15),
          ),
        ),
      );
    }

    final maxValue = categoryTotals.values.reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categoryTotals.entries.map((entry) {
          final ratio = maxValue == 0 ? 0.0 : entry.value / maxValue;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _ChartBarItem(
              label: entry.key,
              amount: _formatAmount(entry.value),
              ratio: ratio,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ChartBarItem extends StatelessWidget {
  final String label;
  final String amount;
  final double ratio;

  const _ChartBarItem({
    required this.label,
    required this.amount,
    required this.ratio,
  });

  @override
  Widget build(BuildContext context) {
    final safeRatio = ratio.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '৳ $amount',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Container(
                  height: 10,
                  width: constraints.maxWidth * safeRatio,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
