abstract class SettingsRepository {
  Map<String, dynamic> fetchSettings();
  Future<void> saveSettings(Map<String, dynamic> settings);
}
