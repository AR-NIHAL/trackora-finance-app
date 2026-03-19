import 'package:flutter/material.dart';
import '../widgets/monthly_budget_summary_card.dart';
import '../widgets/category_budget_section.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Budget',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 20),
          MonthlyBudgetSummaryCard(),
          SizedBox(height: 24),
          CategoryBudgetSection(),
        ],
      ),
    );
  }
}
