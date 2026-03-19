import 'package:flutter/material.dart';
import 'category_budget_card.dart';

class CategoryBudgetSection extends StatelessWidget {
  const CategoryBudgetSection({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      {
        'title': 'Food & Drinks',
        'spent': '\$860.00',
        'limit': '\$1,200.00',
        'progress': 0.72,
        'icon': Icons.restaurant_outlined,
      },
      {
        'title': 'Transport',
        'spent': '\$420.00',
        'limit': '\$700.00',
        'progress': 0.60,
        'icon': Icons.directions_car_outlined,
      },
      {
        'title': 'Shopping',
        'spent': '\$740.00',
        'limit': '\$1,000.00',
        'progress': 0.74,
        'icon': Icons.shopping_bag_outlined,
      },
      {
        'title': 'Bills',
        'spent': '\$510.00',
        'limit': '\$800.00',
        'progress': 0.64,
        'icon': Icons.receipt_long_outlined,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Budgets',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CategoryBudgetCard(
              title: item['title']! as String,
              spentAmount: item['spent']! as String,
              limitAmount: item['limit']! as String,
              progress: item['progress']! as double,
              icon: item['icon']! as IconData,
            ),
          ),
        ),
      ],
    );
  }
}
