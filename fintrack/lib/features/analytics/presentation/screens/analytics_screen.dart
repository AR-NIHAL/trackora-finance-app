import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../providers/analytics_provider.dart';
import '../widgets/analytics_chart.dart';
import '../widgets/analytics_filter_tabs.dart';
import '../widgets/analytics_summary.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final income = ref.watch(analyticsIncomeProvider);
    final expense = ref.watch(analyticsExpenseProvider);
    final balance = ref.watch(analyticsBalanceProvider);
    final totalTransactions = ref.watch(analyticsTransactionCountProvider);
    final topCategory = ref.watch(analyticsTopCategoryProvider);
    final categoryTotals = ref.watch(analyticsCategoryTotalsProvider);

    return AppScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics Overview',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Track your income, expense and category trends',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            const AnalyticsFilterTabs(),
            const SizedBox(height: 20),
            AnalyticsSummary(
              income: income,
              expense: expense,
              balance: balance,
              totalTransactions: totalTransactions,
              topCategory: topCategory,
            ),
            const SizedBox(height: 20),
            const Text(
              'Expense by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            AnalyticsChart(categoryTotals: categoryTotals),
          ],
        ),
      ),
    );
  }
}
