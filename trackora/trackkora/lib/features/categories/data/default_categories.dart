import 'package:trackkora/features/categories/domain/entities/category.dart';

abstract final class DefaultCategories {
  static List<Category> get all => [
        Category(
          id: 'salary',
          name: 'Salary',
          iconCodePoint: 0xe227, // Icons.attach_money
          colorValue: 0xFF2E7D32,
        ),
        Category(
          id: 'freelance',
          name: 'Freelance',
          iconCodePoint: 0xe30b, // Icons.laptop
          colorValue: 0xFF1565C0,
        ),
        Category(
          id: 'investment',
          name: 'Investment',
          iconCodePoint: 0xe22b, // Icons.trending_up
          colorValue: 0xFF6A1B9A,
        ),
        Category(
          id: 'food',
          name: 'Food & Dining',
          iconCodePoint: 0xe54c, // Icons.restaurant
          colorValue: 0xFFEF6C00,
        ),
        Category(
          id: 'transport',
          name: 'Transport',
          iconCodePoint: 0xe531, // Icons.directions_car
          colorValue: 0xFF00838F,
        ),
        Category(
          id: 'shopping',
          name: 'Shopping',
          iconCodePoint: 0xe553, // Icons.shopping_bag
          colorValue: 0xFFC62828,
        ),
        Category(
          id: 'bills',
          name: 'Bills & Utilities',
          iconCodePoint: 0xe06a, // Icons.receipt
          colorValue: 0xFFF9A825,
        ),
        Category(
          id: 'entertainment',
          name: 'Entertainment',
          iconCodePoint: 0xe03b, // Icons.movie
          colorValue: 0xFF4E342E,
        ),
        Category(
          id: 'health',
          name: 'Health',
          iconCodePoint: 0xe548, // Icons.local_hospital
          colorValue: 0xFFE91E63,
        ),
        Category(
          id: 'education',
          name: 'Education',
          iconCodePoint: 0xe80c, // Icons.school
          colorValue: 0xFF3F51B5,
        ),
        Category(
          id: 'rent',
          name: 'Rent',
          iconCodePoint: 0xe300, // Icons.home
          colorValue: 0xFF795548,
        ),
        Category(
          id: 'other',
          name: 'Other',
          iconCodePoint: 0xe5d3, // Icons.more_horiz
          colorValue: 0xFF757575,
        ),
      ];
}
