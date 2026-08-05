import 'dart:convert';

import 'package:expense_tracker/core/services/export_service.dart';
import 'package:expense_tracker/features/add_transaction/state/transaction_provider.dart';
import 'package:expense_tracker/features/budget/state/budget_provider.dart';
import 'package:expense_tracker/features/goals/state/goal_provider.dart';
import 'package:expense_tracker/features/settings/presentation/widgets/setting_section_card.dart';
import 'package:expense_tracker/features/settings/state/settings_provider.dart';
import 'package:expense_tracker/shared/models/budget_model.dart';
import 'package:expense_tracker/shared/models/saving_goal_model.dart';
import 'package:expense_tracker/shared/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/about_app_card.dart';
import '../widgets/settings_dropdown_tile.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    void confirmReset() {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reset all data?'),
          content: const Text(
            'This will permanently delete all transactions and budgets. This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                ref.read(transactionProvider.notifier).reset();
                ref.read(budgetProvider.notifier).reset();
                ref.read(goalProvider.notifier).reset();
                Navigator.of(context).pop();
              },
              child: const Text('Reset'),
            ),
          ],
        ),
      );
    }

    Future<void> exportCsv() async {
      final transactions = ref.read(transactionProvider).transactions;
      final csv = ExportService.buildCsv(transactions);
      await SharePlus.instance.share(
        ShareParams(text: csv, subject: 'Trackora transactions export'),
      );
    }

    Future<void> createBackup() async {
      final json = ExportService.buildBackupJson(
        transactions: ref.read(transactionProvider).transactions,
        budgets: ref.read(budgetProvider).budgets,
        goals: ref.read(goalProvider).goals,
      );
      await SharePlus.instance.share(
        ShareParams(text: json, subject: 'Trackora backup'),
      );
    }

    Future<void> restoreBackup() async {
      final messenger = ScaffoldMessenger.of(context);
      final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
      final raw = clipboard?.text;
      if (raw == null || raw.trim().isEmpty) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Clipboard is empty')),
        );
        return;
      }

      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        if (data['transactions'] == null || data['budgets'] == null) {
          throw const FormatException('Invalid backup');
        }

        final transactions = (data['transactions'] as List<dynamic>)
            .map(
              (item) =>
                  TransactionModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        final budgets = (data['budgets'] as List<dynamic>)
            .map((item) => BudgetModel.fromJson(item as Map<String, dynamic>))
            .toList();
        final goals = ((data['goals'] as List<dynamic>?) ?? [])
            .map((item) => SavingGoal.fromJson(item as Map<String, dynamic>))
            .toList();

        ref.read(transactionProvider.notifier).replaceAll(transactions);
        ref.read(budgetProvider.notifier).replaceAll(budgets);
        ref.read(goalProvider.notifier).replaceAll(goals);

        messenger.showSnackBar(
          const SnackBar(content: Text('Backup restored')),
        );
      } catch (_) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Invalid backup data')),
        );
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),

          SettingsSectionCard(
            children: [
              SettingsSwitchTile(
                title: 'Dark Mode',
                subtitle: 'Switch between light and dark appearance',
                icon: Icons.dark_mode_outlined,
                value: settings.isDarkMode,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).toggleDarkMode(value);
                },
              ),
              SettingsDropdownTile(
                title: 'Currency',
                subtitle: 'Choose your preferred currency',
                icon: Icons.attach_money_rounded,
                value: settings.currencyCode,
                items: const ['USD', 'BDT', 'EUR', 'GBP', 'INR'],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(settingsProvider.notifier).setCurrency(value);
                  }
                },
              ),
              SettingsSwitchTile(
                title: 'Notifications',
                subtitle: 'Enable reminders and alerts',
                icon: Icons.notifications_none_rounded,
                value: settings.notificationsEnabled,
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .setNotificationsEnabled(value);
                },
              ),
              SettingsTile(
                title: 'Reset Data',
                subtitle: 'Clear all transactions and budget data',
                icon: Icons.restart_alt_rounded,
                isDestructive: true,
                onTap: confirmReset,
              ),
            ],
          ),

          const SizedBox(height: 24),

          SettingsSectionCard(
            children: [
              SettingsTile(
                title: 'Export Transactions (CSV)',
                subtitle: 'Share your transactions as a CSV file',
                icon: Icons.download_rounded,
                onTap: exportCsv,
              ),
              SettingsTile(
                title: 'Create Backup',
                subtitle: 'Share a full backup of all your data',
                icon: Icons.backup_rounded,
                onTap: createBackup,
              ),
              SettingsTile(
                title: 'Restore from Backup',
                subtitle: 'Paste a backup JSON from the clipboard',
                icon: Icons.restore_rounded,
                onTap: restoreBackup,
              ),
            ],
          ),

          const SizedBox(height: 24),

          const AboutAppCard(),
        ],
      ),
    );
  }
}
