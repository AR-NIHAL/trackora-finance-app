import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app/router/app_tab_item.dart';
import '../../app/theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final AppTabItem currentTab;
  final ValueChanged<AppTabItem> onTabSelected;

  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  Widget _buildNavItem(
    BuildContext context, {
    required AppTabItem tab,
    required String label,
    required IconData icon,
    required IconData selectedIcon,
  }) {
    final isSelected = currentTab == tab;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onTabSelected(tab),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isSelected ? selectedIcon : icon,
                    color: isSelected ? primaryColor : unselectedColor,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? primaryColor : unselectedColor,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddNavItem(BuildContext context) {
    final isSelected = currentTab == AppTabItem.add;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onTabSelected(AppTabItem.add),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [primaryColor, primaryColor.withValues(alpha: 0.85)]
                          : [
                              primaryColor.withValues(alpha: 0.95),
                              primaryColor.withValues(alpha: 0.8),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? primaryColor
                        : theme.colorScheme.onSurfaceVariant,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        bottomPadding > 0 ? bottomPadding : 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 66,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.cardDark.withValues(alpha: 0.75)
                  : AppColors.cardLight.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.6),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : const Color(0xFF64748B))
                      .withValues(alpha: isDark ? 0.35 : 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  context,
                  tab: AppTabItem.home,
                  label: 'Home',
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                ),
                _buildNavItem(
                  context,
                  tab: AppTabItem.analytics,
                  label: 'Analytics',
                  icon: Icons.bar_chart_outlined,
                  selectedIcon: Icons.bar_chart_rounded,
                ),
                _buildAddNavItem(context),
                _buildNavItem(
                  context,
                  tab: AppTabItem.budget,
                  label: 'Budget',
                  icon: Icons.account_balance_wallet_outlined,
                  selectedIcon: Icons.account_balance_wallet_rounded,
                ),
                _buildNavItem(
                  context,
                  tab: AppTabItem.settings,
                  label: 'Settings',
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
