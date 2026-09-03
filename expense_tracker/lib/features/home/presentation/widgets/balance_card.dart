import 'dart:ui';
import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:expense_tracker/core/utils/app_utils.dart';
import 'package:expense_tracker/features/add_transaction/state/transaction_provider.dart';
import 'package:expense_tracker/features/settings/state/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'amount_overview_chip.dart';

class BalanceSummaryCard extends ConsumerWidget {
  const BalanceSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final balance = ref.watch(totalBalanceProvider);
    final monthIncome = ref.watch(currentMonthIncomeProvider);
    final monthExpense = ref.watch(currentMonthExpenseProvider);
    final currencyCode = ref.watch(
      settingsProvider.select((settings) => settings.currencyCode),
    );

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
              Text(
                'Total Balance',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppUtils.formatCurrency(balance, currencyCode),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AmountOverviewChip(
                      title: 'Month Income',
                      amount: AppUtils.formatCurrency(monthIncome, currencyCode),
                      icon: Icons.arrow_downward_rounded,
                      accentColor: AppColors.income(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AmountOverviewChip(
                      title: 'Month Expense',
                      amount: AppUtils.formatCurrency(monthExpense, currencyCode),
                      icon: Icons.arrow_upward_rounded,
                      accentColor: AppColors.expense(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
