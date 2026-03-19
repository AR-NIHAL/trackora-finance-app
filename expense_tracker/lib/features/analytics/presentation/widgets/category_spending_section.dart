import 'package:flutter/material.dart';
import 'category_spending_card.dart';

class CategorySpendingSection extends StatelessWidget {
  const CategorySpendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      {
        'title': 'Food & Drinks',
        'amount': '\$860.00',
        'percent': '27%',
        'icon': Icons.restaurant_outlined,
      },
      {
        'title': 'Transport',
        'amount': '\$420.00',
        'percent': '13%',
        'icon': Icons.directions_car_outlined,
      },
      {
        'title': 'Shopping',
        'amount': '\$740.00',
        'percent': '23%',
        'icon': Icons.shopping_bag_outlined,
      },
      {
        'title': 'Bills',
        'amount': '\$510.00',
        'percent': '16%',
        'icon': Icons.receipt_long_outlined,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Spending',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CategorySpendingCard(
              title: item['title']! as String,
              amount: item['amount']! as String,
              percent: item['percent']! as String,
              icon: item['icon']! as IconData,
            ),
          ),
        ),
      ],
    );
  }
}
