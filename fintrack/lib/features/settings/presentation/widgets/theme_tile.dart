import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/theme_provider.dart';

class ThemeTile extends ConsumerWidget {
  const ThemeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.teal.withValues(alpha: 0.12),
        child: Icon(
          isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: Colors.teal,
        ),
      ),
      title: const Text(
        'Dark Mode',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(isDarkMode ? 'Currently enabled' : 'Currently disabled'),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) {
          ref.read(themeModeProvider.notifier).state = value
              ? ThemeMode.dark
              : ThemeMode.light;
        },
      ),
    );
  }
}
