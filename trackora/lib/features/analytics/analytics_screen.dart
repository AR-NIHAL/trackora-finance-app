import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trackora/features/add_transaction/transaction_store.dart';
import 'package:trackora/shared/widgets/empty_state_card.dart';
import 'package:trackora/shared/widgets/summary_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    final totalIncome = TransactionStore.currentMonthIncome;
    final totalExpense = TransactionStore.currentMonthExpense;
    final balance = totalIncome - totalExpense;
    final categoryMap = TransactionStore.currentMonthCategoryExpenseMap;
    final last7Days = TransactionStore.last7DaysExpenses;

    String topMessage;
    if (totalExpense == 0 && totalIncome == 0) {
      topMessage = 'No analytics yet. Add transactions first.';
    } else if (totalExpense > totalIncome) {
      topMessage = 'Your monthly expense is higher than income.';
    } else {
      topMessage = 'Good job! Your cash flow looks healthy.';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 240,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: last7Days.every((e) => e == 0)
                ? const Center(child: Text('No expense data for last 7 days'))
                : BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 36,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const labels = [
                                'D1',
                                'D2',
                                'D3',
                                'D4',
                                'D5',
                                'D6',
                                'D7',
                              ];
                              final index = value.toInt();
                              if (index < 0 || index >= labels.length) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                labels[index],
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(
                        last7Days.length,
                        (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: last7Days[index],
                              width: 16,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ),
                      ),
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
          const SizedBox(height: 24),
          const Text(
            'Category Breakdown',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (categoryMap.isEmpty)
            const EmptyStateCard(
              message: 'No category expense data available yet.',
            )
          else
            ...categoryMap.entries.map(
              (entry) => Card(
                child: ListTile(
                  leading: const Icon(Icons.pie_chart_outline),
                  title: Text(entry.key),
                  trailing: Text(
                    '৳ ${entry.value.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
