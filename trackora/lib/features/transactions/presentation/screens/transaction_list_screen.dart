import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:trackora/core/theme/app_colors.dart';
import 'package:trackora/core/theme/app_radius.dart';
import 'package:trackora/core/theme/app_spacing.dart';
import 'package:trackora/features/categories/presentation/providers/category_providers.dart';
import 'package:trackora/features/transactions/domain/entities/transaction.dart';
import 'package:trackora/features/transactions/presentation/providers/transaction_providers.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionListProvider);
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: Text('No transactions yet.'),
            );
          }

          final categories = categoriesAsync.valueOrNull ?? [];

          return ListView.builder(
            padding: EdgeInsets.all(AppSpacing.md.toDouble()),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final cat = categories.where((c) => c.id == tx.categoryId).toList();
              final catName = cat.isNotEmpty ? cat.first.name : 'Unknown';
              final isIncome = tx.type == TransactionType.income;
              final prefix = isIncome ? '+' : '-';
              final color = isIncome ? AppColors.income : AppColors.expense;

              return Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md.toDouble()),
                  child: Row(
                    children: [
                      Container(
                        width: AppSpacing.xxl.toDouble(),
                        height: AppSpacing.xxl.toDouble(),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: AppRadius.allMd,
                        ),
                        child: Icon(
                          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                          color: color,
                          size: AppSpacing.lg.toDouble(),
                        ),
                      ),
                      SizedBox(width: AppSpacing.md.toDouble()),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.note.isEmpty ? catName : tx.note,
                              style: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppSpacing.xxs.toDouble()),
                            Text(
                              '$catName • ${DateFormat.yMMMd().format(tx.date)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$prefix\$${tx.amount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: color,
                            ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(transactionListProvider.notifier)
                              .delete(tx.id);
                        },
                        icon: const Icon(Icons.delete_outline, size: 20),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
