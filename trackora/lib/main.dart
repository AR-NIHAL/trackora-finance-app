import 'package:flutter/material.dart';
import 'package:trackora/core/theme/app_theme.dart';
import 'package:trackora/shared/widgets/main_nav_screen.dart';

void main() {
  runApp(const Trackora());
}

class Trackora extends StatelessWidget {
  const Trackora({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trackora',
      theme: AppTheme.lightTheme,
      home: const MainNavScreen(),
    );
  }
}
