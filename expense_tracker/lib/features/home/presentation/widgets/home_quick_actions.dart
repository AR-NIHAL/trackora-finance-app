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
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
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
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: action.$3.withValues(alpha: 0.14),
                      ),
                      child: Icon(action.$1, color: action.$3, size: 24),
                    ),
                    const SizedBox(height: 6),
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
    );
  }
}
