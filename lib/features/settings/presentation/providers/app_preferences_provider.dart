import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/app_preferences_model.dart';
import '../../data/services/app_preferences_service.dart';
import '../../../../core/theme/theme_provider.dart';

part 'app_preferences_provider.g.dart';

@riverpod
AppPreferencesService appPreferencesService(Ref ref) {
  return AppPreferencesService();
}

@riverpod
class AppPreferences extends _$AppPreferences {
  @override
  Future<AppPreferencesModel> build() async {
    final service = ref.read(appPreferencesServiceProvider);
    return await service.loadPreferences();
  }

  Future<void> setThemeMode(ThemeModeEnum themeMode) async {
    ref.read(appThemeModeProvider.notifier).setTheme(themeMode);
  }

  Future<void> setDarkMode(bool isDark) async {
    await setThemeMode(isDark ? ThemeModeEnum.dark : ThemeModeEnum.light);
  }

  Future<void> setNumberFormat(String format) async {
    final service = ref.read(appPreferencesServiceProvider);
    final currentPrefs = await future;

    final updatedPrefs = currentPrefs.copyWith(numberFormat: format);
    await service.savePreferences(updatedPrefs);
    state = AsyncValue.data(updatedPrefs);
  }

  Future<void> setDefaultCurrency(String currency) async {
    final service = ref.read(appPreferencesServiceProvider);
    final currentPrefs = await future;

    final updatedPrefs = currentPrefs.copyWith(defaultCurrency: currency);
    await service.savePreferences(updatedPrefs);
    state = AsyncValue.data(updatedPrefs);
  }

  Future<void> setConfirmBeforeDelete(bool confirm) async {
    final service = ref.read(appPreferencesServiceProvider);
    final currentPrefs = await future;

    final updatedPrefs = currentPrefs.copyWith(confirmBeforeDelete: confirm);
    await service.savePreferences(updatedPrefs);
    state = AsyncValue.data(updatedPrefs);
  }

  Future<void> setEnableHaptics(bool enable) async {
    final service = ref.read(appPreferencesServiceProvider);
    final currentPrefs = await future;

    final updatedPrefs = currentPrefs.copyWith(enableHaptics: enable);
    await service.savePreferences(updatedPrefs);
    state = AsyncValue.data(updatedPrefs);
  }

  Future<void> setLanguage(String language) async {
    final service = ref.read(appPreferencesServiceProvider);
    final currentPrefs = await future;

    final updatedPrefs = currentPrefs.copyWith(language: language);
    await service.savePreferences(updatedPrefs);
    state = AsyncValue.data(updatedPrefs);
  }

  Future<void> resetToDefaults() async {
    final service = ref.read(appPreferencesServiceProvider);
    const defaultPrefs = AppPreferencesModel();

    await service.savePreferences(defaultPrefs);
    state = const AsyncValue.data(defaultPrefs);
  }
}
