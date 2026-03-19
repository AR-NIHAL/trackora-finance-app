import 'package:expense_tracker/features/analytics/presentation/screens/analytical_screen.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/app/router/app_tab_item.dart';
import 'package:expense_tracker/features/home/presentation/screens/home_screen.dart';
import 'package:expense_tracker/features/add_transaction/presentation/screens/add_transaction_screen.dart';
import 'package:expense_tracker/features/budget/presentation/screens/budget_screen.dart';
import 'package:expense_tracker/features/settings/presentation/screens/settings_screen.dart';
import 'package:expense_tracker/shared/widgets/app_bottom_nav_bar.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  AppTabItem _currentTab = AppTabItem.home;

  Widget _buildCurrentScreen() {
    switch (_currentTab) {
      case AppTabItem.home:
        return const HomeScreen();
      case AppTabItem.analytics:
        return const AnalyticsScreen();
      case AppTabItem.add:
        return const AddTransactionScreen();
      case AppTabItem.budget:
        return const BudgetScreen();
      case AppTabItem.settings:
        return const SettingsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildCurrentScreen()),
      bottomNavigationBar: AppBottomNavBar(
        currentTab: _currentTab,
        onTabSelected: (tab) {
          setState(() {
            _currentTab = tab;
          });
        },
      ),
    );
  }
}
