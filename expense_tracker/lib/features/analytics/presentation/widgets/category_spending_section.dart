import 'package:expense_tracker/features/analytics/state/analytics_provider.dart';
import 'package:expense_tracker/features/analytics/presentation/widgets/category_spending_card.dart';
import 'package:expense_tracker/features/settings/state/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorySpendingSection extends ConsumerWidget {
  const CategorySpendingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totals = ref.watch(rangeCategoryTotalsProvider);
    final totalExpense = ref.watch(rangeTotalExpenseProvider);
    final currencyCode = ref.watch(
      settingsProvider.select((settings) => settings.currencyCode),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Spending',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (totals.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No expense data for this period.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          )
        else
          ...totals.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CategorySpendingCard(
                categoryId: entry.key,
                amount: entry.value,
                percent: totalExpense == 0
                    ? 0
                    : (entry.value / totalExpense * 100).clamp(0, 100),
                currencyCode: currencyCode,
              ),
            ),
          ),
      ],
    );
  }
}
