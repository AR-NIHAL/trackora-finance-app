import 'package:flutter/material.dart';
import 'package:trackora/core/services/app_settings.dart';
import 'package:trackora/core/theme/app_theme.dart';
import 'package:trackora/widgets/main_nav_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.init();

  runApp(const TrackoraApp());
}

class TrackoraApp extends StatefulWidget {
  const TrackoraApp({super.key});

  @override
  State<TrackoraApp> createState() => _TrackoraAppState();
}

class _TrackoraAppState extends State<TrackoraApp> {
  @override
  void initState() {
    super.initState();
    AppSettings.themeNotifier.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    AppSettings.themeNotifier.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trackora',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: AppSettings.themeNotifier.value
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const MainNavScreen(),
    );
  }
}
