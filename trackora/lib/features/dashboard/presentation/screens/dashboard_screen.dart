import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackora/core/theme/app_colors.dart';
import 'package:trackora/core/theme/app_spacing.dart';
import 'package:trackora/features/categories/presentation/providers/category_providers.dart';
import 'package:trackora/features/transactions/domain/entities/transaction.dart';
import 'package:trackora/features/transactions/presentation/providers/transaction_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionListProvider);
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackora'),
      ),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (transactions) {
          final categories = categoriesAsync.valueOrNull ?? [];

          final totalIncome = transactions
              .where((t) => t.type == TransactionType.income)
              .fold<double>(0, (sum, t) => sum + t.amount);

          final totalExpense = transactions
              .where((t) => t.type == TransactionType.expense)
              .fold<double>(0, (sum, t) => sum + t.amount);

          final balance = totalIncome - totalExpense;

          return ListView(
            padding: EdgeInsets.all(AppSpacing.md.toDouble()),
            children: [
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg.toDouble()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Balance',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                      SizedBox(height: AppSpacing.xs.toDouble()),
                      Text(
                        '\$${balance.toStringAsFixed(2)}',
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      SizedBox(height: AppSpacing.md.toDouble()),
                      Row(
                        children: [
                          _MiniStat(
                            label: 'Income',
                            amount: totalIncome,
                            color: AppColors.income,
                          ),
                          SizedBox(width: AppSpacing.lg.toDouble()),
                          _MiniStat(
                            label: 'Expense',
                            amount: totalExpense,
                            color: AppColors.expense,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.lg.toDouble()),
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: AppSpacing.sm.toDouble()),
              if (transactions.isEmpty)
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl.toDouble()),
                    child: Center(
                      child: Text(
                        'No transactions yet.\nTap + to add one.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                ...transactions.take(5).map((tx) {
                  final cat = categories
                      .where((c) => c.id == tx.categoryId)
                      .toList();
                  final catName =
                      cat.isNotEmpty ? cat.first.name : 'Unknown';
                  final isIncome = tx.type == TransactionType.income;
                  final prefix = isIncome ? '+' : '-';

                  return Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md.toDouble(),
                        vertical: AppSpacing.sm.toDouble(),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.note.isEmpty ? catName : tx.note,
                                  style:
                                      Theme.of(context).textTheme.bodyLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  catName,
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '$prefix\$${tx.amount.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: isIncome
                                      ? AppColors.income
                                      : AppColors.expense,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.sm.toDouble(),
          height: AppSpacing.sm.toDouble(),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: AppSpacing.xs.toDouble()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
