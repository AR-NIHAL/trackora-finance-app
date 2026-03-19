import 'package:expense_tracker/features/settings/presentation/widgets/setting_section_card.dart';
import 'package:flutter/material.dart';
import '../widgets/about_app_card.dart';
import '../widgets/settings_dropdown_tile.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Settings',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 20),

          SettingsSectionCard(
            children: [
              SettingsSwitchTile(
                title: 'Dark Mode',
                subtitle: 'Switch between light and dark appearance',
                icon: Icons.dark_mode_outlined,
                value: false,
              ),
              SettingsDropdownTile(
                title: 'Currency',
                subtitle: 'Choose your preferred currency',
                icon: Icons.attach_money_rounded,
                value: 'USD',
                items: ['USD', 'BDT', 'EUR', 'GBP'],
              ),
              SettingsSwitchTile(
                title: 'Notifications',
                subtitle: 'Enable reminders and alerts',
                icon: Icons.notifications_none_rounded,
                value: true,
              ),
              SettingsTile(
                title: 'Reset Data',
                subtitle: 'Clear all transactions and budget data',
                icon: Icons.restart_alt_rounded,
                isDestructive: true,
              ),
            ],
          ),

          SizedBox(height: 24),

          AboutAppCard(),
        ],
      ),
    );
  }
}
