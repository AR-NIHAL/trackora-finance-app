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
        Colors.indigo,
        const SubscriptionsScreen(),
      ),
      (
        Icons.savings_rounded,
        'Goals',
        Colors.teal,
        const GoalsScreen(),
      ),
      (
        Icons.trending_up_rounded,
        'Forecast',
        Colors.deepPurple,
        const ForecastScreen(),
      ),
    ];

    return Row(
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (context) => action.$4),
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: action.$3.withValues(alpha: 0.14),
                    ),
                    child: Icon(action.$1, color: action.$3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.$2,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
