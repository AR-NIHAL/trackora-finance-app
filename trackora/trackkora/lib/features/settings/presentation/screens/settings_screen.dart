import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:trackkora/core/constants/hive_boxes.dart';
import 'package:trackkora/core/constants/app_strings.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final settingsBox = Hive.box<String>(HiveBoxes.settings);
  return _getThemeMode(settingsBox.get(AppStrings.themeKey));
});

ThemeMode _getThemeMode(String? value) {
  switch (value) {
    case 'dark':
      return ThemeMode.dark;
    case 'light':
      return ThemeMode.light;
    default:
      return ThemeMode.system;
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Theme Section
          _SectionHeader(title: 'Appearance'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                RadioGroup<ThemeMode>(
                  groupValue: themeMode,
                  onChanged: (value) {
                    if (value != null) _setTheme(ref, value);
                  },
                  child: const Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        title: Text('System'),
                        subtitle: Text('Follow system theme'),
                        secondary: Icon(Icons.brightness_auto),
                        value: ThemeMode.system,
                      ),
                      RadioListTile<ThemeMode>(
                        title: Text('Light'),
                        subtitle: Text('Always use light theme'),
                        secondary: Icon(Icons.light_mode),
                        value: ThemeMode.light,
                      ),
                      RadioListTile<ThemeMode>(
                        title: Text('Dark'),
                        subtitle: Text('Always use dark theme'),
                        secondary: Icon(Icons.dark_mode),
                        value: ThemeMode.dark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Data Section
          _SectionHeader(title: 'Data'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Categories'),
                  subtitle: const Text('Manage transaction categories'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/categories'),
                ),
                ListTile(
                  leading: const Icon(Icons.repeat),
                  title: const Text('Recurring Transactions'),
                  subtitle: const Text('Manage recurring transactions'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/recurring'),
                ),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Export Data'),
                  subtitle: const Text('Export transactions to CSV or PDF'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/export'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // About Section
          _SectionHeader(title: 'About'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('App Version'),
                  subtitle: Text('1.0.0'),
                ),
                const ListTile(
                  leading: Icon(Icons.code),
                  title: Text('TrackKora'),
                  subtitle: Text('A local-first personal finance tracker'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _setTheme(WidgetRef ref, ThemeMode mode) {
    final settingsBox = Hive.box<String>(HiveBoxes.settings);
    String value;
    switch (mode) {
      case ThemeMode.system:
        value = 'system';
        break;
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
    }
    settingsBox.put(AppStrings.themeKey, value);
    ref.read(themeModeProvider.notifier).state = mode;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
