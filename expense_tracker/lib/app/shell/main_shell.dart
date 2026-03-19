import 'package:expense_tracker/features/analytics/presentation/screens/analytical_screen.dart';
import 'package:flutter/material.dart';
import '../router/app_tab_item.dart';
import '../../shared/widgets/app_bottom_nav_bar.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/add_transaction/presentation/screens/add_transaction_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  AppTabItem _currentTab = AppTabItem.home;

  void _onTabSelected(AppTabItem tab) {
    if (_currentTab == tab) return;
    setState(() {
      _currentTab = tab;
    });
  }

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
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
