import 'package:flutter/material.dart';

class AppColors {
  // Primary (Brand / Buttons)
  static const Color primaryLight = Color(0xFF2D5A43);
  static const Color primaryDark = Color(0xFF68A67D);
  static const Color primary = primaryLight;

  // Background (Scaffold)
  static const Color scaffoldLight = Color(0xFFF2F5F3);
  static const Color scaffoldDark = Color(0xFF111418);

  // Dark Mode Ambient Gradient (Deep black at top fading into minimal brand emerald at bottom)
  static const List<Color> darkGradientColors = [
    Color(0xFF090B0A), // Black at top
    Color(0xFF0D1410), // Slow subtle dark transition
    Color(0xFF13221B), // Minimal deep emerald undertone matching the app
  ];

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: darkGradientColors,
    stops: [0.0, 0.40, 1.0],
  );

  // Surface / Cards
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1A2027);

  // Card Borders
  static const Color cardBorderLight = Color(0xFFE2E8E4);
  static const Color cardBorderDark = Color(0x1FFFFFFF);

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
  static Color cardBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? cardBorderDark
          : cardBorderLight;

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
