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
    final statusList = ref.watch(budgetStatusListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Category Budgets',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No budgets set. Tap "Add" to set a monthly limit for a category.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
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
