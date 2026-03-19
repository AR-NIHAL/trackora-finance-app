import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/analytics_provider.dart';

class AnalyticsFilterTabs extends ConsumerWidget {
  const AnalyticsFilterTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(analyticsFilterProvider);

    return Row(
      children: [
        Expanded(
          child: _FilterChipItem(
            label: 'All',
            isSelected: selectedFilter == 'all',
            onTap: () {
              ref.read(analyticsFilterProvider.notifier).state = 'all';
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FilterChipItem(
            label: 'Monthly',
            isSelected: selectedFilter == 'monthly',
            onTap: () {
              ref.read(analyticsFilterProvider.notifier).state = 'monthly';
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _FilterChipItem(
            label: 'Weekly',
            isSelected: selectedFilter == 'weekly',
            onTap: () {
              ref.read(analyticsFilterProvider.notifier).state = 'weekly';
            },
          ),
        ),
      ],
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
