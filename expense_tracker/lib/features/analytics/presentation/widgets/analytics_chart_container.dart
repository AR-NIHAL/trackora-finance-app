import 'dart:ui';
import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:expense_tracker/features/analytics/presentation/widgets/analytics_bar_chart.dart';
import 'package:expense_tracker/features/analytics/presentation/widgets/analytics_donut_chart.dart';
import 'package:expense_tracker/features/analytics/presentation/widgets/analytics_line_chart.dart';
import 'package:expense_tracker/features/analytics/state/analytics_provider.dart';
import 'package:expense_tracker/features/settings/state/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsChartContainer extends ConsumerWidget {
  const AnalyticsChartContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final chartType = ref.watch(analyticsChartTypeProvider);
    final points = ref.watch(spendingTrendProvider);
    final categoryTotals = ref.watch(rangeCategoryTotalsProvider);
    final totalExpense = ref.watch(rangeTotalExpenseProvider);
    final currencyCode = ref.watch(
      settingsProvider.select((settings) => settings.currencyCode),
    );

    final maxValue = points.fold<double>(0.0, (max, p) => p.value > max ? p.value : max);

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: isDark
                ? AppColors.cardDark.withValues(alpha: 0.75)
                : AppColors.cardLight.withValues(alpha: 0.8),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : Colors.white.withValues(alpha: 0.6),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.black : const Color(0xFF64748B))
                    .withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Spending Trends',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ChartTypeButton(
                          icon: Icons.bar_chart_rounded,
                          tooltip: 'Bar Chart',
                          isSelected: chartType == AnalyticsChartType.bar,
                          onTap: () => ref
                              .read(analyticsChartTypeProvider.notifier)
                              .setType(AnalyticsChartType.bar),
                        ),
                        _ChartTypeButton(
                          icon: Icons.show_chart_rounded,
                          tooltip: 'Line Chart',
                          isSelected: chartType == AnalyticsChartType.line,
                          onTap: () => ref
                              .read(analyticsChartTypeProvider.notifier)
                              .setType(AnalyticsChartType.line),
                        ),
                        _ChartTypeButton(
                          icon: Icons.donut_large_rounded,
                          tooltip: 'Donut Chart',
                          isSelected: chartType == AnalyticsChartType.donut,
                          onTap: () => ref
                              .read(analyticsChartTypeProvider.notifier)
                              .setType(AnalyticsChartType.donut),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (maxValue == 0 && totalExpense == 0)
                SizedBox(
                  height: 180,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.insights_rounded,
                          size: 36,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No spending in this period',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                switch (chartType) {
                  AnalyticsChartType.bar => AnalyticsBarChart(
                      points: points,
                      maxValue: maxValue,
                      currencyCode: currencyCode,
                    ),
                  AnalyticsChartType.line => AnalyticsLineChart(
                      points: points,
                      maxValue: maxValue,
                      currencyCode: currencyCode,
                    ),
                  AnalyticsChartType.donut => AnalyticsDonutChart(
                      categoryTotals: categoryTotals,
                      totalExpense: totalExpense,
                      currencyCode: currencyCode,
                    ),
                },
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartTypeButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChartTypeButton({
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 17,
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
