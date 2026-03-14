import 'package:flutter/material.dart';
import 'package:trackora/features/add_transaction/transaction_dummy_data.dart';
import 'package:trackora/shared/widgets/summary_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final totalIncome = TransactionStore.totalIncome;
    final totalExpense = TransactionStore.totalExpense;
    final balance = TransactionStore.totalBalance;

    String topMessage;
    if (totalExpense == 0 && totalIncome == 0) {
      topMessage = 'No analytics yet. Add transactions first.';
    } else if (totalExpense > totalIncome) {
      topMessage = 'Your expenses are higher than income.';
    } else {
      topMessage = 'Good job! Your balance is under control.';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                'Chart will be shown here in Module 6/7',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              topMessage,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Balance',
                  amount: '৳ ${balance.toStringAsFixed(0)}',
                  bgColor: Colors.blue.shade50,
                  textColor: Colors.blue,
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'Income',
                  amount: '৳ ${totalIncome.toStringAsFixed(0)}',
                  bgColor: Colors.green.shade50,
                  textColor: Colors.green,
                  icon: Icons.arrow_downward,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SummaryCard(
            title: 'Expense',
            amount: '৳ ${totalExpense.toStringAsFixed(0)}',
            bgColor: Colors.red.shade50,
            textColor: Colors.red,
            icon: Icons.arrow_upward,
          ),
        ],
      ),
    );
  }
}
