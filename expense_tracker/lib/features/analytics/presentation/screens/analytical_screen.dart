import 'package:expense_tracker/features/analytics/presentation/widgets/analytics_cash_flow_card.dart';
import 'package:expense_tracker/features/analytics/presentation/widgets/analytics_chart_container.dart';
import 'package:expense_tracker/features/analytics/presentation/widgets/analytics_filter_tabs.dart';
import 'package:expense_tracker/features/analytics/presentation/widgets/analytics_kpi_card.dart';
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
          SizedBox(height: 16),
          AnalyticsFilterTabs(),
          SizedBox(height: 16),
          AnalyticsKpiCard(),
          SizedBox(height: 16),
          AnalyticsChartContainer(),
          SizedBox(height: 16),
          AnalyticsCashFlowCard(),
          SizedBox(height: 20),
          CategorySpendingSection(),
        ],
      ),
    );
  }
}
