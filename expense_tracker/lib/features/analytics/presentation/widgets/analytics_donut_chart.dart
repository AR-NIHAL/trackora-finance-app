import 'package:expense_tracker/shared/models/dummy_categories.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsDonutChart extends StatefulWidget {
  final Map<String, double> categoryTotals;
  final double totalExpense;
  final String currencyCode;

  const AnalyticsDonutChart({
    super.key,
    required this.categoryTotals,
    required this.totalExpense,
    required this.currencyCode,
  });

  @override
  State<AnalyticsDonutChart> createState() => _AnalyticsDonutChartState();
}

class _AnalyticsDonutChartState extends State<AnalyticsDonutChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = widget.categoryTotals.entries.toList();

    if (entries.isEmpty || widget.totalExpense <= 0) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Text(
            'No category data available',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }

    final sections = List.generate(entries.length, (index) {
      final entry = entries[index];
      final isTouched = index == _touchedIndex;
      final category = DummyCategories.findById(entry.key);
      final color = category?.color ?? theme.colorScheme.primary;
      final percent = (entry.value / widget.totalExpense) * 100;

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: isTouched ? '${percent.toStringAsFixed(0)}%' : '',
        radius: isTouched ? 34 : 26,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      );
    });

    final activeEntry = (_touchedIndex >= 0 && _touchedIndex < entries.length)
        ? entries[_touchedIndex]
        : entries.first;
    final activeCategory = DummyCategories.findById(activeEntry.key);
    final activePercent = (activeEntry.value / widget.totalExpense * 100).toStringAsFixed(0);

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 3,
                  centerSpaceRadius: 48,
                  sections: sections,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    activeCategory?.name ?? 'Total',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$activePercent%',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: entries.take(5).map((entry) {
            final category = DummyCategories.findById(entry.key);
            final color = category?.color ?? theme.colorScheme.primary;
            final percent = (entry.value / widget.totalExpense * 100).toStringAsFixed(0);

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${category?.name ?? 'Other'} ($percent%)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
