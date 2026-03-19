import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../transactions/providers/transaction_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/home_header.dart';
import '../widgets/recent_transaction_list.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_search_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _formatAmount(double value) {
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionProvider);
    final totalBalance = ref.watch(totalBalanceProvider);
    final totalIncome = ref.watch(totalIncomeProvider);
    final totalExpense = ref.watch(totalExpenseProvider);

    return AppScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHeader(),
            const SizedBox(height: 20),
            BalanceCard(
              balance: totalBalance,
              income: totalIncome,
              expense: totalExpense,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Income',
                    amount: '৳ ${_formatAmount(totalIncome)}',
                    icon: Icons.arrow_downward,
                    iconBackgroundColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: 'Expense',
                    amount: '৳ ${_formatAmount(totalExpense)}',
                    icon: Icons.arrow_upward,
                    iconBackgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const TransactionSearchBar(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${transactionState.transactions.length} items',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const RecentTransactionList(),
          ],
        ),
      ),
    );
  }
}
