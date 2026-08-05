import 'package:expense_tracker/features/add_transaction/state/transaction_provider.dart';
import 'package:expense_tracker/features/home/presentation/widgets/recent_transaction_card.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentTransactionsSection extends ConsumerWidget {
  final String searchQuery;

  const RecentTransactionsSection({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider).sortedByDateDesc;

    final filtered = searchQuery.trim().isEmpty
        ? transactions
        : transactions.where((tx) {
            final query = searchQuery.trim().toLowerCase();
            return tx.title.toLowerCase().contains(query) ||
                tx.note.toLowerCase().contains(query);
          }).toList();

    final display = filtered.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        if (display.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                searchQuery.trim().isEmpty
                    ? 'No transactions yet. Tap + to add one.'
                    : 'No matching transactions.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          )
        else
          ...display.map(
            (TransactionModel item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RecentTransactionCard(transaction: item),
            ),
          ),
      ],
    );
  }
}
