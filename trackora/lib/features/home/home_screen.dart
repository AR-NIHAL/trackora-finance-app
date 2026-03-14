import 'package:flutter/material.dart';
import 'package:trackora/features/add_transaction/transaction_dummy_data.dart';
import 'package:trackora/shared/widgets/summary_card.dart';
import 'package:trackora/shared/widgets/transaction_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final transactions = TransactionStore.transactions;
    final totalBalance = TransactionStore.totalBalance;
    final totalIncome = TransactionStore.totalIncome;
    final totalExpense = TransactionStore.totalExpense;

    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '৳ ${totalBalance.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Income',
                    amount: '৳ ${totalIncome.toStringAsFixed(0)}',
                    bgColor: Colors.green.shade50,
                    textColor: Colors.green,
                    icon: Icons.arrow_downward,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: 'Expense',
                    amount: '৳ ${totalExpense.toStringAsFixed(0)}',
                    bgColor: Colors.red.shade50,
                    textColor: Colors.red,
                    icon: Icons.arrow_upward,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (transactions.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'No transactions yet.\nAdd one from the Add tab.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              ...transactions.reversed.map(
                (item) => TransactionCard(
                  item: item,
                  onLongPress: () {
                    TransactionStore.deleteTransaction(item.id);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transaction deleted')),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
