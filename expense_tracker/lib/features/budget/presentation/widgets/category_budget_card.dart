import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:expense_tracker/core/utils/app_utils.dart';
import 'package:expense_tracker/features/budget/presentation/widgets/budget_progress_bar.dart';
import 'package:expense_tracker/features/settings/state/settings_provider.dart';
import 'package:expense_tracker/shared/models/dummy_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryBudgetCard extends ConsumerWidget {
  final String categoryId;
  final double spentAmount;
  final double limitAmount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryBudgetCard({
    super.key,
    required this.categoryId,
    required this.spentAmount,
    required this.limitAmount,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currencyCode = ref.watch(
      settingsProvider.select((settings) => settings.currencyCode),
    );
    final category = DummyCategories.findById(categoryId);
    final progress = limitAmount <= 0
        ? 0.0
        : (spentAmount / limitAmount).clamp(0.0, 1.0);
    final isExceeded = spentAmount > limitAmount;
    final isWarning = !isExceeded && progress >= 0.8;

    final barColor = isExceeded
        ? AppColors.expense(context)
        : isWarning
        ? Colors.orange
        : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
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
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: (category?.color ?? theme.colorScheme.primary)
                      .withValues(alpha: 0.14),
                ),
                child: Icon(
                  DummyCategories.iconFor(category?.iconName),
                  color: category?.color ?? theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category?.name ?? 'Other',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${AppUtils.formatCurrency(spentAmount, currencyCode)} / ${AppUtils.formatCurrency(limitAmount, currencyCode)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          BudgetProgressBar(
            progress: progress,
            progressLabel: isExceeded
                ? 'Over budget by ${AppUtils.formatCurrency(spentAmount - limitAmount, currencyCode)}'
                : '${(progress * 100).toInt()}% used',
            color: barColor,
          ),
        ],
      ),
    );
  }
}
