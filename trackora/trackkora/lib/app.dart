import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackkora/core/router/app_router.dart';
import 'package:trackkora/core/theme/app_theme.dart';
import 'package:trackkora/features/settings/presentation/screens/settings_screen.dart';

class TrackKoraApp extends ConsumerWidget {
  const TrackKoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'TrackKora',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
