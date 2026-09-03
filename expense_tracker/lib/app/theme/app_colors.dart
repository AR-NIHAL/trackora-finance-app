import 'package:flutter/material.dart';

class AppColors {
  // Primary (Brand / Buttons)
  static const Color primaryLight = Color(0xFF2D5A43);
  static const Color primaryDark = Color(0xFF68A67D);
  static const Color primary = primaryLight;

  // Background (Scaffold)
  static const Color scaffoldLight = Color(0xFFF8F9FA);
  static const Color scaffoldDark = Color(0xFF111418);

  // Surface / Cards
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1A2027);

  // Primary Text
  static const Color textPrimaryLight = Color(0xFF1A1F1D);
  static const Color textPrimaryDark = Color(0xFFEDEDED);

  // Muted Text / Dates
  static const Color textMutedLight = Color(0xFF6C757D);
  static const Color textMutedDark = Color(0xFF94A3B8);

  // Income Accent
  static const Color incomeLight = Color(0xFF2E7D32);
  static const Color incomeDark = Color(0xFF81C784);

  // Expense Accent
  static const Color expenseLight = Color(0xFFC25450);
  static const Color expenseDark = Color(0xFFE57373);

  // Dynamic context helpers
  static Color primaryColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? primaryDark
          : primaryLight;

  static Color scaffold(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? scaffoldDark
          : scaffoldLight;

  static Color card(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? cardDark
          : cardLight;

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? textPrimaryDark
          : textPrimaryLight;

  static Color textMuted(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? textMutedDark
          : textMutedLight;

  static Color income(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? incomeDark
          : incomeLight;

  static Color expense(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? expenseDark
          : expenseLight;
}
