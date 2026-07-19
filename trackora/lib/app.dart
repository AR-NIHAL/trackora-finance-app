import 'package:flutter/material.dart';
import 'package:trackora/core/router/app_router.dart';
import 'package:trackora/core/theme/app_theme.dart';

class TrackoraApp extends StatelessWidget {
  const TrackoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Trackora',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
