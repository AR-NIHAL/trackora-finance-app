import 'package:flutter/material.dart';
import '../../app/router/app_tab_item.dart';

class AppBottomNavBar extends StatelessWidget {
  final AppTabItem currentTab;
  final ValueChanged<AppTabItem> onTabSelected;

  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  int _currentIndexFromTab(AppTabItem tab) {
    switch (tab) {
      case AppTabItem.home:
        return 0;
      case AppTabItem.analytics:
        return 1;
      case AppTabItem.add:
        return 2;
      case AppTabItem.budget:
        return 3;
      case AppTabItem.settings:
        return 4;
    }
  }

  AppTabItem _tabFromIndex(int index) {
    switch (index) {
      case 0:
        return AppTabItem.home;
      case 1:
        return AppTabItem.analytics;
      case 2:
        return AppTabItem.add;
      case 3:
        return AppTabItem.budget;
      case 4:
        return AppTabItem.settings;
      default:
        return AppTabItem.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _currentIndexFromTab(currentTab),
      onDestinationSelected: (index) {
        onTabSelected(_tabFromIndex(index));
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.bar_chart_outlined),
          selectedIcon: Icon(Icons.bar_chart),
          label: 'Analytics',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline),
          selectedIcon: Icon(Icons.add_circle),
          label: 'Add',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_balance_wallet_outlined),
          selectedIcon: Icon(Icons.account_balance_wallet),
          label: 'Budget',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
