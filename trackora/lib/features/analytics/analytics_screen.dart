import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trackora/features/add_transaction/transaction_model.dart';
import 'package:trackora/features/add_transaction/transaction_store.dart';
import 'package:trackora/shared/widgets/empty_state_card.dart';
import 'package:trackora/shared/widgets/summary_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool _isLoading = true;

  double totalIncome = 0;
  double totalExpense = 0;
  double balance = 0;

  Map<String, double> categoryMap = {};
  List<double> last7Days = List.filled(7, 0);

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    final transactions = await TransactionStore.getTransactions();
    final now = DateTime.now();

    double income = 0;
    double expense = 0;
    final Map<String, double> categoryExpense = {};
    final List<double> weekData = List.filled(7, 0);

    bool isSameMonth(DateTime date) {
      return date.year == now.year && date.month == now.month;
    }

    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    for (final item in transactions) {
      if (isSameMonth(item.date)) {
        if (item.type == 'Income') {
          income += item.amount;
        } else if (item.type == 'Expense') {
          expense += item.amount;
          categoryExpense[item.category] =
              (categoryExpense[item.category] ?? 0) + item.amount;
        }
      }
    }

    for (int i = 0; i < 7; i++) {
      final day = DateTime(now.year, now.month, now.day - (6 - i));
      double total = 0;

      for (final item in transactions) {
        if (item.type == 'Expense' && isSameDay(item.date, day)) {
          total += item.amount;
        }
      }

      weekData[i] = total;
    }

    if (!mounted) return;

    setState(() {
      totalIncome = income;
      totalExpense = expense;
      balance = income - expense;
      categoryMap = categoryExpense;
      last7Days = weekData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAnalytics,
              child: ListView(
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
                        ? const Center(
                            child: Text('No expense data for last 7 days'),
                          )
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
            ),
    );
  }
}
