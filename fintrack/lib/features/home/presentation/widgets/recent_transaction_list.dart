import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../transactions/providers/transaction_filter_provider.dart';
import '../../../transactions/providers/transaction_provider.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';

class RecentTransactionList extends ConsumerWidget {
  const RecentTransactionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(filteredTransactionsProvider);

    if (transactions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).cardColor,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Text('No transactions found', style: TextStyle(fontSize: 15)),
        ),
      );
    }

    final recentTransactions = [...transactions]
      ..sort((a, b) => b.date.compareTo(a.date));

    final limitedTransactions = recentTransactions.take(5).toList();

    return Column(
      children: limitedTransactions.map((transaction) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TransactionTile(
            transaction: transaction,
            onDelete: () async {
              await ref
                  .read(transactionProvider.notifier)
                  .deleteTransaction(transaction.id);
            },
          ),
        );
      }).toList(),
    );
  }
}
