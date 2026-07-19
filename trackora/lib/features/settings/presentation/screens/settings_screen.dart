import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trackora/core/theme/app_spacing.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md.toDouble()),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Manage Categories'),
              subtitle: const Text('Add or remove income & expense categories'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/categories'),
            ),
          ),
        ],
      ),
    );
  }
}
