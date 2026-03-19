import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final String selectedType;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
    super.key,
    required this.selectedType,
    required this.selectedCategory,
    required this.onChanged,
  });

  List<String> _categoriesForType(String type) {
    if (type == 'income') {
      return const [
        'Salary',
        'Freelance',
        'Business',
        'Investment',
        'Gift',
        'Other Income',
      ];
    }

    return const [
      'Food',
      'Transport',
      'Bills',
      'Shopping',
      'Entertainment',
      'Health',
      'Education',
      'Other Expense',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categoriesForType(selectedType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          decoration: InputDecoration(
            hintText: 'Select category',
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          items: categories
              .map(
                (category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ),
              )
              .toList(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please select a category';
            }
            return null;
          },
          onChanged: onChanged,
        ),
      ],
    );
  }
}
