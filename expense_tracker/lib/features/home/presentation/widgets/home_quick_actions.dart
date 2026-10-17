import 'package:expense_tracker/app/theme/app_colors.dart';
import 'package:expense_tracker/features/forecast/presentation/screens/forecast_screen.dart';
import 'package:expense_tracker/features/goals/presentation/screens/goals_screen.dart';
import 'package:expense_tracker/features/insights/presentation/screens/insights_screen.dart';
import 'package:expense_tracker/features/subscriptions/presentation/screens/subscriptions_screen.dart';
import 'package:flutter/material.dart';

class HomeQuickActions extends StatelessWidget {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final actions = <(IconData, String, Color, Widget)>[
      (
        Icons.lightbulb_outline_rounded,
        'Insights',
        theme.colorScheme.primary,
        const InsightsScreen(),
      ),
      (
        Icons.autorenew_rounded,
        'Subscriptions',
        const Color(0xFF6366F1),
        const SubscriptionsScreen(),
      ),
      (
        Icons.savings_outlined,
        'Goals',
        const Color(0xFF0D9488),
        const GoalsScreen(),
      ),
      (
        Icons.trending_up_rounded,
        'Forecast',
        const Color(0xFF8B5CF6),
        const ForecastScreen(),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border.all(
          color: AppColors.cardBorder(context),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF1E293B).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: actions.map((action) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (context) => action.$4),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: action.$3,
                          boxShadow: [
                            BoxShadow(
                              color: action.$3.withValues(alpha: 0.28),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          action.$1,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            action.$2,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
