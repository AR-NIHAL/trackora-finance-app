import 'package:flutter/material.dart';
import 'app_bottom_nav_bar.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: body),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
