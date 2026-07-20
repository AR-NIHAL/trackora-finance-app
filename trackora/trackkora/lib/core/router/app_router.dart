import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:trackkora/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:trackkora/features/transactions/presentation/screens/transactions_screen.dart';
import 'package:trackkora/features/transactions/presentation/screens/add_transaction_screen.dart';
import 'package:trackkora/features/categories/presentation/screens/categories_screen.dart';
import 'package:trackkora/features/budgets/presentation/screens/budgets_screen.dart';
import 'package:trackkora/features/search/presentation/screens/search_screen.dart';
import 'package:trackkora/features/settings/presentation/screens/settings_screen.dart';
import 'package:trackkora/features/recurring/presentation/screens/recurring_screen.dart';
import 'package:trackkora/features/recurring/presentation/screens/add_recurring_screen.dart';
import 'package:trackkora/features/export/presentation/screens/export_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/transactions',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TransactionsScreen(),
          ),
        ),
        GoRoute(
          path: '/budgets',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BudgetsScreen(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/add-transaction',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AddTransactionScreen(),
    ),
    GoRoute(
      path: '/edit-transaction/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AddTransactionScreen(transactionId: id);
      },
    ),
    GoRoute(
      path: '/categories',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/search',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/recurring',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RecurringScreen(),
    ),
    GoRoute(
      path: '/add-recurring',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AddRecurringScreen(),
    ),
    GoRoute(
      path: '/add-recurring/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AddRecurringScreen(recurringId: id);
      },
    ),
    GoRoute(
      path: '/export',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ExportScreen(),
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.savings_outlined),
            selectedIcon: Icon(Icons.savings),
            label: 'Budgets',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _shouldShowFab(context)
          ? FloatingActionButton(
              onPressed: () => context.push('/add-transaction'),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/transactions')) return 1;
    if (location.startsWith('/budgets')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/dashboard');
      case 1:
        context.go('/transactions');
      case 2:
        context.go('/budgets');
      case 3:
        context.go('/settings');
    }
  }

  bool _shouldShowFab(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return location.startsWith('/dashboard') ||
        location.startsWith('/transactions');
  }
}
