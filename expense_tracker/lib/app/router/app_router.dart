import 'package:expense_tracker/features/analytics/presentation/screens/analytical_screen.dart';
import 'package:flutter/material.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/add_transaction/presentation/screens/add_transaction_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AnalyticsScreen(),
    AddTransactionScreen(),
    BudgetScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
      },
      body: _screens[_currentIndex],
    );
  }
}
