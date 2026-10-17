import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:expense_tracker/features/budget/presentation/widgets/category_budget_card.dart';
import 'package:expense_tracker/features/budget/presentation/widgets/budget_form_dialog.dart';
import 'package:expense_tracker/features/budget/state/budget_provider.dart';
import 'package:expense_tracker/shared/models/budget_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryBudgetSection extends ConsumerWidget {
  const CategoryBudgetSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusList = ref.watch(budgetStatusListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Category Budgets',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton.icon(
              onPressed: () => _openForm(context, ref),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (statusList.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              border: Border.all(
                color: AppColors.cardBorder(context),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.2)
                      : const Color(0xFF1E293B).withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  ),
                  child: Icon(
                    Icons.pie_chart_outline_rounded,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'No budgets set',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'No budgets set. Tap "Add" to set a monthly limit for a category.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted(context),
                  ),
                ),
              ],
            ),
          )
        else
          ...statusList.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CategoryBudgetCard(
                categoryId: item.budget.categoryId,
                spentAmount: item.spentAmount,
                limitAmount: item.budget.limitAmount,
                onEdit: () => _openForm(context, ref, existing: item.budget),
                onDelete: () {
                  ref
                      .read(budgetProvider.notifier)
                      .deleteBudget(item.budget.id);
                },
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    BudgetModel? existing,
  }) async {
    final result = await showDialog(
      context: context,
      builder: (context) => BudgetFormDialog(existingBudget: existing),
    );
    if (result != null) {
      ref.read(budgetProvider.notifier).setBudget(result);
    }
  }
}
