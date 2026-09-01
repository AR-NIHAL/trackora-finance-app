import 'package:expense_tracker/features/analytics/presentation/widgets/analytics_filter_tabs.dart';
import 'package:expense_tracker/features/analytics/presentation/widgets/analytics_chart_placeholder.dart';
import 'package:expense_tracker/features/analytics/presentation/widgets/spending_overview_card.dart';
import 'package:expense_tracker/features/analytics/presentation/widgets/category_spending_section.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Analytics',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 20),
          AnalyticsFilterTabs(),
          SizedBox(height: 20),
          SpendingOverviewCard(),
          SizedBox(height: 20),
          AnalyticsChartPlaceholder(),
          SizedBox(height: 24),
          CategorySpendingSection(),
        ],
      ),
    );
  }
}
