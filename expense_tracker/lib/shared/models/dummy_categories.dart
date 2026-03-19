import 'package:flutter/material.dart';
import 'app_enums.dart';
import 'category_model.dart';

class DummyCategories {
  static const List<CategoryModel> expenseCategories = [
    CategoryModel(
      id: 'exp_food',
      name: 'Food',
      iconName: 'restaurant',
      type: CategoryType.expense,
      color: Color(0xFFF97316),
    ),
    CategoryModel(
      id: 'exp_transport',
      name: 'Transport',
      iconName: 'directions_car',
      type: CategoryType.expense,
      color: Color(0xFF3B82F6),
    ),
    CategoryModel(
      id: 'exp_shopping',
      name: 'Shopping',
      iconName: 'shopping_bag',
      type: CategoryType.expense,
      color: Color(0xFFEC4899),
    ),
    CategoryModel(
      id: 'exp_bills',
      name: 'Bills',
      iconName: 'receipt_long',
      type: CategoryType.expense,
      color: Color(0xFFEF4444),
    ),
    CategoryModel(
      id: 'exp_health',
      name: 'Health',
      iconName: 'favorite',
      type: CategoryType.expense,
      color: Color(0xFF10B981),
    ),
    CategoryModel(
      id: 'exp_entertainment',
      name: 'Entertainment',
      iconName: 'movie',
      type: CategoryType.expense,
      color: Color(0xFF8B5CF6),
    ),
    CategoryModel(
      id: 'exp_education',
      name: 'Education',
      iconName: 'school',
      type: CategoryType.expense,
      color: Color(0xFF14B8A6),
    ),
    CategoryModel(
      id: 'exp_other',
      name: 'Other',
      iconName: 'category',
      type: CategoryType.expense,
      color: Color(0xFF64748B),
    ),
  ];

  static const List<CategoryModel> incomeCategories = [
    CategoryModel(
      id: 'inc_salary',
      name: 'Salary',
      iconName: 'payments',
      type: CategoryType.income,
      color: Color(0xFF22C55E),
    ),
    CategoryModel(
      id: 'inc_freelance',
      name: 'Freelance',
      iconName: 'laptop_mac',
      type: CategoryType.income,
      color: Color(0xFF06B6D4),
    ),
    CategoryModel(
      id: 'inc_bonus',
      name: 'Bonus',
      iconName: 'card_giftcard',
      type: CategoryType.income,
      color: Color(0xFFEAB308),
    ),
    CategoryModel(
      id: 'inc_gift',
      name: 'Gift',
      iconName: 'redeem',
      type: CategoryType.income,
      color: Color(0xFFA855F7),
    ),
    CategoryModel(
      id: 'inc_other',
      name: 'Other',
      iconName: 'account_balance_wallet',
      type: CategoryType.income,
      color: Color(0xFF64748B),
    ),
  ];

  static const List<CategoryModel> allCategories = [
    ...expenseCategories,
    ...incomeCategories,
  ];
}
