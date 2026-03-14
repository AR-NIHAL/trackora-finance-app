import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static late SharedPreferences _prefs;

  static final ValueNotifier<bool> themeNotifier = ValueNotifier(false);
  static final ValueNotifier<double> budgetNotifier = ValueNotifier(0);

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    themeNotifier.value = _prefs.getBool('isDarkMode') ?? false;
    budgetNotifier.value = _prefs.getDouble('monthlyBudget') ?? 0;
  }

  static Future<void> setDarkMode(bool value) async {
    themeNotifier.value = value;
    await _prefs.setBool('isDarkMode', value);
  }

  static Future<void> setMonthlyBudget(double value) async {
    budgetNotifier.value = value;
    await _prefs.setDouble('monthlyBudget', value);
  }
}
