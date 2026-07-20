import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary
  static const Color primaryLight = Color(0xFF2E7D32);
  static const Color primaryDark = Color(0xFF66BB6A);

  // Income
  static const Color income = Color(0xFF2E7D32);
  static const Color incomeLight = Color(0xFFE8F5E9);

  // Expense
  static const Color expense = Color(0xFFC62828);
  static const Color expenseLight = Color(0xFFFFEBEE);

  // Neutral
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF2E7D32),
    Color(0xFFC62828),
    Color(0xFF1565C0),
    Color(0xFFF9A825),
    Color(0xFF6A1B9A),
    Color(0xFF00838F),
    Color(0xFFEF6C00),
    Color(0xFF4E342E),
  ];
}
