import 'package:expense_tracker/core/services/local_storage_service.dart';
import 'package:expense_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return LocalSettingsRepository(storageService);
});

class LocalSettingsRepository implements SettingsRepository {
  final LocalStorageService _storageService;

  LocalSettingsRepository(this._storageService);

  @override
  Map<String, dynamic> fetchSettings() {
    return _storageService.getSettings();
  }

  @override
  Future<void> saveSettings(Map<String, dynamic> settings) {
    return _storageService.saveSettings(settings);
  }
}
