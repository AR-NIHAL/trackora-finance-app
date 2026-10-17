import 'dart:ui';
import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:expense_tracker/core/utils/app_utils.dart';
import 'package:expense_tracker/features/analytics/state/analytics_provider.dart';
import 'package:expense_tracker/features/settings/state/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsKpiCard extends ConsumerWidget {
  const AnalyticsKpiCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currencyCode = ref.watch(
      settingsProvider.select((settings) => settings.currencyCode),
    );
    final totalExpense = ref.watch(rangeTotalExpenseProvider);
    final transactionCount = ref.watch(rangeTransactionCountProvider);
    final dailyAvg = ref.watch(rangeDailyAverageProvider);
    final peak = ref.watch(rangePeakSpendingProvider);
    final delta = ref.watch(rangeExpenseDeltaPercentProvider);
    final range = ref.watch(analyticsRangeProvider);

    final rangeLabel = switch (range) {
      AnalyticsRange.week => 'vs last week',
      AnalyticsRange.month => 'vs last month',
      AnalyticsRange.year => 'vs last year',
    };

    final peakLabel = switch (range) {
      AnalyticsRange.week => 'Peak Day',
      AnalyticsRange.month => 'Peak Week',
      AnalyticsRange.year => 'Peak Month',
    };

    final peakValue = switch (range) {
      AnalyticsRange.month => peak != null
          ? (peak.label.startsWith('W')
              ? 'Week ${peak.label.substring(1)}'
              : peak.label)
          : 'None',
      _ => peak != null ? peak.label : 'None',
    };

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
                ? AppColors.cardDark.withValues(alpha: 0.85)
                : AppColors.cardLight,
            border: Border.all(
              color: AppColors.cardBorder(context),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : const Color(0xFF1E293B).withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: isDark
                    ? Colors.transparent
                    : const Color(0xFF1E293B).withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
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
                    'Total Spending',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (delta != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (delta > 0
                                ? AppColors.expense(context)
                                : AppColors.income(context))
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            delta > 0
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 14,
                            color: delta > 0
                                ? AppColors.expense(context)
                                : AppColors.income(context),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${delta.abs().toStringAsFixed(0)}% $rangeLabel',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: delta > 0
                                  ? AppColors.expense(context)
                                  : AppColors.income(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppUtils.formatCurrency(totalExpense, currencyCode),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : const Color(0xFFF8FAF9),
                  border: Border.all(
                    color: AppColors.cardBorder(context),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _KpiMetricColumn(
                        icon: Icons.calendar_today_rounded,
                        label: 'Daily Avg',
                        value: AppUtils.formatCurrency(dailyAvg, currencyCode),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: AppColors.cardBorder(context),
                    ),
                    Expanded(
                      child: _KpiMetricColumn(
                        icon: Icons.trending_up_rounded,
                        label: peakLabel,
                        value: peakValue,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: AppColors.cardBorder(context),
                    ),
                    Expanded(
                      child: _KpiMetricColumn(
                        icon: Icons.receipt_long_rounded,
                        label: 'Txns',
                        value: '$transactionCount',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiMetricColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _KpiMetricColumn({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12, color: AppColors.textMuted(context)),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
