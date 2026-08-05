import 'package:expense_tracker/core/utils/app_utils.dart';
import 'package:expense_tracker/features/analytics/state/analytics_provider.dart';
import 'package:expense_tracker/features/settings/state/settings_provider.dart';
import 'package:expense_tracker/shared/models/dummy_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpendingOverviewCard extends ConsumerWidget {
  const SpendingOverviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currencyCode = ref.watch(
      settingsProvider.select((settings) => settings.currencyCode),
    );
    final totalExpense = ref.watch(rangeTotalExpenseProvider);
    final topCategoryId = ref.watch(rangeTopCategoryProvider);
    final transactionCount = ref.watch(rangeTransactionCountProvider);

    final topCategory =
        topCategoryId == null ? null : DummyCategories.findById(topCategoryId);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: theme.colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Spending',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(
                alpha: 0.75,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppUtils.formatCurrency(totalExpense, currencyCode),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _OverviewItem(
                  label: 'Top Category',
                  value: topCategory?.name ?? 'No expense data',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _OverviewItem(
                  label: 'Transactions',
                  value: '$transactionCount',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String label;
  final String value;

  const _OverviewItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: theme.colorScheme.surface.withValues(alpha: 0.55),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
