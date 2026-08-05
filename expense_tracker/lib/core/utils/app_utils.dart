import 'dart:math';

import 'package:intl/intl.dart';

class AppUtils {
  AppUtils._();

  static String formatCurrency(double amount, String currencyCode) {
    try {
      return NumberFormat.simpleCurrency(name: currencyCode).format(amount);
    } catch (_) {
      return NumberFormat('##,##0.00').format(amount);
    }
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  static String generateId() {
    return '${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(9999)}';
  }
}