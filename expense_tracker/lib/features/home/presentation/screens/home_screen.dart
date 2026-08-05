import 'package:expense_tracker/features/home/presentation/widgets/balance_card.dart';
import 'package:expense_tracker/features/home/presentation/widgets/budget_alert_banner.dart';
import 'package:expense_tracker/features/home/presentation/widgets/home_quick_actions.dart';
import 'package:expense_tracker/features/home/presentation/widgets/insights_preview.dart';
import 'package:flutter/material.dart';
import '../widgets/home_search_field.dart';
import '../widgets/recent_transactions_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BalanceSummaryCard(),
          const SizedBox(height: 16),
          const HomeQuickActions(),
          const SizedBox(height: 16),
          const BudgetAlertBanner(),
          if (_searchQuery.isEmpty) const SizedBox(height: 16),
          if (_searchQuery.isEmpty) const InsightsPreview(),
          if (_searchQuery.isEmpty) const SizedBox(height: 16),
          HomeSearchField(
            controller: _searchController,
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          const SizedBox(height: 24),
          RecentTransactionsSection(searchQuery: _searchQuery),
        ],
      ),
    );
  }
}
