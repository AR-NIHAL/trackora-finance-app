import 'package:flutter/material.dart';
import 'package:trackora/core/services/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _toggleTheme(bool value) async {
    await AppSettings.setDarkMode(value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppSettings.themeNotifier.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            value: isDarkMode,
            onChanged: _toggleTheme,
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
          ),
          const Divider(height: 1),
          const ListTile(
            leading: Icon(Icons.currency_exchange),
            title: Text('Currency'),
            subtitle: Text('BDT (demo)'),
          ),
          const Divider(height: 1),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About App'),
            subtitle: Text('Trackora - Personal Finance Tracker'),
          ),
        ],
      ),
    );
  }
}
