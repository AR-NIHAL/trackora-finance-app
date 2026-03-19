import 'package:expense_tracker/features/home/presentation/widgets/balance_card.dart';
import 'package:flutter/material.dart';
import '../widgets/home_search_field.dart';
import '../widgets/recent_transactions_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          BalanceSummaryCard(),
          SizedBox(height: 16),
          HomeSearchField(),
          SizedBox(height: 24),
          RecentTransactionsSection(),
        ],
      ),
    );
  }
}
