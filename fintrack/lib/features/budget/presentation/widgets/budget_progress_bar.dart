import 'package:flutter/material.dart';

class BudgetProgressBar extends StatelessWidget {
  final double progress;
  final bool isExceeded;

  const BudgetProgressBar({
    super.key,
    required this.progress,
    required this.isExceeded,
  });

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: LinearProgressIndicator(
        value: safeProgress,
        minHeight: 10,
        backgroundColor: Colors.grey.shade200,
        valueColor: AlwaysStoppedAnimation<Color>(
          isExceeded ? Colors.red : Colors.teal,
        ),
      ),
    );
  }
}
