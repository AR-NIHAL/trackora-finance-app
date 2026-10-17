import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:expense_tracker/core/utils/app_utils.dart';
import 'package:expense_tracker/features/settings/state/settings_provider.dart';
import 'package:expense_tracker/shared/models/dummy_categories.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentTransactionCard extends ConsumerWidget {
  final TransactionModel transaction;

  const RecentTransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currencyCode = ref.watch(
      settingsProvider.select((settings) => settings.currencyCode),
    );
    final category = DummyCategories.findById(transaction.categoryId);
    final isExpense = transaction.isExpense;

    final color = category?.color ?? theme.colorScheme.secondary;
    final iconData = DummyCategories.iconFor(category?.iconName);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border.all(
          color: AppColors.cardBorder(context),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF1E293B).withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: color.withValues(alpha: 0.14),
            ),
            child: Icon(iconData, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${category?.name ?? 'Other'} • ${AppUtils.formatDate(transaction.date)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              '${isExpense ? '-' : '+'}${AppUtils.formatCurrency(transaction.amount, currencyCode)}',
              maxLines: 1,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: isExpense
                    ? AppColors.expense(context)
                    : AppColors.income(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
