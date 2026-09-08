import 'package:expense_tracker/features/settings/data/repositories/local_settings_repository.dart';
import 'package:expense_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool isDarkMode;
  final String currencyCode;
  final bool notificationsEnabled;

  const SettingsState({
    this.isDarkMode = false,
    this.currencyCode = 'USD',
    this.notificationsEnabled = true,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    String? currencyCode,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currencyCode: currencyCode ?? this.currencyCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'currencyCode': currencyCode,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  factory SettingsState.fromJson(Map<String, dynamic> json) {
    return SettingsState(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      currencyCode: json['currencyCode'] as String? ?? 'USD',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  SettingsRepository get _repository => ref.read(settingsRepositoryProvider);

  @override
  SettingsState build() {
    final stored = _repository.fetchSettings();
    if (stored.isEmpty) return const SettingsState();
    return SettingsState.fromJson(stored);
  }

  void _persist() {
    _repository.saveSettings(state.toJson());
  }

  void toggleDarkMode(bool value) {
    state = state.copyWith(isDarkMode: value);
    _persist();
  }

  void setCurrency(String code) {
    state = state.copyWith(currencyCode: code);
    _persist();
  }

  void setNotificationsEnabled(bool value) {
    state = state.copyWith(notificationsEnabled: value);
    _persist();
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(settingsProvider).isDarkMode
      ? ThemeMode.dark
      : ThemeMode.light;
});
